Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1FMOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:46:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38633 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1FMOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:46:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=KQCVUjhI/mfpkRtMWIXo43X7lADqin5mSA9po+edjrE87T5T3ZyRBob9R6qQXNCY4
	LGuI8c9k8hUABbvTDEDeA==
From: Greg Thelen <gthelen@google.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] hda: check make_exec_verb() return value
Date: Mon, 13 Jun 2011 07:45:45 -0700
Message-Id: <1307976345-13258-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If given a -1 cmd parameter then make_exec_verb() returns -1 without
setting the res output value.

Prior to this change snd_hda_codec_read() assumed that make_exec_verb()
unconditionally set res regardless of the cmd value.

This change explicitly checks the make_exec_verb() return value before
consuming the potentially unset res value.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 sound/pci/hda/hda_codec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 45b4a8d..f06dd5f 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -243,7 +243,8 @@ unsigned int snd_hda_codec_read(struct hda_codec *codec, hda_nid_t nid,
 {
 	unsigned cmd = make_codec_cmd(codec, nid, direct, verb, parm);
 	unsigned int res;
-	codec_exec_verb(codec, cmd, &res);
+	if (codec_exec_verb(codec, cmd, &res))
+		return -1;
 	return res;
 }
 EXPORT_SYMBOL_HDA(snd_hda_codec_read);
-- 
1.7.3.1

