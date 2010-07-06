Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0GFASu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:18:50 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:41934 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0GFASq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:18:46 -0400
Subject: [PATCH 2/2] isdn: avoid calling tty_ldisc_flush() in atomic context
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20100705-patch-isdn-02.tilman@imap.cc>
In-Reply-To: <20100705-patch-isdn-00.tilman@imap.cc>
References: <20100705-patch-isdn-00.tilman@imap.cc>
Date: Tue,  6 Jul 2010 02:18:27 +0200 (CEST)
X-Spam-Score: -1.282 () AWL,BAYES_20,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the call to tty_ldisc_flush() from the RESULT_NO_CARRIER
branch of isdn_tty_modem_result(), as already proposed in commit
00409bb045887ec5e7b9e351bc080c38ab6bfd33.
This avoids a "sleeping function called from invalid context" BUG
when the hardware driver calls the statcallb() callback with
command==ISDN_STAT_DHUP in atomic context, which in turn calls
isdn_tty_modem_result(RESULT_NO_CARRIER, ~), and from there,
tty_ldisc_flush() which may sleep.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/i4l/isdn_tty.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index fc8454d..51dc60d 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2636,12 +2636,6 @@ isdn_tty_modem_result(int code, modem_info * info)
 		if ((info->flags & ISDN_ASYNC_CLOSING) || (!info->tty)) {
 			return;
 		}
-#ifdef CONFIG_ISDN_AUDIO
-		if ( !info->vonline )
-			tty_ldisc_flush(info->tty);
-#else
-		tty_ldisc_flush(info->tty);
-#endif
 		if ((info->flags & ISDN_ASYNC_CHECK_CD) &&
 		    (!((info->flags & ISDN_ASYNC_CALLOUT_ACTIVE) &&
 		       (info->flags & ISDN_ASYNC_CALLOUT_NOHUP)))) {
-- 
1.6.5.3.298.g39add

