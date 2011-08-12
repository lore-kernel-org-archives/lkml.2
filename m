Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1HNQKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab1HNQK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.595559160@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>
Subject: [85/90] gianfar: fix fiper alignment after resetting the time
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit cbc056602c7c63620c86904c431ff6b61e029dcc upstream.

After resetting the time, the PPS signals on the FIPER output channels
are incorrectly offset from the clock time, as can be readily verified
by a looping back the FIPER to the external time stamp input.

Despite its name, setting the "Fiper Realignment Disable" bit seems to
fix the problem, at least on the P2020.

Also, following the example code from the Freescale BSP, it is not really
necessary to disable and re-enable the timer in order to reprogram the
FIPER. (The documentation is rather unclear on this point. It seems that
writing to the alarm register also disables the FIPER.)

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/gianfar_ptp.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/gianfar_ptp.c
+++ b/drivers/net/gianfar_ptp.c
@@ -193,14 +193,9 @@ static void set_alarm(struct etsects *et
 /* Caller must hold etsects->lock. */
 static void set_fipers(struct etsects *etsects)
 {
-	u32 tmr_ctrl = gfar_read(&etsects->regs->tmr_ctrl);
-
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl & (~TE));
-	gfar_write(&etsects->regs->tmr_prsc,   etsects->tmr_prsc);
+	set_alarm(etsects);
 	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
 	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
-	set_alarm(etsects);
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|TE);
 }
 
 /*
@@ -511,7 +506,7 @@ static int gianfar_ptp_probe(struct plat
 	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
 	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
 	set_alarm(etsects);
-	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE);
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE|FRD);
 
 	spin_unlock_irqrestore(&etsects->lock, flags);
 


