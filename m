Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab2CMAYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:48774 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965137Ab2CMAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 171/196] cifs: check for bytes_remaining going to zero in CIFS_SessSetup
Date: Mon, 12 Mar 2012 20:21:24 -0400
Message-Id: <1331598109-31424-126-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fcda7f4578bbf9717444ca6da8a421d21489d078 upstream.

It's possible that when we go to decode the string area in the
SESSION_SETUP response, that bytes_remaining will be 0. Decrementing it at
that point will mean that it can go "negative" and wrap. Check for a
bytes_remaining value of 0, and don't try to decode the string area if
that's the case.

Reported-and-Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/sess.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index c7d78c0..ff4f5b1 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -906,7 +906,9 @@ ssetup_ntlmssp_authenticate:
 	}
 
 	/* BB check if Unicode and decode strings */
-	if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
+	if (bytes_remaining == 0) {
+		/* no string area to decode, do nothing */
+	} else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
 		/* unicode string area must be word-aligned */
 		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
 			++bcc_ptr;
-- 
1.7.9.3

