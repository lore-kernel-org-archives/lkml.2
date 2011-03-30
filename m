Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab1C3VZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:25:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:9049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075Ab1C3VJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278707"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: pbruskispam@op.pl, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [207/275] ALSA: ctxfi - Fix SPDIF status retrieval
Message-Id: <20110330210731.A34083E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Przemyslaw Bruski <pbruskispam@op.pl>

commit f164753a263bfd2daaf3e0273b179de7e099c57d upstream.

SDPIF status retrieval always returned the default settings instead of
the actual ones.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/ctxfi/ctmixer.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

Index: linux-2.6.35.y/sound/pci/ctxfi/ctmixer.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/ctxfi/ctmixer.c	2011-03-29 22:50:36.240331118 -0700
+++ linux-2.6.35.y/sound/pci/ctxfi/ctmixer.c	2011-03-29 23:03:02.576234251 -0700
@@ -566,19 +566,6 @@
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
@@ -586,6 +573,10 @@
 	unsigned int status;
 
 	atc->spdif_out_get_status(atc, &status);
+
+	if (status == 0)
+		status = SNDRV_PCM_DEFAULT_CON_SPDIF;
+
 	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
 	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
 	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
@@ -629,7 +620,7 @@
 	.name		= SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
 	.count		= 1,
 	.info		= ct_spdif_info,
-	.get		= ct_spdif_default_get,
+	.get		= ct_spdif_get,
 	.put		= ct_spdif_put,
 	.private_value	= MIXER_IEC958_DEFAULT
 };
