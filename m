Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab1H0Q5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 12:57:37 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12261 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1H0Q5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 12:57:34 -0400
Date: Sat, 27 Aug 2011 18:58:34 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Steve French <sfrench@samba.org>
cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][Trivial] CIFS: Don't free volume_info->UNC until we are
 entirely done with it.
Message-ID: <alpine.LNX.2.00.1108271851470.27813@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cleanup_volume_info_contents() we kfree(volume_info->UNC); and then 
proceed to use that variable on the very next line.
This causes (at least) Coverity Prevent to complain about use-after-free 
of that variable (and I guess other checkers may do that as well).
There's not any /real/ problem here since we are just using the value of 
the pointer, not actually dereferencing it, but it's still trivial to 
silence the tool, so why not?
To me at least it also just seems nicer to defer freeing the variable 
until we are entirely done with it in all respects.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 633c246..9bb4b10 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2877,9 +2877,9 @@ cleanup_volume_info_contents(struct smb_vol *volume_info)
 {
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
-	kfree(volume_info->UNC);
 	if (volume_info->UNCip != volume_info->UNC + 2)
 		kfree(volume_info->UNCip);
+	kfree(volume_info->UNC);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);
-- 
1.7.6.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

