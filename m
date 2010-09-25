Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0IYPHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:07:33 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:53499 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0IYPHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:07:32 -0400
Subject: [PATCH] sound/pci/rme9652: prevent reading uninitialized stack
 memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 11:07:27 -0400
Message-ID: <1285427247.7957.35.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SNDRV_HDSP_IOCTL_GET_CONFIG_INFO and
SNDRV_HDSP_IOCTL_GET_CONFIG_INFO ioctls in hdspm.c and hdsp.c allow
unprivileged users to read uninitialized kernel stack memory, because
several fields of the hdsp{m}_config_info structs declared on the stack
are not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

diff -urp linux-2.6.35.5.orig/sound/pci/rme9652/hdsp.c linux-2.6.35.5/sound/pci/rme9652/hdsp.c
--- linux-2.6.35.5.orig/sound/pci/rme9652/hdsp.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/sound/pci/rme9652/hdsp.c	2010-09-25 10:59:42.000000000 -0400
@@ -4601,6 +4601,8 @@ static int snd_hdsp_hwdep_ioctl(struct s
 		unsigned long flags;
 		int i;
 
+		memset(&info, 0, sizeof(info));
+
 		err = hdsp_check_for_iobox(hdsp);
 		if (err < 0)
 			return err;
diff -urp linux-2.6.35.5.orig/sound/pci/rme9652/hdspm.c linux-2.6.35.5/sound/pci/rme9652/hdspm.c
--- linux-2.6.35.5.orig/sound/pci/rme9652/hdspm.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/sound/pci/rme9652/hdspm.c	2010-09-25 10:58:44.000000000 -0400
@@ -4128,6 +4128,9 @@ static int snd_hdspm_hwdep_ioctl(struct 
 	case SNDRV_HDSPM_IOCTL_GET_CONFIG_INFO:
 
 		spin_lock_irq(&hdspm->lock);
+		
+		memset(&info, 0, sizeof(info));
+		
 		info.pref_sync_ref = hdspm_pref_sync_ref(hdspm);
 		info.wordclock_sync_check = hdspm_wc_sync_check(hdspm);
 


