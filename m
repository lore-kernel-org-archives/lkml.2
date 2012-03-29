Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab2C2ELc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:11:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2C2ELY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:11:24 -0400
X-IronPort-AV: E=Sophos;i="4.75,335,1330876800"; 
   d="scan'208";a="4645499"
Message-ID: <4F73E0FB.7010605@cn.fujitsu.com>
Date: Thu, 29 Mar 2012 12:11:39 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20110412 CentOS/3.1.3-1.el6.centos Thunderbird/3.1.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: Tokunaga Kei <tokunaga.keiich@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        UDEV <linux-hotplug@vger.kernel.org>
Subject: Re: [RFC PATCH] virtio_blk: Checking "private_data"  to avoid kernel
 panic when hotplugging
References: <4F728831.2090406@cn.fujitsu.com> <20120328111115.GE6194@redhat.com>
In-Reply-To: <20120328111115.GE6194@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 12:09:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-29 12:09:06,
	Serialize complete at 2012-03-29 12:09:06
Content-Type: multipart/mixed;
 boundary="------------020606090403000606010302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020606090403000606010302
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

  Hi, Michael:

On 03/28/2012 07:11 PM, Michael S. Tsirkin wrote:
> On Wed, Mar 28, 2012 at 11:40:33AM +0800, Ren Mingxin wrote:
>>   On guest with upstream's kernel(3.3.0-rc7), I
>> mounted virtblk as:
>>    a) # mkfs /dev/vda
>>    b) # mount /dev/vda /mnt
>>    c) # cd /mnt
>>
>> Then I did hotplug for virtblk via virsh on host as:
>>    a) # sudo virsh detach-disk guest vda
>>    b) # sudo virsh attach-disk guest /media/data/test.img vda
> Did a quick test and I don't seem to see a panic.
> How reproducible is this for you?

I think the key difference of environment is udev:
my udev version is 147(BTW, actually, except
the upstream's kernel, other tools are based on
rhel6.2ga) with "60-persistent-storage.rules":

# cat /lib/udev/rules.d/60-persistent-storage.rules
....
# skip unpartitioned removable media devices from drivers which do not 
send "change" events
ENV{DEVTYPE}=="disk", KERNEL!="xvd*|sd*|sr*", ATTR{removable}=="1", 
GOTO="persistent_storage_end"
....
# probe filesystem metadata of disks
KERNEL!="xvd*|sr*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
....
LABEL="persistent_storage_end"

According to this, "blkid" will be executed
on unpartitioned virtblk, but will not be on
partitioned virtblk. So this panic will only be
occurred on unpartitioned virtblk. BTW: I
commented this "blkid" line in this rule file
as debug, and the panic can be avoided.

