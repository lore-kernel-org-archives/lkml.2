Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1DYUYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:41 -0400
Received: from 1wt.eu ([62.212.114.60]:34208 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab1DYUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:35 -0400
Message-Id: <20110425200237.210068643@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Tilman Schmidt <tilman@imap.cc>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 097/173] isdn: avoid calling tty_ldisc_flush() in atomic context
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit bc10f96757bd6ab3721510df8defa8f21c32f974 upstream.

Remove the call to tty_ldisc_flush() from the RESULT_NO_CARRIER
branch of isdn_tty_modem_result(), as already proposed in commit
00409bb045887ec5e7b9e351bc080c38ab6bfd33.
This avoids a "sleeping function called from invalid context" BUG
when the hardware driver calls the statcallb() callback with
command==ISDN_STAT_DHUP in atomic context, which in turn calls
isdn_tty_modem_result(RESULT_NO_CARRIER, ~), and from there,
tty_ldisc_flush() which may sleep.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/i4l/isdn_tty.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2635,12 +2635,6 @@ isdn_tty_modem_result(int code, modem_in
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


