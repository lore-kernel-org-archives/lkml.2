Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab1FWRyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:54:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:35258 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665Ab1FWRh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Przemyslaw Bruski <pbruskispam@op.pl>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 190/247] ALSA: ctxfi - Fix SPDIF status retrieval
Date: Thu, 23 Jun 2011 13:34:18 -0400
Message-Id: <1308850515-15242-131-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Przemyslaw Bruski <pbruskispam@op.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f164753a263bfd2daaf3e0273b179de7e099c57d upstream.

SDPIF status retrieval always returned the default settings instead of
the actual ones.

Signed-off-by: Przemyslaw Bruski <pbruskispam@op.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/ctxfi/ctmixer.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 15c1e72..c3519ff 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -566,19 +566,6 @@ static int ct_spdif_get_mask(struct snd_kcontrol *kcontrol,
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
@@ -586,6 +573,10 @@ static int ct_spdif_get(struct snd_kcontrol *kcontrol,
 	unsigned int status;
 
 	atc->spdif_out_get_status(atc, &status);
+
+	if (status == 0)
+		status = SNDRV_PCM_DEFAULT_CON_SPDIF;
+
 	ucontrol->value.iec958.status[0] = (status >> 0) & 0xff;
 	ucontrol->value.iec958.status[1] = (status >> 8) & 0xff;
 	ucontrol->value.iec958.status[2] = (status >> 16) & 0xff;
@@ -629,7 +620,7 @@ static struct snd_kcontrol_new iec958_default_ctl = {
 	.name		= SNDRV_CTL_NAME_IEC958("", PLAYBACK, DEFAULT),
 	.count		= 1,
 	.info		= ct_spdif_info,
-	.get		= ct_spdif_default_get,
+	.get		= ct_spdif_get,
 	.put		= ct_spdif_put,
 	.private_value	= MIXER_IEC958_DEFAULT
 };
-- 
1.7.4.4

