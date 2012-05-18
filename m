Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031337Ab2ERX36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:29:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53597 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946311Ab2ERXDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:03:42 -0400
Message-Id: <20120518211601.489317137@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 22/54] ALSA: HDA: Lessen CPU usage when waiting for chip to respond
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -702,11 +702,13 @@ static unsigned int azx_rirb_get_respons
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
@@ -722,7 +724,7 @@ static unsigned int azx_rirb_get_respons
 		}
 		if (time_after(jiffies, timeout))
 			break;
-		if (bus->needs_damn_long_delay)
+		if (bus->needs_damn_long_delay || loopcounter > 3000)
 			msleep(2); /* temporary workaround */
 		else {
 			udelay(10);


