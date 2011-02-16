Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1BPAVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:09 -0500
Received: from kroah.org ([198.145.64.141]:39191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab1BPAU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:35 2011
Message-Id: <20110216001435.594308642@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [105/272] ASoC: When disabling WM8994 FLL force a source selection
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 4514e8997fbefd5befd6176ac9785e287b4daed4 upstream.

When we disable the WM8994 FLL code path sharing means that we end up
writing out a configuration. Currently this is the currently active
input and output frequency (which causes snd_soc_update_bits() to
suppress actual writes both immediately and in the common case where
we reenable the same configuration later) but we allow machine drivers
to pass through a source of zero. Since the register values written
are one less than the source constants this causes corruption of other
bitfields in the register.

Fix this by using the most recently configured FLL source when none is
provided.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2930,6 +2930,7 @@ static int _wm8994_set_fll(struct snd_so
 		/* Allow no source specification when stopping */
 		if (freq_out)
 			return -EINVAL;
+		src = wm8994->fll[id].src;
 		break;
 	case WM8994_FLL_SRC_MCLK1:
 	case WM8994_FLL_SRC_MCLK2:


