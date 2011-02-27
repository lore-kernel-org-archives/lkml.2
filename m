Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab1B0AYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 19:24:07 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48299 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1B0AYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 19:24:04 -0500
Subject: [PATCH] intel8x0m: schedule timeout before warm reset check
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sun, 27 Feb 2011 01:23:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1298766242.1828.20.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At every resume a laptop I use prints this message (at KERN_ERR level):
    ALSA sound/pci/intel8x0m.c:904: AC'97 warm reset still in progress?
[0x2]

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

One way to fix this is to call schedule_timeout_uninterruptible() at the
start of the loop. (This might punish the "finish cold reset" case, but
on this laptop such a cold reset apparently never happens, so I can't
say for sure.)

While we're at it drop the extra single tick from end_time, as it looks
rather silly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The question I asked in the previous message ("snd_intel8x0m: error
message because return value is unused?") made little sense. I probably
got quite confused by my own efforts to debug this.

 sound/pci/intel8x0m.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 13cec1e..9abff7b 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -894,11 +894,11 @@ static int snd_intel8x0m_ich_chip_init(struct intel8x0m *chip, int probing)
        /* finish cold or do warm reset */
        cnt |= (cnt & ICH_AC97COLD) == 0 ? ICH_AC97COLD : ICH_AC97WARM;
        iputdword(chip, ICHREG(GLOB_CNT), cnt);
-       end_time = (jiffies + (HZ / 4)) + 1;
+       end_time = jiffies + HZ / 4;
        do {
+               schedule_timeout_uninterruptible(1);
                if ((igetdword(chip, ICHREG(GLOB_CNT)) & ICH_AC97WARM) == 0)
                        goto __ok;
-               schedule_timeout_uninterruptible(1);
        } while (time_after_eq(end_time, jiffies));
        snd_printk(KERN_ERR "AC'97 warm reset still in progress? [0x%x]\n",
                   igetdword(chip, ICHREG(GLOB_CNT)));
-- 
1.7.4.1




