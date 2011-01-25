Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1AYFqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:46:34 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54046 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1AYFqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:46:33 -0500
Date: Tue, 25 Jan 2011 06:46:31 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] azt3328: repair breakage (Re: [PATCH 1/1] SOUND: azt3328,
 fix broken AZF_FMT_XLATE macro)
Message-ID: <20110125054631.GA10984@rhlx01.hs-esslingen.de>
References: <1295704570-27015-1-git-send-email-jslaby@suse.cz>
 <s5h1v44j45c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1v44j45c.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanly revert to non-macro implementation of
snd_azf3328_codec_setfmt(), to fix last-minute functionality breakage
induced by following checkpatch.pl recommendations without giving them
their due full share of thought ("revolting computer, ensuing PEBKAC").

I would like to thank Jiri Slaby for his very timely (in -rc1 even)
and unexpected (uncommon hardware) "recognition of the dangerous situation"
due to his very commendable static parser use. :)

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andreas Mohr <andi@lisas.de>
---
On Sat, Jan 22, 2011 at 05:26:39PM +0100, Takashi Iwai wrote:
> At Sat, 22 Jan 2011 14:56:10 +0100,
> Jiri Slaby wrote:
> > I vote for removing that crap completely because it makes the code
> > weird anyway -- you have to specify manually both of freq and bits
> > which is I would expect to be avoided exactly by such a macro.
> 
> I agree.  Andreas, please either revert back to the plain code,
> or use a simple look-up table if you don't want switch/case.

And indeed, the currently committed state IS broken since listening to audio
is strangely devoid of positive effects. :)
Sucks to be taking a larger tried and tested patch series into the holidays
and then making minor "improvements" to it before submission.


I decided that an additional lookup table isn't really worth it,
thus reverting is probably best.


The checkpatch.pl false positive (which triggered the horrid mistake of
additionally enclosing this per-case macro within do-while(0)) was:

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#20: FILE: azt3328.c:982:
+#define AZF_FMT_XLATE(in_freq, out_bits) \
+               case AZF_FREQ_ ## in_freq: \
+                       freq = SOUNDFORMAT_FREQ_ ## out_bits; \
+                       break;


It is also quite interesting to note that this rather uncommon language syntax
(do...while(0) within switch scope) compiled cleanly without issue
(no warnings).


Please note that this clean revert (exclusively created from existing
development steps) was compile-tested only and not runtime-tested on -rc2.
This is due to existing suspected modvers issues on -rc2 (it did work fine
in many previous versions, now I'm getting unresolved symbols issues
with my -dirty, extra/ modules, perhaps due to having switched to/enabled
CONFIG_KERNEL_LZO, CONFIG_DEBUG_SET_MODULE_RONX)
which I was unable to rectify sufficiently easily so far in my limited time.

The clean revert will be followed up by
corresponding comments and some cleanup within that function in the mid-future.

Thanks,

Andreas Mohr

diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 6117595..573594b 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -979,31 +979,25 @@ snd_azf3328_codec_setfmt(struct snd_azf3328_codec_data *codec,
 
 	snd_azf3328_dbgcallenter();
 	switch (bitrate) {
-#define AZF_FMT_XLATE(in_freq, out_bits) \
-	do { \
-		case AZF_FREQ_ ## in_freq: \
-			freq = SOUNDFORMAT_FREQ_ ## out_bits; \
-			break; \
-	} while (0);
-	AZF_FMT_XLATE(4000, SUSPECTED_4000)
-	AZF_FMT_XLATE(4800, SUSPECTED_4800)
-	/* the AZF3328 names it "5510" for some strange reason: */
-	AZF_FMT_XLATE(5512, 5510)
-	AZF_FMT_XLATE(6620, 6620)
-	AZF_FMT_XLATE(8000, 8000)
-	AZF_FMT_XLATE(9600, 9600)
-	AZF_FMT_XLATE(11025, 11025)
-	AZF_FMT_XLATE(13240, SUSPECTED_13240)
-	AZF_FMT_XLATE(16000, 16000)
-	AZF_FMT_XLATE(22050, 22050)
-	AZF_FMT_XLATE(32000, 32000)
+	case AZF_FREQ_4000:  freq = SOUNDFORMAT_FREQ_SUSPECTED_4000; break;
+	case AZF_FREQ_4800:  freq = SOUNDFORMAT_FREQ_SUSPECTED_4800; break;
+	case AZF_FREQ_5512:
+		/* the AZF3328 names it "5510" for some strange reason */
+			     freq = SOUNDFORMAT_FREQ_5510; break;
+	case AZF_FREQ_6620:  freq = SOUNDFORMAT_FREQ_6620; break;
+	case AZF_FREQ_8000:  freq = SOUNDFORMAT_FREQ_8000; break;
+	case AZF_FREQ_9600:  freq = SOUNDFORMAT_FREQ_9600; break;
+	case AZF_FREQ_11025: freq = SOUNDFORMAT_FREQ_11025; break;
+	case AZF_FREQ_13240: freq = SOUNDFORMAT_FREQ_SUSPECTED_13240; break;
+	case AZF_FREQ_16000: freq = SOUNDFORMAT_FREQ_16000; break;
+	case AZF_FREQ_22050: freq = SOUNDFORMAT_FREQ_22050; break;
+	case AZF_FREQ_32000: freq = SOUNDFORMAT_FREQ_32000; break;
 	default:
 		snd_printk(KERN_WARNING "unknown bitrate %d, assuming 44.1kHz!\n", bitrate);
 		/* fall-through */
-	AZF_FMT_XLATE(44100, 44100)
-	AZF_FMT_XLATE(48000, 48000)
-	AZF_FMT_XLATE(66200, SUSPECTED_66200)
-#undef AZF_FMT_XLATE
+	case AZF_FREQ_44100: freq = SOUNDFORMAT_FREQ_44100; break;
+	case AZF_FREQ_48000: freq = SOUNDFORMAT_FREQ_48000; break;
+	case AZF_FREQ_66200: freq = SOUNDFORMAT_FREQ_SUSPECTED_66200; break;
 	}
 	/* val = 0xff07; 3m27.993s (65301Hz; -> 64000Hz???) hmm, 66120, 65967, 66123 */
 	/* val = 0xff09; 17m15.098s (13123,478Hz; -> 12000Hz???) hmm, 13237.2Hz? */
