Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab0JGHO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:14:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55650 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0JGHO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:14:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sbU7SFnD876Trq+VPqOYoxDqfDBnLBcq9cg1YoiOYZ7S54HqqJMfl2ypzR3l49Hhhj
         LhJx1t1ma/nT45ntRjiabv3GwprJWX30Jv4IpHXXEyIWAsdd+I/Q883FxXgoeegP5Vjk
         wBPJYt4PI3BTf15E6FD66BF+hoNaIkVzXUg2I=
Date: Thu, 7 Oct 2010 15:18:59 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Robin Holt <holt@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, ebiederm@xmission.com
Subject: Re: [PATCH] sysctl: fix min/max handling in
 __do_proc_doulongvec_minmax()
Message-ID: <20101007071859.GD5471@cr0.nay.redhat.com>
References: <1286025469.2582.1806.camel@edumazet-laptop>
 <20101004085913.GR14068@sgi.com>
 <1286183058.18293.26.camel@edumazet-laptop>
 <20101004093439.GG5189@cr0.nay.redhat.com>
 <1286187030.18293.33.camel@edumazet-laptop>
 <20101004103545.GJ5189@cr0.nay.redhat.com>
 <1286188701.18293.57.camel@edumazet-laptop>
 <20101005130117.GK5170@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101005130117.GK5170@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:01:17PM +0800, Américo Wang wrote:
>On Mon, Oct 04, 2010 at 12:38:21PM +0200, Eric Dumazet wrote:
>>Le lundi 04 octobre 2010 à 18:35 +0800, Américo Wang a écrit :
>>
>>> Your patch does fix the problem, but seems not a good solution,
>>> we should skip all min/max checking if ->extra(1|2) is NULL,
>>> instead of checking it every time within the loop.
>>
>>Please do submit a patch, we'll see if you come to a better solution,
>>with no added code size (this is slow path, I dont care for checking it
>>'every time winthin the loop')
>>
>>
>
>I have one, but just did compile test. :)
>I will test it tomorrow.
>

Here is the final one.

--------------->

Eric D. noticed that we may trigger an OOPS if we leave ->extra{1,2}
to NULL when we use proc_doulongvec_minmax().

Actually, we don't need to store min/max values in a vector,
because all the elements in the vector should share the same min/max
value, like what proc_dointvec_minmax() does.

This also shrinks the binary size a little bit.

   text    data     bss     dec     hex filename
  12419    8744    4016   25179    625b kernel/sysctl.o.BEFORE
  12395    8744    4024   25163    624b kernel/sysctl.o.AFTER

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric W. <ebiederm@xmission.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f88552c..ba5e511 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2448,86 +2448,119 @@ int proc_dointvec_minmax(struct ctl_table *table, int write,
 				do_proc_dointvec_minmax_conv, &param);
 }
 
-static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
-				     void __user *buffer,
+static int __doulongvec_minmax_read(void *data, void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
 				     unsigned long convmul,
 				     unsigned long convdiv)
 {
-	unsigned long *i, *min, *max;
-	int vleft, first = 1, err = 0;
-	unsigned long page = 0;
-	size_t left;
-	char *kbuf;
+	unsigned long *i = (unsigned long *) data;
+	int err = 0;
+	bool first = true;
+	size_t left = *lenp;
 
-	if (!data || !table->maxlen || !*lenp || (*ppos && !write)) {
-		*lenp = 0;
-		return 0;
+	for (; left; i++, first=false) {
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
 
-	for (; left && vleft--; i++, min++, max++, first=0) {
+	for (; left && vleft--; i++, first=false) {
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
+	if (!data || !table->maxlen || !*lenp || (*ppos && !write)) {
+		*lenp = 0;
+		return 0;
+	}
+
+	if (write) {
+		unsigned long min, max;
+		int vleft;
+
+		vleft = table->maxlen / sizeof(unsigned long);
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
+						 ppos, convmul, convdiv);
+}
+
 static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
