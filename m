Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab1I0A7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 20:59:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1I0A7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 20:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
Date: Mon, 26 Sep 2011 17:59:34 -0700
Message-ID: <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
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

On Mon, Sep 26, 2011 at 2:02 PM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Mon, Sep 26, 2011 at 4:32 AM, David Howells <dhowells@redhat.com> wrote:
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>>> I thought I'd be extra-helpful by getting that trace with a 3.0.4
>>> kernel but got a completely different error this time (there was
>>> nothing logged above this though). There was a
>>> '__fscache_read_or_alloc_pages' crash for the previous boot too,
>>> though it went for about 2.5 hours that time (with an empty cache
>>> partition though).
>>
>> I'm fairly certain I know what the cause of this one is: Invalidation upon
>> server change isn't handled correctly.  NFS tries to invalidate a file by
>> discarding that file's attachment to the cache - without first clearing up the
>> operations it has outstanding on the cache for that file.
>>
>> I'm working on adding formal invalidation at the moment.
>>
>> The attached patch may get you more precise information.  The first hunk is the
>> main catcher.
>>
>> David
>> ---
>> diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
>> index 9905350..48c63b8 100644
>> --- a/fs/fscache/cookie.c
>> +++ b/fs/fscache/cookie.c
>> @@ -452,6 +452,13 @@ void __fscache_relinquish_cookie(struct fscache_cookie *cookie, int retire)
>>
>>                _debug("RELEASE OBJ%x", object->debug_id);
>>
>> +               if (atomic_read(&object->n_reads)) {
>> +                       spin_unlock(&cookie->lock);
>> +                       printk(KERN_ERR "FS-Cache: Cookie '%s' still has outstanding reads\n",
>> +                              cookie->def->name);
>> +                       BUG();
>> +               }
>> +
>>                /* detach each cache object from the object cookie */
>>                spin_lock(&object->lock);
>>                hlist_del_init(&object->cookie_link);
>> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
>> index b8b62f4..f087051 100644
>> --- a/fs/fscache/page.c
>> +++ b/fs/fscache/page.c
>> @@ -496,6 +496,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>>        if (fscache_submit_op(object, &op->op) < 0)
>>                goto nobufs_unlock;
>>        spin_unlock(&cookie->lock);
>> +       ASSERTCMP(object->cookie, ==, cookie);
>>
>>        fscache_stat(&fscache_n_retrieval_ops);
>>
>> @@ -513,6 +514,26 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>>                goto error;
>>
>>        /* ask the cache to honour the operation */
>> +       if (!object->cookie) {
>> +               const char prefix[] = "fs-";
>> +               printk(KERN_ERR "%sobject: OBJ%x\n",
>> +                      prefix, object->debug_id);
>> +               printk(KERN_ERR "%sobjstate=%s fl=%lx wbusy=%x ev=%lx[%lx]\n",
>> +                      prefix, fscache_object_states[object->state],
>> +                      object->flags, work_busy(&object->work),
>> +                      object->events,
>> +                      object->event_mask & FSCACHE_OBJECT_EVENTS_MASK);
>> +               printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
>> +                      prefix, object->n_ops, object->n_in_progress,
>> +                      object->n_exclusive);
>> +               printk(KERN_ERR "%sparent=%p\n",
>> +                      prefix, object->parent);
>> +               printk(KERN_ERR "%scookie=%p [pr=%p nd=%p fl=%lx]\n",
>> +                      prefix, object->cookie,
>> +                      cookie->parent, cookie->netfs_data, cookie->flags);
>> +       }
>> +       ASSERTCMP(object->cookie, ==, cookie);
>> +
>>        if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
>>                fscache_stat(&fscache_n_cop_allocate_pages);
>>                ret = object->cache->ops->allocate_pages(
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Ok, patched and running now. This same box was running 3.0.3 over the
> weekend but it died without a stacktrace (and I had set it up to not
> start cachefilesd on boot for the next boot). After I get the trace
> for 3.0.4, I'll boot back into 3.0.3 and see if I can get that
> previous trace again.
>

Ok, this just popped 15 mins ago. Here's the trace. Some went to IPMI,
some made it to the logs, so I'll post both (logs first):


[12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
[12999.564927] ------------[ cut here ]------------
[12999.574160] kernel BUG at fs/fscache/cookie.c:459!
[12999.574694] invalid opcode: 0000 [#1] SMP
[12999.574694] CPU 2
[12999.574694] Modules linked in: xfs ioatdma dca loop joydev evdev
dcdbas psmouse pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
pci_hotplug sg sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last
unloaded: scsi_wait_scan]
[12999.574694]
[12999.574694] Pid: 8589, comm: httpd Not tainted 3.0.4 #1 Dell Inc.
PowerEdge 1950/0DT097
[12999.574694] RIP: 0010:[<ffffffff811a6370>]  [<ffffffff811a6370>]
__fscache_relinquish_cookie+0x1c0/0x3b0
[12999.574694] RSP: 0018:ffff8800c64b1cd8  EFLAGS: 00010296
[12999.574694] RAX: 000000000000004b RBX: ffff8801b1eea780 RCX: ffffffff81cfd080
[12999.574694] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81cfcf70
[12999.574694] RBP: ffff8800c64b1d18 R08: 0000000000000006 R09: 0000000000000000
[12999.574694] R10: 0000000000000003 R11: 00000000ffffffff R12: ffff8800c962eb40
[12999.574694] R13: ffff8801b1eea7d8 R14: ffff880224d73800 R15: ffff8800c962eb48
[12999.574694] FS:  0000036e5df836e0(0000) GS:ffff88022fc80000(0000)
knlGS:0000000000000000
[12999.574694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12999.574694] CR2: ffffffffff600400 CR3: 000000000167f000 CR4: 00000000000006f0
[12999.574694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12999.574694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400


>From console via IPMI:

[12999.564927] ------------[ cut here ]------------
[12999.574160] kernel BUG at fs/fscache/cookie.c:459!
[12999.574694] invalid opcode: 0000 [#1] SMP
[12999.574694] CPU 2
[12999.574694] Modules linked in: xfs ioatdma dca loop joydev evdev
dcdbas psmouse pcspkr serio_raw i5000_edac edac_core i5k_amb shpchp
pci_hotplug sg sr
_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last unloaded: scsi_wait_scan]
[12999.574694]
[12999.574694] Pid: 8589, comm: httpd Not tainted 3.0.4 #1 Dell Inc.
PowerEdge 1950/0DT097
[12999.574694] RIP: 0010:[<ffffffff811a6370>]  [<ffffffff811a6370>]
__fscache_relinquish_cookie+0x1c0/0x3b0
[12999.574694] RSP: 0018:ffff8800c64b1cd8  EFLAGS: 00010296
[12999.574694] RAX: 000000000000004b RBX: ffff8801b1eea780 RCX: ffffffff81cfd080
[12999.574694] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81cfcf70
[12999.574694] RBP: ffff8800c64b1d18 R08: 0000000000000006 R09: 0000000000000000
[12999.574694] R10: 0000000000000003 R11: 00000000ffffffff R12: ffff8800c962eb40
[12999.574694] R13: ffff8801b1eea7d8 R14: ffff880224d73800 R15: ffff8800c962eb48
[12999.574694] FS:  0000036e5df836e0(0000) GS:ffff88022fc80000(0000)
knlGS:0000000000000000
[12999.574694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12999.574694] CR2: ffffffffff600400 CR3: 000000000167f000 CR4: 00000000000006f0
[12999.574694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12999.574694] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12999.574694] Process httpd (pid: 8589, threadinfo ffff880208ff8500,
task ffff880208ff8000)
[12999.574694] Stack:
[12999.574694]  ffffffff81073dd0 00000005c64b1ce0 ffff880208ff8428
ffff88019328ad98
[12999.574694]  ffff88019328aed0 ffff88019328ad08 ffff880224d73800
ffff880037a9d500
[12999.574694]  ffff8800c64b1d58 ffffffff8125a355 ffff88019328b018
ffff88019328aed0
[12999.574694] Call Trace:
[12999.574694]  [<ffffffff81073dd0>] ? autoremove_wake_function+0x40/0x40
[12999.574694]  [<ffffffff8125a355>] nfs_fscache_reset_inode_cookie+0x85/0x100
[12999.574694]  [<ffffffff81230316>] nfs_revalidate_mapping+0xb6/0x130
[12999.574694]  [<ffffffff8122e026>] nfs_file_read+0x86/0x130
[12999.574694]  [<ffffffff8112d4c9>] do_sync_read+0xd9/0x120
[12999.574694]  [<ffffffff810ea629>] ? __filemap_fdatawrite_range+0x59/0x70
[12999.574694]  [<ffffffff8113206b>] ? cp_new_stat+0x16b/0x190
[12999.574694]  [<ffffffff8112e335>] vfs_read+0xf5/0x210
[12999.574694]  [<ffffffff8112e545>] sys_read+0x55/0x90
[12999.574694]  [<ffffffff81651074>] system_call_fastpath+0x16/0x1b
[12999.574694] Code: 7c 6b 4a 00 48 83 c4 18 5b 41 5c 41 5d 41 5e 41
5f c9 c3 41 fe 44 24 08 48 c7 c7 88 27 8d 81 49 8b 74 24 18 31 c0 e8
55 6b 4a 00 <0f> 0b eb fe 41 8b 55 ac 48 8b 75 d0 48 c7 c7 93 a9 8c 81
31 c0
[12999.574694] RIP  [<ffffffff811a6370>] __fscache_relinquish_cookie+0x1c0/0x3b0
[12999.574694]  RSP <ffff8800c64b1cd8>
[12999.564927] [13000.116916] ---[ end trace 67856f08df77c469 ]---


I'll grab 3.0.3 tomorrow.
