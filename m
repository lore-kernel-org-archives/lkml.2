Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2BQBE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:04:58 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51713 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756801Ab2BQBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:04 -0500
X-Sasl-enc: xcu1BnCNkVqyGq3Ek9N/nt+Ikb56MDUO9ygerTY+0i8C 1329440403
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:36 2012
Message-Id: <20120217005536.644510427@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>
Subject: [19/28] cifs: dont return error from standard_receive3 after
 marking response malformed
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit ff4fa4a25a33f92b5653bb43add0c63bea98d464 upstream.

standard_receive3 will check the validity of the response from the
server (via checkSMB). It'll pass the result of that check to handle_mid
which will dequeue it and mark it with a status of
MID_RESPONSE_MALFORMED if checkSMB returned an error. At that point,
standard_receive3 will also return an error, which will make the
demultiplex thread skip doing the callback for the mid.

This is wrong -- if we were able to identify the request and the
response is marked malformed, then we want the demultiplex thread to do
the callback. Fix this by making standard_receive3 return 0 in this
situation.

Reported-and-Tested-by: Mark Moseley <moseleymark@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -756,10 +756,11 @@ standard_receive3(struct TCP_Server_Info
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
-	if (mid)
-		handle_mid(mid, server, smb_buffer, length);
+	if (!mid)
+		return length;
 
-	return length;
+	handle_mid(mid, server, smb_buffer, length);
+	return 0;
 }
 
 static int


