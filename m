Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1DSVwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:52:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45174 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DSVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XMeCUxdPYJ4XnubmseAefNs3HbbkIm2xuigmFoD2Mv6m0ePFLJ502H111JW/MMLrTg
         r5tlCwSn/tLMEJujosmGo4S4Gw1UemRZZvhNADOTBO8mf1dbgIyKd/kV0EpZdBLNd51D
         9pru+sHxJDG5Y3WWQYmDfJv6gISYmMExuNtcQ=
Date: Tue, 19 Apr 2011 23:50:48 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Kyle Spaans <kspaans@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 1/2] drm/nouveau: fix notifier memory corruption bug
Message-ID: <20110419215048.GB2965@joi.lan>
References: <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan>
 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan>
 <20110418200204.GA2522@joi.lan>
 <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
 <20110419214747.GA2965@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419214747.GA2965@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nouveau_bo_wr32 expects offset to be in words, but we pass value in bytes,
so after commit 73412c3854c877e5f37ad944ee8977addde4d35a ("drm/nouveau: allocate
kernel's notifier object at end of block") we started to overwrite some memory
after notifier buffer object (previously m2mf_ntfy was always 0, so it didn't
matter it was a value in bytes).

Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reported-by: Nigel Cunningham <lkml@nigelcunningham.com.au>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Pekka Paalanen <pq@iki.fi>
Cc: stable@kernel.org    [2.6.38]
---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 889c445..39aee6d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -181,13 +181,13 @@ nouveau_fbcon_sync(struct fb_info *info)
 		OUT_RING  (chan, 0);
 	}
 
-	nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy + 3, 0xffffffff);
+	nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy/4 + 3, 0xffffffff);
 	FIRE_RING(chan);
 	mutex_unlock(&chan->mutex);
 
 	ret = -EBUSY;
 	for (i = 0; i < 100000; i++) {
-		if (!nouveau_bo_rd32(chan->notifier_bo, chan->m2mf_ntfy + 3)) {
+		if (!nouveau_bo_rd32(chan->notifier_bo, chan->m2mf_ntfy/4 + 3)) {
 			ret = 0;
 			break;
 		}
-- 
1.7.4.1

