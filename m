Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1C2OW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:22:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59905 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab1C2OW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UAL0Sq0fQqVrNHpCx78dKy6wnN/qAt/42tl6Lvyr5OvZzxvs79mnCVAVWeHUtWflZW
         4+2rnrffVdUCHwRVnQACO33aGogwIRtePrW+cp8du1DRY0HxSWgDfpXMcnPfE4Q9NK0r
         UVvdtp4s3meXNOVVUb9YuhiEdn14mgAY75Z0g=
MIME-Version: 1.0
In-Reply-To: <1301336010.2217.20.camel@workstation>
References: <1301310995.5615.92.camel@wangqingchuan>
	<1301336010.2217.20.camel@workstation>
Date: Tue, 29 Mar 2011 10:22:54 -0400
Message-ID: <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
From: Jerome Glisse <j.glisse@gmail.com>
To: Lucas Stach <dev@lynxeye.de>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 2:13 PM, Lucas Stach <dev@lynxeye.de> wrote:
> Hi,
>
> I have seen this too in some traces I have done with nouveau nvfx some
> time ago. (The report in kernel bugzilla is a outcome of this.) I'm
> strongly in favour of fixing the kernel side, as I think doing a
> workaround in userspace is a bad hack. In fact doing so is on my long
> "list of things to fix when I ever get a 48h day".
>
> One thing that pulled me away from this is, that doing something new in
> mmap is a bit regression-prone. If we miss some corner case it is very
> easy to break someone's application.
>
> --Lucas
>
> Am Montag, den 28.03.2011, 19:16 +0800 schrieb r6144:
>> Hello,
>>
>> I am reporting a problem of significant desktop sluggishness caused by
>> mmap-related kernel algorithms.  In particular, after a few days of use,
>> I encounter multiple-second delays switching between a workspace
>> containing Evolution and another containing e.g. firefox, which is very
>> annoying since I switch workspaces very frequently.  Oprofile indicates
>> that, during workspace switching, over 30% of CPU time is spent in
>> find_vma(), likely called from arch_get_unmapped_area_topdown().
>>
>> This is essentially a repost of https://lkml.org/lkml/2010/11/14/236 ,
>> with a bit more investigation and workarounds.  The same issue has also
>> been reported in https://bugzilla.kernel.org/show_bug.cgi?id=17531 , but
>> that bug report has not received any attention either.
>>
>> My kernel is Fedora 14's kernel-2.6.35.11-83.fc14.x86_64, and the open
>> source radeon (r600) driver is used.
>>
>> Basically, the GEM/TTM-based r600 driver (and presumably many other
>> drivers as well) seems to allocate a buffer object for each XRender
>> picture or glyph, and most such objects are mapped into the X server's
>> address space with libdrm.  After the system runs for a few days, the
>> number of mappings according to "wc -l /proc/$(pgrep Xorg)/maps" can
>> reach 5k-10k, with the vast majority being 4kB-sized mappings
>> to /dev/dri/card0 almost contiguously laid out in the address space.
>> Such a large number of mappings should be expected, given the numerous
>> distinct glyphs arising from different CJK characters, fonts, and sizes.
>> Note that libdrm_radeon's bo_unmap() keeps a buffer object mapped even
>> if it is no longer accessed by the CPU (and only calls munmap() when the
>> object is destroyed), which has certainly inflated the mapping count
>> significantly, but otherwise the mmap() overhead would be prohibitive.
>>
>> Currently the kernel's arch_get_unmapped_area_topdown() is linear-time,
>> so further mmap() calls becomes very slow with so many mappings existing
>> in the X server's address space.  Since redrawing a window usually
>> involves the creation of a significant number of temporary pixmaps or
>> XRender pictures, often requiring mapping by the X server, it is thus
>> slowed down greatly.  Although arch_get_unmapped_area_topdown() attempts
>> to use mm->free_area_cache to speed up the search, the cache is usually
>> invalidated due to the mm->cached_hole_size test whenever the block size
>> being searched for is smaller than that in the last time; this ensures
>> that the function always finds the earliest unmapped area in search
>> order that is sufficiently large, thus reducing address space
>> fragmentation (commit 1363c3cd).  Consequently, if different mapping
>> sizes are used in successive mmap() calls, as is often the case when
>> dealing with pixmaps larger than a page in size, the cache would be
>> invalidated almost half of the time, and the amortized cost of each
>> mmap() remains linear.
>>
>> A quantitative measurement is made with the attached pbobench.cpp,
>> compiled with Makefile.pbobench.  This program uses OpenGL pixel-buffer
>> objects (which corresponds one-to-one to GEM buffer objects on my
>> system) to simulate the effect of having a large number of GEM-related
>> mappings in the X server.  It first creates and maps N page-sized PBOs
>> to mimic the large number of XRender glyphs, then measures the time
>> needed to create/map/unmap/destroy more PBOs with size varying between
>> 1-16384 bytes.  The time spent per iteration (which does either a
>> create/map or an unmap/destroy) is clearly O(N):
>>
>> N=100: 17.3us
>> N=1000: 19.9us
>> N=10000: 88.5us
>> N=20000: 205us
>> N=40000: 406us
>>
>> and in oprofile results, the amount of CPU time spent in find_vma() can
>> reach 60-70%, while no other single function takes more than 3%.
>>
>> I think this problem is not difficult to solve.  While it isn't obvious
>> to me how to find the earliest sufficiently-large unmapped area quickly,
>> IMHO it is just as good, fragmentation-wise, if we simply allocate from
>> the smallest sufficiently-large unmapped area regardless of its address;
>> for this purpose, the final "open-ended" unmapped area in the original
>> search order (i.e. the one with the lowest address in
>> arch_get_unmapped_area_topdown()) can be regarded as being infinitely
>> large, so that it is only used (from the correct "end") when absolutely
>> necessary.  In this way, a simple size-indexed rb-tree of the unmapped
>> areas will allow the search to be performed in logarithmic time.
>>
>> As I'm not good at kernel hacking, for now I have written a userspace
>> workaround in libdrm, available from
>> https://github.com/r6144/libdrm/tree/my , which reserves some address
>> space and then allocates from it using MMAP_FIXED.  Due to laziness, it
>> is written in C++ and does not currently combine adjacent free blocks.
>> This gives the expected improvements in pbobench results:
>>
>> N=100: 18.3us
>> N=1000: 18.0us
>> N=10000: 18.2us
>> N=20000: 18.9us
>> N=40000: 20.8us
>> N=80000: 23.5us
>> NOTE: N=80000 requires increasing /proc/sys/vm/max_map_count
>>
>> I am also running Xorg with this modified version of libdrm.  So far it
>> runs okay, and seem to be somewhat snappier than before, although as "wc
>> -l /proc/$(pgrep Xorg)/maps" has only reached 4369 by now, the
>> improvement in responsiveness is not yet that great.  I have not tested
>> the algorithm in 32-bit programs though, but intuitively it should work.
>>
>> (By the way, after this modification, SELinux's sidtab_search_context()
>> appears near the top of the profiling results due to the use of
>> linear-time search.  It should eventually be optimized as well.)
>>
>> Do you find it worthwhile to implement something similar in the kernel?
>> After all, the responsiveness improvement can be quite significant, and
>> it seems difficult to make the graphics subsystem do fewer mmap()'s
>> (e.g. by storing multiple XRender glyphs in a single buffer object).
>> Not to mention that other applications doing lots of mmap()'s for
>> whatever reason will benefit as well.
>>
>> Please CC me as I'm not subscribed.
>>
>> r6144

Killer solution would be to have no mapping and a decent
upload/download ioctl that can take userpage.

Cheers,
Jerome
