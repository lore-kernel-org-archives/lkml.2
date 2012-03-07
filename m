Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab2CGHbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 02:31:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:13492 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab2CGHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 02:31:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115730374"
Date: Tue, 6 Mar 2012 23:26:08 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@ZenIV.linux.org.uk, Christoph Hellwig <hch@infradead.org>
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120307072608.GA24087@localhost>
References: <20120306185137.GA15881@redhat.com>
 <20120306210307.GC8781@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306210307.GC8781@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 10:03:07PM +0100, Jan Kara wrote:
> On Tue 06-03-12 13:51:37, Dave Jones wrote:
> > We've had three separate reports against 3.2.x recently where the linked list debugging
> > is getting tripped up by the prev->next pointer being null instead of pointing
> > to the current list entry while walking the i_wb_list
> > 
> > Call traces are slightly different each time, but all end up walking i_wb_list 
> > in dput -> d_kill -> i_put -> evict -> inode_wb_list_del
> > 
> > What protects that list ? It looks to be just bdi->wb.list_lock ?
> > 
> > 
> > full reports at:
> > https://bugzilla.redhat.com/show_bug.cgi?id=784741
> > https://bugzilla.redhat.com/show_bug.cgi?id=799229
> > https://bugzilla.redhat.com/show_bug.cgi?id=799692
>   Hum, interesting! I'd guess this might be caused by f758eeab - adding
> Fengguang and Christoph to CC. But I'm really failing to see how this could
> happen but interesting thing is that in two of the three cases the files
> are on virtual filesystems (once cgroup, once sysfs). These both use
> noop_backing_dev_info.

sysfs/cgroup forgot to init inode->i_wb_list?

This simplified fix inits it in inode_init_always().

The better fix would be to add init_once to sysfs or perhaps fix
sysfs_get_inode()/cgroup_new_inode().

Thanks,
Fengguang

---
 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/fs/inode.c	2012-02-22 19:20:48.374799955 -0800
+++ linux/fs/inode.c	2012-03-06 23:11:29.133899478 -0800
@@ -193,6 +193,7 @@ int inode_init_always(struct super_block
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 	INIT_LIST_HEAD(&inode->i_dentry);	/* buggered by rcu freeing */
+	INIT_LIST_HEAD(&inode->i_wb_list);
 #ifdef CONFIG_FS_POSIX_ACL
 	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
 #endif
