Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1H0PCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:02:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab1H0O7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:59:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:53 2011
Message-Id: <20110826215053.403284701@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J.R. Okajima" <hooanon05@yahoo.co.jp>,
        Steve French <sfrench@us.ibm.com>
Subject: [05/35] [CIFS] possible memory corruption on mount
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit 13589c437daf4c8e429b3236c0b923de1c9420d8 upstream.

CIFS cleanup_volume_info_contents() looks like having a memory
corruption problem.
When UNCip is set to "&vol->UNC[2]" in cifs_parse_mount_options(), it
should not be kfree()-ed in cleanup_volume_info_contents().

Introduced in commit b946845a9dc523c759cae2b6a0f6827486c3221a

Signed-off-by: J.R. Okajima <hooanon05@yahoo.co.jp>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_
 	kfree(volume_info->username);
 	kzfree(volume_info->password);
 	kfree(volume_info->UNC);
-	kfree(volume_info->UNCip);
+	if (volume_info->UNCip != volume_info->UNC + 2)
+		kfree(volume_info->UNCip);
 	kfree(volume_info->domainname);
 	kfree(volume_info->iocharset);
 	kfree(volume_info->prepath);


