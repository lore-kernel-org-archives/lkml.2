Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2DYXDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 19:03:06 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:50621 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab2DYXDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 19:03:03 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20120425-patch-gigaset-03.tilman@imap.cc>
In-Reply-To: <20120425-patch-gigaset-00.tilman@imap.cc>
References: <20120425-patch-gigaset-00.tilman@imap.cc>
Subject: [PATCH 3/8] isdn/gigaset: improve error handling querying firmware version
Date: Thu, 26 Apr 2012 01:02:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An out-of-place "OK" response to the "AT+GMR" (get firmware version)
command turns out to be, more often than not, a delayed response to
a previous command rather than an actual error, so continue waiting
for the version number in that case.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
CC: stable <stable@kernel.org>
---
 drivers/isdn/gigaset/ev-layer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index 624a825..685638a 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -190,6 +190,7 @@ struct reply_t gigaset_tab_nocid[] =
 								  ACT_INIT} },
 	{RSP_OK,	121, 121, -1,			  0,  0, {ACT_GOTVER,
 								  ACT_INIT} },
+	{RSP_NONE,	121, 121, -1,			120,  0, {ACT_GETSTRING} },
 
 /* leave dle mode */
 	{RSP_INIT,	  0,   0, SEQ_DLE0,		201,  5, {0},	"^SDLE=0\r"},
@@ -1314,8 +1315,9 @@ static void do_action(int action, struct cardstate *cs,
 		s = ev->ptr;
 
 		if (!strcmp(s, "OK")) {
+			/* OK without version string: assume old response */
 			*p_genresp = 1;
-			*p_resp_code = RSP_ERROR;
+			*p_resp_code = RSP_NONE;
 			break;
 		}
 
-- 
1.7.3.4

