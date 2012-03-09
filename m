Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2CIIfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:35:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2CIIfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120307104240.GB18658@quack.suse.cz>
References: <20120306185137.GA15881@redhat.com> <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost> <20120307104240.GB18658@quack.suse.cz>
From: Yang Bai <hamo.by@gmail.com>
Date: Fri, 9 Mar 2012 16:34:57 +0800
Message-ID: <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
Subject: Re: inode->i_wb_list corruption.
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 6:42 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 06-03-12 23:26:08, Wu Fengguang wrote:
>  Umm, it's not *that* simple I'd say. E.g. sysfs doesn't provide
> alloc_inode() method so we use inode_cachep for allocations. And that cache
> is configured to use inode_init_once().
>
> Also note that the error message is:
> list_del corruption. prev->next should be ffff8801c2f41b18, but was (null)
>
> Which means that our inode had correct i_wb_list.prev but the previous
> inode had NULL in i_wb_list.next. But that means that both inodes were
> linked into the list at some point. So it does not seem like an
> initialization issue to me...
>
>                                                                Honza
>
I still want to know how to reproduce this bug. I add the following
patch to the kernel fc-16 3.2.9-1

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5b4a936..568ed0a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -192,8 +192,13 @@ void bdi_start_background_writeback(struct
backing_dev_info *bdi)
 void inode_wb_list_del(struct inode *inode)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	struct list_head *pos;

 	spin_lock(&bdi->wb.list_lock);
+	list_for_each(pos, &inode->i_wb_list) {
+		printk(KERN_EMERG "list entry: %p; next: %p; prev: %p",
+		       pos, pos->next, pos->prev);
+	}
 	list_del_init(&inode->i_wb_list);
 	spin_unlock(&bdi->wb.list_lock);
 }

So on every inode_wb_list_del, it will show the whole list.

and Doing while true; do touch a && rm -f a; done for almost one day
without any problem.

So How to reproduce it??

Thanks,
Yang
