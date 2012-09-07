Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2IGPb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:31:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2IGPbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAMLZHHR=9J0o43xYFBP34vFst4q1DpzEVtgVpyg4BDbq5=8g0g@mail.gmail.com>
References: <CAMLZHHR=9J0o43xYFBP34vFst4q1DpzEVtgVpyg4BDbq5=8g0g@mail.gmail.com>
Date: Fri, 7 Sep 2012 09:31:49 -0600
X-Google-Sender-Auth: OTTpbTMNZT31sd_n0QL96t8fP3w
Message-ID: <CAMLZHHTtTpMLUX2r9=v2=whbZfeF-XQ=asFksBk390kKQ6_=gA@mail.gmail.com>
Subject: Re: Loop device partition scanning is unreliable
From: Daniel Drake <dsd@laptop.org>
To: kzak@redhat.com, kay.sievers@vrfy.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bump :)

On Thu, Jul 19, 2012 at 9:42 AM, Daniel Drake <dsd@laptop.org> wrote:
> I'm having trouble with the loop device partition scanning code.
>
> If I create a blank file, put a partition table on it with fdisk, and
> then immediately turn it into a partitioned loop device, the
> partitions dont always show up.
>
> Here is a script to test this:
> http://dev.laptop.org/~dsd/20120719/loop-partition.sh
>
> I have reproduced this on 5 systems, a mixture of 32 and 64 bit. It
> doesn't seem to matter if the underlying filesystem is ext4 or tmpfs.
> I've reproduced it on 3.3, 3.4.5 and 3.5-rc7.
>
> On some systems it seems to always fail within 8 loops. On others it
> takes more time (100+ loops). I think it crashes more reliable when
> the system is under load - I'm testing with stress
> (http://weather.ou.edu/~apw/projects/stress/): stress -c 6 -m 6 -d 1

Investigating more, the code in loop.c that probes for partitions is:

		ioctl_by_bdev(bdev, BLKRRPART, 0);

This reaches blkdev_reread_part()

static int blkdev_reread_part(struct block_device *bdev)
{
	struct gendisk *disk = bdev->bd_disk;
	int res;

	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
		return -EINVAL;
	if (!capable(CAP_SYS_ADMIN))
		return -EACCES;
	if (!mutex_trylock(&bdev->bd_mutex))
		return -EBUSY;


And this returns with -EBUSY because the mutex is taken. (and the loop
driver doesn't check the return code to become aware of this, or make
the user aware of it).

I added a call to debug_show_all_locks() and the result is:

3 locks held by systemd-udevd/545:
#0:  (&bdev->bd_mutex){......}, at: [<b04ccc55>] __blkdev_get+0x4e/0x342
#1:  (loop_index_mutex){......}, at: [<b05edb48>] lo_open+0x18/0x5a
#2:  (&lo->lo_ctl_mutex){......}, at: [<b05edb67>] lo_open+0x37/0x5a

Thinking that udev is only temporarily holding this lock, I added a
function in loop.c which is blkdev_reread_part() modified to
mutex_lock instead of mutex_trylock:

static int loop_scan_partitions(struct block_device *bdev)
{
	struct gendisk *disk = bdev->bd_disk;
	int res;

	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
		return -EINVAL;
	if (!capable(CAP_SYS_ADMIN))
		return -EACCES;

	mutex_lock(&bdev->bd_mutex);
	res = rescan_partitions(disk, bdev);
	mutex_unlock(&bdev->bd_mutex);
	return res;
}

and I ported loop.c to use that rather than calling the ioctl.

That resulted in a deadlock.

 INFO: task losetup:565 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 losetup         D 00000001  6336   565    561 0x00000000
  eb5ebce8 00000046 00000046 00000001 d3160fa3 00000007 e9bd74b0 e9bd74b0
  eb69b3b0 000001ba e9bd74b0 000001bb ea2cf390 00000000 00000000 eb5ebce0
  00000246 00000000 00000000 00000000 b07691fa 00000000 00000246 ea2cf3c8
 Call Trace:
  [<b07691fa>] ? loop_scan_partitions+0x51/0x78
  [<b076bbf4>] schedule+0x4d/0x4f
  [<b076accb>] mutex_lock_nested+0x126/0x229
  [<b07691fa>] loop_scan_partitions+0x51/0x78
  [<b05ee9c4>] loop_set_status+0x2f6/0x3dc
  [<b05eeb4f>] loop_set_status64+0x32/0x42
  [<b05efb00>] lo_ioctl+0x493/0x603
  [<b05ef66d>] ? lo_release+0x56/0x56
  [<b05520fd>] __blkdev_driver_ioctl+0x21/0x2e
  [<b0552a7f>] blkdev_ioctl+0x6e7/0x734
  [<b0566e77>] ? __debug_check_no_obj_freed+0x4d/0x139
  [<b04cbc00>] block_ioctl+0x37/0x3f
  [<b04cbc00>] ? block_ioctl+0x37/0x3f
  [<b04cbbc9>] ? bd_set_size+0x7a/0x7a
  [<b04b2a60>] vfs_ioctl+0x20/0x2a
  [<b04b3468>] do_vfs_ioctl+0x41c/0x45a
  [<b04a4401>] ? sys_close+0x27/0x9f
  [<b04b34e4>] sys_ioctl+0x3e/0x62
  [<b0771210>] sysenter_do_call+0x12/0x31
 2 locks held by losetup/565:
  #0:  (&lo->lo_ctl_mutex/1){......}, at: [<b05ef6a5>] lo_ioctl+0x38/0x603
  #1:  (&bdev->bd_mutex){......}, at: [<b07691fa>]
loop_scan_partitions+0x51/0x78
 INFO: task systemd-udevd:566 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 systemd-udevd   D 00000000  7148   566    183 0x00000004
  eb495d8c 00000046 00000046 00000000 d3f59b5e 00000007 eb69b3b0 eb69b3b0
  eb649330 00000261 eb69b3b0 00000262 e9bebd18 00000000 00000000 eb495d84
  00000246 00000000 00000000 00000000 b05edb67 00000000 00000246 e9bebd50
 Call Trace:
  [<b05edb67>] ? lo_open+0x37/0x5a
  [<b076bbf4>] schedule+0x4d/0x4f
  [<b076accb>] mutex_lock_nested+0x126/0x229
  [<b05edb30>] ? find_free_cb+0x19/0x19
  [<b05edb67>] lo_open+0x37/0x5a
  [<b04cce33>] __blkdev_get+0x22c/0x342
  [<b04cd08a>] blkdev_get+0x141/0x260
  [<b0439d8e>] ? get_parent_ip+0xb/0x31
  [<b076ec2d>] ? sub_preempt_count+0x75/0x92
  [<b076c7e3>] ? _raw_spin_unlock+0x2c/0x42
  [<b04cd202>] blkdev_open+0x59/0x63
  [<b04a48c7>] __dentry_open+0x249/0x356
  [<b04a5659>] nameidata_to_filp+0x3e/0x4c
  [<b04cd1a9>] ? blkdev_get+0x260/0x260
  [<b04b10ea>] do_last.isra.25+0x5bb/0x5ec
  [<b04b11e4>] path_openat+0x9f/0x2b5
  [<b04b14bf>] do_filp_open+0x26/0x62
  [<b076ec2d>] ? sub_preempt_count+0x75/0x92
  [<b076c7e3>] ? _raw_spin_unlock+0x2c/0x42
  [<b04ba5b6>] ? alloc_fd+0xb8/0xc3
  [<b04a575f>] do_sys_open+0xf8/0x173
  [<b04a0000>] ? __put_swap_token+0x22/0x88
  [<b04a57fa>] sys_open+0x20/0x25
  [<b0771210>] sysenter_do_call+0x12/0x31
 3 locks held by systemd-udevd/566:
  #0:  (&bdev->bd_mutex){......}, at: [<b04ccc55>] __blkdev_get+0x4e/0x342
  #1:  (loop_index_mutex){......}, at: [<b05edb48>] lo_open+0x18/0x5a
  #2:  (&lo->lo_ctl_mutex){......}, at: [<b05edb67>] lo_open+0x37/0x5a

Any thoughts/approaches to try?

Thanks
Daniel
