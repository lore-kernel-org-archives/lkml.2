Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1ABHrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:47:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:36170 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1ABHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 160/260] ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:17:36 -0500
Message-Id: <1293952756-15010-161-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:05.0884 (UTC) FILETIME=[E60A75C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit e68d3b316ab7b02a074edc4f770e6a746390cb7d upstream.

The SNDRV_HDSP_IOCTL_GET_CONFIG_INFO and
SNDRV_HDSP_IOCTL_GET_CONFIG_INFO ioctls in hdspm.c and hdsp.c allow
unprivileged users to read uninitialized kernel stack memory, because
several fields of the hdsp{m}_config_info structs declared on the stack
are not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/rme9652/hdsp.c  |    1 +
 sound/pci/rme9652/hdspm.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index b92adef..d6fa7bf 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -4609,6 +4609,7 @@ static int snd_hdsp_hwdep_ioctl(struct snd_hwdep *hw, struct file *file, unsigne
 		if (err < 0)
 			return err;
 
+		memset(&info, 0, sizeof(info));
 		spin_lock_irqsave(&hdsp->lock, flags);
 		info.pref_sync_ref = (unsigned char)hdsp_pref_sync_ref(hdsp);
 		info.wordclock_sync_check = (unsigned char)hdsp_wc_sync_check(hdsp);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 547b713..0c98ef9 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4127,6 +4127,7 @@ static int snd_hdspm_hwdep_ioctl(struct snd_hwdep * hw, struct file *file,
 
 	case SNDRV_HDSPM_IOCTL_GET_CONFIG_INFO:
 
+		memset(&info, 0, sizeof(info));
 		spin_lock_irq(&hdspm->lock);
 		info.pref_sync_ref = hdspm_pref_sync_ref(hdspm);
 		info.wordclock_sync_check = hdspm_wc_sync_check(hdspm);
-- 
1.7.3.3

