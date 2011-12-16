Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1LPUIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:08:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760388Ab1LPTsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:48:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:57 2011
Message-Id: <20111216194557.272123967@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [20/53] TOMOYO: Fix pathname handling of disconnected paths.
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 1418a3e5ad4d01b1d4abf2c479c50b0cedd59e3f upstream.

Current tomoyo_realpath_from_path() implementation returns strange pathname
when calculating pathname of a file which belongs to lazy unmounted tree.
Use local pathname rather than strange absolute pathname in that case.

Also, this patch fixes a regression by commit 02125a82 "fix apparmor
dereferencing potentially freed dentry, sanitize __d_path() API".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/tomoyo/realpath.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -275,8 +275,16 @@ char *tomoyo_realpath_from_path(struct p
 			pos = tomoyo_get_local_path(path->dentry, buf,
 						    buf_len - 1);
 		/* Get absolute name for the rest. */
-		else
+		else {
 			pos = tomoyo_get_absolute_path(path, buf, buf_len - 1);
+			/*
+			 * Fall back to local name if absolute name is not
+			 * available.
+			 */
+			if (pos == ERR_PTR(-EINVAL))
+				pos = tomoyo_get_local_path(path->dentry, buf,
+							    buf_len - 1);
+		}
 encode:
 		if (IS_ERR(pos))
 			continue;


