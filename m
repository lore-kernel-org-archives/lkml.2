Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965718Ab2DKX3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:29:07 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53150 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702Ab2DKX3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:29:01 -0400
Message-Id: <20120411231312.198081129@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Phillip Lougher <plougher@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Richard Weinberger <richard@nod.at>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 28/42] sysctl: fix write access to dmesg_restrict/kptr_restrict
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 620f6e8e855d6d447688a5f67a4e176944a084e8 upstream.

Commit bfdc0b4 adds code to restrict access to dmesg_restrict,
however, it incorrectly alters kptr_restrict rather than
dmesg_restrict.

The original patch from Richard Weinberger
(https://lkml.org/lkml/2011/3/14/362) alters dmesg_restrict as
expected, and so the patch seems to have been misapplied.

This adds the CAP_SYS_ADMIN check to both dmesg_restrict and
kptr_restrict, since both are sensitive.

Reported-by: Phillip Lougher <plougher@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sysctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -172,7 +172,7 @@ static int proc_taint(struct ctl_table *
 #endif
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -709,7 +709,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -718,7 +718,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dmesg_restrict,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2416,7 +2416,7 @@ static int proc_taint(struct ctl_table *
 }
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (write && !capable(CAP_SYS_ADMIN))