>> I encountered guest's kernel panic (*probability*
>> *event*)whose backtrace liked this:
>>
>> PID: 2496   TASK: ffff88001f5de080  CPU: 0   COMMAND: "blkid"
>>   #0 [ffff88001afdbb00] machine_kexec at ffffffff81031fcb
>>   #1 [ffff88001afdbb60] crash_kexec at ffffffff810b8f72
>>   #2 [ffff88001afdbc30] oops_end at ffffffff814f04b0
>>   #3 [ffff88001afdbc60] die at ffffffff8100f26b
>>   #4 [ffff88001afdbc90] do_general_protection at ffffffff814f0042
>>   #5 [ffff88001afdbcc0] general_protection at ffffffff814ef815
>>      [exception RIP: virtio_check_driver_offered_feature+27]
>>      RIP: ffffffffa00540cb  RSP: ffff88001afdbd78  RFLAGS: 00010206
>>      RAX: ffffffff810ffde0  RBX: ffff88001f14a800  RCX: 000000004cf0758b
>>      RDX: 4ce86d8b4ce0658b  RSI: 0000000000000007  RDI: ffffffff81a970a0
>>      RBP: ffff88001afdbd78   R8: ffffffffa009d060   R9: 0000000000000100
>>      R10: 0000000000000006  R11: 0000000000000246  R12: 000000000000101d
>>      R13: 0000000000005331  R14: ffffffff81a970a0  R15: 0000000000000000
>>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>>   #6 [ffff88001afdbd80] virtblk_ioctl at ffffffffa009c459 [virtio_blk]
>>   #7 [ffff88001afdbdc0] __blkdev_driver_ioctl at ffffffff81257317
>>   #8 [ffff88001afdbe00] blkdev_ioctl at ffffffff8125779d
>>   #9 [ffff88001afdbe50] block_ioctl at ffffffff811aec5c
>> #10 [ffff88001afdbe60] vfs_ioctl at ffffffff81189342
>> #11 [ffff88001afdbea0] do_vfs_ioctl at ffffffff811894e4
>> #12 [ffff88001afdbf30] sys_ioctl at ffffffff81189a61
>> #13 [ffff88001afdbf80] system_call_fastpath at ffffffff8100b0f2
>>      RIP: 0000003f566dd847  RSP: 00007fffa23e6130  RFLAGS: 00010202
>>      RAX: 0000000000000010  RBX: ffffffff8100b0f2  RCX: 0000000000000008
>>      RDX: 0000000000000000  RSI: 0000000000005331  RDI: 0000000000000003
>>      RBP: 0000000040000000   R8: 0000003f5699b580   R9: 0000000000000100
>>      R10: 0000000000000006  R11: 0000000000000246  R12: 0000000000000000
>>      R13: 0000003f59020ba0  R14: 0000000000000003  R15: 000000000241f030
>>      ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
>>
>> This panic was triggered by the command of "blkid" in
>> udev's rule "60-persistent-storage.rules".
> The weird thing is, we should not get any ioctls
> before add_disk is called.

The problem is, virtblk_probe() has been called to
add disk, then the "blkid" in the udev rule calls
virtblk_ioctl(), but at this time, the data of bdev->
bd_disk->private_data is wrong. See details in the
attachment please.

>> So, when the virtblk was reattached, command "blkid"
>> probed filesystem metadata of disks. At that moment,
>> virtblk_ioctl() was called, but the data of "virtio_blk"
>> "bdev->bd_disk->private_data" pointing to may not be
>> updated for the sync reason.
> Sorry, what does "for the sync reason" mean?
> private_data seems to be set at device probe
> and never changed.

Sorry, I means timing reason. For if I debug the
virtblk_probe() by step, this panic will not be
happened.(the data should have been updated.)

