Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1ABHWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:34847 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1ABHWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Yusuke Goda <yusuke.goda.sx@renesas.com>,
        Matt Fleming <matt@console-pimps.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Paul Mundt <lethal@linux-sh.org>,
        <linux-mmc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 067/260] tmio_mmc: don't clear unhandled pending interrupts
Date: Sun,  2 Jan 2011 02:16:03 -0500
Message-Id: <1293952756-15010-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:19.0757 (UTC) FILETIME=[A6C8C3D0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yusuke Goda <yusuke.goda.sx@renesas.com>

commit b78d6c5f51935ba89df8db33a57bacb547aa7325 upstream.

Previously, it was possible for ack_mmc_irqs() to clear pending interrupt
bits in the CTL_STATUS register, even though the interrupt handler had not
been called.  This was because of a race that existed when doing a
read-modify-write sequence on CTL_STATUS.  After the read step in this
sequence, if an interrupt occurred (causing one of the bits in CTL_STATUS
to be set) the write step would inadvertently clear it.

Observed with the TMIO_STAT_RXRDY bit together with CMD53 on AR6002 and
BCM4318 SDIO cards in polled mode.

This patch eliminates this race by only writing to CTL_STATUS and clearing
the interrupts that were passed as an argument to ack_mmc_irqs()."

[matt@console-pimps.org: rewrote changelog]
Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Acked-by: Magnus Damm <damm@opensource.se>"
Tested-by: Arnd Hannemann <arnd@arndnet.de>"
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/host/tmio_mmc.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index dafecfb..1836ed9 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -80,10 +80,7 @@
 
 #define ack_mmc_irqs(host, i) \
 	do { \
-		u32 mask;\
-		mask  = sd_ctrl_read32((host), CTL_STATUS); \
-		mask &= ~((i) & TMIO_MASK_IRQ); \
-		sd_ctrl_write32((host), CTL_STATUS, mask); \
+		sd_ctrl_write32((host), CTL_STATUS, ~(i)); \
 	} while (0)
 
 
-- 
1.7.3.3

