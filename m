Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1BIBFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 20:05:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1BIBFi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:05:38 -0500
MIME-Version: 1.0
Message-ID: <1ddd01a8-591a-42bc-8bb3-561843b31acb@default>
Date: Tue, 8 Feb 2011 17:03:24 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        sfr@canb.auug.org.au, wfg@mail.ustc.edu.cn, tytso@mit.edu,
        viro@ZenIV.linux.org.uk, hughd@google.com, hannes@cmpxchg.org,
        Matt <jackdachef@gmail.com>
Subject: RE: [PATCH V2 0/3] drivers/staging: zcache: dynamic page cache/swap
 compression
References: <20110207032407.GA27404@ca-server1.us.oracle.com>
In-Reply-To: <20110207032407.GA27404@ca-server1.us.oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D51E7FC.0109:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (Historical note: This "new" zcache patchset supercedes both the
> kztmem patchset and the "old" zcache patchset as described in:
> http://lkml.org/lkml/2011/2/5/148)

(In order to move discussion from the old kztmem patchset to
the new zcache patchset, I am replying here to Matt's email
sent at: https://lkml.org/lkml/2011/2/4/199 )

> From: Matt [mailto:jackdachef@gmail.com]

Hi Matt --

Thanks for all the thoughtful work and questions!  Sorry it
took me a few days to reply...

> This finally makes Cleancache's functionality usable for desktop and
> other small device (non-enterprise) users (especially regarding
> frontswap) :)

> 2) feedback
> 
> WARNING: at kernel/softirq.c:159 local_bh_enable+0xba/0x110()

These should be gone in V2.

> I also observed that it takes some time until volumes (which use
> kztmem's ephemeral nodes) are unmounted - probably due to emptying
> slub/slab taking longer - so this should be normal.

If "some time" becomes a problem, I have a design in my
head how to fix this.  But I'll consider it lower priority
for now.

> 2.2) a user (32bit box) who's running a pretty similar kernel to mine
> (details later) has had some assert_spinlocks thrown while

The specific sequence of asserts indicates a race, but I think
a harmless one.  I haven't been able to reproduce it and stared
at various race possibilities for a couple of hours without
luck. (Aha! There it is!  Oops, no that's not it.  Repeat.)
Hopefully getting broader exposure to more experienced
kernel developers will help find/fix this one.

> 2.3) rsync-operations seemed to speed up quite noticably to say the
> least (significantly)
>  :
> so job (2) could be cut by 1-2 minutes. Unmounting the drive/partition
>  :
> So kztmem also seems to help where low latency needs to be met, e.g.
> pro-audio.
>  :
> So productivity is improved quite a lot.

Thanks for running some performance tests on a broader set of
test cases!  The numbers look very nice!

> Questions:
> • What exactly is kztmem?
> ∘ is it a tmem similar functionality like provided in the project
> "Xen's Transcent Memory"
> ∘ and zmem is simply a "plugin" for memory compression support to tmem
> ? (is that what zcache does ?)
> • so simplified (superficially without taking into account advantages
> or certain unique characteristics) some equivalents:
> ∘ frontswap == ramzswap
> ∘ kztmem == zcache
> ∘ cleancache == is the "core", "mastermind" or "hypervisor" behind all
> this, making frontswap and kztmem kind of "plugins" for it ?

This is best described in the "Academic Overview" section
of PATCH V2 0/3: https://lkml.org/lkml/2011/2/6/346
Cleancache and frontswap are "data sources" for page-oriented
data that can easily be stored in "transcendent memory"
(aka "tmem").  Once pages of data are accessible only via tmem,
lots of things can be done to the data, including compression,
deduplication, being sent to the hypervisor, etc.

> So kztmem (or more accurately: cleancache) is open for adding more
> functionality in the future ?

Very definitely...  I'm working on another interesting use
model right now!

