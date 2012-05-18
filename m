Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102Ab2ERHqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:46:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49257 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245Ab2ERHqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAFeW=patEo56jXmyO6EPkDOf4oBwk1kaNE8OQASZHK-3d3zhZA@mail.gmail.com>
References: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
	<CAFeW=pZ-HZKyBALRZVo=PeWUoaEk39QUSoMsV-1K5CBgcVUMeA@mail.gmail.com>
	<4FB5C76F.6090504@huawei.com>
	<CAFeW=patEo56jXmyO6EPkDOf4oBwk1kaNE8OQASZHK-3d3zhZA@mail.gmail.com>
Date: Fri, 18 May 2012 15:46:17 +0800
Message-ID: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
Subject: Re: cgroup: denying device doesn't work with 'rw' mode string
From: Amos Kong <kongjianjun@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: serue@us.ibm.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        tj@kernel.org, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In devcgroup_create(), we create a new whitelist, and add first entry
which type is 'DEV_ALL'.
Execute "# echo 'b 253:3 rw' > devices/devices.deny",
dev_whitelist_rm() will update access
of first entry to 3, but type of first entry is also 'DEV_ALL'

.. static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup, ...) {
..      list_for_each_entry_safe(walk, tmp, &dev_cgroup->whitelist, list) {
..              if (walk->type == DEV_ALL)
..                      goto remove;

If the type is 'DEV_ALL', will try to remove it without checking major/minor/..

.. remove:
..              walk->access &= ~wh->access;

                access of first entry will be updated to 7(mrw) & ~4(w) = 3

..              if (!walk->access) {

                first entry will not be deleted, because walk->access is not 0

..                      list_del_rcu(&walk->list);
..                      kfree_rcu(walk, rcu);

Execute dd cmd to write device, __devcgroup_inode_permission() will be called.
The type of first list entry is 'DEV_ALL', just pass this permission checking.
(write operation will not be denied)

.. int __devcgroup_inode_permission(struct inode *inode, int mask) {
..         ....
..      dev_cgroup = task_devcgroup(current);
..      list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
..              if (wh->type & DEV_ALL)
..                      goto found;

// If type is 'DEV_ALL', pass permission check

..                 ....
..              if ((mask & MAY_WRITE) && !(wh->access & ACC_WRITE))
..                      continue;
.. found:
..              rcu_read_unlock();
..              return 0;
..
