Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1CUXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:14:09 -0400
Received: from kroah.org ([198.145.64.141]:49117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1CUXOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:14:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:54 2011
Message-Id: <20110321231054.276488661@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [35/44] isdn: avoid calling tty_ldisc_flush() in atomic context
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


