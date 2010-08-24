Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab0HXXCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:02:37 -0400
Received: from kroah.org ([198.145.64.141]:41091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab0HXXCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:24 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:05 2010
Message-Id: <20100824224505.611274744@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [050/114] dm: prevent access to md being deleted
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

commit abdc568b0540bec6d3e0afebac496adef1189b77 upstream.

This patch prevents access to mapped_device which is being deleted.

Currently, even after a mapped_device has been removed from the hash,
it could be accessed through idr_find() using minor number.
That could cause a race and NULL pointer reference below:
  CPU0                          CPU1
  ------------------------------------------------------------------
  dev_remove(param)
    down_write(_hash_lock)
    dm_lock_for_deletion(md)
      spin_lock(_minor_lock)
      set_bit(DMF_DELETING)
      spin_unlock(_minor_lock)
    __hash_remove(hc)
    up_write(_hash_lock)
                                dev_status(param)
                                  md = find_device(param)
                                         down_read(_hash_lock)
                                         __find_device_hash_cell(param)
                                           dm_get_md(param->dev)
                                             md = dm_find_md(dev)
                                                    spin_lock(_minor_lock)
                                                    md = idr_find(MINOR(dev))
                                                    spin_unlock(_minor_lock)
    dm_put(md)
      free_dev(md)
                                             dm_get(md)
                                         up_read(_hash_lock)
                                  __dev_status(md, param)
                                  dm_put(md)

This patch fixes such problems.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2141,6 +2141,7 @@ static struct mapped_device *dm_find_md(
 	md = idr_find(&_minor_idr, minor);
 	if (md && (md == MINOR_ALLOCED ||
 		   (MINOR(disk_devt(dm_disk(md))) != minor) ||
+		   dm_deleting_md(md) ||
 		   test_bit(DMF_FREEING, &md->flags))) {
 		md = NULL;
 		goto out;


