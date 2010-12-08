Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0LHBDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:44 -0500
Received: from kroah.org ([198.145.64.141]:33769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab0LHBDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:39 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:46 2010
Message-Id: <20101208005745.988154185@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [246/289] Revert "vfs: show unreachable paths in getcwd and proc"
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit 7b2a69ba7055da9a04eb96aa7b38c8e3280aaaa5 upstream.

Because it caused a chroot ttyname regression in 2.6.36.

As of 2.6.36 ttyname does not work in a chroot.  It has already been
reported that screen breaks, and for me this breaks an automated
distribution testsuite, that I need to preserve the ability to run the
existing binaries on for several more years.  glibc 2.11.3 which has a
fix for this is not an option.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1526,7 +1526,7 @@ static int do_proc_readlink(struct path
 	if (!tmp)
 		return -ENOMEM;
 
-	pathname = d_path_with_unreachable(path, tmp, PAGE_SIZE);
+	pathname = d_path(path, tmp, PAGE_SIZE);
 	len = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
 		goto out;


