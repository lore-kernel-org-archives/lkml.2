Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1AMSmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:42:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1AMSmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:42:51 -0500
Message-ID: <4D2F4799.5030901@redhat.com>
Date: Thu, 13 Jan 2011 19:42:33 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Valdis.Kletnieks@vt.edu, Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] block: restore multiple bd_link_disk_holder() support
References: <16069.1294853673@localhost> <4D2E4611.90002@redhat.com> <4D2E6129.8000700@ce.jp.nec.com> <20110113172133.GE14096@htj.dyndns.org>
In-Reply-To: <20110113172133.GE14096@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 06:21 PM, Tejun Heo wrote:
> Commit e09b457b (block: simplify holder symlink handling) incorrectly
> assumed that there is only one holder at maximum.  dm may use multiple
> holders.  Remove the single holder assumption and automatic removal of
> the link.  Let the callers explicitly remove them.  This change makes
> it even more alien from the rest of the block layer.
> 
> While at it, note that this facility should not be used by anyone else
> than the current ones.  Sysfs symlinks shouldn't be abused like this
> and the whole thing doesn't belong in the block layer at all.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Milan Broz <mbroz@redhat.com>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> ---
> Milan, Jun, can you guys please verify this works correctly for the
> multi holder dm case?  Thank you.

Hi,

unfortunately not. And the problem is much worse,
it breaks lvm resize operation completely.

I cherry-picked you patch to my tree, it fails, reverting helps.

Following test is over linux-next with your last patch applied:

Test case (lvresize of volume over 3 disks sdb,c,d):

# pvcreate /dev/sd[bcd]
  Physical volume "/dev/sdb" successfully created
  Physical volume "/dev/sdc" successfully created
  Physical volume "/dev/sdd" successfully created

# vgcreate vg_test /dev/sd[bcd]
  Volume group "vg_test" successfully created

# lvcreate -l100%FREE -n lv vg_test
  Logical volume "lv" created

# dmsetup table
vg_test-lv: 0 409600 linear 8:16 2048
vg_test-lv: 409600 409600 linear 8:32 2048
vg_test-lv: 819200 409600 linear 8:48 2048

so we have active LV mapped to 3 devices now.

Now online resize it. I means that it will create inactive table,
then switch active (so the magic with claiming disks applies):

# lvresize -L-10M vg_test/lv
  Rounding up size to full physical extent 8.00 MiB
  WARNING: Reducing active logical volume to 592.00 MiB
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce lv? [y/n]: y
  Reducing logical volume lv to 592.00 MiB
  device-mapper: reload ioctl failed: Invalid argument
  Failed to suspend lv

and in syslog:
[  291.221081] ------------[ cut here ]------------
[  291.221111] WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x6b/0x80()
[  291.221130] Hardware name: VMware Virtual Platform
[  291.221140] sysfs: cannot create duplicate filename '/devices/virtual/block/dm-0/slaves/sdb'
[  291.221162] Modules linked in: usbcore dm_mod
[  291.221265] Pid: 4074, comm: lvresize Tainted: G        W   2.6.37-next-20110113+ #2
[  291.221269] Call Trace:
[  291.221286]  [<c102e58f>] ? warn_slowpath_common+0x65/0x7a
[  291.221290]  [<c10f8911>] ? sysfs_add_one+0x6b/0x80
[  291.221295]  [<c102e608>] ? warn_slowpath_fmt+0x26/0x2a
[  291.221299]  [<c10f8911>] ? sysfs_add_one+0x6b/0x80
[  291.221304]  [<c10f9482>] ? sysfs_do_create_link+0xda/0x164
[  291.221308]  [<c10f9522>] ? sysfs_create_link+0xa/0xc
[  291.221314]  [<c10db85c>] ? bd_link_disk_holder+0x66/0xad
[  291.221484]  [<d08289ea>] ? open_dev+0x47/0x67 [dm_mod]
[  291.221492]  [<d0828aff>] ? dm_get_device+0xf5/0x1d5 [dm_mod]
[  291.221502]  [<c11bf168>] ? vsscanf+0x364/0x3ee
[  291.221510]  [<c10b250a>] ? cache_alloc_debugcheck_after+0xf/0x180
[  291.221523]  [<d0829812>] ? linear_ctr+0x86/0xc0 [dm_mod]
[  291.221531]  [<d0829287>] ? dm_table_add_target+0x153/0x1d3 [dm_mod]
[  291.221538]  [<d082adea>] ? table_load+0x1fd/0x21e [dm_mod]
[  291.221545]  [<d082b9f8>] ? dm_ctl_ioctl+0x188/0x1c8 [dm_mod]
[  291.221551]  [<d082abed>] ? table_load+0x0/0x21e [dm_mod]
[  291.221558]  [<d082b870>] ? dm_ctl_ioctl+0x0/0x1c8 [dm_mod]
[  291.221565]  [<c10c38ab>] ? do_vfs_ioctl+0x493/0x4d8
[  291.221573]  [<c1313511>] ? do_page_fault+0x3ee/0x418
[  291.221578]  [<c10c391e>] ? sys_ioctl+0x2e/0x48
[  291.221583]  [<c1002853>] ? sysenter_do_call+0x12/0x32
[  291.221609] ---[ end trace c21a5bad605a4a87 ]---
[  291.221760] device-mapper: table: 254:0: linear: dm-linear: Device lookup failed
[  291.221782] device-mapper: ioctl: error adding target to table

Milan
