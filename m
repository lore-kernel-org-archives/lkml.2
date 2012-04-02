Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2DBMMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:12:20 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47931 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 08/69] TTY: isdn, make some functions readable
Date: Mon,  2 Apr 2012 13:53:52 +0200
Message-Id: <1333367693-3244-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huh, this was a mess.

* Remove the 5 indent levels by just returning from isdn_tty_try_read
  when the conditions there are not satisfied.
* Use 'continue' in loop in isdn_tty_readmodem to save 2 levels.
* Chain 'if's in isdn_tty_modem_escape.
* Use 'continue' in loop in isdn_tty_carrier_timeout to save 1 level.

Better to look at this patch with -w -b.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |  178 ++++++++++++++++++++++---------------------
 1 file changed, 93 insertions(+), 85 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 1ff3072..74b0518 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -65,49 +65,54 @@ isdn_tty_try_read(modem_info *info, struct sk_buff *skb)
 	struct tty_struct *tty;
 	char last;
 
-	if (info->online) {
-		if ((tty = info->tty)) {
-			if (info->mcr & UART_MCR_RTS) {
-				len = skb->len
+	if (!info->online)
+		return 0;
+
+	tty = info->tty;
+	if (!tty)
+		return 0;
+
+	if (!(info->mcr & UART_MCR_RTS))
+		return 0;
+
+	len = skb->len
 #ifdef CONFIG_ISDN_AUDIO
-					+ ISDN_AUDIO_SKB_DLECOUNT(skb)
+		+ ISDN_AUDIO_SKB_DLECOUNT(skb)
 #endif
-					;
+		;
+
+	c = tty_buffer_request_room(tty, len);
+	if (c < len)
+		return 0;
 
-				c = tty_buffer_request_room(tty, len);
-				if (c >= len) {
-#ifdef CONFIG_ISDN_AUDIO
-					if (ISDN_AUDIO_SKB_DLECOUNT(skb)) {
-						int l = skb->len;
-						unsigned char *dp = skb->data;
-						while (--l) {
-							if (*dp == DLE)
-								tty_insert_flip_char(tty, DLE, 0);
-							tty_insert_flip_char(tty, *dp++, 0);
-						}
-						if (*dp == DLE)
-							tty_insert_flip_char(tty, DLE, 0);
-						last = *dp;
-					} else {
-#endif
-						if (len > 1)
-							tty_insert_flip_string(tty, skb->data, len - 1);
-						last = skb->data[len - 1];
 #ifdef CONFIG_ISDN_AUDIO
-					}
+	if (ISDN_AUDIO_SKB_DLECOUNT(skb)) {
+		int l = skb->len;
+		unsigned char *dp = skb->data;
+		while (--l) {
+			if (*dp == DLE)
+				tty_insert_flip_char(tty, DLE, 0);
+			tty_insert_flip_char(tty, *dp++, 0);
+		}
+		if (*dp == DLE)
+			tty_insert_flip_char(tty, DLE, 0);
+		last = *dp;
+	} else {
 #endif
-					if (info->emu.mdmreg[REG_CPPP] & BIT_CPPP)
-						tty_insert_flip_char(tty, last, 0xFF);
-					else
-						tty_insert_flip_char(tty, last, TTY_NORMAL);
-					tty_flip_buffer_push(tty);
-					kfree_skb(skb);
-					return 1;
-				}
-			}
-		}
+		if (len > 1)
+			tty_insert_flip_string(tty, skb->data, len - 1);
+		last = skb->data[len - 1];
+#ifdef CONFIG_ISDN_AUDIO
 	}
-	return 0;
+#endif
+	if (info->emu.mdmreg[REG_CPPP] & BIT_CPPP)
+		tty_insert_flip_char(tty, last, 0xFF);
+	else
+		tty_insert_flip_char(tty, last, TTY_NORMAL);
+	tty_flip_buffer_push(tty);
+	kfree_skb(skb);
+
+	return 1;
 }
 
 /* isdn_tty_readmodem() is called periodically from within timer-interrupt.
@@ -125,35 +130,39 @@ isdn_tty_readmodem(void)
 	modem_info *info;
 
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
-		if ((midx = dev->m_idx[i]) >= 0) {
-			info = &dev->mdm.info[midx];
-			if (info->online) {
-				r = 0;
+		midx = dev->m_idx[i];
+		if (midx < 0)
+			continue;
+
+		info = &dev->mdm.info[midx];
+		if (!info->online)
+			continue;
+
+		r = 0;
 #ifdef CONFIG_ISDN_AUDIO
-				isdn_audio_eval_dtmf(info);
-				if ((info->vonline & 1) && (info->emu.vpar[1]))
-					isdn_audio_eval_silence(info);
-#endif
-				if ((tty = info->tty)) {
-					if (info->mcr & UART_MCR_RTS) {
-						/* CISCO AsyncPPP Hack */
-						if (!(info->emu.mdmreg[REG_CPPP] & BIT_CPPP))
-							r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 0);
-						else
-							r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 1);
-						if (r)
-							tty_flip_buffer_push(tty);
-					} else
-						r = 1;
-				} else
-					r = 1;
-				if (r) {
-					info->rcvsched = 0;
-					resched = 1;
-				} else
-					info->rcvsched = 1;
-			}
-		}
+		isdn_audio_eval_dtmf(info);
+		if ((info->vonline & 1) && (info->emu.vpar[1]))
+			isdn_audio_eval_silence(info);
+#endif
+		tty = info->tty;
+		if (tty) {
+			if (info->mcr & UART_MCR_RTS) {
+				/* CISCO AsyncPPP Hack */
+				if (!(info->emu.mdmreg[REG_CPPP] & BIT_CPPP))
+					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 0);
+				else
+					r = isdn_readbchan_tty(info->isdn_driver, info->isdn_channel, tty, 1);
+				if (r)
+					tty_flip_buffer_push(tty);
+			} else
+				r = 1;
+		} else
+			r = 1;
+		if (r) {
+			info->rcvsched = 0;
+			resched = 1;
+		} else
+			info->rcvsched = 1;
 	}
 	if (!resched)
 		isdn_timer_ctrl(ISDN_TIMER_MODEMREAD, 0);
