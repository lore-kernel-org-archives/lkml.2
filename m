Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2JKAmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:42:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36646 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035Ab2JKAOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:14:01 -0400
X-Sasl-enc: t0g+qhpcQfKyHv+kLCOb/6dTraQnfEQ2tKp9BAF3YwH+ 1349914440
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 092/133] drm/nvc0/fence: restore pre-suspend fence buffer context on resume
Date: Thu, 11 Oct 2012 07:51:58 +0900
Message-Id: <20121010224911.053489155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit d6ba6d215a538a58f0f0026f0961b0b9125e8042 upstream.

Fixes some unfortunate races on resume.  The G84 version of the code doesn't
need this as "gpuobj"s are automagically suspended/resumed by the core code
whereas pinned buffer objects are not.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvc0_fence.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvc0_fence.c
+++ b/drivers/gpu/drm/nouveau/nvc0_fence.c
@@ -32,6 +32,7 @@
 struct nvc0_fence_priv {
 	struct nouveau_fence_priv base;
 	struct nouveau_bo *bo;
+	u32 *suspend;
 };
 
 struct nvc0_fence_chan {
@@ -125,12 +126,36 @@ nvc0_fence_context_new(struct nouveau_ch
 static int
 nvc0_fence_fini(struct drm_device *dev, int engine, bool suspend)
 {
+	struct nouveau_fifo_priv *pfifo = nv_engine(dev, NVOBJ_ENGINE_FIFO);
+	struct nvc0_fence_priv *priv = nv_engine(dev, engine);
+	int i;
+
+	if (suspend) {
+		priv->suspend = vmalloc(pfifo->channels * sizeof(u32));
+		if (!priv->suspend)
+			return -ENOMEM;
+
+		for (i = 0; i < pfifo->channels; i++)
+			priv->suspend[i] = nouveau_bo_rd32(priv->bo, i);
+	}
+
 	return 0;
 }
 
 static int
 nvc0_fence_init(struct drm_device *dev, int engine)
 {
+	struct nouveau_fifo_priv *pfifo = nv_engine(dev, NVOBJ_ENGINE_FIFO);
+	struct nvc0_fence_priv *priv = nv_engine(dev, engine);
+	int i;
+
+	if (priv->suspend) {
+		for (i = 0; i < pfifo->channels; i++)
+			nouveau_bo_wr32(priv->bo, i, priv->suspend[i]);
+		vfree(priv->suspend);
+		priv->suspend = NULL;
+	}
+
 	return 0;
 }
 


