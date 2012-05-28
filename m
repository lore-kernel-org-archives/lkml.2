Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2E1Dxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:53:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451Ab2E1D3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:09 -0400
Message-Id: <20120528031206.065849401@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 023/117] isdn/gigaset: improve error handling querying firmware version
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit e055d03dc088a990fe5ea24a2d64033a168da23c upstream.

An out-of-place "OK" response to the "AT+GMR" (get firmware version)
command turns out to be, more often than not, a delayed response to
a previous command rather than an actual error, so continue waiting
for the version number in that case.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/gigaset/ev-layer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index 624a825..685638a 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -190,6 +190,7 @@ struct reply_t gigaset_tab_nocid[] =
 							  ACT_INIT} },
 {RSP_OK,	121, 121, -1,			  0,  0, {ACT_GOTVER,
 							  ACT_INIT} },
+{RSP_NONE,	121, 121, -1,			120,  0, {ACT_GETSTRING} },
 
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
 


