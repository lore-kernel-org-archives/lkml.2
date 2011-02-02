Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1BBA0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:26:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1BBA0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:26:33 -0500
Date: Wed, 2 Feb 2011 01:26:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: =?utf-8?Q?Jind=C5=99ich_Makovi=C4=8Dka?= <makovick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: khugepaged: gets stuck when writing to USB flash, 2.6.38-rc2
Message-ID: <20110202002605.GD16981@random.random>
References: <AANLkTi=uOpN0PwWdGh6iri-vJwuMS+WMPxmaZjv0-TrV@mail.gmail.com>
 <20110201154947.GX16981@random.random>
 <AANLkTi=bqnaif=7xdLFDny86-WYJONRZB45Q=ekKMMst@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=bqnaif=7xdLFDny86-WYJONRZB45Q=ekKMMst@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:24:00PM +0100, Jindřich Makovička wrote:
> With -rc2, there is
> 
> $ ps aux | grep -E "kswap|khugep"
> root       474  0.0  0.0      0     0 ?        S    20:44   0:00 [kswapd0]
> root       540  0.0  0.0      0     0 ?        DN   20:44   0:00 [khugepaged]
> 
> Sysrq-t output is attached.

khugepaged is missing at the top because dmesg is too small to fit all
sysrq+t.

Anyway I see lots of tasks (you've some heavy java load allocating
plenty of hugepages) that allocates transparent hugepages and they're
all stuck in migrate_pages->wait_on_page_writeback and
migrate_pages->writepage.

> Good news is, I don't see these issues with -rc3.

Ah try again, I didn't check the diff between -rc2 and -rc3 to be able
to tell what helped.. but it sounds too easy that got magically fixed
by -rc3.

Anyway it's not THP, it had to be something in compaction, and if it
happens again you can be sure that doing "echo never >defrag" will fix
it (if it really is it). Ironically you can leave khugepaged/defrag
set to "always". It's ok if khugepaged stays in D state (khugepaged
will actually be not noticeable at all in D state with CONFIG_NUMA=n,
because it'd allocate all hugepages without having to hold any
mmap_sem at all, but with CONFIG_NUMA=y it tried to allocate the
hugepage from the right node and it needs to pass a vma down to the
allocator to track the right allocation node, and that requires the
mmap_sem read mode during the allocation to avoid the vma to go away,
but it's no big deal).

Maybe we need to change compaction to never block unless some
__GFP_COMPACTION_WAIT bitflag is set. It's perfectly ok to fail some
hugepage allocation if there's congestion like that without trying so
hard to allocate hugepages. The only thing that would need to pass
down a __GFP_COMPACTION_WAIT would then be fork() in the kernel stack
allocation... everything else should have a 4k fallback. Even
khugepaged doesn't need so hard to compact if the system is under huge
stress.

Usually to reproduce you need "cp /dev/zero /mnt/usbdrive", and that
tends to hang all systems no matter THP or not... it's hard to
quantify what is normal and what is not.

I've another latency issue that is much easier to quantify for some
heavy write fs-network load being reported that is most certainly
related to the use of compaction even for the jumbo frames and large
network skbs. It's still compaction related (not THP related as THP on
but with compaction only used by THP it doesn't happen). I'll let you
know when that is fixed for any patch to try as that may benefit your
workload too. In the meantime if you've have more data let me know.

Thanks,
Andrea
