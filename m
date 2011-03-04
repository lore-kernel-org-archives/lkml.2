Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab1CDPqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:46:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1CDPqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XIPJ8EkmQ7IvHDkePxFUxg0koGLeL1+DG1hbnkI28pkhPIEYlWl8qGTR+Hot5vjgXG
         AFu5fvFERoXlenCUXw/jqbz11K2Y2Zo2VxV1OVnrpC+mBtm7YY5jauINKeAaD517BO3x
         UKba1g7NdQ+svODWK97HbqxUUqT+Ra0/AypdM=
Date: Fri, 4 Mar 2011 23:45:49 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: sysctl: add proc_dointvec_bool handler
Message-ID: <20110304154549.GA14672@darkstar>
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
