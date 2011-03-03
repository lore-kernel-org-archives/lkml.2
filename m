Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab1CCN72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:59:28 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:53828 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab1CCN71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DYx8vqZ/8dVAVywZ8D2dBPUyVBHVrFaV3q5liUPxcHL5vZmeQ1IkBwPk6wik6d0Wzh
         f3e7JqS/IKKknrH43CPs3mdU0Pff8ylq4c5yDQjZ+FjHmlMImJ1CE35T4arsBXjDm0wS
         Y0hS2Tb0GEmPTp6cbqoPrxa+DhzlKVY48oRhg=
Date: Thu, 3 Mar 2011 21:59:17 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/05] add proc_dointvec_bool sysctl handler
Message-ID: <20110303135917.GB2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proc_dointvec_bool sysctl handler for cases value is limited to 0 and 1

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

--- linux-2.6.orig/kernel/sysctl.c	2011-03-03 11:13:01.986661838 +0800
+++ linux-2.6/kernel/sysctl.c	2011-03-03 11:15:52.196661447 +0800
@@ -2448,6 +2448,33 @@ int proc_dointvec_minmax(struct ctl_tabl
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+/**
+ * proc_dointvec_bool - read a vector of integers with 0/1 values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are either 0 or 1.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_bool(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = &zero,
+		.max = &one,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_minmax_conv, &param);
+}
+EXPORT_SYMBOL(proc_dointvec_bool);
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
--- linux-2.6.orig/include/linux/sysctl.h	2010-06-22 14:02:49.000000000 +0800
+++ linux-2.6/include/linux/sysctl.h	2011-03-03 11:16:16.119994725 +0800
@@ -970,6 +970,8 @@ extern int proc_dointvec(struct ctl_tabl
 			 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_minmax(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_dointvec_bool(struct ctl_table *, int,
+				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