> • What are advantages of kztmem compared to ramzswap ("compcache") &
> zcache ? From what I understood - it's more dynamic in it's nature
> than compcache & zcache: they need to preallocate predetermined amount
> of memory, several "ram-drives" would be needed for SMP-scalability
> ∘ whereas this (pre-allocated RAM and multiple "ram-drives" aren't
> needed for kztmem, cleancache and frontswap since cleancache,
> frontswap & kztmem are concurrency-safe and dynamic (according to
> documentation) ?

Yes, that's a good overview of the differences.

> • Coming back to usage of compcache - how about the problem of 60%
> memory fragmentation (according to compcache/zcache wiki,
> http://code.google.com/p/compcache/wiki/Fragmentation) ?
> Could the situation be improved with in-kernel "memory compaction" ?
> I'm not a developer so I don't know exactly how lumpy reclaim/memory
> compaction and xvmalloc would interact with each other

Nitin is the expert on compcache and xvmalloc, so I will leave
this question unanswered for now.

> • According to the Documentation you posted "e.g. a ram-based FS such
> as tmpfs should not enable cleancache" - so it's not using block i/o
> layer ? what are the performance or other advantages of that approach
> ?

Correct, no block i/o layer involved.  The block i/o layer is
optimized for disks (though it is slowly becoming adapted to
faster devices).  The real "advantage" is that EVERY put/get
has immediate feedback and this is very important to making
things as dynamic as possible.

> • Is there support for XFS or reiserfs - how difficult would it be to
> add that ?

I'm not familiar with either, but most filesystems are easy to
add... I'm just not able to do the testing.  If zcache moves
into upstream, other filesystem experts should be able to try
zcache easily on other filesystems.

> • Very interesting would be: support for FUSE (taking into account zfs
> and ntfs3g, etc.) - would that be possible ?

I don't know enough about those to feel comfortable answering,
but would be happy to consult if someone else wants to try it.

> • Was there testing done on 32bit boxes ? How about alternative
> architectures such as ARM, PPC, etc. ?
> ∘ I'm especially interested in ARM since surely a lot on the

Sadly, I haven't done any testing on 32-bit boxes.  All the code
is designed to be entirely architecture-independent though I'm
sure a bug or three will be found on other architectures.

> be / Is there a port of cleancache, kztmem and frontswap available for
> 2.6.32* kernels ? (most android devices are currently running those)

I've found porting cleancache and frontswap to other recent
Linux versions to be straightforward.  And zcache is just a
staging driver so should also port easily.

> • Considerung UP boxes - is the usage even beneficial on those ?
> ∘ If not - why not (written in the documentation) - due to missing raw
> CPU power ?

Should work fine on a UP box.  The majority of the performance
advantage is "converting" disk seek wait time into CPU compress/
decompress time.

> • How is the scaling ? In case of Multiprocessors  - are the
> operations/parallelism or concurrency, how it's called, realized
> through "work queues" - (there have been lots of changes recently in
> the kernel [2.6.37, 2.6.38]).  ?

Good questions.  The concurrency should be pretty good, but in
the current version, interrupts are disabled during compression,
which could lead to some problems in a more real-time load.
This design is fixable but will take some work.

> • Are there higher latencies during high memory pressure or high CPU
> load situations, e.g. where the latencies would even go down below
> without usage of kztmem ?

Theoretically, if there is no disk wait time (e.g. CPUs are always
loaded even during disk reads) AND there is high disk demand,
zcache could cause a reduction in performance.

> • The compression algorithm in use seems to be lzo. Are any additional
> selectable compressions planned such as lzf, gzip - maybe even bzip2 ?
> - Would they be selectable via Kconfig ?
> ∘ are these threaded / scaling with multiple processors - e.g. like pcrypt ?

Good ideas for future enhancements!

> • "Exactly how much memory it provides is entirely dynamic and
> random." - can maximum limits be set ? ("watermarks" ? - if that is
> the correct term)
> How efficient is the algorithm ? What is it based on ?

For cleancache pages, all can be reclaimed so no maximum needs
to be set as long as the kernel reclaim mechanism is working properly.
For frontswap pages, there is a maximum currently hardcoded,
but this could be changed to be handled through a /sys fs file.

> • Can the operations be sped up even more using spice() system call or
> something similar (if existant) - if even applicable ?

Sorry, I don't know the answer to this.

> • Are userland hooks planned ? e.g. for other virtualization solutions
> such as KVM, qemu, etc.

We've thought of userland hooks, but haven't tried them yet.

KVM should be able to take advantage of zcache with a little effort.

> • How about deduplication support for the ephemeral (filesystem) pools?
> ∘ in my (humble) opinion this might be really useful - since in the
> future there will be more and more CPU power but due to available RAM
> not growing as linear (or fast) as CPU's power this could be a kind of
> compensation to gain more memory
> ∘ would that work with "Kernel Samepage Merging"?
> ∘ is KSM even similar to tmem's deduplication functionality (tmem -
> which is used or planned for Xen)
> Referring to http://marc.info/?l=linux-kernel&m=129683713531791&w=2
> slides 20 to 21 on the presentation deduplication would seem much more
> efficient than KSM.

Deduplication support could be added.

> Kztmem seems to be quite useful on memory constrained devices:

You have suggested several interesting possibilities!

If I've missed anything important, please let me know!

Thanks again!
Dan
