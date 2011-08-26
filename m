Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1H0O5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:57:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab1H0O5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.210072853@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milan Broz <mbroz@redhat.com>, Tejun Heo <tj@kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [13/35] loop: fix deadlock when sysfs and LOOP_CLR_FD race against each other
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit 05eb0f252b04aa94ace0794f73d56c6a02351d80 upstream.

LOOP_CLR_FD takes lo->lo_ctl_mutex and tries to remove the loop sysfs
files. Sysfs calls show() and waits for lo->lo_ctl_mutex. LOOP_CLR_FD
waits for show() to finish to remove the sysfs file.

  cat /sys/class/block/loop0/loop/backing_file
    mutex_lock_nested+0x176/0x350
    ? loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
    ? loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
    loop_attr_do_show_backing_file+0x2f/0xd0 [loop]
    dev_attr_show+0x1b/0x60
    ? sysfs_read_file+0x86/0x1a0
    ? __get_free_pages+0x12/0x50
    sysfs_read_file+0xaf/0x1a0

  ioctl(LOOP_CLR_FD):
    wait_for_common+0x12c/0x180
    ? try_to_wake_up+0x2a0/0x2a0
    wait_for_completion+0x18/0x20
    sysfs_deactivate+0x178/0x180
    ? sysfs_addrm_finish+0x43/0x70
    ? sysfs_addrm_start+0x1d/0x20
    sysfs_addrm_finish+0x43/0x70
    sysfs_hash_and_remove+0x85/0xa0
    sysfs_remove_group+0x59/0x100
    loop_clr_fd+0x1dc/0x3f0 [loop]
    lo_ioctl+0x223/0x7a0 [loop]

Instead of taking the lo_ctl_mutex from sysfs code, take the inner
lo->lo_lock, to protect the access to the backing_file data.

Thanks to Tejun for help debugging and finding a solution.

Cc: Milan Broz <mbroz@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/loop.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -750,10 +750,10 @@ static ssize_t loop_attr_backing_file_sh
 	ssize_t ret;
 	char *p = NULL;
 
-	mutex_lock(&lo->lo_ctl_mutex);
+	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
 		p = d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
-	mutex_unlock(&lo->lo_ctl_mutex);
+	spin_unlock_irq(&lo->lo_lock);
 
 	if (IS_ERR_OR_NULL(p))
 		ret = PTR_ERR(p);
@@ -1007,7 +1007,9 @@ static int loop_clr_fd(struct loop_devic
 
 	kthread_stop(lo->lo_thread);
 
+	spin_lock_irq(&lo->lo_lock);
 	lo->lo_backing_file = NULL;
+	spin_unlock_irq(&lo->lo_lock);
 
 	loop_release_xfer(lo);
 	lo->transfer = NULL;


