Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2AHOC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:02:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56947 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2AHOC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:02:57 -0500
Message-ID: <4F09A20C.7090705@gmail.com>
Date: Sun, 08 Jan 2012 09:02:52 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Clemens Ladisch <clemens@ladisch.de>, Daniel Mack <zonque@gmail.com>,
        Wolfgang Breyha <wbreyha@gmx.net>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH v2] ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
References: <1325698749-5353-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1325698749-5353-1-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

2) Limit nr_rates to 1024.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 sound/usb/format.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 89421d1..e09aba1 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -209,6 +209,8 @@ static int parse_audio_format_rates_v1(struct snd_usb_audio *chip, struct audiof
 	return 0;
 }
 
+#define MAX_UAC2_NR_RATES 1024
+
 /*
  * Helper function to walk the array of sample rate triplets reported by
  * the device. The problem is that we need to parse whole array first to
@@ -226,7 +228,7 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 		int min = combine_quad(&data[2 + 12 * i]);
 		int max = combine_quad(&data[6 + 12 * i]);
 		int res = combine_quad(&data[10 + 12 * i]);
-		int rate;
+		unsigned int rate;
 
 		if ((max < 0) || (min < 0) || (res < 0) || (max < min))
 			continue;
@@ -253,6 +255,10 @@ static int parse_uac2_sample_rate_range(struct audioformat *fp, int nr_triplets,
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
 
 			nr_rates++;
+			if (nr_rates >= MAX_UAC2_NR_RATES) {
+				snd_printk(KERN_ERR "invalid uac2 rates\n");
+				break;
+			}
 
 			/* avoid endless loop */
 			if (res == 0)
-- 
1.7.5.4


