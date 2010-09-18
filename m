Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0IRTCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:33 -0400
Received: from kroah.org ([198.145.64.141]:51267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab0IRTBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:32 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:55 2010
Message-Id: <20100918185955.815808265@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [035/123] ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=alsa-seq-oss-fix-double-free-at-error-path-of-snd_seq_oss_open.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 27f7ad53829f79e799a253285318bff79ece15bd upstream.

The error handling in snd_seq_oss_open() has several bad codes that
do dereferecing released pointers and double-free of kmalloc'ed data.
The object dp is release in free_devinfo() that is called via
private_free callback.  The rest shouldn't touch this object any more.

The patch changes delete_port() to call kfree() in any case, and gets
rid of unnecessary calls of destructors in snd_seq_oss_open().

Fixes CVE-2010-3080.

Reported-and-tested-by: Tavis Ormandy <taviso@cmpxchg8b.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/seq/oss/seq_oss_init.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -280,13 +280,10 @@ snd_seq_oss_open(struct file *file, int
 	return 0;
 
  _error:
-	snd_seq_oss_writeq_delete(dp->writeq);
-	snd_seq_oss_readq_delete(dp->readq);
 	snd_seq_oss_synth_cleanup(dp);
 	snd_seq_oss_midi_cleanup(dp);
-	delete_port(dp);
 	delete_seq_queue(dp->queue);
-	kfree(dp);
+	delete_port(dp);
 
 	return rc;
 }
@@ -349,8 +346,10 @@ create_port(struct seq_oss_devinfo *dp)
 static int
 delete_port(struct seq_oss_devinfo *dp)
 {
-	if (dp->port < 0)
+	if (dp->port < 0) {
+		kfree(dp);
 		return 0;
+	}
 
 	debug_printk(("delete_port %i\n", dp->port));
 	return snd_seq_event_port_detach(dp->cseq, dp->port);


