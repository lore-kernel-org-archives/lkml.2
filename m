Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2AXCmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab2AXCmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:24 2012
Message-Id: <20120124023924.211883301@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [003/129] mtd: mtd_blkdevs: dont increase open count on error path
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2504
Lines: 78

From: Brian Norris <computersforpeace@gmail.com>

commit 342ff28f5a2e5aa3236617bd2bddf6c749677ef2 upstream.

Some error paths in mtd_blkdevs were fixed in the following commit:

    commit 94735ec4044a6d318b83ad3c5794e931ed168d10
    mtd: mtd_blkdevs: fix error path in blktrans_open

But on these error paths, the block device's `dev->open' count is
already incremented before we check for errors. This meant that, while
the error path was handled correctly on the first time through
blktrans_open(), the device is erroneously considered already open on
the second time through.

This problem can be seen, for instance, when a UBI volume is
simultaneously mounted as a UBIFS partition and read through its
corresponding gluebi mtdblockX device. This results in blktrans_open()
passing its error checks (with `dev->open > 0') without actually having
a handle on the device. Here's a summarized log of the actions and
results with nandsim:

    # modprobe nandsim
    # modprobe mtdblock
    # modprobe gluebi
    # modprobe ubifs
    # ubiattach /dev/ubi_ctrl -m 0
    ...
    # ubimkvol /dev/ubi0 -N test -s 16MiB
    ...
    # mount -t ubifs ubi0:test /mnt
    # ls /dev/mtdblock*
    /dev/mtdblock0  /dev/mtdblock1
    # cat /dev/mtdblock1 > /dev/null
    cat: can't open '/dev/mtdblock4': Device or resource busy
    # cat /dev/mtdblock1 > /dev/null

    CPU 0 Unable to handle kernel paging request at virtual address
    fffffff0, epc == 8031536c, ra == 8031f280
    Oops[#1]:
    ...
    Call Trace:
    [<8031536c>] ubi_leb_read+0x14/0x164
    [<8031f280>] gluebi_read+0xf0/0x148
    [<802edba8>] mtdblock_readsect+0x64/0x198
    [<802ecfe4>] mtd_blktrans_thread+0x330/0x3f4
    [<8005be98>] kthread+0x88/0x90
    [<8000bc04>] kernel_thread_helper+0x10/0x18

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtd_blkdevs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -215,7 +215,7 @@ static int blktrans_open(struct block_de
 
 	mutex_lock(&dev->lock);
 
-	if (dev->open++)
+	if (dev->open)
 		goto unlock;
 
 	kref_get(&dev->ref);
@@ -235,6 +235,7 @@ static int blktrans_open(struct block_de
 		goto error_release;
 
 unlock:
+	dev->open++;
 	mutex_unlock(&dev->lock);
 	blktrans_dev_put(dev);
 	return ret;


