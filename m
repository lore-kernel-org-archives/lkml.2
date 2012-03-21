Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2CULkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:40:42 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:43621 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2CULkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:40:40 -0400
Message-ID: <4F69BE2E.7070903@t-online.de>
Date: Wed, 21 Mar 2012 12:40:30 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [REGRESSION][PATCH] Fix an old sky2 WOL regression
Content-Type: multipart/mixed;
 boundary="------------040100010800030605090509"
X-ID: rPJ6ycZbZh+biriUBUr2NbIE-x7nwT9zEz7jsQvdZi115k3Q5oqJ3Mw8ko1eJn+w+k
X-TOI-MSGID: 7f25fb76-4116-4a88-967e-012d2bd8d982
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040100010800030605090509
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sky2 Wake on LAN is broken since February 2010 on a number of systems.
Yes. More than two years.

We know about the problem and the cause since October 2010
(Bugzilla bug #19492). It´s commit 87b09f1f25cd1e01d7c50bf423c7fe33027d7511.

Stephen, David: You signed off that commit.

Andrew: You called it a regression in October 2010.

It has been proposed to revert the commit that caused the problem.
Nothing happened.

I proposed to re-establish the old code for dmi_match()ed systems.
Without success.

Now it is proposed to re-establish the old code as a configuration option.
If nothing happens again I will propose a module parameter ;-)

Stephen, I don´t want to be a pain in the neck, and it is not my intention
to offend you by my "attitude". But I simply cannot understand why this
know regression is not fixed. The bit we talk about is documented,
and in fact it was set for a number of kernel versions unconditionally.
Nobody complained about ruined hardware or minor problems.

The systems affected are old enough that no manufacturer cares about
them, but they are still quite usable for a lot of jobs (kernel 3.3 compile
time here is below 15 minutes).

If there is a problem in the kernel and if we do know an easy solution,
that solution should be commited to the kernel, no matter what is written
in some random documentation, no matter if we could blame some
BIOS authors. That´s the way Linux works - at least I thought so.

cu,
Knut

--------------040100010800030605090509
Content-Type: text/x-patch;
 name="0001-Fix-an-old-sky2-WOL-regression.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Fix-an-old-sky2-WOL-regression.patch"

>From 7fae2839363277835a0ac1f3f75a788aa299e0a1 Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Wed, 21 Mar 2012 07:42:20 +0100
Subject: [PATCH] Fix an old sky2 WOL regression

Commit 87b09f1f25cd1e01d7c50bf423c7fe33027d7511 removed
code to enable legacy power management mode during wake
on lan initialization. According to the documentation
this was the right thing to do, but it definitely broke
wake on lan on a number of systems.

The regression and the cause of the problem has been
reported more than _18_ months ago, see Bugzilla bug
19492. We should fix it now.

This patch introduces a kernel configuration option that
allows to select inclusion of code to set legacy PM mode
during wake on lan init.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 drivers/net/ethernet/marvell/Kconfig |   10 ++++++++++
 drivers/net/ethernet/marvell/sky2.c  |   11 ++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index 0029934..4f97020 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -98,6 +98,16 @@ config SKY2
 	  To compile this driver as a module, choose M here: the module
 	  will be called sky2.  This is recommended.
 
+config SKY2_PME_LEGACY
+	bool "WOL support for broken BIOSes"
+	depends on SKY2 && DEBUG_FS
+	---help---
+	  If this option is set, Yukon 2 legacy power management mode will
+	  be enabled during wake on lan setup. Some BIOS implementations
+	  need this for actual WOL support.
+
+	  If unsure, say N.
+
 config SKY2_DEBUG
 	bool "Debugging interface"
 	depends on SKY2 && DEBUG_FS
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 760c2b1..832589c 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -814,7 +814,9 @@ static void sky2_wol_init(struct sky2_port *sky2)
 	unsigned port = sky2->port;
 	enum flow_control save_mode;
 	u16 ctrl;
-
+#ifdef CONFIG_SKY2_PME_LEGACY
+	u32 reg1;
+#endif
 	/* Bring hardware out of reset */
 	sky2_write16(hw, B0_CTST, CS_RST_CLR);
 	sky2_write16(hw, SK_REG(port, GMAC_LINK_CTRL), GMLC_RST_CLR);
@@ -867,6 +869,13 @@ static void sky2_wol_init(struct sky2_port *sky2)
 	/* Disable PiG firmware */
 	sky2_write16(hw, B0_CTST, Y2_HW_WOL_OFF);
 
+#ifdef CONFIG_SKY2_PME_LEGACY
+	/* Needed by some broken BIOSes*/
+	reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
+	reg1 |= PCI_Y2_PME_LEGACY;
+	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
+#endif
+
 	/* block receiver */
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
 	sky2_read32(hw, B0_CTST);
-- 
1.7.9.2




--------------040100010800030605090509--
