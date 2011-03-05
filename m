Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1CEXBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 18:01:48 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:35747 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1CEXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 18:01:47 -0500
Subject: [PATCH v2] intel8x0m: wait a bit before warm reset check
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sun, 06 Mar 2011 00:01:43 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.90 (2.91.90-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1299366106.2470.5.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At every resume a laptop I use prints this message (at KERN_ERR level):
    ALSA sound/pci/intel8x0m.c:904: AC'97 warm reset still in progress? [0x2]

The thing to note here is that 0x2 corresponds to ICH_AC97COLD. Ie, what
seems to be happening is that the register involved indicated a warm
reset for some time (as the ICH_AC97WARM bit was set) but by the time
the warning is printed, and that same register is checked again, that
bit is already cleared and only the ICH_AC97COLD bit is still set.

It turns out a warm reset needs some time to settle, but it is currently
checked right away. The test therefore fails the first time it is done
and schedule_timeout_uninterruptible() will be called. Once we return
from that jiffies is already (far) past end_time on this laptop, so we
exit the loop, print a warning, and exit the function while the warm
reset actually succeeded.

One way to fix this is to call udelay() after writing to the register
involved. A handful of tests suggests 500 usecs is a safe value. (This
might punish the "finish cold reset" case, but on this laptop such a
cold reset apparently never happens, so I can't say for sure.)

While we're at it drop the extra single tick from end_time, as it looks
rather silly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v1 was called " intel8x0m: schedule timeout before warm reset check".

1) A udelay of 250 usecs always failed while 300 usecs always worked. So
500 usecs might be a bit cautious.

 sound/pci/intel8x0m.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 13cec1e..62fad24 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -894,7 +894,8 @@ static int snd_intel8x0m_ich_chip_init(struct intel8x0m *chip, int probing)
 	/* finish cold or do warm reset */
 	cnt |= (cnt & ICH_AC97COLD) == 0 ? ICH_AC97COLD : ICH_AC97WARM;
 	iputdword(chip, ICHREG(GLOB_CNT), cnt);
-	end_time = (jiffies + (HZ / 4)) + 1;
+	udelay(500);
+	end_time = jiffies + HZ / 4;
 	do {
 		if ((igetdword(chip, ICHREG(GLOB_CNT)) & ICH_AC97WARM) == 0)
 			goto __ok;
-- 
1.7.4.1



