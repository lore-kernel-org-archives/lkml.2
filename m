Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2ADRk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:40:58 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45329 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2ADRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:40:57 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, Daniel Mack <zonque@gmail.com>,
        Wolfgang Breyha <wbreyha@gmx.net>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
Date: Wed,  4 Jan 2012 12:39:09 -0500
Message-Id: <1325698749-5353-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A malicious USB device may feed in carefully crafted min/max/res values,
so that the inner loop in parse_uac2_sample_rate_range() could run for
a long time or even never terminate, e.g., given max = INT_MAX.

Also nr_rates could be a large integer, which causes an integer overflow
in the subsequent call to kmalloc() in parse_audio_format_rates_v2().
Thus, kmalloc() would allocate a smaller buffer than expected, leading
to a memory corruption.

To exploit the two vulnerabilities, an attacker needs physical access
to the machine to plug in a malicious USB device.

This patch makes two changes.

1) The type of "rate" is changed to unsigned int, so that the loop could
   stop once "rate" is larger than INT_MAX.

2) Limit nr_rates to avoid overflow.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 sound/usb/format.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 89421d1..a99de67 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -226,7 +226,7 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 		int min = combine_quad(&data[2 + 12 * i]);
 		int max = combine_quad(&data[6 + 12 * i]);
 		int res = combine_quad(&data[10 + 12 * i]);
-		int rate;
+		unsigned int rate;
 
 		if ((max < 0) || (min < 0) || (res < 0) || (max < min))
 			continue;
@@ -253,6 +253,9 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
+			/* avoid overflow */
+			if (nr_rates == KMALLOC_MAX_SIZE / sizeof(int))
+				break;
 
 			/* avoid endless loop */
 			if (res == 0)
-- 
1.7.5.4

