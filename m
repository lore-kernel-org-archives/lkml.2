Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1HCVlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:41:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57676 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab1HCVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:41:12 -0400
Message-ID: <4E39C074.10007@lwfinger.net>
Date: Wed, 03 Aug 2011 16:41:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
CC: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Regression in 3.0-git after commit c82693db52beced0419cecf09a3c81adfe95a544
 - sound does not work
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the latest git pull of 3.0-git from Linus's tree, the sound on my HP laptop 
does not work. This problem was bisected to the commit in the subject.

The lspci output for my sound device is:

00:07.0 Audio device [0403]: nVidia Corporation MCP67 High Definition Audio 
[10de:055c] (rev a1)
         Subsystem: Hewlett-Packard Company Device [103c:30d6]
         Kernel driver in use: snd_hda_intel

I further isolated the problem to the following hunk:

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 6e90b6b..4ca880b 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1994,10 +1990,8 @@ static int patch_cxt5051(struct hda_codec *codec)
         board_config = snd_hda_check_board_config(codec, CXT5051_MODELS,
                                                   cxt5051_models,
                                                   cxt5051_cfg_tbl);
-#if 0 /* use the old method just for safety */
         if (board_config < 0)
-               board_config = CXT5051_AUTO;
-#endif
+               board_config = CXT5051_AUTO; /* model=auto as default */
         if (board_config == CXT5051_AUTO)
                 return patch_conexant_auto(codec);

In my case, snd_hda_check_board_config() returns -1. Thus, the new code returns 
the value of patch_conexant_auto(), whereas the original version fell through to 
the setup code below. Clearly, this is needed for my device.

I will be happy to provide any further information you need. I have not yet 
prepared a bugzilla report, but I will later.

Thanks,

Larry
