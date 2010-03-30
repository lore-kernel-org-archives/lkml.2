Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845Ab0CaAeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:34:37 -0400
Received: from kroah.org ([198.145.64.141]:48763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab0C3XLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:51 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:13 2010
Message-Id: <20100330225812.338545097@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [07/89] cciss: Make cciss_seq_show handle holes in the h->drv[] array
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

commit 531c2dc70d339c5dfa8c3eb628c3459dc6f3a075 upstream.

It is possible (and expected) for there to be holes in the h->drv[]
array, that is, some elements may be NULL pointers.  cciss_seq_show
needs to be made aware of this possibility to avoid an Oops.

To reproduce the Oops which this fixes:

1) Create two "arrays" in the Array Configuratino Utility and
   several logical drives on each array.
2) cat /proc/driver/cciss/cciss* in an infinite loop
3) delete some of the logical drives in the first "array."

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -323,6 +323,9 @@ static int cciss_seq_show(struct seq_fil
 	if (*pos > h->highest_lun)
 		return 0;
 
+	if (drv == NULL) /* it's possible for h->drv[] to have holes. */
+		return 0;
+
 	if (drv->heads == 0)
 		return 0;
 


