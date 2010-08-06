Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777Ab0HFSfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:20 -0400
Received: from kroah.org ([198.145.64.141]:48537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759322Ab0HFSfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:16 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:00 2010
Message-Id: <20100806183200.113567117@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [01/38] PARISC: led.c - fix potential stack overflow in led_proc_write()
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Deller <deller@gmx.de>

commit 4b4fd27c0b5ec638a1f06ced9226fd95229dbbf0 upstream.

avoid potential stack overflow by correctly checking count parameter

Reported-by: Ilja <ilja@netric.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parisc/led.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -176,16 +176,18 @@ static ssize_t led_proc_write(struct fil
 	size_t count, loff_t *pos)
 {
 	void *data = PDE(file->f_path.dentry->d_inode)->data;
-	char *cur, lbuf[count + 1];
+	char *cur, lbuf[32];
 	int d;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	memset(lbuf, 0, count + 1);
+	if (count >= sizeof(lbuf))
+		count = sizeof(lbuf)-1;
 
 	if (copy_from_user(lbuf, buf, count))
 		return -EFAULT;
+	lbuf[count] = 0;
 
 	cur = lbuf;
 


