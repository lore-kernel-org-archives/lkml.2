Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab3AIVJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:09:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:43010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522Ab3AIUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@redhat.com>
Subject: [ 075/123] SMB3 mounts fail with access denied to some servers
Date: Wed,  9 Jan 2013 12:35:14 -0800
Message-Id: <20130109201508.237902414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit 52c0f4ad8ed462d81f1d37f56a74a71dc0c9bf0f upstream.

We were checking incorrectly if signatures were required to be sent,
so were always sending signatures after the initial session establishment.
For SMB3 mounts (vers=3.0) this was a problem because we were putting
SMB2 signatures in SMB3 requests which would cause access denied
on mount (the tree connection would fail).

This might also be worth considering for stable (for 3.7), as the
error message on mount (access denied) is confusing to users and
there is no workaround if the server is configured to only
support smb3.0. I am ok either way.

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -425,7 +425,7 @@ SMB2_negotiate(const unsigned int xid, s
 	}
 
 	cFYI(1, "sec_flags 0x%x", sec_flags);
-	if (sec_flags & CIFSSEC_MUST_SIGN) {
+	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
 		cFYI(1, "Signing required");
 		if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
 		      SMB2_NEGOTIATE_SIGNING_ENABLED))) {


