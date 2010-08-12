Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab0HLAI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:57 -0400
Received: from kroah.org ([198.145.64.141]:47909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172Ab0HLAIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:45 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:17 2010
Message-Id: <20100812000617.018777829@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Robertson <steven@strobe.cc>, Pete Zaitcev <zaitcev@redhat.com>
Subject: [47/67] USB: resizing usbmon binary interface buffer causes protection faults
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1009,7 +1009,7 @@ static int mon_bin_ioctl(struct file *fi
 
 		mutex_lock(&rp->fetch_lock);
 		spin_lock_irqsave(&rp->b_lock, flags);
-		mon_free_buff(rp->b_vec, size/CHUNK_SIZE);
+		mon_free_buff(rp->b_vec, rp->b_size/CHUNK_SIZE);
 		kfree(rp->b_vec);
 		rp->b_vec  = vec;
 		rp->b_size = size;


