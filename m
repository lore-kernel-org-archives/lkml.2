Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1ABHpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:45:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:36249 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab1ABHYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 164/260] ALSA: rawmidi: fix oops (use after free) when unloading a driver module
Date: Sun,  2 Jan 2011 02:17:40 -0500
Message-Id: <1293952756-15010-165-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:10.0072 (UTC) FILETIME=[E8897F80:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

commit aa73aec6c385e2c797ac25cc7ccf0318031de7c8 upstream.

When a driver module is unloaded and the last still open file is a raw
MIDI device, the card and its devices will be actually freed in the
snd_card_file_remove() call when that file is closed.  Afterwards, rmidi
and rmidi->card point into freed memory, so the module pointer is likely
to be garbage.
(This was introduced by commit 9a1b64caac82aa02cb74587ffc798e6f42c6170a.)

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Krzysztof Foltman <wdev@foltman.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/rawmidi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 0f5a194..5fac1a3 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -531,13 +531,15 @@ static int snd_rawmidi_release(struct inode *inode, struct file *file)
 {
 	struct snd_rawmidi_file *rfile;
 	struct snd_rawmidi *rmidi;
+	struct module *module;
 
 	rfile = file->private_data;
 	rmidi = rfile->rmidi;
 	rawmidi_release_priv(rfile);
 	kfree(rfile);
+	module = rmidi->card->module;
 	snd_card_file_remove(rmidi->card, file);
-	module_put(rmidi->card->module);
+	module_put(module);
 	return 0;
 }
 
-- 
1.7.3.3

