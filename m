Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0JVSlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:32 -0400
Received: from kroah.org ([198.145.64.141]:45946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab0JVSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:32 2010
Message-Id: <20101022184032.761252013@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [03/17] ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/rme9652/hdsp.c  |    1 +
 sound/pci/rme9652/hdspm.c |    1 +
 2 files changed, 2 insertions(+)

--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -4569,6 +4569,7 @@ static int snd_hdsp_hwdep_ioctl(struct s
 			snd_printk(KERN_ERR "Hammerfall-DSP: Firmware needs to be uploaded to the card.\n");	
 			return -EINVAL;
 		}
+		memset(&info, 0, sizeof(info));
 		spin_lock_irqsave(&hdsp->lock, flags);
 		info.pref_sync_ref = (unsigned char)hdsp_pref_sync_ref(hdsp);
 		info.wordclock_sync_check = (unsigned char)hdsp_wc_sync_check(hdsp);
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4133,6 +4133,7 @@ static int snd_hdspm_hwdep_ioctl(struct
 
 	case SNDRV_HDSPM_IOCTL_GET_CONFIG_INFO:
 
+		memset(&info, 0, sizeof(info));
 		spin_lock_irq(&hdspm->lock);
 		info.pref_sync_ref = hdspm_pref_sync_ref(hdspm);
 		info.wordclock_sync_check = hdspm_wc_sync_check(hdspm);


