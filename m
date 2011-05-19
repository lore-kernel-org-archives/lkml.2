Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab1ESSHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:07:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37293 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933751Ab1ESSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:38 -0400
X-Sasl-enc: Y2c1RhPgiKP7bqvjQaGFYgXQ0Ac6nRiwc4KKCQMLb7b5 1305828457
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:54 2011
Message-Id: <20110519180554.372523805@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [01/71] cifs: change bleft in decode_unicode_ssetup back to signed type
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit bfacf2225a955bea9c41c707fc72ba16009674a0 upstream.

The buffer length checks in this function depend on this value being a
signed data type, but 690c522fa converted it to an unsigned type.

Also, eliminate a problem with the null termination check in the same
function. cifs_strndup_from_ucs handles that situation correctly
already, and the existing check could potentially lead to a buffer
overrun since it increments bleft without checking to see whether it
falls off the end of the buffer.

Reported-and-Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -277,7 +277,7 @@ static void ascii_ssetup_strings(char **
 }
 
 static void
-decode_unicode_ssetup(char **pbcc_area, __u16 bleft, struct cifsSesInfo *ses,
+decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 		      const struct nls_table *nls_cp)
 {
 	int len;
@@ -285,19 +285,6 @@ decode_unicode_ssetup(char **pbcc_area,
 
 	cFYI(1, "bleft %d", bleft);
 
-	/*
-	 * Windows servers do not always double null terminate their final
-	 * Unicode string. Check to see if there are an uneven number of bytes
-	 * left. If so, then add an extra NULL pad byte to the end of the
-	 * response.
-	 *
-	 * See section 2.7.2 in "Implementing CIFS" for details
-	 */
-	if (bleft % 2) {
-		data[bleft] = 0;
-		++bleft;
-	}
-
 	kfree(ses->serverOS);
 	ses->serverOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
 	cFYI(1, "serverOS=%s", ses->serverOS);


