Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab1CUXOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:14:04 -0400
Received: from kroah.org ([198.145.64.141]:49065 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896Ab1CUXN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:53 2011
Message-Id: <20110321231053.367702305@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:10:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Przemyslaw Bruski <pbruskispam@op.pl>, Takashi Iwai <tiwai@suse.de>
Subject: [26/44] ALSA: ctxfi - Fix SPDIF status retrieval
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Przemyslaw Bruski <pbruskispam@op.pl>

commit f164753a263bfd2daaf3e0273b179de7e099c57d upstream.

SDPIF status retrieval always returned the default settings instead of
the actual ones.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ctxfi/ctmixer.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -566,19 +566,6 @@ static int ct_spdif_get_mask(struct snd_
 	return 0;
 }
 
-static int ct_spdif_default_get(struct snd_kcontrol *kcontrol,
-				struct snd_ctl_elem_value *ucontrol)
-{
-	unsigned int status = SNDRV_PCM_DEFAULT_CON_SPDIF;
-
-	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
-	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
-	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
-	ucontrol->value.iec958.status[3] = (status >> 24) & 0xff;
-
-	return 0;
-}
-
 static int ct_spdif_get(struct snd_kcontrol *kcontrol,
 			struct snd_ctl_elem_value *ucontrol)
 {
@@ -586,6 +573,10 @@ static int ct_spdif_get(struct snd_kcont
 	unsigned int status;
 
 	atc->spdif_out_get_status(atc, &status);
+
+	if (status == 0)
+		status = SNDRV_PCM_DEFAULT_CON_SPDIF;
+
 	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
 	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
 	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
@@ -629,7 +620,7 @@ static struct snd_kcontrol_new iec958_de
 	.name		= SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
 	.count		= 1,
 	.info		= ct_spdif_info,
-	.get		= ct_spdif_default_get,
+	.get		= ct_spdif_get,
 	.put		= ct_spdif_put,
 	.private_value	= MIXER_IEC958_DEFAULT
 };