@@ -3769,19 +3778,19 @@ isdn_tty_modem_escape(void)
 	int midx;
 
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++)
-		if (USG_MODEM(dev->usage[i]))
-			if ((midx = dev->m_idx[i]) >= 0) {
-				modem_info *info = &dev->mdm.info[midx];
-				if (info->online) {
-					ton = 1;
-					if ((info->emu.pluscount == 3) &&
-					    time_after(jiffies , info->emu.lastplus + PLUSWAIT2)) {
-						info->emu.pluscount = 0;
-						info->online = 0;
-						isdn_tty_modem_result(RESULT_OK, info);
-					}
+		if (USG_MODEM(dev->usage[i]) && (midx = dev->m_idx[i]) >= 0) {
+			modem_info *info = &dev->mdm.info[midx];
+			if (info->online) {
+				ton = 1;
+				if ((info->emu.pluscount == 3) &&
+				    time_after(jiffies,
+					    info->emu.lastplus + PLUSWAIT2)) {
+					info->emu.pluscount = 0;
+					info->online = 0;
+					isdn_tty_modem_result(RESULT_OK, info);
 				}
 			}
+		}
 	isdn_timer_ctrl(ISDN_TIMER_MODEMPLUS, ton);
 }
 
@@ -3839,15 +3848,14 @@ isdn_tty_carrier_timeout(void)
 
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 		modem_info *info = &dev->mdm.info[i];
-		if (info->dialing) {
-			if (info->emu.carrierwait++ > info->emu.mdmreg[REG_WAITC]) {
-				info->dialing = 0;
-				isdn_tty_modem_result(RESULT_NO_CARRIER, info);
-				isdn_tty_modem_hup(info, 1);
-			}
-			else
-				ton = 1;
-		}
+		if (!info->dialing)
+			continue;
+		if (info->emu.carrierwait++ > info->emu.mdmreg[REG_WAITC]) {
+			info->dialing = 0;
+			isdn_tty_modem_result(RESULT_NO_CARRIER, info);
+			isdn_tty_modem_hup(info, 1);
+		} else
+			ton = 1;
 	}
 	isdn_timer_ctrl(ISDN_TIMER_CARRIER, ton);
 }
-- 
1.7.9.2


