Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1FIXqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:46:55 -0400
Received: from twin.jikos.cz ([89.185.236.188]:38228 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab1FIXqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:46:51 -0400
Date: Fri, 10 Jun 2011 01:45:53 +0200
From: David Sterba <dave@jikos.cz>
To: Jim Schutt <jaschut@sandia.gov>
Cc: miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: 3.0-rcX BUG at fs/btrfs/ioctl.c:432 - bisected
Message-ID: <20110609234553.GN12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Jim Schutt <jaschut@sandia.gov>, miaox@cn.fujitsu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <4DF140AB.4030805@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF140AB.4030805@sandia.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a candidate fix:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=aa0467d8d2a00e75b2bb6a56a4ee6d70c5d1928f

"
 With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
 produced this warning:

 fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
 fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
 uninitialized in this function
 Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
 operation").

 This fixes a bug in btrfs_update_inode(): if the returned value from
 btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
 updated and several call paths may hit a BUG_ON or fail with strange
 code.
"

if you can reproduce it reliably, add this patch on top of the delayed inodes.



On Thu, Jun 09, 2011 at 03:52:43PM -0600, Jim Schutt wrote:
> Hi,
> 
> I've run into the following BUG on 3.0-rcX kernels when
> running mkcephfs:
> 
> Jun  9 15:14:50 an1 [  299.446615] ------------[ cut here ]------------
> Jun  9 15:14:50 an1 [  299.447357] kernel BUG at fs/btrfs/ioctl.c:432!

ioctl.c:
 431         ret = btrfs_update_inode(trans, root, dir);
 432         BUG_ON(ret);

> Jun  9 15:14:50 an1 [  299.447357] RSP: 0018:ffff88021b163c48  EFLAGS: 00010206
> Jun  9 15:14:50 an1 [  299.447357] RAX: 0000000019b201a0 RBX: ffff88022402d800 RCX: ffff88019206c028
                                          ^^^^^^^^^^^^^^^^
ret, which seems to contain value of delayed_node from previous return value
(deduced from assembly):

delayed-node.c:
1600         delayed_node = btrfs_get_or_create_delayed_node(inode);
1601         if (IS_ERR(delayed_node))
1602                 return PTR_ERR(delayed_node);


> Please let me know what other information I can provide, or
> any testing I can do, that will help to resolve this issue.

thanks, I think the stacktrace contains everything important. I was trying to
trigger the bugon myself when the report arrived, but did not succeed. the
issue is quite recent and seeing this report was a "cache" hit :)

Note: there are two more possibilities to hit the bugon in the ioctl: ENOMEM
and ENOENT being retunred from btrfs_update_inode, but the symptoms fit the
case described above.


david
