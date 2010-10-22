Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab0JVSzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:55:55 -0400
Received: from kroah.org ([198.145.64.141]:33875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759120Ab0JVSzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:27 2010
Message-Id: <20101022185227.854068545@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [006/103] ALSA: rawmidi: fix oops (use after free) when unloading a driver module
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/rawmidi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -535,13 +535,15 @@ static int snd_rawmidi_release(struct in
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
 


