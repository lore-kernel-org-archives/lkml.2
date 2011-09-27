Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab1I0XqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:46:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61808 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1I0XqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
Date: Tue, 27 Sep 2011 16:46:16 -0700
Message-ID: <CAOH1cHnDztXZOse+aXBLHuroVJK6p8MLifv65BaAmbq7JjnXfg@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 5:59 PM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Mon, Sep 26, 2011 at 2:02 PM, Mark Moseley <moseleymark@gmail.com> wrote:
>> On Mon, Sep 26, 2011 at 4:32 AM, David Howells <dhowells@redhat.com> wrote:
>>> Mark Moseley <moseleymark@gmail.com> wrote:
>>>
>>>> I thought I'd be extra-helpful by getting that trace with a 3.0.4
>>>> kernel but got a completely different error this time (there was
>>>> nothing logged above this though). There was a
>>>> '__fscache_read_or_alloc_pages' crash for the previous boot too,
>>>> though it went for about 2.5 hours that time (with an empty cache
>>>> partition though).
>>>
>>> I'm fairly certain I know what the cause of this one is: Invalidation upon
>>> server change isn't handled correctly.  NFS tries to invalidate a file by
>>> discarding that file's attachment to the cache - without first clearing up the
>>> operations it has outstanding on the cache for that file.
>>>
>>> I'm working on adding formal invalidation at the moment.
>>>
>>> The attached patch may get you more precise information.  The first hunk is the
>>> main catcher.
>>>
>>> David
>>> ---
>>> diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
>>> index 9905350..48c63b8 100644
>>> --- a/fs/fscache/cookie.c
>>> +++ b/fs/fscache/cookie.c
>>> @@ -452,6 +452,13 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
>>>
>>>                _debug("RELEASE OBJ%x", object->debug_id);
>>>
>>> +               if (atomic_read(&object->n_reads)) {
>>> +                       spin_unlock(&cookie->lock);
>>> +                       printk(KERN_ERR "FS-Cache: Cookie '%s' still has outstanding reads\n",
>>> +                              cookie->def->name);
>>> +                       BUG();
>>> +               }
>>> +
>>>                /* detach each cache object from the object cookie */
>>>                spin_lock(&object->lock);
>>>                hlist_del_init(&object->cookie_link);
>>> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
>>> index b8b62f4..f087051 100644
>>> --- a/fs/fscache/page.c
>>> +++ b/fs/fscache/page.c
>>> @@ -496,6 +496,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>>>        if (fscache_submit_op(object, &op->op) < 0)
>>>                goto nobufs_unlock;
>>>        spin_unlock(&cookie->lock);
>>> +       ASSERTCMP(object->cookie, ==, cookie);
>>>
>>>        fscache_stat(&fscache_n_retrieval_ops);
>>>
>>> @@ -513,6 +514,26 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>>>                goto error;
>>>
>>>        /* ask the cache to honour the operation */
>>> +       if (!object->cookie) {
>>> +               const char prefix[] = "fs-";
>>> +               printk(KERN_ERR "%sobject: OBJ%x\n",
>>> +                      prefix, object->debug_id);
>>> +               printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
>>> +                      prefix, fscache_object_states[object->state],
>>> +                      object->flags, work_busy(&object->work),
>>> +                      object->events,
>>> +                      object->event_mask & FSCACHE_OBJECT_EVENTS_MASK);
>>> +               printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
>>> +                      prefix, object->n_ops, object->n_in_progress,
>>> +                      object->n_exclusive);
>>> +               printk(KERN_ERR "%sparent=%p\n",
>>> +                      prefix, object->parent);
>>> +               printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
>>> +                      prefix, object->cookie,
>>> +                      cookie->parent, cookie->netfs_data, cookie->flags);
>>> +       }
>>> +       ASSERTCMP(object->cookie, ==, cookie);
>>> +
>>>        if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
>>>                fscache_stat(&fscache_n_cop_allocate_pages);
>>>                ret = object->cache->ops->allocate_pages(
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>> Ok, patched and running now. This same box was running 3.0.3 over the
>> weekend but it died without a stacktrace (and I had set it up to not
>> start cachefilesd on boot for the next boot). After I get the trace
>> for 3.0.4, I'll boot back into 3.0.3 and see if I can get that
>> previous trace again.
>>
>
> Ok, this just popped 15 mins ago. Here's the trace. Some went to IPMI,
> some made it to the logs, so I'll post both (logs first):
>
>
> [12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
> [12999.564927] ------------[ cut here ]------------
> [12999.574160] kernel BUG at fs/fscache/cookie.c:459!
> [12999.574694] invalid opcode: 0000 [#1] SMP
> [12999.574694] CPU 2
> [12999.574694] Modules linked in: xfs ioatdma dca loop joydev evdev
> dcdbas psmouse pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
> pci_hotplug sg sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last
> unloaded: scsi_wait_scan]
> [12999.574694]
> [12999.574694] Pid: 8589, comm: httpd Not tainted 3.0.4 #1 Dell Inc.
> PowerEdge 1950/0DT097
> [12999.574694] RIP: 0010:[<ffffffff811a6370>]  [<ffffffff811a6370>]
> __fscache_relinquish_cookie+0x1c0/0x3b0
> [12999.574694] RSP: 0018:ffff8800c64b1cd8  EFLAGS: 00010296
> [12999.574694] RAX: 000000000000004b RBX: ffff8801b1eea780 RCX: ffffffff81cfd080
> [12999.574694] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81cfcf70
> [12999.574694] RBP: ffff8800c64b1d18 R08: 0000000000000006 R09: 0000000000000000
> [12999.574694] R10: 0000000000000003 R11: 00000000ffffffff R12: ffff8800c962eb40
> [12999.574694] R13: ffff8801b1eea7d8 R14: ffff880224d73800 R15: ffff8800c962eb48
> [12999.574694] FS:  0000036e5df836e0(0000) GS:ffff88022fc80000(0000)
> knlGS:0000000000000000
> [12999.574694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12999.574694] CR2: ffffffffff600400 CR3: 000000000167f000 CR4: 00000000000006f0
> [12999.574694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [12999.574694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>
>
> From console via IPMI:
>
> [12999.564927] ------------[ cut here ]------------
> [12999.574160] kernel BUG at fs/fscache/cookie.c:459!
> [12999.574694] invalid opcode: 0000 [#1] SMP
> [12999.574694] CPU 2
> [12999.574694] Modules linked in: xfs ioatdma dca loop joydev evdev
> dcdbas psmouse pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
> pci_hotplug sg sr
> _mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last unloaded: scsi_wait_scan]
> [12999.574694]
> [12999.574694] Pid: 8589, comm: httpd Not tainted 3.0.4 #1 Dell Inc.
> PowerEdge 1950/0DT097
> [12999.574694] RIP: 0010:[<ffffffff811a6370>]  [<ffffffff811a6370>]
> __fscache_relinquish_cookie+0x1c0/0x3b0
> [12999.574694] RSP: 0018:ffff8800c64b1cd8  EFLAGS: 00010296
> [12999.574694] RAX: 000000000000004b RBX: ffff8801b1eea780 RCX: ffffffff81cfd080
> [12999.574694] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81cfcf70
> [12999.574694] RBP: ffff8800c64b1d18 R08: 0000000000000006 R09: 0000000000000000
> [12999.574694] R10: 0000000000000003 R11: 00000000ffffffff R12: ffff8800c962eb40
> [12999.574694] R13: ffff8801b1eea7d8 R14: ffff880224d73800 R15: ffff8800c962eb48
> [12999.574694] FS:  0000036e5df836e0(0000) GS:ffff88022fc80000(0000)
> knlGS:0000000000000000
> [12999.574694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12999.574694] CR2: ffffffffff600400 CR3: 000000000167f000 CR4: 00000000000006f0
> [12999.574694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [12999.574694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [12999.574694] Process httpd (pid: 8589, threadinfo ffff880208ff8500,
> task ffff880208ff8000)
> [12999.574694] Stack:
> [12999.574694]  ffffffff81073dd0 00000005c64b1ce0 ffff880208ff8428
> ffff88019328ad98
> [12999.574694]  ffff88019328aed0 ffff88019328ad08 ffff880224d73800
> ffff880037a9d500
> [12999.574694]  ffff8800c64b1d58 ffffffff8125a355 ffff88019328b018
> ffff88019328aed0
> [12999.574694] Call Trace:
> [12999.574694]  [<ffffffff81073dd0>] ? autoremove_wake_function+0x40/0x40
> [12999.574694]  [<ffffffff8125a355>] nfs_fscache_reset_inode_cookie+0x85/0x100
> [12999.574694]  [<ffffffff81230316>] nfs_revalidate_mapping+0xb6/0x130
> [12999.574694]  [<ffffffff8122e026>] nfs_file_read+0x86/0x130
> [12999.574694]  [<ffffffff8112d4c9>] do_sync_read+0xd9/0x120
> [12999.574694]  [<ffffffff810ea629>] ? __filemap_fdatawrite_range+0x59/0x70
> [12999.574694]  [<ffffffff8113206b>] ? cp_new_stat+0x16b/0x190
> [12999.574694]  [<ffffffff8112e335>] vfs_read+0xf5/0x210
> [12999.574694]  [<ffffffff8112e545>] sys_read+0x55/0x90
> [12999.574694]  [<ffffffff81651074>] system_call_fastpath+0x16/0x1b
> [12999.574694] Code: 7c 6b 4a 00 48 83 c4 18 5b 41 5c 41 5d 41 5e 41
> 5f c9 c3 41 fe 44 24 08 48 c7 c7 88 27 8d 81 49 8b 74 24 18 31 c0 e8
> 55 6b 4a 00 <0f> 0b eb fe 41 8b 55 ac 48 8b 75 d0 48 c7 c7 93 a9 8c 81
> 31 c0
> [12999.574694] RIP  [<ffffffff811a6370>] __fscache_relinquish_cookie+0x1c0/0x3b0
> [12999.574694]  RSP <ffff8800c64b1cd8>
> [12999.564927] [13000.116916] ---[ end trace 67856f08df77c469 ]---
>
>
> I'll grab 3.0.3 tomorrow.
>

Hmm, my 3.0.3 popped but I didn't get the " fs/cachefiles/namei.c"
error from the beginning of the thread. Looks like the same location
as for 3.0.4. Figured I'd post it anyway, in case it's helpful. I'll
clear the fscache cache and let it run on 3.0.3 again.


[ 5460.793832] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000040
[ 5460.803806] IP: [<ffffffff8119e302>]
__fscache_read_or_alloc_pages+0x142/0x370
[ 5460.803806] PGD 104d81067 PUD 22400b067 PMD 0
[ 5460.803806] Oops: 0000 [#1] SMP
[ 5460.803806] CPU 7
[ 5460.803806] Modules linked in: xfs ioatdma dca loop joydev fan
evdev psmouse i5000_edac edac_core dcdbas i5k_amb serio_raw pcspkr
shpchp pci_hotplug ]
[ 5460.803806]
[ 5460.803806] Pid: 18863, comm: httpd Not tainted 3.0.3 #1 Dell Inc.
PowerEdge 1950/0DT097
[ 5460.803806] RIP: 0010:[<ffffffff8119e302>]  [<ffffffff8119e302>]
__fscache_read_or_alloc_pages+0x142/0x370
[ 5460.803806] RSP: 0018:ffff88008fb9fa28  EFLAGS: 00010246
[ 5460.803806] RAX: 0000000000000000 RBX: ffff8800926ee230 RCX: ffff88008fb9e000
[ 5460.803806] RDX: 0000000000000000 RSI: ffff88008fb9f988 RDI: ffff88022ffd2ba0
[ 5460.803806] RBP: ffff88008fb9fa68 R08: ffff88008fb9e000 R09: 0000000000000000
[ 5460.803806] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[ 5460.803806] R13: ffff8800c9a72300 R14: ffff88008fb9fbf8 R15: ffff88008fb9fad4
[ 5460.803806] FS:  00007f0ef221c6e0(0000) GS:ffff88022fdc0000(0000)
knlGS:0000000000000000
[ 5460.803806] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5460.803806] CR2: 0000000000000040 CR3: 0000000208240000 CR4: 00000000000006e0
[ 5460.803806] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5460.803806] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5460.803806] Process httpd (pid: 18863, threadinfo ffff88008fb9e000,
task ffff88004c4c5bc0)
[ 5460.803806] Stack:
[ 5460.803806]  ffff8800c6e22c00 ffffffff8124af80 ffff8801015bd600
00000000ffffff97
[ 5460.803806]  ffff88008fb9fad4 0000000000000001 ffff8800acd2ec38
ffff8800acd2ed80
[ 5460.803806]  ffff88008fb9fab8 ffffffff8124ae30 ffffffff000200da
ffff880200000002
[ 5460.803806] Call Trace:
[ 5460.803806]  [<ffffffff8124af80>] ? __nfs_readpages_from_fscache+0x1c0/0x1c0
[ 5460.803806]  [<ffffffff8124ae30>] __nfs_readpages_from_fscache+0x70/0x1c0
[ 5460.803806]  [<ffffffff8122bdf6>] nfs_readpages+0xd6/0x200
[ 5460.803806]  [<ffffffff815e91b6>] ? rpc_do_put_task+0x36/0x50
[ 5460.803806]  [<ffffffff810ec59a>] __do_page_cache_readahead+0x1da/0x280
[ 5460.803806]  [<ffffffff810ec661>] ra_submit+0x21/0x30
[ 5460.803806]  [<ffffffff810ec88d>] ondemand_readahead+0x11d/0x250
[ 5460.803806]  [<ffffffff810ecab6>] page_cache_sync_readahead+0x36/0x60
[ 5460.803806]  [<ffffffff810e485c>] generic_file_aio_read+0x45c/0x770
[ 5460.803806]  [<ffffffff8121f8c1>] nfs_file_read+0xe1/0x130
[ 5460.803806]  [<ffffffff8103bcef>] ? set_next_entity+0xaf/0xd0
[ 5460.803806]  [<ffffffff81127ec9>] do_sync_read+0xd9/0x120
[ 5460.803806]  [<ffffffff81128c28>] vfs_read+0xc8/0x180
[ 5461.296269]  [<ffffffff81128de5>] sys_read+0x55/0x90
[ 5461.296269]  [<ffffffff8162f06b>] system_call_fastpath+0x16/0x1b
[ 5461.296269] Code: 48 8b 7a 28 ff d0 48 c7 c1 64 55 e5 81 48 c7 c2
6c 55 e5 81 48 8b 75 d0 4c 89 ef e8 d9 fa ff ff 41 89 c4 85 c0 78 3b
49 8b 45 70
[ 5461.296269]  8b 40 40 a8 04 0f 84 32 01 00 00 f0 ff 05 3f 73 cb 00 49 8b
[ 5461.296269] RIP  [<ffffffff8119e302>]
__fscache_read_or_alloc_pages+0x142/0x370
[ 5461.296269]  RSP <ffff88008fb9fa28>
[ 5461.296269] CR2: 0000000000000040
[ 5461.284631] BUG: unable to handle kernel
[ 5461.403124] ---[ end trace 755467f1fed5f5eb ]---

[ 5461.403130] Kernel panic - not syncing: Fatal exception
[ 5461.403136] Pid: 18863, comm: httpd Tainted: G      D     3.0.3 #1
[ 5461.403138] Call Trace:
[ 5461.403150]  [<ffffffff8162402e>] panic+0xbf/0x1e5
[ 5461.403157]  [<ffffffff8104cb3f>] ? kmsg_dump+0x4f/0xa0f>]
page_fault+0x1f/0x30
[ 5461.403203]  [<ffffffff8119e302>] ? __fscache_read_or_alloc_pages+0x142/0x370
[ 5461.403207]  [<ffffffff8119e2f7>] ? __fscache_read_or_alloc_pages+0x137/0x370
[ 5461.403212]  [<ffffffff8124af80>] ? __nfs_readpages_from_fscache+0x1c0/0x1c0
[ 5461.403216]  [<ffffffff8124ae30>] __nfs_readpages_from_fscache+0x70/0x1c0
[ 5461.403221]  [<ffffffff8122bdf6>] nfs_readpages+0xd6/0x200
[ 5461.403227]  [<ffffffff815e91b6>] ? rpc_do_put_task+0x36/0x50
[ 5461.403233]  [<ffffffff810ec59a>] __do_page_cache_readahead+0x1da/0x280
[ 5461.403238]  [<ffffffff810ec661>] ra_submit+0x21/0x30
[ 5461.403242]  [<ffffffff810ec88d>] ondemand_readahead+0x11d/0x250
[ 5461.403246]  [<ffffffff810ecab6>] page_cache_sync_readahead+0x36/0x60
[ 5461.403250]  [<ffffffff810e485c>] generic_file_aio_read+0x45c/0x770
[ 5461.403256]  [<ffffffff8121f8c1>] nfs_file_read+0xe1/0x130
[ 5461.403262]  [<ffffffff8103bcef>] ? set_next_entity+0xaf/0xd0
[ 5461.403268]  [<ffffffff81127ec9>] do_sync_read+0xd9/0x120
[ 5461.403272]  [<ffffffff81128c28>] vfs_read+0xc8/0x180
[ 5461.403275]  [<ffffffff81128de5>] sys_read+0x55/0x90
[ 5461.403279]  [<ffffffff8162f06b>] system_call_fastpath+0x16/0x1b
[ 5461.399263] NULL pointer dereference at 0000000000000040
[ 5461.399263] IP: [<ffffffff8119e302>]
__fscache_read_or_alloc_pages+0x142/0x370
[ 5461.399263] PGD 8fbb4067 PUD 1982e067 PMD 0
[ 5461.399263] Oops: 0000 [#2] SMP
[ 5461.399263] CPU 1
[ 5461.399263] Modules linked in: xfs ioatdma dca loop joydev fan
evdev psmouse i5000_edac edac_core dcdbas i5k_amb serio_raw pcspkr
shpchp pci_hotplug ]
[ 5461.399263]
[ 5461.399263] Pid: 18970, comm: httpd Tainted: G      D     3.0.3 #1
Dell Inc. PowerEdge 1950/0DT097
[ 5461.399263] RIP: 0010:[<ffffffff8119e302>]  [<ffffffff8119e302>]
__fscache_read_or_alloc_pages+0x142/0x370
[ 5461.399263] RSP: 0018:ffff88000eec5a28  EFLAGS: 00010246
[ 5461.399263] RAX: 0000000000000000 RBX: ffff8800926ee230 RCX: ffff88000eec4000
[ 5461.399263] RDX: 0000000000000000 RSI: ffff88000eec5988 RDI: ffff88022ffd2b70
[ 5461.399263] RBP: ffff88000eec5a68 R08: ffff88000eec4000 R09: 0000000000000000
[ 5461.399263] R10: 0000000000000400 R11: 0000000000000001 R12: 0000000000000000
[ 5461.399263] R13: ffff8800c9a72300 R14: ffff88000eec5bf8 R15: ffff88000eec5ad4
[ 5461.399263] FS:  00007f0ef221c6e0(0000) GS:ffff88022fc40000(0000)
knlGS:0000000000000000
[ 5461.399263] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5461.399263] CR2: 0000000000000040 CR3: 000000007d37d000 CR4: 00000000000006e0
[ 5461.399263] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5461.399263] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5461.399263] Process httpd (pid: 18970, threadinfo ffff88000eec4000,
task ffff88006fed44d0)
[ 5461.399263] Stack:
[ 5461.399263]  ffff880014d5cd00 ffffffff812

Cuts off at this point.
