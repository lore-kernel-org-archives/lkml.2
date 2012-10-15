Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2JOXsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:48:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49367 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2JOXsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:48:54 -0400
Date: Tue, 16 Oct 2012 00:48:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bisected regression in Linux 3.7.0-rc1, hang on login caused by
 replace_fd()
Message-ID: <20121015234853.GN2616@ZenIV.linux.org.uk>
References: <20121015171437.32e9a4ac@mj>
 <20121015215127.GK2616@ZenIV.linux.org.uk>
 <20121015191105.2dac4cac@mj>
 <20121015232705.GM2616@ZenIV.linux.org.uk>
 <20121015194008.29e38086@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015194008.29e38086@mj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 07:40:08PM -0400, Pavel Roskin wrote:
> On Tue, 16 Oct 2012 00:27:05 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > 	I think I understand what's going on there.  Add
> > fput(files[0]) after that replace_fd(); we have a leak and while
> > that's not the right way to fix it, that'd verify if anything else is
> > going on there.
> 
> Yes, it's working now!  No more hang on login!

That should be closer to the final variant.

diff --git a/fs/coredump.c b/fs/coredump.c
index fd37fac..ce47379 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -450,11 +450,12 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 
 	cp->file = files[1];
 
-	replace_fd(0, files[0], 0);
+	err = replace_fd(0, files[0], 0);
+	fput(files[0]);
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
-	return 0;
+	return err;
 }
 
 void do_coredump(siginfo_t *siginfo, struct pt_regs *regs)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 24ab414..61a5336 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2132,18 +2132,14 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 		return;
 
 	devnull = dentry_open(&selinux_null, O_RDWR, cred);
-	if (!IS_ERR(devnull)) {
-		/* replace all the matching ones with this */
-		do {
-			replace_fd(n - 1, get_file(devnull), 0);
-		} while ((n = iterate_fd(files, n, match_file, cred)) != 0);
+	if (IS_ERR(devnull))
+		devnull = NULL;
+	/* replace all the matching ones with this */
+	do {
+		replace_fd(n - 1, devnull, 0);
+	} while ((n = iterate_fd(files, n, match_file, cred)) != 0);
+	if (devnull)
 		fput(devnull);
-	} else {
-		/* just close all the matching ones */
-		do {
-			replace_fd(n - 1, NULL, 0);
-		} while ((n = iterate_fd(files, n, match_file, cred)) != 0);
-	}
 }
 
 /*
