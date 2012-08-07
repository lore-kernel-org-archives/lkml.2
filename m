Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2HGXRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:17:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab2HGWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [ 018/109] ASoC: dapm: Fix _PRE and _POST events for DAPM performance improvements
Date: Tue,  7 Aug 2012 15:34:37 -0700
Message-Id: <20120807222044.697355149@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1442,7 +1442,15 @@ static int dapm_power_widgets(struct snd
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


