Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0D1TY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:24:26 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:5159 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0D1TYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:24:24 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN936eM62a3Lab9bh8c8aizz1202hzz6ff19h2ba5Mz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L1LPWA-02-PO2-02
X-M-MSG: 
Date: Wed, 28 Apr 2010 21:24:09 +0200
From: Robert Richter <robert.richter@amd.com>
To: Siarhei Siamashka <siarhei.siamashka@nokia.com>
CC: oprofile-list@lists.sourceforge.net,
       "Carmody Phil.2 (EXT-Ixonos/Helsinki)" <ext-phil.2.carmody@nokia.com>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile, hrtimer: only add samples if regs are available
Message-ID: <20100428192409.GB21724@erda.amd.com>
References: <20100427152544.GA9063@pcarmody-desktop>
 <20100427174026.GR6450@erda.amd.com>
 <201004272047.52056.siarhei.siamashka@nokia.com>
 <20100428165906.GA21724@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100428165906.GA21724@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Apr 2010 19:24:10.0224 (UTC) FILETIME=[60BD1700:01CAE708]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.04.10 18:59:06, Robert Richter wrote:
> On 27.04.10 20:47:51, Siarhei Siamashka wrote:
> > Isn't hrtimer callback function supposed to be only called from IRQ context
> > after this cleanup: http://lwn.net/Articles/308545/ ?
> 
> Yes, the patch is upstream since v2.6.29. Thanks Siarhei.
> 
> I will add a null pointer check anyway.

--

>From ad8a6546b32d22ecf92b4448ad329133d18dde0f Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 28 Apr 2010 20:43:18 +0200
Subject: [PATCH] oprofile, hrtimer: only add samples if regs are available

This patch adds a check if the regs pointer is valid. This actually
should not happen since hrtimer notification code should always run in
hard_irq context after this commit (since v2.6.29):

 ca10949 hrtimer: removing all ur callback modes

However, if code does not run in interrupt context, regs will be null:

 http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14074.html

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/timer_int.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index dc0ae4d..ca3436c 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -24,8 +24,12 @@ static DEFINE_PER_CPU(struct hrtimer, oprofile_hrtimer);
 
 static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
 {
-	oprofile_add_sample(get_irq_regs(), 0);
+	struct pt_regs *regs = get_irq_regs();
+
+	if (regs)
+		oprofile_add_sample(regs, 0);
 	hrtimer_forward_now(hrtimer, ns_to_ktime(TICK_NSEC));
+
 	return HRTIMER_RESTART;
 }
 
-- 
1.7.0.3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