>> This patch do this check to avoid panic.
>>
>> Any comment will be appreciated.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   virtio_blk.c |    6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index c4a60ba..4ac81f8 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -245,6 +245,12 @@ static int virtblk_ioctl(struct block_device
>> *bdev, fmode_t mode,
>>          struct virtio_blk *vblk = disk->private_data;
>>
>>          /*
>> +        * Check whether the private data pointer has been updated.
>> +        */
>> +       if (vblk != vblk->vdev->priv)
>> +               return -EFAULT;
>> +
> I would change this to
> BUG_ON(vblk != vblk->vdev->priv);
>
> Add traces to virtblk_probe/virtblk_remove
> and see where the bad device came from.

I attached the debug log using gdb on host.
You can see the panic occurs at the function
virtio_check_driver_offered_feature() who
accesses the feature_table out-of range
(actually, the size of array should be 8).
But these data became wrong since
bdev->bd_disk->private_data.

And, could you tell me what data do you need
me  trace on virtblk_probe/virtblk_remove? I'll
collect these in my environment.

Thanks,
Ren

-- 
Best Regards
--------------------------------------------------
Ren Mingxin
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No.6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8552
FUJITSU INTERNAL: 7998-8552
FAX: +86+25-83317685
MAIL:renmx@cn.fujitsu.com
--------------------------------------------------


--------------020606090403000606010302
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="virtblk_hotplug_panic_gdb_log"
Content-Disposition: attachment;
 filename="virtblk_hotplug_panic_gdb_log"

(gdb) b virtblk_ioctl
Breakpoint 1 at 0xffffffffa00255f1: file drivers/block/virtio_blk.c, line 250.
(gdb) b virtblk_probe
Breakpoint 2 at 0xffffffffa0025caa: file drivers/block/virtio_blk.c, line 378.
(gdb) c
Continuing.

Breakpoint 2, virtblk_probe (vdev=0xffff88003d0e8000) at drivers/block/virtio_blk.c:378
378	in drivers/block/virtio_blk.c
(gdb) c
Continuing.

Breakpoint 1, virtblk_ioctl (bdev=0xffff880037cb9740, mode=4125, cmd=21297, data=0) at drivers/block/virtio_blk.c:250
250	in drivers/block/virtio_blk.c
(gdb) bt
#0  virtblk_ioctl (bdev=0xffff880037cb9740, mode=4125, cmd=21297, data=0) at drivers/block/virtio_blk.c:250
#1  0xffffffff81232cd8 in __blkdev_driver_ioctl (bdev=<value optimized out>, mode=<value optimized out>, cmd=<value optimized out>, arg=<value optimized out>)
    at block/ioctl.c:171
#2  0xffffffff8123306e in blkdev_ioctl (bdev=0xffff880037cb9740, mode=<value optimized out>, cmd=21297, arg=0) at block/ioctl.c:347
#3  0xffffffff811a0f5c in block_ioctl (file=<value optimized out>, cmd=<value optimized out>, arg=<value optimized out>) at fs/block_dev.c:1558
#4  0xffffffff8117dacc in vfs_ioctl (filp=0xffff880039dca6c0, fd=3, cmd=<value optimized out>, arg=<value optimized out>) at fs/ioctl.c:43
#5  do_vfs_ioctl (filp=0xffff880039dca6c0, fd=3, cmd=<value optimized out>, arg=<value optimized out>) at fs/ioctl.c:598
#6  0xffffffff8117de21 in sys_ioctl (fd=3, cmd=21297, arg=0) at fs/ioctl.c:618
#7  0xffffffff815091a9 in ?? () at arch/x86/kernel/entry_64.S:488
#8  0x0000003f566dd847 in __brk_reservation_fn_dmi_alloc__ ()
(gdb) p *(struct block_device *)bdev
$7 = {bd_dev = 265289728, bd_openers = 2, bd_inode = 0xffff880037cb9820, bd_super = 0xffff880037a8fc00, bd_mutex = {count = {counter = 1}, wait_lock = {{rlock = {raw_lock = {{
              head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, wait_list = {next = 0xffff880037cb9760, prev = 0xffff880037cb9760}, owner = 0x0}, bd_inodes = {
    next = 0xffff8800370c9a10, prev = 0xffff8800370c9a10}, bd_claiming = 0x0, bd_holder = 0xffffffffa00d4920, bd_holders = 2, bd_write_holder = false, bd_holder_disks = {
    next = 0xffff880037cb97a0, prev = 0xffff880037cb97a0}, bd_contains = 0xffff880037cb9740, bd_block_size = 4096, bd_part = 0xffff880037091848, bd_part_count = 0, 
  bd_invalidated = 1, bd_disk = 0xffff880037091800, bd_queue = 0xffff880037014078, bd_list = {next = 0xffff880037cb9b20, prev = 0xffff880037cb9160}, bd_private = 0, 
  bd_fsfreeze_count = 0, bd_fsfreeze_mutex = {count = {counter = 1}, wait_lock = {{rlock = {raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, wait_list = {
      next = 0xffff880037cb9808, prev = 0xffff880037cb9808}, owner = 0x0}}
(gdb) p *(struct gendisk *)bdev->bd_disk
$8 = {major = 253, first_minor = 0, minors = 16, disk_name = "vda", '\000' <repeats 28 times>, devnode = 0, events = 0, async_events = 0, part_tbl = 0xffff880037021fc0, 
  part0 = {start_sect = 0, nr_sects = 0, alignment_offset = 0, discard_alignment = 0, __dev = {parent = 0xffff8800377bcc08, p = 0xffff8800370972c0, kobj = {
        name = 0xffff880037770620 "vda", entry = {next = 0xffff880037091880, prev = 0xffff880037091880}, parent = 0x0, kset = 0xffff88003daa6ac0, ktype = 0xffffffff81a94ee0, 
        sd = 0x0, kref = {refcount = {counter = 2}}, state_initialized = 1, state_in_sysfs = 0, state_add_uevent_sent = 1, state_remove_uevent_sent = 1, uevent_suppress = 0}, 
      init_name = 0x0, type = 0xffffffff81a7f3c0, mutex = {count = {counter = 1}, wait_lock = {{rlock = {raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, 
        wait_list = {next = 0xffff8800370918d0, prev = 0xffff8800370918d0}, owner = 0x0}, bus = 0x0, driver = 0x0, platform_data = 0x0, power = {power_state = {event = -1}, 
        can_wakeup = 0, async_suspend = 0, is_prepared = false, is_suspended = false, ignore_children = false, lock = {{rlock = {raw_lock = {{head_tail = 65537, tickets = {
                    head = 1, tail = 1}}}}}}, entry = {next = 0xffff880037091910, prev = 0xffff880037091910}, completion = {done = 4294967294, wait = {lock = {{rlock = {
                  raw_lock = {{head_tail = 131074, tickets = {head = 2, tail = 2}}}}}}, task_list = {next = 0xffff880037091930, prev = 0xffff880037091930}}}, wakeup = 0x0, 
        wakeup_path = false, suspend_timer = {entry = {next = 0x0, prev = 0x0}, expires = 0, base = 0xffffffff81d4e000, function = 0xffffffff8133f7d0 <pm_suspend_timer_fn>, 
          data = 18446612133237561448, slack = -1, start_pid = -1, start_site = 0x0, start_comm = '\000' <repeats 15 times>}, timer_expires = 0, work = {data = {
            counter = 1048832}, entry = {next = 0xffff8800370919b0, prev = 0xffff8800370919b0}, func = 0xffffffff8133fef0 <pm_runtime_work>}, wait_queue = {lock = {{rlock = {
                raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, task_list = {next = 0xffff8800370919d0, prev = 0xffff8800370919d0}}, usage_count = {
          counter = 0}, child_count = {counter = 0}, disable_depth = 2, idle_notification = 0, request_pending = 0, deferred_resume = 0, run_wake = 0, runtime_auto = 1, 
        no_callbacks = 0, irq_safe = 0, use_autosuspend = 0, timer_autosuspends = 0, request = RPM_REQ_NONE, runtime_status = RPM_SUSPENDED, runtime_error = 0, 
        autosuspend_delay = 0, last_busy = 0, active_jiffies = 0, suspended_jiffies = 0, accounting_timestamp = 4294668457, suspend_time = {tv64 = 0}, 
        max_time_suspended_ns = -1, subsys_data = 0x0, constraints = 0x0}, pm_domain = 0x0, numa_node = -1, dma_mask = 0x0, coherent_dma_mask = 0, dma_parms = 0x0, 
      dma_pools = {next = 0xffff880037091a68, prev = 0xffff880037091a68}, dma_mem = 0x0, archdata = {acpi_handle = 0x0, dma_ops = 0x0, iommu = 0x0}, of_node = 0x0, 
      devt = 265289728, id = 0, devres_lock = {{rlock = {raw_lock = {{head_tail = 65537, tickets = {head = 1, tail = 1}}}}}}, devres_head = {next = 0xffff880037091ab0, 
        prev = 0xffff880037091ab0}, knode_class = {n_klist = 0x0, n_node = {next = 0xdead000000100100, prev = 0xdead000000200200}, n_ref = {refcount = {counter = 0}}}, 
      class = 0xffffffff81a7f2e0, groups = 0x0, release = 0}, holder_dir = 0xffff880037021a80, policy = 0, partno = 0, info = 0x0, stamp = 0, in_flight = {{counter = 0}, {
        counter = 0}}, dkstats = 0x1a060, ref = {counter = 1}, rcu_head = {next = 0x0, func = 0}}, fops = 0xffffffffa0026300, queue = 0xffff880037014078, 
  private_data = 0xffff88003777c000, flags = 0, driverfs_dev = 0x0, slave_dir = 0xffff880037021a40, random = 0xffff880037009e60, sync_io = {counter = 0}, ev = 0x0, 
  integrity = 0x0, node_id = -1}
(gdb) p *(struct virtio_blk *)bdev->bd_disk->private_data
$9 = {lock = {{rlock = {raw_lock = {{head_tail = 926040256, tickets = {head = 16576, tail = 14130}}}}}}, vdev = 0xffffffff81a17060, vq = 0x80, disk = 0x0, reqs = {
    next = 0x7ffffffff000, prev = 0xffffffff8105e3f0}, pool = 0x0, config_work = {data = {counter = 0}, entry = {next = 0x0, prev = 0x0}, func = 0}, config_lock = {count = {
      counter = 0}, wait_lock = {{rlock = {raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, wait_list = {next = 0x0, prev = 0x57ac6e9d}, owner = 0x0}, 
  config_enable = false, sg_elems = 128, index = 0, sg = 0xffff88003777c000}
(gdb) p *(struct virtio_device *)((struct virtio_blk *)bdev->bd_disk->private_data)->vdev
$10 = {index = -2122592968, dev = {parent = 0xffffffff8104d410, p = 0x0, kobj = {name = 0xffffffff81a17260 "", entry = {next = 0xffffffff81a17260, prev = 0x0}, parent = 0x0, 
      kset = 0x0, ktype = 0x0, sd = 0x0, kref = {refcount = {counter = 0}}, state_initialized = 0, state_in_sysfs = 0, state_add_uevent_sent = 0, state_remove_uevent_sent = 0, 
      uevent_suppress = 0}, init_name = 0x0, type = 0xffffffff81a16f00, mutex = {count = {counter = -2120126112}, wait_lock = {{rlock = {raw_lock = {{head_tail = 4294967295, 
                tickets = {head = 65535, tail = 65535}}}}}}, wait_list = {next = 0xffffffff81a52f40, prev = 0xffffffff817a2666}, owner = 0xffff88003dc456c0}, bus = 0x0, 
    driver = 0xffffffff81a21e88, platform_data = 0xffffffff81a17198, power = {power_state = {event = -2120126664}, can_wakeup = 1, async_suspend = 1, is_prepared = true, 
      is_suspended = true, ignore_children = true, lock = {{rlock = {raw_lock = {{head_tail = 61, tickets = {head = 61, tail = 0}}}}}}, entry = {next = 0xffffffff81a52ec0, 
        prev = 0xffffffff817a8f98}, completion = {done = 0, wait = {lock = {{rlock = {raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, task_list = {
            next = 0xffffffff81a17200, prev = 0x8}}}, wakeup = 0x0, wakeup_path = false, suspend_timer = {entry = {next = 0x0, prev = 0x0}, expires = 18446744071589425344, 
        base = 0xffffffff81a173e0, function = 0xffffffff81a52ee0, data = 18446744071586850427, slack = 1036276480, start_pid = -30720, start_site = 0x0, 
        start_comm = "h\037\242\201\377\377\377\377\030t\241\201\377\377\377\377"}, timer_expires = 18446744071589425400, work = {data = {counter = 62}, entry = {
          next = 0xffffffff81a52ea0, prev = 0xffff88003dbdb280}, func = 0}, wait_queue = {lock = {{rlock = {raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, 
        task_list = {next = 0xffffffff81a17200, prev = 0x8}}, usage_count = {counter = 0}, child_count = {counter = 0}, disable_depth = 0, idle_notification = 0, 
      request_pending = 0, deferred_resume = 0, run_wake = 0, runtime_auto = 0, no_callbacks = 0, irq_safe = 0, use_autosuspend = 0, timer_autosuspends = 0, 
      request = RPM_REQ_NONE, runtime_status = RPM_ACTIVE, runtime_error = 0, autosuspend_delay = 0, last_busy = 18446744071586850449, active_jiffies = 4294967431, 
      suspended_jiffies = 18446744071589426016, accounting_timestamp = 18446744071589426024, suspend_time = {tv64 = -131940359491072}, 
      max_time_suspended_ns = -131940359491008, subsys_data = 0xffffffff81a17160, constraints = 0xffffffff81a170c0}, pm_domain = 0x100000000, numa_node = -2120126368, 
    dma_mask = 0x0, coherent_dma_mask = 0, dma_parms = 0x0, dma_pools = {next = 0x1, prev = 0x2}, dma_mem = 0x3, archdata = {acpi_handle = 0x4, dma_ops = 0x5, iommu = 0x6}, 
    of_node = 0x7, devt = 8, id = 0, devres_lock = {{rlock = {raw_lock = {{head_tail = 9, tickets = {head = 9, tail = 0}}}}}}, devres_head = {next = 0xa, prev = 0xb}, 
    knode_class = {n_klist = 0xc, n_node = {next = 0xd, prev = 0xe}, n_ref = {refcount = {counter = 15}}}, class = 0x10, groups = 0x11, 
    release = 0x12 <__mod_description698+6>}, id = {device = 19, vendor = 0}, config = 0x14, vqs = {next = 0x15, prev = 0x16}, features = {23}, priv = 0x18}
(gdb) p *(struct device *)((struct virtio_blk *)bdev->bd_disk->private_data)->vdev.dev
$11 = {parent = 0xec834853e5894855, p = 0x4865906666666618, kobj = {name = 0x8b0000c6c025048b <Address 0x8b0000c6c025048b out of bounds>, entry = {next = 0x85fb890000048480, 
      prev = 0x25048b48652d75c0}, parent = 0x30808b480000c6c8, kset = 0x1008788148ffffe0, ktype = 0xffdf892b748104d4, sd = 0xc95b18c483480850, kref = {refcount = {
        counter = -2145447997}}, state_initialized = 0, state_in_sysfs = 0, state_add_uevent_sent = 0, state_remove_uevent_sent = 0, uevent_suppress = 0}, 
  init_name = 0xb5e8e8758948ff31 <Address 0xb5e8e8758948ff31 out of bounds>, type = 0xebe8758b48fffffd, mutex = {count = {counter = -2145447998}, wait_lock = {{rlock = {
          raw_lock = {{head_tail = 0, tickets = {head = 0, tail = 0}}}}}}, wait_list = {next = 0xbbf00000001ba, prev = 0xc025348b48650000}, owner = 0x140c0e80000c6}, 
  bus = 0x66c3c95b18c48348, driver = 0x841f0f, platform_data = 0xec834853e5894855, power = {power_state = {event = 1717986824}, can_wakeup = 0, async_suspend = 1, 
    is_prepared = true, is_suspended = false, ignore_children = false, lock = {{rlock = {raw_lock = {{head_tail = 3223651467, tickets = {head = 1163, tail = 49189}}}}}}, 
    entry = {next = 0x484988bffff, prev = 0x55e80574fb390974}, completion = {done = 2315255805, wait = {lock = {{rlock = {raw_lock = {{head_tail = 3284753160, tickets = {
                    head = 23304, tail = 50121}}}}}}, task_list = {next = 0x9090909090909090, prev = 0x66666666e5894855}}}, wakeup = 0x1f0fc3c9c03190, wakeup_path = true, 
    suspend_timer = {entry = {next = 0x801f0f90, prev = 0x2e666666fceb90f3}, expires = 8658703, base = 0x66666666e5894855, function = 0xc802e8058b4890, 
      data = 3343472363359880137, slack = 8658703, start_pid = 0, start_site = 0x66666666e5894855, start_comm = "\220\061\300\203=\322\002\310\000\000\311\017\224\300\303f"}, 
    timer_expires = 8658703, work = {data = {counter = 7378697631616813141}, entry = {next = 0xc802b8058b4890, prev = 0xc083481374c08548}, func = 0xc802a805894801}, 
    wait_queue = {lock = {{rlock = {raw_lock = {{head_tail = 3284779057, tickets = {head = 49201, tail = 50121}}}}}}, task_list = {next = 0xc7c74800000008be, 
        prev = 0x2d0bc7e881ccd818}}, usage_count = {counter = -910151424}, child_count = {counter = 2035651}, disable_depth = 5, idle_notification = 0, request_pending = 1, 
    deferred_resume = 0, run_wake = 1, runtime_auto = 0, no_callbacks = 0, irq_safe = 0, use_autosuspend = 0, timer_autosuspends = 1, request = 1717986918, 
    runtime_status = 4289915024, runtime_error = -1958150145, autosuspend_delay = -939363531, last_busy = 8784482392044377544, active_jiffies = 3343472764446067468, 
    suspended_jiffies = 8658703, accounting_timestamp = 7373329656936220757, suspend_time = {tv64 = -8556276867908868506}, max_time_suspended_ns = 8743158374235900, 
    subsys_data = 0x1c383000817f3e8, constraints = 0x7846e800418958bf}, pm_domain = 0x5be97fdc39410020, numa_node = -1010213823, dma_mask = 0x841f0f, 
  coherent_dma_mask = 17042544940070553685, dma_parms = 0x1d8b906666666608, dma_pools = {next = 0x875db8500c801fc, prev = 0x90c3c95b08c48348}, dma_mem = 0xe881ccd3c0c7c748, 
  archdata = {acpi_handle = 0x1e20d8b004b38b4, dma_ops = 0xfc985c3894800c8, iommu = 0x81158b0000008b84}, of_node = 0x8b5175d28500c7fd, devt = 3355558661, id = 1896188160, 
  devres_lock = {{rlock = {raw_lock = {{head_tail = 251709437, tickets = {head = 51197, tail = 3840}}}}}}, devres_head = {next = 0x100c7fd60058366, prev = 0xff56e8000003e8bf}, 
  knode_class = {n_klist = 0xccd3c0c7c748ffff, n_node = {next = 0x58b004b383ae881, prev = 0x8501e88300c7fd48}, n_ref = {refcount = {counter = 1023773120}}}, 
  class = 0xc8018105c7cf, groups = 0x1f0f3deb000000, release = 0x100c7fd20058366}
(gdb) p *(struct virtio_driver *)((struct virtio_blk *)bdev->bd_disk->private_data)->vdev.dev->driver
$12 = {driver = {name = 0xffffffff81a170e8 "", bus = 0xffffffff81a53f88, owner = 0xffffffff81a21f78, 
    mod_name = 0xffffffff81a21df8 "\230\036\242\201\377\377\377\377\030\035\242\201\377\377\377\377\274", suppress_bind_attrs = 189, of_match_table = 0xffffffff81a52ea0, 
    probe = 0xffff88003dbf6880, remove = 0, shutdown = 0, suspend = 0xffffffff81a21f00, resume = 0x8 <__mod_license699+8>, groups = 0x0, pm = 0x0, p = 0x0}, id_table = 0x0, 
  feature_table = 0xffffffff817a421d, feature_table_size = 123, probe = 0xffffffff81a23400, remove = 0xffffffff81a23408, config_changed = 0xffff88003dbf6800, 
  freeze = 0xffff88003dbf6840, thaw = 0xffffffff81a21e60, restore = 0xffffffff81a21dc0}
(gdb) b virtio_check_driver_offered_feature
Breakpoint 3 at 0xffffffffa00000b9: file drivers/virtio/virtio.c, line 100.
(gdb) c
Continuing.

Breakpoint 3, virtio_check_driver_offered_feature (vdev=0xffffffff81a17060, fbit=7) at drivers/virtio/virtio.c:100
100	drivers/virtio/virtio.c: No such file or directory.
	in drivers/virtio/virtio.c
(gdb) bt
#0  virtio_check_driver_offered_feature (vdev=0xffffffff81a17060, fbit=7) at drivers/virtio/virtio.c:100
#1  0xffffffffa002561c in virtio_has_feature (bdev=0xffff880037cb9740, mode=4125, cmd=21297, data=0) at include/linux/virtio_config.h:148
#2  virtblk_ioctl (bdev=0xffff880037cb9740, mode=4125, cmd=21297, data=0) at drivers/block/virtio_blk.c:250
#3  0xffffffff81232cd8 in __blkdev_driver_ioctl (bdev=<value optimized out>, mode=<value optimized out>, cmd=<value optimized out>, arg=<value optimized out>)
    at block/ioctl.c:171
#4  0xffffffff8123306e in blkdev_ioctl (bdev=0xffff880037cb9740, mode=<value optimized out>, cmd=21297, arg=0) at block/ioctl.c:347
#5  0xffffffff811a0f5c in block_ioctl (file=<value optimized out>, cmd=<value optimized out>, arg=<value optimized out>) at fs/block_dev.c:1558
#6  0xffffffff8117dacc in vfs_ioctl (filp=0xffff880039dca6c0, fd=3, cmd=<value optimized out>, arg=<value optimized out>) at fs/ioctl.c:43
#7  do_vfs_ioctl (filp=0xffff880039dca6c0, fd=3, cmd=<value optimized out>, arg=<value optimized out>) at fs/ioctl.c:598
#8  0xffffffff8117de21 in sys_ioctl (fd=3, cmd=21297, arg=0) at fs/ioctl.c:618
#9  0xffffffff815091a9 in ?? () at arch/x86/kernel/entry_64.S:488
#10 0x0000003f566dd847 in __brk_reservation_fn_dmi_alloc__ ()
(gdb) p *(struct virtio_driver *)vdev.dev->driver
$13 = {driver = {name = 0xffffffff81a170e8 "", bus = 0xffffffff81a53f88, owner = 0xffffffff81a21f78, 
    mod_name = 0xffffffff81a21df8 "\230\036\242\201\377\377\377\377\030\035\242\201\377\377\377\377\274", suppress_bind_attrs = 189, of_match_table = 0xffffffff81a52ea0, 
    probe = 0xffff88003dbf6880, remove = 0, shutdown = 0, suspend = 0xffffffff81a21f00, resume = 0x8 <__mod_license699+8>, groups = 0x0, pm = 0x0, p = 0x0}, id_table = 0x0, 
  feature_table = 0xffffffff817a421d, feature_table_size = 123, probe = 0xffffffff81a23400, remove = 0xffffffff81a23408, config_changed = 0xffff88003dbf6800, 
  freeze = 0xffff88003dbf6840, thaw = 0xffffffff81a21e60, restore = 0xffffffff81a21dc0}
Breakpoint 1, virtblk_ioctl (bdev=0xffff880037cb9740, mode=4125, cmd=21297, data=0) at drivers/block/virtio_blk.c:250
250	drivers/block/virtio_blk.c: No such file or directory.
	in drivers/block/virtio_blk.c
(gdb) 


--------------020606090403000606010302--
