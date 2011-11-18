Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab1KSAJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282Ab1KSAJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:04 2011
Message-Id: <20111119000004.502633461@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [06/26] drm/nouveau: initialize chan->fence.lock before use
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 5e60ee780e792efe6dce97eceb110b1d30bab850 upstream.

Fence lock needs to be initialized before any call to nouveau_channel_put
because it calls nouveau_channel_idle->nouveau_fence_update which uses
fence lock.

BUG: spinlock bad magic on CPU#0, test/24134
 lock: ffff88019f90dba8, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 24134, comm: test Not tainted 3.0.0-nv+ #800
Call Trace:
 spin_bug+0x9c/0xa3
 do_raw_spin_lock+0x29/0x13c
 _raw_spin_lock+0x1e/0x22
 nouveau_fence_update+0x2d/0xf1
 nouveau_channel_idle+0x22/0xa0
 nouveau_channel_put_unlocked+0x84/0x1bd
 nouveau_channel_put+0x20/0x24
 nouveau_channel_alloc+0x4ec/0x585
 nouveau_ioctl_fifo_alloc+0x50/0x130
 drm_ioctl+0x289/0x361
 do_vfs_ioctl+0x4dd/0x52c
 sys_ioctl+0x42/0x65
 system_call_fastpath+0x16/0x1b

It's easily triggerable from userspace.

Additionally remove double initialization of chan->fence.pending.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nouveau_channel.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c   |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_channel.c
+++ b/drivers/gpu/drm/nouveau/nouveau_channel.c
@@ -159,6 +159,7 @@ nouveau_channel_alloc(struct drm_device
 	INIT_LIST_HEAD(&chan->nvsw.vbl_wait);
 	INIT_LIST_HEAD(&chan->nvsw.flip);
 	INIT_LIST_HEAD(&chan->fence.pending);
+	spin_lock_init(&chan->fence.lock);
 
 	/* Allocate DMA push buffer */
 	chan->pushbuf_bo = nouveau_channel_user_pushbuf_alloc(dev);
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -542,8 +542,6 @@ nouveau_fence_channel_init(struct nouvea
 			return ret;
 	}
 
-	INIT_LIST_HEAD(&chan->fence.pending);
-	spin_lock_init(&chan->fence.lock);
 	atomic_set(&chan->fence.last_sequence_irq, 0);
 	return 0;
 }


