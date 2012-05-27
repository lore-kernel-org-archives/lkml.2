Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534Ab2E0BOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:14:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933761Ab2E0BNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:13:53 -0400
Message-Id: <20120527002507.640354768@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:09 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 03/91] isdn/gigaset: improve error handling querying firmware version
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit e055d03dc088a990fe5ea24a2d64033a168da23c upstream.

An out-of-place "OK" response to the "AT+GMR" (get firmware version)
command turns out to be, more often than not, a delayed response to
a previous command rather than an actual error, so continue waiting
for the version number in that case.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/gigaset/ev-layer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -190,6 +190,7 @@ struct reply_t gigaset_tab_nocid[] =
 								  ACT_INIT} },
 	{RSP_OK,	121, 121, -1,			  0,  0, {ACT_GOTVER,
 								  ACT_INIT} },
+	{RSP_NONE,	121, 121, -1,			120,  0, {ACT_GETSTRING} },
 
 /* leave dle mode */
 	{RSP_INIT,	  0,   0, SEQ_DLE0,		201,  5, {0},	"^SDLE=0\r"},
@@ -1314,8 +1315,9 @@ static void do_action(int action, struct
 		s = ev->ptr;
 
 		if (!strcmp(s, "OK")) {
+			/* OK without version string: assume old response */
 			*p_genresp = 1;
-			*p_resp_code = RSP_ERROR;
+			*p_resp_code = RSP_NONE;
 			break;
 		}
 


