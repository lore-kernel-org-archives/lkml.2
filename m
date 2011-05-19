Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab1ESSJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:47 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43058 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934175Ab1ESSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:40 -0400
X-Sasl-enc: Y5gbtiRDJ96WS9hszAa9wuxBoILx8WCmxrJIF2j73O0e 1305828579
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:01 2011
Message-Id: <20110519180600.989720946@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [70/71] cifs: fix cifsConvertToUCS() for the mapchars case
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 11379b5e33950048ad66825da7f462b0d0da9d73 upstream.

As Metze pointed out, commit 84cdf74e broke mapchars option:

    Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
    (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
    in just one commit (moving the function and changing it without
    testing).

    put_unaligned_le16(temp, &target[j]); is never called for any
    codepoint the goes via the 'default' switch statement. As a result
    we put just zero (or maybe uninitialized) bytes into the target
    buffer.

His proposed patch looks correct, but doesn't apply to the current head
of the tree. This patch should also fix it.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_unicode.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -277,6 +277,7 @@ cifsConvertToUCS(__le16 *target, const c
 
 	for (i = 0, j = 0; i < srclen; j++) {
 		src_char = source[i];
+		charlen = 1;
 		switch (src_char) {
 		case 0:
 			put_unaligned(0, &target[j]);
@@ -316,16 +317,13 @@ cifsConvertToUCS(__le16 *target, const c
 				dst_char = cpu_to_le16(0x003f);
 				charlen = 1;
 			}
-			/*
-			 * character may take more than one byte in the source
-			 * string, but will take exactly two bytes in the
-			 * target string
-			 */
-			i += charlen;
-			continue;
 		}
+		/*
+		 * character may take more than one byte in the source string,
+		 * but will take exactly two bytes in the target string
+		 */
+		i += charlen;
 		put_unaligned(dst_char, &target[j]);
-		i++; /* move to next char in source string */
 	}
 
 ctoUCS_out:


