Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0HXWri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:47:38 -0400
Received: from kroah.org ([198.145.64.141]:59784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab0HXWrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:35 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:18:20 2010
Message-Id: <20100824221820.328044232@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:16:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen D. Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        Florian Mickler <florian@mickler.org>
Subject: [3/8] selinux: use default proc sid on symlinks
In-Reply-To: <20100824224631.GA5458@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1197
Lines: 32

From: Stephen Smalley <sds@tycho.nsa.gov>

commit ea6b184f7d521a503ecab71feca6e4057562252b upstream.

As we are not concerned with fine-grained control over reading of
symlinks in proc, always use the default proc SID for all proc symlinks.
This should help avoid permission issues upon changes to the proc tree
as in the /proc/net -> /proc/self/net example.
This does not alter labeling of symlinks within /proc/pid directories.
ls -Zd /proc/net output before and after the patch should show the difference.

Signed-off-by:  Stephen D. Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
Cc: Florian Mickler <florian@mickler.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1290,7 +1290,7 @@ static int inode_doinit_with_dentry(stru
 		/* Default to the fs superblock SID. */
 		isec->sid = sbsec->sid;
 
-		if (sbsec->proc) {
+		if (sbsec->proc && !S_ISLNK(inode->i_mode)) {
 			struct proc_inode *proci = PROC_I(inode);
 			if (proci->pde) {
 				isec->sclass = inode_mode_to_security_class(inode->i_mode);


