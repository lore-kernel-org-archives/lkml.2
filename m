Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1A1PAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:00:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44235 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab1A1PAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:00:47 -0500
Date: Fri, 28 Jan 2011 09:00:42 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] zram: Return zero'd pages on new reads
Message-ID: <20110128150042.GG2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently zram will do nothing to the page in the bvec when that page
has not been previously written.  This allows random data to leak to
user space.  That can be seen by doing the following:

 ## Load the module and create a 256Mb zram device called /dev/zram0
 # modprobe zram
 # echo $((256*1024*1024)) > /sys/class/block/zram0/disksize

 ## Initialize the device by writing zero to the first block
 # dd if=/dev/zero of=/dev/zram0 bs=512 count=1

 ## Read ~256Mb of memory into a file and hope for something interesting
 # dd if=/dev/zram0 of=file

This patch will treat an unwritten page as a zero-filled page.  If a
page is read before a write has occurred the data returned is all 0's.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/zram_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index c67060c..86066fd 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -238,7 +238,7 @@ static int zram_read(struct zram *zram, struct bio *bio)
 		if (unlikely(!zram->table[index].page)) {
 			pr_debug("Read before write: sector=%lu, size=%u",
 				(ulong)(bio->bi_sector), bio->bi_size);
-			/* Do nothing */
+			handle_zero_page(page);
 			continue;
 		}
 
-- 
1.7.0.4

