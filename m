Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2DEFLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 01:11:47 -0400
Received: from tundra.namei.org ([65.99.196.166]:41047 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2DEFLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:11:46 -0400
Date: Thu, 5 Apr 2012 15:11:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Eugene Teo <eteo@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] sysctl: fix write access to
 dmesg_restrict/kptr_restrict
In-Reply-To: <20120404184019.GA32681@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1204051510230.24026@tundra.namei.org>
References: <20120404184019.GA32681@www.outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here it is in git pullable form for Linus:

The following changes since commit 6c216ec636f75d834461be15f83ec41a6759bd2b:
  Linus Torvalds (1):
        Merge tag 'for_linus-3.4-rc2' of git://git.kernel.org/.../jwessel/kgdb

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Kees Cook (1):
      sysctl: fix write access to dmesg_restrict/kptr_restrict

 kernel/sysctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

commit 620f6e8e855d6d447688a5f67a4e176944a084e8
Author: Kees Cook <keescook@chromium.org>
Date:   Wed Apr 4 11:40:19 2012 -0700

    sysctl: fix write access to dmesg_restrict/kptr_restrict
    
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
    Cc: stable@vger.kernel.org
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 52b3a06..4ab1187 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -170,7 +170,7 @@ static int proc_taint(struct ctl_table *table, int write,
 #endif
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -703,7 +703,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -712,7 +712,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kptr_restrict,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dmesg_restrict,
+		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -1943,7 +1943,7 @@ static int proc_taint(struct ctl_table *table, int write,
 }
 
 #ifdef CONFIG_PRINTK
-static int proc_dmesg_restrict(struct ctl_table *table, int write,
+static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (write && !capable(CAP_SYS_ADMIN))
