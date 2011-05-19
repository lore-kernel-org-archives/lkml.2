Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab1ESSHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:07:42 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48068 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933751Ab1ESSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:39 -0400
X-Sasl-enc: GUcSmcd0uRFQTUGmI19J0SqIn3z5zsY6pjknq8QnkPaT 1305828458
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:54 2011
Message-Id: <20110519180554.468490820@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [02/71] cifs: check for bytes_remaining going to zero in CIFS_SessSetup
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit fcda7f4578bbf9717444ca6da8a421d21489d078 upstream.

It's possible that when we go to decode the string area in the
SESSION_SETUP response, that bytes_remaining will be 0. Decrementing it at
that point will mean that it can go "negative" and wrap. Check for a
bytes_remaining value of 0, and don't try to decode the string area if
that's the case.

Reported-and-Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -917,7 +917,9 @@ ssetup_ntlmssp_authenticate:
 	}
 
 	/* BB check if Unicode and decode strings */
-	if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
+	if (bytes_remaining == 0) {
+		/* no string area to decode, do nothing */
+	} else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
 		/* unicode string area must be word-aligned */
 		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
 			++bcc_ptr;


