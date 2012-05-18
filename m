Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031177Ab2ERDJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:09:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762545Ab2ERCw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:27 -0400
Message-Id: <20120518023255.053534199@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:32:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 05/53] ALSA: HDA: Lessen CPU usage when waiting for chip to respond
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 32cf4023e689ad5b3a81a749d8cc99d7f184cb99 upstream.

When an IRQ for some reason gets lost, we wait up to a second using
udelay, which is CPU intensive. This patch improves the situation by
waiting about 30 ms in the CPU intensive mode, then stepping down to
using msleep(2) instead. In essence, we trade some granularity in
exchange for less CPU consumption when the waiting time is a bit longer.

As a result, PulseAudio should no longer be killed by the kernel
for taking up to much RT-prio CPU time. At least not for *this* reason.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Tested-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_intel.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 6e958bf..1f35052 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -783,11 +783,13 @@ static unsigned int azx_rirb_get_response(struct hda_bus *bus,
 {
 	struct azx *chip = bus->private_data;
 	unsigned long timeout;
+	unsigned long loopcounter;
 	int do_poll = 0;
 
  again:
 	timeout = jiffies + msecs_to_jiffies(1000);
-	for (;;) {
+
+	for (loopcounter = 0;; loopcounter++) {
 		if (chip->polling_mode || do_poll) {
 			spin_lock_irq(&chip->reg_lock);
 			azx_update_rirb(chip);
@@ -803,7 +805,7 @@ static unsigned int azx_rirb_get_response(struct hda_bus *bus,
 		}
 		if (time_after(jiffies, timeout))
 			break;
-		if (bus->needs_damn_long_delay)
+		if (bus->needs_damn_long_delay || loopcounter > 3000)
 			msleep(2); /* temporary workaround */
 		else {
 			udelay(10);
-- 
1.7.10



