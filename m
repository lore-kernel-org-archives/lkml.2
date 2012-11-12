Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2KLSdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:33:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45170 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2KLSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:33:16 -0500
Date: Mon, 12 Nov 2012 10:33:11 -0800
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cuse: do not register multiple devices with the same name
Message-ID: <20121112183311.GA5560@mtj.dyndns.org>
References: <1352736948-18243-1-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352736948-18243-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Mon, Nov 12, 2012 at 05:15:48PM +0100, David Herrmann wrote:
> We do not check whether we already registered a CUSE device with a given
> name so we might end up with two devices with the same name. Sysfs will
> then complain as it cannot create suitable directories.
> 
> This patch makes the init-command fail if there is already a device with
> the given name. To avoid race-conditions during initialization, we
> actually need to add the device to the list while still holding the lock
> for the name-check.
> The new "ready" field guarantees that the device is still not opened until
> it is fully initialized.
> 
> Following the sysfs warnings when registering two devices with the same
> name:
> 
>  ------------[ cut here ]------------
>  WARNING: at fs/sysfs/dir.c:529 sysfs_add_one+0xc8/0xf0()
>  Hardware name: N150P/N210P/N220P
>  sysfs: cannot create duplicate filename '/devices/virtual/cuse/ttyFseat0'
>  Modules linked in: btusb bluetooth
>  Pid: 14089, comm: lt-kmscon Tainted: G        W    3.5.3+ #60
>  Call Trace:
>   [<ffffffff81136400>] ? sysfs_add_one+0x60/0xf0
>   [<ffffffff8102f99d>] warn_slowpath_common+0x7d/0xc0
>   [<ffffffff8102fa83>] warn_slowpath_fmt+0x43/0x50
>   [<ffffffff81136468>] sysfs_add_one+0xc8/0xf0
>   [<ffffffff81136686>] create_dir+0x76/0xd0
>   [<ffffffff81136a14>] sysfs_create_dir+0x84/0xe0
>   [<ffffffff811fe67b>] kobject_add_internal+0x9b/0x200
>   [<ffffffff811feb38>] kobject_add+0x68/0xc0
>   [<ffffffff81310c73>] device_add+0xe3/0x680
>   [<ffffffff8130f5ae>] ? dev_set_name+0x3e/0x40
>   [<ffffffff811c6834>] cuse_process_init_reply+0x204/0x410
>   [<ffffffff811c6630>] ? cuse_open+0xe0/0xe0
>   [<ffffffff811bb23c>] request_end+0xfc/0x1a0
>   [<ffffffff811bc6e2>] fuse_dev_do_write+0xa32/0xd10
>   [<ffffffff811ba435>] ? fuse_copy_one+0x45/0x60
>   [<ffffffff8109cf06>] ? find_get_page+0x66/0xb0
>   [<ffffffff811bccc0>] ? fuse_dev_splice_write+0x300/0x300
>   [<ffffffff811bcd29>] fuse_dev_write+0x69/0x80
>   [<ffffffff810d569c>] do_sync_readv_writev+0xdc/0x120
>   [<ffffffff810d57db>] ? rw_copy_check_uvector+0x6b/0x130
>   [<ffffffff810b9c5e>] ? handle_mm_fault+0x12e/0x1f0
>   [<ffffffff810d5973>] do_readv_writev+0xd3/0x1e0
>   [<ffffffff810d5ab0>] vfs_writev+0x30/0x60
>   [<ffffffff810d5c38>] sys_writev+0x48/0xb0
>   [<ffffffff815846a2>] system_call_fastpath+0x16/0x1b
>  ---[ end trace 368eb04507b14c94 ]---
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
> ---
> Hi
> 
> I am not sure whether this qualifies for the stable-tree, so please CC
> stable@vger.kernel.org if you think so.
> 
> The patch is against linux-next from today.
> 
> Regards
> David
> 
>  fs/fuse/cuse.c | 35 +++++++++++++++++++++++++++++------
>  1 file changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
> index 1326051..11fbc52 100644
> --- a/fs/fuse/cuse.c
> +++ b/fs/fuse/cuse.c
> @@ -33,6 +33,7 @@
>   * closed.
>   */
>  
> +#include <linux/atomic.h>
>  #include <linux/fuse.h>
>  #include <linux/cdev.h>
>  #include <linux/device.h>
> @@ -45,6 +46,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/smp.h>
>  #include <linux/spinlock.h>
>  #include <linux/stat.h>
>  #include <linux/module.h>
> @@ -54,6 +56,7 @@
>  #define CUSE_CONNTBL_LEN	64
>  
>  struct cuse_conn {
> +	atomic_t		ready;	/* device is ready for open() */

Hmmm... how about converting cuse_lock to a mutex and wrapping the
whole registration inside it instead of splitting the synchronization
into two places?

Thanks.

-- 
tejun
