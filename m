Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab0HLAYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:24:46 -0400
Received: from kroah.org ([198.145.64.141]:60252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759545Ab0HLAEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:22 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:26 2010
Message-Id: <20100812000126.182641316@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Robertson <steven@strobe.cc>, Pete Zaitcev <zaitcev@redhat.com>
Subject: [32/54] USB: resizing usbmon binary interface buffer causes protection faults
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Robertson <steven@strobe.cc>

commit 33d973ad88ceb83ed1449592b7574b5b5bb33ac6 upstream.

Enlarging the buffer size via the MON_IOCT_RING_SIZE ioctl causes
general protection faults. It appears the culprit is an incorrect
argument to mon_free_buff: instead of passing the size of the current
buffer being freed, the size of the new buffer is passed.

Use the correct size argument to mon_free_buff when changing the size of
the buffer.

Signed-off-by: Steven Robertson <steven@strobe.cc>
Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/mon/mon_bin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1010,7 +1010,7 @@ static int mon_bin_ioctl(struct inode *i
 
 		mutex_lock(&rp->fetch_lock);
 		spin_lock_irqsave(&rp->b_lock, flags);
-		mon_free_buff(rp->b_vec, size/CHUNK_SIZE);
+		mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
 		kfree(rp->b_vec);
 		rp->b_vec  = vec;
 		rp->b_size = size;


