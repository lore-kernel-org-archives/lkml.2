Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0LEXvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:51:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44185 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0LEXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:51:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@kernel.org
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Sun, 05 Dec 2010 15:51:21 -0800
Message-ID: <m1vd37lqx2.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Zte/rOcQuR1LhHewOz0yA6skEYUMHrsE=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH]: Revert 2.6.36 chroot ttyname regression
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As of 2.6.36 ttyname does not work in a chroot.  It has already
been reported that screen breaks, and for me this breaks an automated
distribution testsuite, that I need to preserve the ability to run
the existing binaries on for several more years.  glibc 2.11.3 which
has a fix for this is not an option.

The root cause of this breakage is:
commit 8df9d1a4142311c084ffeeacb67cd34d190eff74
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Tue Aug 10 11:41:41 2010 +0200

    vfs: show unreachable paths in getcwd and proc
    
    Prepend "(unreachable)" to path strings if the path is not reachable
    from the current root.
    
    Two places updated are
     - the return string from getcwd()
     - and symlinks under /proc/$PID.
    
    Other uses of d_path() are left unchanged (we know that some old
    software crashes if /proc/mounts is changed).
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


So remove the nice sounding, but ultimately ill advised change to how
/proc/fd symlinks work.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

---

Index: linux-2.6.37-rc4.x86_64/fs/proc/base.c
===================================================================
--- linux-2.6.37-rc4.x86_64.orig/fs/proc/base.c
+++ linux-2.6.37-rc4.x86_64/fs/proc/base.c
@@ -1574,7 +1574,7 @@ static int do_proc_readlink(struct path 
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path_with_unreachable(path, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;
