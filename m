Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0JSISr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0JSISq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:18:46 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/2] sysctl: refactor __do_proc_doulongvec_minmax()
Date: Tue, 19 Oct 2010 16:22:35 +0800
Message-Id: <1287476560-5874-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seperate read and write into two functions.

Signed-off-by: Amerigo Wang <amwang@redhat.com>

---
 kernel/sysctl.c |  151 +++++++++++++++++++++++++++++++++---------------------
 1 files changed, 92 insertions(+), 59 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3a45c22..7f9f937 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2448,86 +2448,119 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
-static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
-				     void __user *buffer,
-				     size_t *lenp, loff_t *ppos,
+static int __doulongvec_minmax_read(void *data, void __user *buffer,
+				     size_t *lenp, loff_t *ppos, int vleft,
 				     unsigned long convmul,
 				     unsigned long convdiv)
 {
-	unsigned long *i, *min, *max;
-	int vleft, first = 1, err = 0;
-	unsigned long page = 0;
-	size_t left;
-	char *kbuf;
+	unsigned long *i = data;
+	int err = 0;
+	bool first = true;
+	size_t left = *lenp;
 
-	if (!data || !table->maxlen || !*lenp || (*ppos && !write)) {
-		*lenp = 0;
-		return 0;
+	for (; left && vleft--; i++, first = false) {
+		unsigned long val;
+
+		val = convdiv * (*i) / convmul;
+		if (!first)
+			err = proc_put_char(&buffer, &left, '\t');
+		err = proc_put_long(&buffer, &left, val, false);
+		if (err)
+			break;
 	}
 
-	i = (unsigned long *) data;
-	min = (unsigned long *) table->extra1;
-	max = (unsigned long *) table->extra2;
-	vleft = table->maxlen / sizeof(unsigned long);
-	left = *lenp;
+	if (!first && left && !err)
+		err = proc_put_char(&buffer, &left, '\n');
 
-	if (write) {
-		if (left > PAGE_SIZE - 1)
-			left = PAGE_SIZE - 1;
-		page = __get_free_page(GFP_TEMPORARY);
-		kbuf = (char *) page;
-		if (!kbuf)
-			return -ENOMEM;
-		if (copy_from_user(kbuf, buffer, left)) {
-			err = -EFAULT;
-			goto free;
-		}
-		kbuf[left] = 0;
+	*lenp -= left;
+	*ppos += *lenp;
+	return err;
+}
+
+static int __doulongvec_minmax_write(void *data, void __user *buffer,
+				     size_t *lenp, loff_t *ppos, int vleft,
+				     unsigned long min, unsigned long max)
+{
+	char *kbuf;
+	size_t left = *lenp;
+	unsigned long page = 0;
+	unsigned long *i = (unsigned long *) data;
+	int err = 0;
+	bool first = true;
+
+	if (left > PAGE_SIZE - 1)
+		left = PAGE_SIZE - 1;
+	page = __get_free_page(GFP_TEMPORARY);
+	kbuf = (char *) page;
+	if (!kbuf)
+		return -ENOMEM;
+	if (copy_from_user(kbuf, buffer, left)) {
+		err = -EFAULT;
+		goto free;
 	}
+	kbuf[left] = 0;
 
-	for (; left && vleft--; i++, first = 0) {
+	for (; left && vleft--; i++, first = false) {
 		unsigned long val;
+		bool neg;
 
-		if (write) {
-			bool neg;
-
-			left -= proc_skip_spaces(&kbuf);
+		left -= proc_skip_spaces(&kbuf);
 
-			err = proc_get_long(&kbuf, &left, &val, &neg,
-					     proc_wspace_sep,
-					     sizeof(proc_wspace_sep), NULL);
-			if (err)
-				break;
-			if (neg)
-				continue;
-			if ((min && val < *min) || (max && val > *max))
-				continue;
-			*i = val;
-		} else {
-			val = convdiv * (*i) / convmul;
-			if (!first)
-				err = proc_put_char(&buffer, &left, '\t');
-			err = proc_put_long(&buffer, &left, val, false);
-			if (err)
-				break;
-		}
+		err = proc_get_long(&kbuf, &left, &val, &neg,
+				     proc_wspace_sep,
+				     sizeof(proc_wspace_sep), NULL);
+		if (err)
+			break;
+		if (neg)
+			continue;
+		if (val < min || val > max)
+			continue;
+		*i = val;
 	}
 
-	if (!write && !first && left && !err)
-		err = proc_put_char(&buffer, &left, '\n');
-	if (write && !err)
+	if (!err)
 		left -= proc_skip_spaces(&kbuf);
 free:
-	if (write) {
-		free_page(page);
-		if (first)
-			return err ? : -EINVAL;
-	}
+	free_page(page);
+	if (first)
+		return err ? : -EINVAL;
+
 	*lenp -= left;
 	*ppos += *lenp;
 	return err;
 }
 
+static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
+				     void __user *buffer,
+				     size_t *lenp, loff_t *ppos,
+				     unsigned long convmul,
+				     unsigned long convdiv)
+{
+	int vleft;
+	if (!data || !table->maxlen || !*lenp || (*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
+
+	vleft = table->maxlen / sizeof(unsigned long);
+	if (write) {
+		unsigned long min, max;
+
+		if (table->extra1)
+			min = *(unsigned long *) table->extra1;
+		else
+			min = 0;
+		if (table->extra2)
+			max = *(unsigned long *) table->extra2;
+		else
+			max = ULONG_MAX;
+		return __doulongvec_minmax_write(data, buffer, lenp,
+						  ppos, vleft, min, max);
+	} else
+		return __doulongvec_minmax_read(data, buffer, lenp,
+						 ppos, vleft, convmul, convdiv);
+}
+
 static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
-- 
1.6.5.2

