Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1DLPBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:01:20 -0400
Received: from kroah.org ([198.145.64.141]:57336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab1DLOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:48 2011
Message-Id: <20110412143548.229151967@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:33:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [003/105] ALSA: Fix yet another race in disconnection
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a45e3d6b13e97506b616980c0f122c3389bcefa4 upstream.

This patch fixes a race between snd_card_file_remove() and
snd_card_disconnect().  When the card is added to shutdown_files list
in snd_card_disconnect(), but it's freed in snd_card_file_remove() at
the same time, the shutdown_files list gets corrupted.  The list member
must be freed in snd_card_file_remove() as well.

Reported-and-tested-by: Russ Dill <russ.dill@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -848,6 +848,7 @@ int snd_card_file_add(struct snd_card *c
 		return -ENOMEM;
 	mfile->file = file;
 	mfile->disconnected_f_op = NULL;
+	INIT_LIST_HEAD(&mfile->shutdown_list);
 	spin_lock(&card->files_lock);
 	if (card->shutdown) {
 		spin_unlock(&card->files_lock);
@@ -883,6 +884,9 @@ int snd_card_file_remove(struct snd_card
 	list_for_each_entry(mfile, &card->files_list, list) {
 		if (mfile->file == file) {
 			list_del(&mfile->list);
+			spin_lock(&shutdown_lock);
+			list_del(&mfile->shutdown_list);
+			spin_unlock(&shutdown_lock);
 			if (mfile->disconnected_f_op)
 				fops_put(mfile->disconnected_f_op);
 			found = mfile;


