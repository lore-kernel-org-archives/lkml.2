Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0HKXty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:49:54 -0400
Received: from kroah.org ([198.145.64.141]:57503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab0HKXtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:49:52 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:25 2010
Message-Id: <20100811234624.996057874@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: [01/11] nvram: Fix write beyond end condition; prove to gcc copy is safe
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit a01c7800420d2c294ca403988488a635d4087a6d upstream.

In nvram_write, first of all, correctly handle the case where the file
pointer is already beyond the end; we should return EOF in that case.

Second, make the logic a bit more explicit so that gcc can statically
prove that the copy_from_user() is safe.  Once the condition of the
beyond-end filepointer is eliminated, the copy is safe but gcc can't
prove it, causing build failures for i386 allyesconfig.

Third, eliminate the entirely superfluous variable "len", and just use
the passed-in variable "count" instead.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <tip-*@git.kernel.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/nvram.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -265,10 +265,16 @@ nvram_write(struct file *file, const cha
 	unsigned char contents[NVRAM_BYTES];
 	unsigned i = *ppos;
 	unsigned char *tmp;
-	int len;
 
-	len = (NVRAM_BYTES - i) < count ? (NVRAM_BYTES - i) : count;
-	if (copy_from_user(contents, buf, len))
+	if (i >= NVRAM_BYTES)
+		return 0;	/* Past EOF */
+
+	if (count > NVRAM_BYTES - i)
+		count = NVRAM_BYTES - i;
+	if (count > NVRAM_BYTES)
+		return -EFAULT;	/* Can't happen, but prove it to gcc */
+
+	if (copy_from_user(contents, buf, count))
 		return -EFAULT;
 
 	spin_lock_irq(&rtc_lock);
@@ -276,7 +282,7 @@ nvram_write(struct file *file, const cha
 	if (!__nvram_check_checksum())
 		goto checksum_err;
 
-	for (tmp = contents; count-- > 0 && i < NVRAM_BYTES; ++i, ++tmp)
+	for (tmp = contents; count--; ++i, ++tmp)
 		__nvram_write_byte(*tmp, i);
 
 	__nvram_set_checksum();


