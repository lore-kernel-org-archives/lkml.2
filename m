Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab2I1S6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152Ab2I1S6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Karsten Keil <keil@b1-systems.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 102/262] mISDN: Fix wrong usage of flush_work_sync while holding locks
Date: Fri, 28 Sep 2012 11:50:31 -0700
Message-Id: <20120928183010.168233564@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karsten Keil <keil@b1-systems.de>

commit 4b921eda53366b319602351ff4d7256fafa4bd1b upstream.

It is a bad idea to hold a spinlock and call flush_work_sync.
Move the workqueue cleanup outside the spinlock and use cancel_work_sync,
on closing the channel this seems to be the more correct function.
Remove the never used and constant return value of mISDN_freebchannel.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/hardware/mISDN/avmfritz.c  |    3 ++-
 drivers/isdn/hardware/mISDN/mISDNipac.c |    3 ++-
 drivers/isdn/hardware/mISDN/mISDNisar.c |    3 ++-
 drivers/isdn/hardware/mISDN/netjet.c    |    3 ++-
 drivers/isdn/hardware/mISDN/w6692.c     |    3 ++-
 drivers/isdn/mISDN/hwchannel.c          |    9 ++++-----
 include/linux/mISDNhw.h                 |    2 +-
 7 files changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -857,8 +857,9 @@ avm_bctrl(struct mISDNchannel *ch, u32 c
 	switch (cmd) {
 	case CLOSE_CHANNEL:
 		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		cancel_work_sync(&bch->workq);
 		spin_lock_irqsave(&fc->lock, flags);
-		mISDN_freebchannel(bch);
+		mISDN_clear_bchannel(bch);
 		modehdlc(bch, ISDN_P_NONE);
 		spin_unlock_irqrestore(&fc->lock, flags);
 		ch->protocol = ISDN_P_NONE;
--- a/drivers/isdn/hardware/mISDN/mISDNipac.c
+++ b/drivers/isdn/hardware/mISDN/mISDNipac.c
@@ -1406,8 +1406,9 @@ hscx_bctrl(struct mISDNchannel *ch, u32
 	switch (cmd) {
 	case CLOSE_CHANNEL:
 		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		cancel_work_sync(&bch->workq);
 		spin_lock_irqsave(hx->ip->hwlock, flags);
-		mISDN_freebchannel(bch);
+		mISDN_clear_bchannel(bch);
 		hscx_mode(hx, ISDN_P_NONE);
 		spin_unlock_irqrestore(hx->ip->hwlock, flags);
 		ch->protocol = ISDN_P_NONE;
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -1588,8 +1588,9 @@ isar_bctrl(struct mISDNchannel *ch, u32
 	switch (cmd) {
 	case CLOSE_CHANNEL:
 		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		cancel_work_sync(&bch->workq);
 		spin_lock_irqsave(ich->is->hwlock, flags);
-		mISDN_freebchannel(bch);
+		mISDN_clear_bchannel(bch);
 		modeisar(ich, ISDN_P_NONE);
 		spin_unlock_irqrestore(ich->is->hwlock, flags);
 		ch->protocol = ISDN_P_NONE;
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -812,8 +812,9 @@ nj_bctrl(struct mISDNchannel *ch, u32 cm
 	switch (cmd) {
 	case CLOSE_CHANNEL:
 		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		cancel_work_sync(&bch->workq);
 		spin_lock_irqsave(&card->lock, flags);
-		mISDN_freebchannel(bch);
+		mISDN_clear_bchannel(bch);
 		mode_tiger(bc, ISDN_P_NONE);
 		spin_unlock_irqrestore(&card->lock, flags);
 		ch->protocol = ISDN_P_NONE;
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -1054,8 +1054,9 @@ w6692_bctrl(struct mISDNchannel *ch, u32
 	switch (cmd) {
 	case CLOSE_CHANNEL:
 		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		cancel_work_sync(&bch->workq);
 		spin_lock_irqsave(&card->lock, flags);
-		mISDN_freebchannel(bch);
+		mISDN_clear_bchannel(bch);
 		w6692_mode(bc, ISDN_P_NONE);
 		spin_unlock_irqrestore(&card->lock, flags);
 		ch->protocol = ISDN_P_NONE;
--- a/drivers/isdn/mISDN/hwchannel.c
+++ b/drivers/isdn/mISDN/hwchannel.c
@@ -148,17 +148,16 @@ mISDN_clear_bchannel(struct bchannel *ch
 	ch->next_minlen = ch->init_minlen;
 	ch->maxlen = ch->init_maxlen;
 	ch->next_maxlen = ch->init_maxlen;
+	skb_queue_purge(&ch->rqueue);
+	ch->rcount = 0;
 }
 EXPORT_SYMBOL(mISDN_clear_bchannel);
 
-int
+void
 mISDN_freebchannel(struct bchannel *ch)
 {
+	cancel_work_sync(&ch->workq);
 	mISDN_clear_bchannel(ch);
-	skb_queue_purge(&ch->rqueue);
-	ch->rcount = 0;
-	flush_work_sync(&ch->workq);
-	return 0;
 }
 EXPORT_SYMBOL(mISDN_freebchannel);
 
--- a/include/linux/mISDNhw.h
+++ b/include/linux/mISDNhw.h
@@ -183,7 +183,7 @@ extern int	mISDN_initbchannel(struct bch
 				   unsigned short);
 extern int	mISDN_freedchannel(struct dchannel *);
 extern void	mISDN_clear_bchannel(struct bchannel *);
-extern int	mISDN_freebchannel(struct bchannel *);
+extern void	mISDN_freebchannel(struct bchannel *);
 extern int	mISDN_ctrl_bchannel(struct bchannel *, struct mISDN_ctrl_req *);
 extern void	queue_ch_frame(struct mISDNchannel *, u_int,
 			int, struct sk_buff *);


