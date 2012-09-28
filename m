Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030612Ab2I1TEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:04:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517Ab2I1TEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>
Subject: [ 209/262] drm/nv86/fifo: suspend fix
Date: Fri, 28 Sep 2012 11:52:18 -0700
Message-Id: <20120928183022.791415875@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 2064db725cc6d4ea19a24c138bc37939b63e3ae6 upstream.

This fix is a backport from the reworked nouveau driver.  It masks off the
engines we're not expecting to use before attempting a channel kickoff.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nv84_fifo.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/nouveau/nv84_fifo.c
+++ b/drivers/gpu/drm/nouveau/nv84_fifo.c
@@ -117,17 +117,22 @@ nv84_fifo_context_del(struct nouveau_cha
 	struct drm_device *dev = chan->dev;
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	unsigned long flags;
+	u32 save;
 
 	/* remove channel from playlist, will context switch if active */
 	spin_lock_irqsave(&dev_priv->context_switch_lock, flags);
 	nv_mask(dev, 0x002600 + (chan->id * 4), 0x80000000, 0x00000000);
 	nv50_fifo_playlist_update(dev);
 
+	save = nv_mask(dev, 0x002520, 0x0000003f, 0x15);
+
 	/* tell any engines on this channel to unload their contexts */
 	nv_wr32(dev, 0x0032fc, chan->ramin->vinst >> 12);
 	if (!nv_wait_ne(dev, 0x0032fc, 0xffffffff, 0xffffffff))
 		NV_INFO(dev, "PFIFO: channel %d unload timeout\n", chan->id);
 
+	nv_wr32(dev, 0x002520, save);
+
 	nv_wr32(dev, 0x002600 + (chan->id * 4), 0x00000000);
 	spin_unlock_irqrestore(&dev_priv->context_switch_lock, flags);
 
@@ -184,10 +189,13 @@ nv84_fifo_fini(struct drm_device *dev, i
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nv84_fifo_priv *priv = nv_engine(dev, engine);
 	int i;
+	u32 save;
 
 	/* set playlist length to zero, fifo will unload context */
 	nv_wr32(dev, 0x0032ec, 0);
 
+	save = nv_mask(dev, 0x002520, 0x0000003f, 0x15);
+
 	/* tell all connected engines to unload their contexts */
 	for (i = 0; i < priv->base.channels; i++) {
 		struct nouveau_channel *chan = dev_priv->channels.ptr[i];
@@ -199,6 +207,7 @@ nv84_fifo_fini(struct drm_device *dev, i
 		}
 	}
 
+	nv_wr32(dev, 0x002520, save);
 	nv_wr32(dev, 0x002140, 0);
 	return 0;
 }


