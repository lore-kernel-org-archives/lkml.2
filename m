Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2JUKwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:52:19 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62022
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab2JUKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:52:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,625,1344204000"; 
   d="scan'208";a="159799679"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jaroslav Kysela <perex@perex.cz>
Cc: kernel-janitors@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] sound/isa/opti9xx/miro.c: eliminate possible double free
Date: Sun, 21 Oct 2012 12:52:03 +0200
Message-Id: <1350816727-1381-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

snd_miro_probe is a static function that is only called twice in the file
that defines it.  At each call site, its argument is freed using
snd_card_free.  Thus, there is no need for snd_miro_probe to call
snd_card_free on its argument on any of its error exit paths.

Because snd_card_free both reads the fields of its argument and kfrees its
argments, the results of the second snd_card_free should be unpredictable.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f,free,a;
parameter list[n] ps;
type T;
expression e;
@@

f(ps,T a,...) {
  ... when any
      when != a = e
  if(...) { ... free(a); ... return ...; }
  ... when any
}

@@
identifier r.f,r.free;
expression x,a;
expression list[r.n] xs;
@@

* x = f(xs,a,...);
  if (...) { ... free(a); ... return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 sound/isa/opti9xx/miro.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 3d1afb6..4a7ff4e 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1286,7 +1286,6 @@ static int __devinit snd_miro_probe(struct snd_card *card)
 
 	error = snd_card_miro_aci_detect(card, miro);
 	if (error < 0) {
-		snd_card_free(card);
 		snd_printk(KERN_ERR "unable to detect aci chip\n");
 		return -ENODEV;
 	}

