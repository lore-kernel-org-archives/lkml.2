Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2HSHE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 03:04:29 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:17830
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab2HSHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 03:03:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="153342472"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] sound/pci/ctxfi/ctatc.c: fix error return code
Date: Sun, 19 Aug 2012 09:02:56 +0200
Message-Id: <1345359780-18647-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345359780-18647-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize err before returning on failure, as done elsewhere in the
function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 sound/pci/ctxfi/ctatc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 58b235c..a2f997a 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1725,8 +1725,10 @@ int __devinit ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 	atc_connect_resources(atc);
 
 	atc->timer = ct_timer_new(atc);
-	if (!atc->timer)
+	if (!atc->timer) {
+		err = -ENOMEM;
 		goto error1;
+	}
 
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, atc, &ops);
 	if (err < 0)

