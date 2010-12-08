Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0LHBFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:05:52 -0500
Received: from kroah.org ([198.145.64.141]:33944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab0LHBEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.827037852@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:01:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Matthew Garrett <mjg@redhat.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [284/289] r8169: revert "Handle rxfifo errors on 8168 chips"
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit 53f57357ff0afc37804f4e82ee3123e0c0a2cad6 upstream.

The original patch helps under obscure conditions (no pun) but
some 8168 do not like it. The change needs to be tightened with
a specific 8168 version.

This reverts commit 801e147cde02f04b5c2f42764cd43a89fc7400a2
("r8169: Handle rxfifo errors on 8168 chips").

Regression at https://bugzilla.kernel.org/show_bug.cgi?id=20882

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Andreas Radke <a.radke@arcor.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2936,7 +2936,7 @@ static const struct rtl_cfg_info {
 		.hw_start	= rtl_hw_start_8168,
 		.region		= 2,
 		.align		= 8,
-		.intr_event	= SYSErr | RxFIFOOver | LinkChg | RxOverflow |
+		.intr_event	= SYSErr | LinkChg | RxOverflow |
 				  TxErr | TxOK | RxOK | RxErr,
 		.napi_event	= TxErr | TxOK | RxOK | RxOverflow,
 		.features	= RTL_FEATURE_GMII | RTL_FEATURE_MSI,
@@ -4628,7 +4628,8 @@ static irqreturn_t rtl8169_interrupt(int
 		}
 
 		/* Work around for rx fifo overflow */
-		if (unlikely(status & RxFIFOOver)) {
+		if (unlikely(status & RxFIFOOver) &&
+		(tp->mac_version == RTL_GIGA_MAC_VER_11)) {
 			netif_stop_queue(dev);
 			rtl8169_tx_timeout(dev);
 			break;


