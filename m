Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0DWHxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 03:53:47 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64579 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab0DWHxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ewfULwz6onh7IW0mne59lhhollXIezz2PgBh2ggFW6MzXAF1gA/lLJ0KRdwyrdDUMR
         Lw8tPdfuwuq1Y10+Akjnv53rEWvZiR/7yVp5hxhNCq8OVr1uZ+AjeXaX6sm/VD4G5lRy
         j+afMRfNPMB030lrcK8yjlertaSsGMy0YnTGE=
MIME-Version: 1.0
In-Reply-To: <20100423161713.3a9e79c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	 <m2l28c262361004222211j602f224bv60ffd381f524e78a@mail.gmail.com>
	 <20100423142738.d0114946.kamezawa.hiroyu@jp.fujitsu.com>
	 <z2x28c262361004230000ubce8c5b0t759dceeee7b4ec19@mail.gmail.com>
	 <20100423161713.3a9e79c5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 23 Apr 2010 16:53:44 +0900
Message-ID: <s2q28c262361004230053g801a9b86u7f9151829164e66d@mail.gmail.com>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 4:17 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 23 Apr 2010 16:00:31 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Fri, Apr 23, 2010 at 2:27 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Fri, 23 Apr 2010 14:11:37 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> >> On Fri, Apr 23, 2010 at 12:01 PM, KAMEZAWA Hiroyuki
>> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >> >
>> >> > This patch itself is for -mm ..but may need to go -stable tree for memory
>> >> > hotplug. (but we've got no report to hit this race...)
>> >> >
>> >> > This one is the simplest, I think and works well on my test set.
>> >> > ==
>> >> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >> >
>> >> > In rmap.c, at checking rmap in vma chain in page->mapping, anon_vma->lock
>> >> > or mapping->i_mmap_lock is held and enter following loop.
>> >> >
>> >> >        for_each_vma_in_this_rmap_link(list from page->mapping) {
>> >> >                unsigned long address = vma_address(page, vma);
>> >> >                if (address == -EFAULT)
>> >> >                        continue;
>> >> >                ....
>> >> >        }
>> >> >
>> >> > vma_address is checking [start, end, pgoff] v.s. page->index.
>> >> >
>> >> > But vma's [start, end, pgoff] is updated without locks. vma_address()
>> >> > can hit a race and may return wrong result.
>> >> >
>> >> > This bahavior is no problem in usual routine as try_to_unmap() etc...
>> >> > But for page migration, rmap_walk() has to find all migration_ptes
>> >> > which migration code overwritten valid ptes. This race is critical and cause
>> >> > BUG that a migration_pte is sometimes not removed.
>> >> >
>> >> > pr 21 17:27:47 localhost kernel: ------------[ cut here ]------------
>> >> > Apr 21 17:27:47 localhost kernel: kernel BUG at include/linux/swapops.h:105!
>> >> > Apr 21 17:27:47 localhost kernel: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>> >> > Apr 21 17:27:47 localhost kernel: last sysfs file: /sys/devices/virtual/net/br0/statistics/collisions
>> >> > Apr 21 17:27:47 localhost kernel: CPU 3
>> >> > Apr 21 17:27:47 localhost kernel: Modules linked in: fuse sit tunnel4 ipt_MASQUERADE iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput ioatdma ppdev parport_pc i5000_edac bnx2 iTCO_wdt edac_core iTCO_vendor_support shpchp parport e1000e kvm_intel dca kvm i2c_i801 i2c_core i5k_amb pcspkr megaraid_sas [last unloaded: microcode]
>> >> > Apr 21 17:27:47 localhost kernel:
>> >> > Apr 21 17:27:47 localhost kernel: Pid: 27892, comm: cc1 Tainted: G        W   2.6.34-rc4-mm1+ #4 D2519/PRIMERGY
>> >> > Apr 21 17:27:47 localhost kernel: RIP: 0010:[<ffffffff8114e9cf>]  [<ffffffff8114e9cf>] migration_entry_wait+0x16f/0x180
>> >> > Apr 21 17:27:47 localhost kernel: RSP: 0000:ffff88008d9efe08  EFLAGS: 00010246
>> >> > Apr 21 17:27:47 localhost kernel: RAX: ffffea0000000000 RBX: ffffea0000241100 RCX: 0000000000000001
>> >> > Apr 21 17:27:47 localhost kernel: RDX: 000000000000a4e0 RSI: ffff880621a4ab00 RDI: 000000000149c03e
>> >> > Apr 21 17:27:47 localhost kernel: RBP: ffff88008d9efe38 R08: 0000000000000000 R09: 0000000000000000
>> >> > Apr 21 17:27:47 localhost kernel: R10: 0000000000000000 R11: 0000000000000001 R12: ffff880621a4aae8
>> >> > Apr 21 17:27:47 localhost kernel: R13: 00000000bf811000 R14: 000000000149c03e R15: 0000000000000000
>> >> > Apr 21 17:27:47 localhost kernel: FS:  00007fe6abc90700(0000) GS:ffff880005a00000(0000) knlGS:0000000000000000
>> >> > Apr 21 17:27:47 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >> > Apr 21 17:27:47 localhost kernel: CR2: 00007fe6a37279a0 CR3: 000000008d942000 CR4: 00000000000006e0
>> >> > Apr 21 17:27:47 localhost kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> >> > Apr 21 17:27:47 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> >> > Apr 21 17:27:47 localhost kernel: Process cc1 (pid: 27892, threadinfo ffff88008d9ee000, task ffff8800b23ec820)
>> >> > Apr 21 17:27:47 localhost kernel: Stack:
>> >> > Apr 21 17:27:47 localhost kernel: ffffea000101aee8 ffff880621a4aae8 ffff88008d9efe38 00007fe6a37279a0
>> >> > Apr 21 17:27:47 localhost kernel: <0> ffff8805d9706d90 ffff880621a4aa00 ffff88008d9efef8 ffffffff81126d05
>> >> > Apr 21 17:27:47 localhost kernel: <0> ffff88008d9efec8 0000000000000246 0000000000000000 ffffffff81586533
>> >> > Apr 21 17:27:47 localhost kernel: Call Trace:
>> >> > Apr 21 17:27:47 localhost kernel: [<ffffffff81126d05>] handle_mm_fault+0x995/0x9b0
>> >> > Apr 21 17:27:47 localhost kernel: [<ffffffff81586533>] ? do_page_fault+0x103/0x330
>> >> > Apr 21 17:27:47 localhost kernel: [<ffffffff8104bf40>] ? finish_task_switch+0x0/0xf0
>> >> > Apr 21 17:27:47 localhost kernel: [<ffffffff8158659e>] do_page_fault+0x16e/0x330
>> >> > Apr 21 17:27:47 localhost kernel: [<ffffffff81582f35>] page_fault+0x25/0x30
>> >> > Apr 21 17:27:47 localhost kernel: Code: 53 08 85 c9 0f 84 32 ff ff ff 8d 41 01 89 4d d8 89 45 d4 8b 75 d4 8b 45 d8 f0 0f b1 32 89 45 dc 8b 45 dc 39 c8 74 aa 89 c1 eb d7 <0f> 0b eb fe 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5
>> >> > Apr 21 17:27:47 localhost kernel: RIP  [<ffffffff8114e9cf>] migration_entry_wait+0x16f/0x180
>> >> > Apr 21 17:27:47 localhost kernel: RSP <ffff88008d9efe08>
>> >> > Apr 21 17:27:47 localhost kernel: ---[ end trace 4860ab585c1fcddb ]---
>> >> >
>> >> >
>> >> >
>> >> > This patch adds vma_address_safe(). And update [start, end, pgoff]
>> >> > under seq counter.
>> >> >
>> >> > Cc: Mel Gorman <mel@csn.ul.ie>
>> >> > Cc: Minchan Kim <minchan.kim@gmail.com>
>> >> > Cc: Christoph Lameter <cl@linux-foundation.org>
>> >> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >>
>> >> That's exactly same what I have in mind. :)
>> >> But I am hesitating. That's because AFAIR, we try to remove seqlock. Right?
>> >
>> > Ah,..."don't use seqlock" is trend ?
>> >
>> >> But in this case, seqlock is good, I think. :)
>> >>
>> > BTW, this isn't seqlock but seq_counter :)
>> >
>> > I'm still testing. What I doubt other than vma_address() is fork().
>> > at fork(), followings _may_ happen. (but I'm not sure).
>> >
>> >        chain vma.
>> >        copy page table.
>> >           -> migration entry is copied, too.
>> >
>> > At remap,
>> >        for each vma
>> >            look into page table and replace.
>> >
>> > Then,
>> >                                                rmap_walk().
>> >        fork(parent, child)
>> >                                                look into child's page table.
>> >                                                => we fond nothing.
>> >        spin_lock(child's pagetable);
>> >        spin_lock(parant's page table);
>> >        copy migration entry
>> >        spin_unlock(paranet's page table)
>> >        spin_unlock(child's page table)
>> >                                                update parent's paga table
>> >
>> > If we always find parant's page table before child's , there is no race.
>> > But I can't get prit_tree's list order as clear image. Hmm.
>> >
>> > Thanks,
>> > -Kame
>> >
>>
>> That's good point, Kame.
>> I looked into prio_tree quickly.
>> If I understand it right, list order is backward.
>>
>> dup_mmap calls vma_prio_tree_add.
>>
>>  * prio_tree_root
>>  *      |
>>  *      A       vm_set.head
>>  *     / \      /
>>  *    L   R -> H-I-J-K-M-N-O-P-Q-S
>>  *    ^   ^    <-- vm_set.list -->
>>  *  tree nodes
>>  *
>>
>> Maybe, parent and childs's vma are H~S.
>> Then, comment said.
>>
>> "vma->shared.vm_set.parent != NULL    ==> a tree node"
>> So vma_prio_tree_add call not list_add_tail but list_add.
>>
> Ah, thank you for explanation.
>
>> Anyway, I think order isn't mixed.
>> So, could we traverse it by backward in rmap?
>>
> Doesn't it make prio-tree code dirty ?
>
> Here is another idea....but ..hmm. Does this make fork() slow in some cases ?

Yes. I think this idea is good to me. :)
Great, Kame.

But as you said, migration is rare.
so we wouldn't lost much performance in many case.

Actually, If I understand prio_tree right, I think backward walking of
prio_tree is nod bad.
I don't think it make code dirty. :)
I admit it's different per people.

I like both ideas.
I passes decision to others.  :)

-- 
Kind regards,
Minchan Kim
