Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1CKKZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:25:06 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:50619 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1CKKZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:25:03 -0500
Subject: [PATCH v3] intel8x0m: wait a bit before warm reset check
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Date: Fri, 11 Mar 2011 11:24:52 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1299839101.12153.3.camel@t41.thuisdomein>
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

A way to fix this is to call usleep_range() after writing to the
register involved. A handful of tests suggest 500 usecs is a safe value.
(This might punish the "finish cold reset" case, but on this laptop such
a cold reset apparently never happens, so I can't say for sure.)

While we're at it drop the extra single tick from end_time, as it looks
rather silly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
changes in v3:
 - add comment
 - use usleep_range()

 sound/pci/intel8x0m.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 13cec1e..b1c926c 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -894,7 +894,8 @@ static int snd_intel8x0m_ich_chip_init(struct intel8x0m *chip, int probing)
 	/* finish cold or do warm reset */
 	cnt |= (cnt & ICH_AC97COLD) == 0 ? ICH_AC97COLD : ICH_AC97WARM;
 	iputdword(chip, ICHREG(GLOB_CNT), cnt);
-	end_time = (jiffies + (HZ / 4)) + 1;
+	usleep_range(500, 1000); /* give warm reset some time */
+	end_time = jiffies + HZ / 4;
 	do {
 		if ((igetdword(chip, ICHREG(GLOB_CNT)) & ICH_AC97WARM) == 0)
 			goto __ok;
-- 
1.7.4.1

