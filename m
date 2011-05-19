Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab1ESSY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:24:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45993 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933797Ab1ESSHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:41 -0400
X-Sasl-enc: vJbb0e7LOaqV4AEr8xRempx/l+DD+IXgXzYrQ6myqQ5w 1305828460
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:54 2011
Message-Id: <20110519180554.565051940@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [03/71] cifs: sanitize length checking in coalesce_t2 (try #3)
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 2a2047bc94d0efc316401170c3d078d9edc20dc4 upstream.

There are a couple of places in this code where these values can wrap or
go negative, and that could potentially end up overflowing the buffer.
Ensure that that doesn't happen. Do all of the length calculation and
checks first, and only perform the memcpy after they pass.

Also, increase some stack variables to 32 bits to ensure that they don't
wrap without being detected.

Finally, change the error codes to be a bit more descriptive of any
problems detected. -EINVAL isn't very accurate.

Reported-and-Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -275,7 +275,8 @@ static int coalesce_t2(struct smb_hdr *p
 	char *data_area_of_target;
 	char *data_area_of_buf2;
 	int remaining;
-	__u16 byte_count, total_data_size, total_in_buf, total_in_buf2;
+	unsigned int byte_count, total_in_buf;
+	__u16 total_data_size, total_in_buf2;
 
 	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
@@ -288,7 +289,7 @@ static int coalesce_t2(struct smb_hdr *p
 	remaining = total_data_size - total_in_buf;
 
 	if (remaining < 0)
-		return -EINVAL;
+		return -EPROTO;
 
 	if (remaining == 0) /* nothing to do, ignore */
 		return 0;
@@ -309,20 +310,29 @@ static int coalesce_t2(struct smb_hdr *p
 	data_area_of_target += total_in_buf;
 
 	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
 	total_in_buf += total_in_buf2;
+	/* is the result too big for the field? */
+	if (total_in_buf > USHRT_MAX)
+		return -EPROTO;
 	put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCount);
+
+	/* fix up the BCC */
 	byte_count = get_bcc_le(pTargetSMB);
 	byte_count += total_in_buf2;
+	/* is the result too big for the field? */
+	if (byte_count > USHRT_MAX)
+		return -EPROTO;
 	put_bcc_le(byte_count, pTargetSMB);
 
 	byte_count = pTargetSMB->smb_buf_length;
 	byte_count += total_in_buf2;
-
-	/* BB also add check that we are not beyond maximum buffer size */
-
+	/* don't allow buffer to overflow */
+	if (byte_count > CIFSMaxBufSize)
+		return -ENOBUFS;
 	pTargetSMB->smb_buf_length = byte_count;
 
+	memcpy(data_area_of_target, data_area_of_buf2, total_in_buf2);
+
 	if (remaining == total_in_buf2) {
 		cFYI(1, "found the last secondary response");
 		return 0; /* we are done */


