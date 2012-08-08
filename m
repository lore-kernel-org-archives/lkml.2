Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2HHS4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:56:18 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:11133 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484Ab2HHS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:56:17 -0400
Date: Wed, 8 Aug 2012 20:56:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Jay Lan <jlan@sgi.com>
Subject: [PATCH] Documentation/accounting/getdelays.c: remember to close()
 socket on error in create_nl_socket()
Message-ID: <alpine.LNX.2.00.1208082053100.10061@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the call to setsockopt() fails in
Documentation/accounting/getdelays.c::create_nl_socket() we return -1
without closing the socket, thus leaking it when the 'fd' variable
goes out of scope.

Easily fixed by just jumping to the 'error' label instead of returning
since we do the proper cleanup there.

While I was there I noticed that the error message that is printet if
setsockopt() fails was broken over two lines - put that on a single
line so it is easier to grep for.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 Documentation/accounting/getdelays.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index f6318f6..6f706ac 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -98,10 +98,9 @@ static int create_nl_socket(int protocol)
 	if (rcvbufsz)
 		if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
 				&rcvbufsz, sizeof(rcvbufsz)) < 0) {
-			fprintf(stderr, "Unable to set socket rcv buf size "
-					"to %d\n",
+			fprintf(stderr, "Unable to set socket rcv buf size to %d\n",
 				rcvbufsz);
-			return -1;
+			goto error;
 		}
 
 	memset(&local, 0, sizeof(local));
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

