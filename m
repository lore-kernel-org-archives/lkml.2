Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271Ab1C3VRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:17:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:24598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965221Ab1C3VJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673448709"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [244/275] ALSA: Fix yet another race in disconnection
Message-Id: <20110330210810.996DC3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/core/init.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.35.y/sound/core/init.c
===================================================================
--- linux-2.6.35.y.orig/sound/core/init.c	2011-03-29 22:50:15.095872154 -0700
+++ linux-2.6.35.y/sound/core/init.c	2011-03-29 23:03:03.293215905 -0700
@@ -848,6 +848,7 @@
 		return -ENOMEM;
 	mfile->file = file;
 	mfile->disconnected_f_op = NULL;
+	INIT_LIST_HEAD(&mfile->shutdown_list);
 	spin_lock(&card->files_lock);
 	if (card->shutdown) {
 		spin_unlock(&card->files_lock);
@@ -883,6 +884,9 @@
 	list_for_each_entry(mfile, &card->files_list, list) {
 		if (mfile->file == file) {
 			list_del(&mfile->list);
+			spin_lock(&shutdown_lock);
+			list_del(&mfile->shutdown_list);
+			spin_unlock(&shutdown_lock);
 			if (mfile->disconnected_f_op)
 				fops_put(mfile->disconnected_f_op);
 			found = mfile;
