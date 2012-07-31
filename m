Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2GaEue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48669 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501Ab2GaEu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:29 -0400
Message-Id: <20120731044321.714529958@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [ 65/73] ASoC: dapm: Fix _PRE and _POST events for DAPM performance
 improvements
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 0ff97ebf0804d2e519d578fcb4db03f104d2ca8c upstream.

Ever since the DAPM performance improvements we've been marking all widgets
as not dirty after each DAPM run. Since _PRE and _POST events aren't part
of the DAPM graph this has rendered them non-functional, they will never be
marked dirty again and thus will never be run again.

Fix this by skipping them when marking widgets as not dirty.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/soc-dapm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index f7a13f7..025060b 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1598,7 +1598,15 @@ static int dapm_power_widgets(struct snd_soc_dapm_context *dapm, int event)
 	}
 
 	list_for_each_entry(w, &card->widgets, list) {
-		list_del_init(&w->dirty);
+		switch (w->id) {
+		case snd_soc_dapm_pre:
+		case snd_soc_dapm_post:
+			/* These widgets always need to be powered */
+			break;
+		default:
+			list_del_init(&w->dirty);
+			break;
+		}
 
 		if (w->power) {
 			d = w->dapm;


