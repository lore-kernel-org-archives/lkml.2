Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab0EYSRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:17:21 -0400
Received: from kroah.org ([198.145.64.141]:44303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab0EYSRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:19 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:12 2010
Message-Id: <20100525181212.204460185@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:08:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [01/25] ALSA: mixart: range checking proc file
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit b0cc58a25d04160d39a80e436847eaa2fbc5aa09 upstream.

The original code doesn't take into consideration that the value of
MIXART_BA0_SIZE - pos can be less than zero which would lead to a large
unsigned value for "count".

Also I moved the check that read size is a multiple of 4 bytes below
the code that adjusts "count".

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/mixart/mixart.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1160,13 +1160,15 @@ static long snd_mixart_BA0_read(struct s
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos >= MIXART_BA0_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA0_SIZE)
-		count = (long)(MIXART_BA0_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_MEM( mgr, pos ), count))
+	maxsize = MIXART_BA0_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_MEM(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }
@@ -1179,13 +1181,15 @@ static long snd_mixart_BA1_read(struct s
 				unsigned long count, unsigned long pos)
 {
 	struct mixart_mgr *mgr = entry->private_data;
+	unsigned long maxsize;
 
-	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
-	if(count <= 0)
+	if (pos > MIXART_BA1_SIZE)
 		return 0;
-	if(pos + count > MIXART_BA1_SIZE)
-		count = (long)(MIXART_BA1_SIZE - pos);
-	if(copy_to_user_fromio(buf, MIXART_REG( mgr, pos ), count))
+	maxsize = MIXART_BA1_SIZE - pos;
+	if (count > maxsize)
+		count = maxsize;
+	count = count & ~3; /* make sure the read size is a multiple of 4 bytes */
+	if (copy_to_user_fromio(buf, MIXART_REG(mgr, pos), count))
 		return -EFAULT;
 	return count;
 }


