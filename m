Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2JJXGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:06:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54937 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932648Ab2JJXDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:31 -0400
X-Sasl-enc: m7wWNSNZHPwu5yurUsqqjFb5BX3wd00jTlcrBD2QsTY2 1349910210
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 068/122] ALSA: hda/via - dont report presence on HPs with no presence support
Date: Thu, 11 Oct 2012 07:53:54 +0900
Message-Id: <20121010225350.371773404@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit cf55e904516947597d75fd3844acc24891a95772 upstream.

If headphone jack can't detect plug presence, and we have the jack in
the jack table, snd_hda_jack_detect will return the plug as always
present (as it'll be considered as a phantom jack). The problem is that
when this happens, line out pins will always be disabled, resulting in
no sound if there are no headphones connected.

This was reported as a no sound problem after suspend on
http://bugs.launchpad.net/bugs/1052499, since the bug doesn't manifests
on first initialization before the phantom jack is added, but on resume
we reexecute the initialization code, and via_hp_automute starts
reporting HP always present with the jack now on the table.

BugLink: https://bugs.launchpad.net/bugs/1052499
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1672,7 +1672,8 @@ static void via_hp_automute(struct hda_c
 	struct via_spec *spec = codec->spec;
 
 	if (!spec->hp_independent_mode && spec->autocfg.hp_pins[0] &&
-	    (spec->codec_type != VT1708 || spec->vt1708_jack_detect))
+	    (spec->codec_type != VT1708 || spec->vt1708_jack_detect) &&
+	    is_jack_detectable(codec, spec->autocfg.hp_pins[0]))
 		present = snd_hda_jack_detect(codec, spec->autocfg.hp_pins[0]);
 
 	if (spec->smart51_enabled)


