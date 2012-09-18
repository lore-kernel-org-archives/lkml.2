Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2IRSjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:39:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44549 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2IRSjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120918143504.GA30585@redhat.com>
References: <20120918143504.GA30585@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 11:38:44 -0700
X-Google-Sender-Auth: V7aiDiQP0DtOJmgPOJjYr40S0dc
Message-ID: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting the entire email, since I added Greg to the list of people (as
the documented maintainer of debugfs) along with what I think are the
guilty parties.

Dave, is trinity perhaps doing read calls on the same file in parallel?

Because it looks to me like debugfs is racy for that case. At least
the file->private_data accesses are, for the case of that "u32_array"
case.

In fact it is racy in two different ways:

 - the whole "file->private_data" access is racy (and this is, I
think, the bug you are hitting)

   If you have multiple readers on the same file, the whole

                if (file->private_data) {
                        kfree(file->private_data);
                        file->private_data = NULL;
                }

                file->private_data = format_array_alloc("%u", data->array,
                                                              data->elements);

   thing is just a disaster waiting to happen.

It should be easyish to fix by just adding a lock around those things.

The other bug is slightly subtler and probably harder to hit (but also
harder to fix):

 - the whole format_array_alloc() code is one buggy piece of sh*t,
since afaik there is nothing that guarantees that the values cannot
change. So the notion of "let's format the output once to know how big
it is, and then a second time to actually print things into the array
we just allocated based on the first time" is pure and utter garbage,
afaik.

Anyway, this is all fairly recent, and came in through the Xen tree.
See commit 9fe2a7015393 ("debugfs: Add support to print u32 array in
debugfs").

Guys?

              Linus

On Tue, Sep 18, 2012 at 7:35 AM, Dave Jones <davej@redhat.com> wrote:
> I was chasing a networking bug, and had trinity reduced to just making read & setsockopt calls,
> and let that run overnight.  I woke up to 800mb of traces from a different bug..
>
> The traces look mostly like this..
>
>
> =============================================================================
> BUG kmalloc-64 (Not tainted): Redzone overwritten
> -----------------------------------------------------------------------------
>
> INFO: 0xffff88001f4b4970-0xffff88001f4b4977. First byte 0xbb instead of 0xcc
> INFO: Allocated in u32_array_read+0xd1/0x110 age=0 cpu=6 pid=32767
>         __slab_alloc+0x516/0x5a5
>         __kmalloc+0x213/0x2c0
>         u32_array_read+0xd1/0x110
>         vfs_read+0xac/0x180
>         sys_read+0x4d/0x90
>         system_call_fastpath+0x1a/0x1f
> INFO: Freed in u32_array_read+0x99/0x110 age=0 cpu=0 pid=32749
>         __slab_free+0x3f/0x3bf
>         kfree+0x2d5/0x310
>         u32_array_read+0x99/0x110
>         vfs_read+0xac/0x180
>         sys_read+0x4d/0x90
>         system_call_fastpath+0x1a/0x1f
> INFO: Slab 0xffffea00007d2d00 objects=41 used=14 fp=0xffff88001f4b7410 flags=0x10000000004081
> INFO: Object 0xffff88001f4b4930 @offset=2352 fp=0xffff88001f4b7410
>
> Bytes b4 ffff88001f4b4920: 1b 20 1c 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  . ......ZZZZZZZZ
> Object ffff88001f4b4930: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff88001f4b4940: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff88001f4b4950: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ffff88001f4b4960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> Redzone ffff88001f4b4970: bb bb bb bb bb bb bb bb                          ........
> Padding ffff88001f4b4ab0: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> Pid: 32756, comm: trinity-child52 Not tainted 3.6.0-rc6+ #44
> Call Trace:
>  [<ffffffff811c10ad>] ? print_section+0x3d/0x40
>  [<ffffffff811c23fe>] print_trailer+0xfe/0x160
>  [<ffffffff811c2592>] check_bytes_and_report+0xe2/0x120
>  [<ffffffff81023b79>] ? native_sched_clock+0x19/0x80
>  [<ffffffff811c2b5b>] check_object+0x18b/0x250
>  [<ffffffff8169b7d7>] free_debug_processing+0xc0/0x1fd
>  [<ffffffff812d2e29>] ? u32_array_read+0x99/0x110
>  [<ffffffff8169ba5c>] __slab_free+0x3f/0x3bf
>  [<ffffffff81365a1c>] ? debug_check_no_obj_freed+0x16c/0x210
>  [<ffffffff810db04f>] ? lock_release_holdtime.part.26+0xf/0x180
>  [<ffffffff812d2e29>] ? u32_array_read+0x99/0x110
>  [<ffffffff811c5725>] kfree+0x2d5/0x310
>  [<ffffffff812d2e29>] u32_array_read+0x99/0x110
>  [<ffffffff811df88c>] vfs_read+0xac/0x180
>  [<ffffffff811df9ad>] sys_read+0x4d/0x90
>  [<ffffffff816aea2d>] system_call_fastpath+0x1a/0x1f
> FIX kmalloc-64: Restoring 0xffff88001f4b4970-0xffff88001f4b4977=0xcc
> =============================================================================
>
> Which looks like we read some file (probably something in sysfs/procfs) that corrupted some internal state.
> Any ideas on what I could do to narrow this down ?
>
> The full traces are at http://www.codemonkey.org.uk/junk/slab-corrupt.txt
> They vary a little later, but it looks like it's probably all the same problem to me.
> Sometimes it flip-flops between "First byte 0xbb instead of 0xcc" and "First byte 0xcc instead of 0xbb"
>
>
> The one outlier being this weird message..
>
> Sep 18 02:00:13 bitcrush kernel: [36617.487681] hrtimer: interrupt took 242337 ns
>
> Which is weird, but probably unrelated.
>
>         Dave
>
