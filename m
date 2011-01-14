Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1ANE5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:57:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1ANE5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:57:19 -0500
Message-ID: <4D2FD771.9040301@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 12:56:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: viro@ZenIV.linux.org.uk, Nick Piggin <npiggin@gmail.com>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: kernel BUG at fs/dcache.c:1363 (from cgroup)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 12:55:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 12:56:51,
	Serialize complete at 2011-01-14 12:56:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just mount the cgroupfs:

# mount -t cgroup -o cpuset xxx /mnt
(oops!!)

The bug is caused by:

=========
commit 0df6a63f8735a7c8a877878bc215d4312e41ef81
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Dec 21 13:29:29 2010 -0500

    switch cgroup
    
    switching it to s_d_op allows to kill the cgroup_lookup() kludge.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
=========

This line:

+       sb->s_d_op = &cgroup_dops;

will cause the dentry op be set twice, and thus trigger the bomb:

struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
{
	...
        if (parent) {
		...
                d_set_d_op(dentry, dentry->d_sb->s_d_op);
		...
        }
	...
}

static struct dentry *d_alloc_and_lookup(struct dentry *parent,
                                struct qstr *name, struct nameidata *nd)
{
	...
        dentry = d_alloc(parent, name);
	...
        old = inode->i_op->lookup(inode, dentry, nd);
	...
}

simple_lookup() will call d_set_d_op()...


==============

[   90.740906] kernel BUG at fs/dcache.c:1360!
..
[   90.810321] Call Trace:
[   90.814166]  [<c04f97ad>] simple_lookup+0x26/0x3c
[   90.818015]  [<c04e86ce>] d_alloc_and_lookup+0x36/0x54
[   90.818021]  [<c04e8aa8>] __lookup_hash+0x6a/0x71
[   90.818026]  [<c04e8f33>] lookup_one_len+0x81/0x90
[   90.818034]  [<c0473083>] cgroup_add_file+0x8e/0x132
[   90.818041]  [<c0473152>] cgroup_add_files+0x2b/0x3d
[   90.818047]  [<c0473188>] cgroup_populate_dir+0x24/0xdb
[   90.818053]  [<c047360b>] cgroup_mount+0x3cc/0x431
[   90.818061]  [<c04e238d>] vfs_kern_mount+0x57/0x109
[   90.818066]  [<c047323f>] ? cgroup_mount+0x0/0x431
[   90.818072]  [<c04e248e>] do_kern_mount+0x38/0xba
[   90.818077]  [<c04f6706>] do_mount+0x5e4/0x60f
[   90.818082]  [<c04f6094>] ? copy_mount_options+0x78/0xd7
[   90.818087]  [<c04f68de>] sys_mount+0x66/0x94
[   90.818093]  [<c040329f>] sysenter_do_call+0x12/0x38
