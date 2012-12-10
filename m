Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2LJPmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:42:53 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437Ab2LJPmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:42:52 -0500
Date: Mon, 10 Dec 2012 09:43:48 -0600
From: Cliff Wickman <cpw@sgi.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, ptesarik@suse.cz,
        linux-kernel@vger.kernel.org, kumagai-atsushi@mxc.nes.nec.co.jp,
        ""@jp.fujitsu.com
Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
Message-ID: <20121210154348.GA9511@sgi.com>
References: <E1TZ8Ia-0000Gn-1v@eag09.americas.sgi.com> <20121116203944.GO4515@redhat.com> <20121119180710.GA16448@sgi.com> <20121210.095929.249234826.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20121210.095929.249234826.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Mon, Dec 10, 2012 at 09:59:29AM +0900, HATAYAMA Daisuke wrote:
> From: Cliff Wickman <cpw@sgi.com>
> Subject: Re: [PATCH] makedumpfile: request the kernel do page scans
> Date: Mon, 19 Nov 2012 12:07:10 -0600
>=20
> > On Fri, Nov 16, 2012 at 03:39:44PM -0500, Vivek Goyal wrote:
> >> On Thu, Nov 15, 2012 at 04:52:40PM -0600, Cliff Wickman wrote:
> >> >=20
> >> > Gentlemen,
> >> >=20
> >> > I know this is rather late to the game, given all the recent work to=
 speed
> >> > up makedumpfile and reduce the memory that it consumes.
> >> > But I've been experimenting with asking the kernel to scan the page =
tables
> >> > instead of reading all those page structures through /proc/vmcore.
> >> >=20
> >> > The results are rather dramatic -- if they weren't I would not presu=
me to
> >> > suggest such a radical path.
> >> > On a small, idle UV system: about 4 sec. versus about 40 sec.
> >> > On a 8TB UV the unnecessary page scan alone takes 4 minutes, vs. abo=
ut 200 min
> >> > through /proc/vmcore.
> >> >=20
> >> > I have not compared it to your version 1.5.1, so I don't know if you=
r recent
> >> > work provides similar speedups.
> >>=20
> >> I guess try 1.5.1-rc. IIUC, we had the logic of going through page tab=
les
> >> but that required one single bitmap to be present and in constrained
> >> memory environment we will not have that.
> >>=20
> >> That's when this idea came up that scan portion of struct page range,
> >> filter it, dump it and then move on to next range.
> >>=20
> >> Even after 1.5.1-rc if difference is this dramatic, that means we are
> >> not doing something right in makedumpfile and it needs to be
> >> fixed/optimized.
> >>=20
> >> But moving the logic to kernel does not make much sense to me at this
> >> point of time untile and unless there is a good explanation that why
> >> user space can't do a good job of what kernel is doing.
> >=20
> > I tested a patch in which makedumpfile does nothing but scan all the
> > page structures using /proc/vmcore.  It is simply reading each consecut=
ive
> > range of page structures in readmem() chunks of 512 structures. And doi=
ng
> > nothing more than accumulating a hash total of the 'flags' field in each
> > page (for a sanity check). On my test machine there are 6 blocks of page
> > structures, totaling 12 million structures. This takes 31.1 'units of t=
ime'
> > (I won't say seconds, as the speed of the clock seems to be way too fas=
t in
> > the crash kernel). If I increase the buffer size to 5120 structures: 31=
=2E0 units.
> > At 51200 structures: 30.9.  So buffer size has virtually no effect.
> >=20
> > I also request the kernel to do the same thing.  Each of the 6 requests
> > asks the kernel to scan a range of page structures and accumulate a hash
> > total of the 'flags' field.  (And also copy a 10000-element pfn list ba=
ck
> > to user space, to test that such copies don't add significant overhead.)
> > And the 12 million pages are scanned in 1.6 'units of time'.
> >=20
> > If I compare the time for actual page scanning (unnecessary pages and
> > free pages) through /proc/vmcore vs.  requesting the kernel to do the
> > scanning:  40 units vs. 3.8 units.
> >=20
> > My conclusion is that makedumpfile's page scanning procedure is extreme=
ly
> > dominated by the overhead of copying page structures through /proc/vmco=
re.
> > And that is about 20x slower than using the kernel to access pages.
>=20
> I have not tested your patch set on the machine with 2TB due to
> reservation problem, but I already tested it on my local machine with
> 32GB and saw big performance improvement.
>=20
> I applied your patch set on makedumpfile v1.5.1-rc and added an option
> -N not to dump pages to focus on scanning pages part only.
>=20
> By this, while scanning pages in user-space took about 25 seconds,
> scanning pages in kernel-space took about 1 second.
>=20
> During the execution I profiled it using perf record/report and its
> results are attached files.
>=20
> >From this we can notice that current makedumpfile consumes large part
> of execution time for ioremap and its related processing. copy_to_user
> was less than 2% only relative to a whole processing.
>=20
> Looking into the codes around read method of /proc/vmcore, its call
> stack can be broken into as follows:
>=20
>   read_vmcore
>     read_from_oldmem
>       copy_oldmem_page
>=20
> copy_oldmem_page reads the 1st kernel's memory *per page* using
> ioremap_cache and after completing it, immediately unmaps the remapped
> address using iounmap.
>=20
> Because ioremap/iounmap is called *per page*, this number of calling
> ioremap throught scanning a whole pages is unchanged even if
> makedumpfile's cache size is changed. This seems consistent with
> Cliff's explanation that increasing 512 entries of makedumpfile's
> cache was meaningless.
>=20
> I think the first step to address this issue is to introduce a kind of
> cache in read_vmcore path to reduce the number of calling
> ioremap/iounmap. Porting scanning logic into kernel-space should be
> considered if it turns out not to work enough.
>=20
> Thanks.
> HATAYAMA, Daisuke


(resending this note - I seem to have messed up the email header)
Hi Hatayama,

If ioremap/iounmap is the bottleneck then perhaps you could do what
my patch does: it consolidates all the ranges of physical addresses
where the boot kernel's page structures reside (see make_kernel_mmap())
and passes them to the kernel, which then does a handfull of ioremaps's
to
cover all of them.  Then /proc/vmcore could look up the already-mapped
virtual address.
(also note a kludge in get_mm_sparsemem() that verifies that each
section
of the mem_map spans contiguous ranges of page structures.  I had
trouble with some sections when I made that assumption)

I'm attaching 3 patches that might be useful in your testing:
- 121210.proc_vmcore2  my current patch that applies to the released
  makedumpfile 1.5.1
- 121207.vmcore_pagescans.sles applies to a 3.0.13 kernel
- 121207.vmcore_pagescans.rhel applies to a 2.6.32 kernel

-Cliff

> sadump: does not have partition header
> sadump: read dump device as unknown format
> sadump: unknown format
> LOAD (0)
>   phys_start : 1000000
>   phys_end   : 22f1000
>   virt_start : ffffffff81000000
>   virt_end   : ffffffff822f1000
> LOAD (1)
>   phys_start : 10000
>   phys_end   : 9b000
>   virt_start : ffff880000010000
>   virt_end   : ffff88000009b000
> LOAD (2)
>   phys_start : 100000
>   phys_end   : 27000000
>   virt_start : ffff880000100000
>   virt_end   : ffff880027000000
> LOAD (3)
>   phys_start : 37000000
>   phys_end   : 7b00d000
>   virt_start : ffff880037000000
>   virt_end   : ffff88007b00d000
> LOAD (4)
>   phys_start : 100000000
>   phys_end   : 880000000
>   virt_start : ffff880100000000
>   virt_end   : ffff880880000000
> Linux kdump
> page_size    : 4096
> page_size    : 4096
>=20
> max_mapnr    : 880000
>=20
> Buffer size for the cyclic mode: 2228224
>=20
> num of NODEs : 4
>=20
>=20
> Memory type  : SPARSEMEM_EX
>=20
> mem_map (0)
>   mem_map    : ffffea0000000000
>   pfn_start  : 0
>   pfn_end    : 8000
> mem_map (1)
>   mem_map    : ffffea00001c0000
>   pfn_start  : 8000
>   pfn_end    : 10000
> mem_map (2)
>   mem_map    : ffffea0000380000
>   pfn_start  : 10000
>   pfn_end    : 18000
> mem_map (3)
>   mem_map    : ffffea0000540000
>   pfn_start  : 18000
>   pfn_end    : 20000
> mem_map (4)
>   mem_map    : ffffea0000700000
>   pfn_start  : 20000
>   pfn_end    : 28000
> mem_map (5)
>   mem_map    : ffffea00008c0000
>   pfn_start  : 28000
>   pfn_end    : 30000
> mem_map (6)
>   mem_map    : ffffea0000a80000
>   pfn_start  : 30000
>   pfn_end    : 38000
> mem_map (7)
>   mem_map    : ffffea0000c40000
>   pfn_start  : 38000
>   pfn_end    : 40000
> mem_map (8)
>   mem_map    : ffffea0000e00000
>   pfn_start  : 40000
>   pfn_end    : 48000
> mem_map (9)
>   mem_map    : ffffea0000fc0000
>   pfn_start  : 48000
>   pfn_end    : 50000
> mem_map (10)
>   mem_map    : ffffea0001180000
>   pfn_start  : 50000
>   pfn_end    : 58000
> mem_map (11)
>   mem_map    : ffffea0001340000
>   pfn_start  : 58000
>   pfn_end    : 60000
> mem_map (12)
>   mem_map    : ffffea0001500000
>   pfn_start  : 60000
>   pfn_end    : 68000
> mem_map (13)
>   mem_map    : ffffea00016c0000
>   pfn_start  : 68000
>   pfn_end    : 70000
> mem_map (14)
>   mem_map    : ffffea0001880000
>   pfn_start  : 70000
>   pfn_end    : 78000
> mem_map (15)
>   mem_map    : ffffea0001a40000
>   pfn_start  : 78000
>   pfn_end    : 80000
> mem_map (16)
>   mem_map    : 0
>   pfn_start  : 80000
>   pfn_end    : 88000
> mem_map (17)
>   mem_map    : 0
>   pfn_start  : 88000
>   pfn_end    : 90000
> mem_map (18)
>   mem_map    : 0
>   pfn_start  : 90000
>   pfn_end    : 98000
> mem_map (19)
>   mem_map    : 0
>   pfn_start  : 98000
>   pfn_end    : a0000
> mem_map (20)
>   mem_map    : 0
>   pfn_start  : a0000
>   pfn_end    : a8000
> mem_map (21)
>   mem_map    : 0
>   pfn_start  : a8000
>   pfn_end    : b0000
> mem_map (22)
>   mem_map    : 0
>   pfn_start  : b0000
>   pfn_end    : b8000
> mem_map (23)
>   mem_map    : 0
>   pfn_start  : b8000
>   pfn_end    : c0000
> mem_map (24)
>   mem_map    : 0
>   pfn_start  : c0000
>   pfn_end    : c8000
> mem_map (25)
>   mem_map    : 0
>   pfn_start  : c8000
>   pfn_end    : d0000
> mem_map (26)
>   mem_map    : 0
>   pfn_start  : d0000
>   pfn_end    : d8000
> mem_map (27)
>   mem_map    : 0
>   pfn_start  : d8000
>   pfn_end    : e0000
> mem_map (28)
>   mem_map    : 0
>   pfn_start  : e0000
>   pfn_end    : e8000
> mem_map (29)
>   mem_map    : 0
>   pfn_start  : e8000
>   pfn_end    : f0000
> mem_map (30)
>   mem_map    : 0
>   pfn_start  : f0000
>   pfn_end    : f8000
> mem_map (31)
>   mem_map    : 0
>   pfn_start  : f8000
>   pfn_end    : 100000
> mem_map (32)
>   mem_map    : ffffea0003800000
>   pfn_start  : 100000
>   pfn_end    : 108000
> mem_map (33)
>   mem_map    : ffffea00039c0000
>   pfn_start  : 108000
>   pfn_end    : 110000
> mem_map (34)
>   mem_map    : ffffea0003b80000
>   pfn_start  : 110000
>   pfn_end    : 118000
> mem_map (35)
>   mem_map    : ffffea0003d40000
>   pfn_start  : 118000
>   pfn_end    : 120000
> mem_map (36)
>   mem_map    : ffffea0003f00000
>   pfn_start  : 120000
>   pfn_end    : 128000
> mem_map (37)
>   mem_map    : ffffea00040c0000
>   pfn_start  : 128000
>   pfn_end    : 130000
> mem_map (38)
>   mem_map    : ffffea0004280000
>   pfn_start  : 130000
>   pfn_end    : 138000
> mem_map (39)
>   mem_map    : ffffea0004440000
>   pfn_start  : 138000
>   pfn_end    : 140000
> mem_map (40)
>   mem_map    : ffffea0004600000
>   pfn_start  : 140000
>   pfn_end    : 148000
> mem_map (41)
>   mem_map    : ffffea00047c0000
>   pfn_start  : 148000
>   pfn_end    : 150000
> mem_map (42)
>   mem_map    : ffffea0004980000
>   pfn_start  : 150000
>   pfn_end    : 158000
> mem_map (43)
>   mem_map    : ffffea0004b40000
>   pfn_start  : 158000
>   pfn_end    : 160000
> mem_map (44)
>   mem_map    : ffffea0004d00000
>   pfn_start  : 160000
>   pfn_end    : 168000
> mem_map (45)
>   mem_map    : ffffea0004ec0000
>   pfn_start  : 168000
>   pfn_end    : 170000
> mem_map (46)
>   mem_map    : ffffea0005080000
>   pfn_start  : 170000
>   pfn_end    : 178000
> mem_map (47)
>   mem_map    : ffffea0005240000
>   pfn_start  : 178000
>   pfn_end    : 180000
> mem_map (48)
>   mem_map    : ffffea0005400000
>   pfn_start  : 180000
>   pfn_end    : 188000
> mem_map (49)
>   mem_map    : ffffea00055c0000
>   pfn_start  : 188000
>   pfn_end    : 190000
> mem_map (50)
>   mem_map    : ffffea0005780000
>   pfn_start  : 190000
>   pfn_end    : 198000
> mem_map (51)
>   mem_map    : ffffea0005940000
>   pfn_start  : 198000
>   pfn_end    : 1a0000
> mem_map (52)
>   mem_map    : ffffea0005b00000
>   pfn_start  : 1a0000
>   pfn_end    : 1a8000
> mem_map (53)
>   mem_map    : ffffea0005cc0000
>   pfn_start  : 1a8000
>   pfn_end    : 1b0000
> mem_map (54)
>   mem_map    : ffffea0005e80000
>   pfn_start  : 1b0000
>   pfn_end    : 1b8000
> mem_map (55)
>   mem_map    : ffffea0006040000
>   pfn_start  : 1b8000
>   pfn_end    : 1c0000
> mem_map (56)
>   mem_map    : ffffea0006200000
>   pfn_start  : 1c0000
>   pfn_end    : 1c8000
> mem_map (57)
>   mem_map    : ffffea00063c0000
>   pfn_start  : 1c8000
>   pfn_end    : 1d0000
> mem_map (58)
>   mem_map    : ffffea0006580000
>   pfn_start  : 1d0000
>   pfn_end    : 1d8000
> mem_map (59)
>   mem_map    : ffffea0006740000
>   pfn_start  : 1d8000
>   pfn_end    : 1e0000
> mem_map (60)
>   mem_map    : ffffea0006900000
>   pfn_start  : 1e0000
>   pfn_end    : 1e8000
> mem_map (61)
>   mem_map    : ffffea0006ac0000
>   pfn_start  : 1e8000
>   pfn_end    : 1f0000
> mem_map (62)
>   mem_map    : ffffea0006c80000
>   pfn_start  : 1f0000
>   pfn_end    : 1f8000
> mem_map (63)
>   mem_map    : ffffea0006e40000
>   pfn_start  : 1f8000
>   pfn_end    : 200000
> mem_map (64)
>   mem_map    : ffffea0007000000
>   pfn_start  : 200000
>   pfn_end    : 208000
> mem_map (65)
>   mem_map    : ffffea00071c0000
>   pfn_start  : 208000
>   pfn_end    : 210000
> mem_map (66)
>   mem_map    : ffffea0007380000
>   pfn_start  : 210000
>   pfn_end    : 218000
> mem_map (67)
>   mem_map    : ffffea0007540000
>   pfn_start  : 218000
>   pfn_end    : 220000
> mem_map (68)
>   mem_map    : ffffea0007700000
>   pfn_start  : 220000
>   pfn_end    : 228000
> mem_map (69)
>   mem_map    : ffffea00078c0000
>   pfn_start  : 228000
>   pfn_end    : 230000
> mem_map (70)
>   mem_map    : ffffea0007a80000
>   pfn_start  : 230000
>   pfn_end    : 238000
> mem_map (71)
>   mem_map    : ffffea0007c40000
>   pfn_start  : 238000
>   pfn_end    : 240000
> mem_map (72)
>   mem_map    : ffffea0007e00000
>   pfn_start  : 240000
>   pfn_end    : 248000
> mem_map (73)
>   mem_map    : ffffea0007fc0000
>   pfn_start  : 248000
>   pfn_end    : 250000
> mem_map (74)
>   mem_map    : ffffea0008180000
>   pfn_start  : 250000
>   pfn_end    : 258000
> mem_map (75)
>   mem_map    : ffffea0008340000
>   pfn_start  : 258000
>   pfn_end    : 260000
> mem_map (76)
>   mem_map    : ffffea0008500000
>   pfn_start  : 260000
>   pfn_end    : 268000
> mem_map (77)
>   mem_map    : ffffea00086c0000
>   pfn_start  : 268000
>   pfn_end    : 270000
> mem_map (78)
>   mem_map    : ffffea0008880000
>   pfn_start  : 270000
>   pfn_end    : 278000
> mem_map (79)
>   mem_map    : ffffea0008a40000
>   pfn_start  : 278000
>   pfn_end    : 280000
> mem_map (80)
>   mem_map    : ffffea0008c00000
>   pfn_start  : 280000
>   pfn_end    : 288000
> mem_map (81)
>   mem_map    : ffffea0008dc0000
>   pfn_start  : 288000
>   pfn_end    : 290000
> mem_map (82)
>   mem_map    : ffffea0008f80000
>   pfn_start  : 290000
>   pfn_end    : 298000
> mem_map (83)
>   mem_map    : ffffea0009140000
>   pfn_start  : 298000
>   pfn_end    : 2a0000
> mem_map (84)
>   mem_map    : ffffea0009300000
>   pfn_start  : 2a0000
>   pfn_end    : 2a8000
> mem_map (85)
>   mem_map    : ffffea00094c0000
>   pfn_start  : 2a8000
>   pfn_end    : 2b0000
> mem_map (86)
>   mem_map    : ffffea0009680000
>   pfn_start  : 2b0000
>   pfn_end    : 2b8000
> mem_map (87)
>   mem_map    : ffffea0009840000
>   pfn_start  : 2b8000
>   pfn_end    : 2c0000
> mem_map (88)
>   mem_map    : ffffea0009a00000
>   pfn_start  : 2c0000
>   pfn_end    : 2c8000
> mem_map (89)
>   mem_map    : ffffea0009bc0000
>   pfn_start  : 2c8000
>   pfn_end    : 2d0000
> mem_map (90)
>   mem_map    : ffffea0009d80000
>   pfn_start  : 2d0000
>   pfn_end    : 2d8000
> mem_map (91)
>   mem_map    : ffffea0009f40000
>   pfn_start  : 2d8000
>   pfn_end    : 2e0000
> mem_map (92)
>   mem_map    : ffffea000a100000
>   pfn_start  : 2e0000
>   pfn_end    : 2e8000
> mem_map (93)
>   mem_map    : ffffea000a2c0000
>   pfn_start  : 2e8000
>   pfn_end    : 2f0000
> mem_map (94)
>   mem_map    : ffffea000a480000
>   pfn_start  : 2f0000
>   pfn_end    : 2f8000
> mem_map (95)
>   mem_map    : ffffea000a640000
>   pfn_start  : 2f8000
>   pfn_end    : 300000
> mem_map (96)
>   mem_map    : ffffea000a800000
>   pfn_start  : 300000
>   pfn_end    : 308000
> mem_map (97)
>   mem_map    : ffffea000a9c0000
>   pfn_start  : 308000
>   pfn_end    : 310000
> mem_map (98)
>   mem_map    : ffffea000ab80000
>   pfn_start  : 310000
>   pfn_end    : 318000
> mem_map (99)
>   mem_map    : ffffea000ad40000
>   pfn_start  : 318000
>   pfn_end    : 320000
> mem_map (100)
>   mem_map    : ffffea000af00000
>   pfn_start  : 320000
>   pfn_end    : 328000
> mem_map (101)
>   mem_map    : ffffea000b0c0000
>   pfn_start  : 328000
>   pfn_end    : 330000
> mem_map (102)
>   mem_map    : ffffea000b280000
>   pfn_start  : 330000
>   pfn_end    : 338000
> mem_map (103)
>   mem_map    : ffffea000b440000
>   pfn_start  : 338000
>   pfn_end    : 340000
> mem_map (104)
>   mem_map    : ffffea000b600000
>   pfn_start  : 340000
>   pfn_end    : 348000
> mem_map (105)
>   mem_map    : ffffea000b7c0000
>   pfn_start  : 348000
>   pfn_end    : 350000
> mem_map (106)
>   mem_map    : ffffea000b980000
>   pfn_start  : 350000
>   pfn_end    : 358000
> mem_map (107)
>   mem_map    : ffffea000bb40000
>   pfn_start  : 358000
>   pfn_end    : 360000
> mem_map (108)
>   mem_map    : ffffea000bd00000
>   pfn_start  : 360000
>   pfn_end    : 368000
> mem_map (109)
>   mem_map    : ffffea000bec0000
>   pfn_start  : 368000
>   pfn_end    : 370000
> mem_map (110)
>   mem_map    : ffffea000c080000
>   pfn_start  : 370000
>   pfn_end    : 378000
> mem_map (111)
>   mem_map    : ffffea000c240000
>   pfn_start  : 378000
>   pfn_end    : 380000
> mem_map (112)
>   mem_map    : ffffea000c400000
>   pfn_start  : 380000
>   pfn_end    : 388000
> mem_map (113)
>   mem_map    : ffffea000c5c0000
>   pfn_start  : 388000
>   pfn_end    : 390000
> mem_map (114)
>   mem_map    : ffffea000c780000
>   pfn_start  : 390000
>   pfn_end    : 398000
> mem_map (115)
>   mem_map    : ffffea000c940000
>   pfn_start  : 398000
>   pfn_end    : 3a0000
> mem_map (116)
>   mem_map    : ffffea000cb00000
>   pfn_start  : 3a0000
>   pfn_end    : 3a8000
> mem_map (117)
>   mem_map    : ffffea000ccc0000
>   pfn_start  : 3a8000
>   pfn_end    : 3b0000
> mem_map (118)
>   mem_map    : ffffea000ce80000
>   pfn_start  : 3b0000
>   pfn_end    : 3b8000
> mem_map (119)
>   mem_map    : ffffea000d040000
>   pfn_start  : 3b8000
>   pfn_end    : 3c0000
> mem_map (120)
>   mem_map    : ffffea000d200000
>   pfn_start  : 3c0000
>   pfn_end    : 3c8000
> mem_map (121)
>   mem_map    : ffffea000d3c0000
>   pfn_start  : 3c8000
>   pfn_end    : 3d0000
> mem_map (122)
>   mem_map    : ffffea000d580000
>   pfn_start  : 3d0000
>   pfn_end    : 3d8000
> mem_map (123)
>   mem_map    : ffffea000d740000
>   pfn_start  : 3d8000
>   pfn_end    : 3e0000
> mem_map (124)
>   mem_map    : ffffea000d900000
>   pfn_start  : 3e0000
>   pfn_end    : 3e8000
> mem_map (125)
>   mem_map    : ffffea000dac0000
>   pfn_start  : 3e8000
>   pfn_end    : 3f0000
> mem_map (126)
>   mem_map    : ffffea000dc80000
>   pfn_start  : 3f0000
>   pfn_end    : 3f8000
> mem_map (127)
>   mem_map    : ffffea000de40000
>   pfn_start  : 3f8000
>   pfn_end    : 400000
> mem_map (128)
>   mem_map    : ffffea000e000000
>   pfn_start  : 400000
>   pfn_end    : 408000
> mem_map (129)
>   mem_map    : ffffea000e1c0000
>   pfn_start  : 408000
>   pfn_end    : 410000
> mem_map (130)
>   mem_map    : ffffea000e380000
>   pfn_start  : 410000
>   pfn_end    : 418000
> mem_map (131)
>   mem_map    : ffffea000e540000
>   pfn_start  : 418000
>   pfn_end    : 420000
> mem_map (132)
>   mem_map    : ffffea000e700000
>   pfn_start  : 420000
>   pfn_end    : 428000
> mem_map (133)
>   mem_map    : ffffea000e8c0000
>   pfn_start  : 428000
>   pfn_end    : 430000
> mem_map (134)
>   mem_map    : ffffea000ea80000
>   pfn_start  : 430000
>   pfn_end    : 438000
> mem_map (135)
>   mem_map    : ffffea000ec40000
>   pfn_start  : 438000
>   pfn_end    : 440000
> mem_map (136)
>   mem_map    : ffffea000ee00000
>   pfn_start  : 440000
>   pfn_end    : 448000
> mem_map (137)
>   mem_map    : ffffea000efc0000
>   pfn_start  : 448000
>   pfn_end    : 450000
> mem_map (138)
>   mem_map    : ffffea000f180000
>   pfn_start  : 450000
>   pfn_end    : 458000
> mem_map (139)
>   mem_map    : ffffea000f340000
>   pfn_start  : 458000
>   pfn_end    : 460000
> mem_map (140)
>   mem_map    : ffffea000f500000
>   pfn_start  : 460000
>   pfn_end    : 468000
> mem_map (141)
>   mem_map    : ffffea000f6c0000
>   pfn_start  : 468000
>   pfn_end    : 470000
> mem_map (142)
>   mem_map    : ffffea000f880000
>   pfn_start  : 470000
>   pfn_end    : 478000
> mem_map (143)
>   mem_map    : ffffea000fa40000
>   pfn_start  : 478000
>   pfn_end    : 480000
> mem_map (144)
>   mem_map    : ffffea000fc00000
>   pfn_start  : 480000
>   pfn_end    : 488000
> mem_map (145)
>   mem_map    : ffffea000fdc0000
>   pfn_start  : 488000
>   pfn_end    : 490000
> mem_map (146)
>   mem_map    : ffffea000ff80000
>   pfn_start  : 490000
>   pfn_end    : 498000
> mem_map (147)
>   mem_map    : ffffea0010140000
>   pfn_start  : 498000
>   pfn_end    : 4a0000
> mem_map (148)
>   mem_map    : ffffea0010300000
>   pfn_start  : 4a0000
>   pfn_end    : 4a8000
> mem_map (149)
>   mem_map    : ffffea00104c0000
>   pfn_start  : 4a8000
>   pfn_end    : 4b0000
> mem_map (150)
>   mem_map    : ffffea0010680000
>   pfn_start  : 4b0000
>   pfn_end    : 4b8000
> mem_map (151)
>   mem_map    : ffffea0010840000
>   pfn_start  : 4b8000
>   pfn_end    : 4c0000
> mem_map (152)
>   mem_map    : ffffea0010a00000
>   pfn_start  : 4c0000
>   pfn_end    : 4c8000
> mem_map (153)
>   mem_map    : ffffea0010bc0000
>   pfn_start  : 4c8000
>   pfn_end    : 4d0000
> mem_map (154)
>   mem_map    : ffffea0010d80000
>   pfn_start  : 4d0000
>   pfn_end    : 4d8000
> mem_map (155)
>   mem_map    : ffffea0010f40000
>   pfn_start  : 4d8000
>   pfn_end    : 4e0000
> mem_map (156)
>   mem_map    : ffffea0011100000
>   pfn_start  : 4e0000
>   pfn_end    : 4e8000
> mem_map (157)
>   mem_map    : ffffea00112c0000
>   pfn_start  : 4e8000
>   pfn_end    : 4f0000
> mem_map (158)
>   mem_map    : ffffea0011480000
>   pfn_start  : 4f0000
>   pfn_end    : 4f8000
> mem_map (159)
>   mem_map    : ffffea0011640000
>   pfn_start  : 4f8000
>   pfn_end    : 500000
> mem_map (160)
>   mem_map    : ffffea0011800000
>   pfn_start  : 500000
>   pfn_end    : 508000
> mem_map (161)
>   mem_map    : ffffea00119c0000
>   pfn_start  : 508000
>   pfn_end    : 510000
> mem_map (162)
>   mem_map    : ffffea0011b80000
>   pfn_start  : 510000
>   pfn_end    : 518000
> mem_map (163)
>   mem_map    : ffffea0011d40000
>   pfn_start  : 518000
>   pfn_end    : 520000
> mem_map (164)
>   mem_map    : ffffea0011f00000
>   pfn_start  : 520000
>   pfn_end    : 528000
> mem_map (165)
>   mem_map    : ffffea00120c0000
>   pfn_start  : 528000
>   pfn_end    : 530000
> mem_map (166)
>   mem_map    : ffffea0012280000
>   pfn_start  : 530000
>   pfn_end    : 538000
> mem_map (167)
>   mem_map    : ffffea0012440000
>   pfn_start  : 538000
>   pfn_end    : 540000
> mem_map (168)
>   mem_map    : ffffea0012600000
>   pfn_start  : 540000
>   pfn_end    : 548000
> mem_map (169)
>   mem_map    : ffffea00127c0000
>   pfn_start  : 548000
>   pfn_end    : 550000
> mem_map (170)
>   mem_map    : ffffea0012980000
>   pfn_start  : 550000
>   pfn_end    : 558000
> mem_map (171)
>   mem_map    : ffffea0012b40000
>   pfn_start  : 558000
>   pfn_end    : 560000
> mem_map (172)
>   mem_map    : ffffea0012d00000
>   pfn_start  : 560000
>   pfn_end    : 568000
> mem_map (173)
>   mem_map    : ffffea0012ec0000
>   pfn_start  : 568000
>   pfn_end    : 570000
> mem_map (174)
>   mem_map    : ffffea0013080000
>   pfn_start  : 570000
>   pfn_end    : 578000
> mem_map (175)
>   mem_map    : ffffea0013240000
>   pfn_start  : 578000
>   pfn_end    : 580000
> mem_map (176)
>   mem_map    : ffffea0013400000
>   pfn_start  : 580000
>   pfn_end    : 588000
> mem_map (177)
>   mem_map    : ffffea00135c0000
>   pfn_start  : 588000
>   pfn_end    : 590000
> mem_map (178)
>   mem_map    : ffffea0013780000
>   pfn_start  : 590000
>   pfn_end    : 598000
> mem_map (179)
>   mem_map    : ffffea0013940000
>   pfn_start  : 598000
>   pfn_end    : 5a0000
> mem_map (180)
>   mem_map    : ffffea0013b00000
>   pfn_start  : 5a0000
>   pfn_end    : 5a8000
> mem_map (181)
>   mem_map    : ffffea0013cc0000
>   pfn_start  : 5a8000
>   pfn_end    : 5b0000
> mem_map (182)
>   mem_map    : ffffea0013e80000
>   pfn_start  : 5b0000
>   pfn_end    : 5b8000
> mem_map (183)
>   mem_map    : ffffea0014040000
>   pfn_start  : 5b8000
>   pfn_end    : 5c0000
> mem_map (184)
>   mem_map    : ffffea0014200000
>   pfn_start  : 5c0000
>   pfn_end    : 5c8000
> mem_map (185)
>   mem_map    : ffffea00143c0000
>   pfn_start  : 5c8000
>   pfn_end    : 5d0000
> mem_map (186)
>   mem_map    : ffffea0014580000
>   pfn_start  : 5d0000
>   pfn_end    : 5d8000
> mem_map (187)
>   mem_map    : ffffea0014740000
>   pfn_start  : 5d8000
>   pfn_end    : 5e0000
> mem_map (188)
>   mem_map    : ffffea0014900000
>   pfn_start  : 5e0000
>   pfn_end    : 5e8000
> mem_map (189)
>   mem_map    : ffffea0014ac0000
>   pfn_start  : 5e8000
>   pfn_end    : 5f0000
> mem_map (190)
>   mem_map    : ffffea0014c80000
>   pfn_start  : 5f0000
>   pfn_end    : 5f8000
> mem_map (191)
>   mem_map    : ffffea0014e40000
>   pfn_start  : 5f8000
>   pfn_end    : 600000
> mem_map (192)
>   mem_map    : ffffea0015000000
>   pfn_start  : 600000
>   pfn_end    : 608000
> mem_map (193)
>   mem_map    : ffffea00151c0000
>   pfn_start  : 608000
>   pfn_end    : 610000
> mem_map (194)
>   mem_map    : ffffea0015380000
>   pfn_start  : 610000
>   pfn_end    : 618000
> mem_map (195)
>   mem_map    : ffffea0015540000
>   pfn_start  : 618000
>   pfn_end    : 620000
> mem_map (196)
>   mem_map    : ffffea0015700000
>   pfn_start  : 620000
>   pfn_end    : 628000
> mem_map (197)
>   mem_map    : ffffea00158c0000
>   pfn_start  : 628000
>   pfn_end    : 630000
> mem_map (198)
>   mem_map    : ffffea0015a80000
>   pfn_start  : 630000
>   pfn_end    : 638000
> mem_map (199)
>   mem_map    : ffffea0015c40000
>   pfn_start  : 638000
>   pfn_end    : 640000
> mem_map (200)
>   mem_map    : ffffea0015e00000
>   pfn_start  : 640000
>   pfn_end    : 648000
> mem_map (201)
>   mem_map    : ffffea0015fc0000
>   pfn_start  : 648000
>   pfn_end    : 650000
> mem_map (202)
>   mem_map    : ffffea0016180000
>   pfn_start  : 650000
>   pfn_end    : 658000
> mem_map (203)
>   mem_map    : ffffea0016340000
>   pfn_start  : 658000
>   pfn_end    : 660000
> mem_map (204)
>   mem_map    : ffffea0016500000
>   pfn_start  : 660000
>   pfn_end    : 668000
> mem_map (205)
>   mem_map    : ffffea00166c0000
>   pfn_start  : 668000
>   pfn_end    : 670000
> mem_map (206)
>   mem_map    : ffffea0016880000
>   pfn_start  : 670000
>   pfn_end    : 678000
> mem_map (207)
>   mem_map    : ffffea0016a40000
>   pfn_start  : 678000
>   pfn_end    : 680000
> mem_map (208)
>   mem_map    : ffffea0016c00000
>   pfn_start  : 680000
>   pfn_end    : 688000
> mem_map (209)
>   mem_map    : ffffea0016dc0000
>   pfn_start  : 688000
>   pfn_end    : 690000
> mem_map (210)
>   mem_map    : ffffea0016f80000
>   pfn_start  : 690000
>   pfn_end    : 698000
> mem_map (211)
>   mem_map    : ffffea0017140000
>   pfn_start  : 698000
>   pfn_end    : 6a0000
> mem_map (212)
>   mem_map    : ffffea0017300000
>   pfn_start  : 6a0000
>   pfn_end    : 6a8000
> mem_map (213)
>   mem_map    : ffffea00174c0000
>   pfn_start  : 6a8000
>   pfn_end    : 6b0000
> mem_map (214)
>   mem_map    : ffffea0017680000
>   pfn_start  : 6b0000
>   pfn_end    : 6b8000
> mem_map (215)
>   mem_map    : ffffea0017840000
>   pfn_start  : 6b8000
>   pfn_end    : 6c0000
> mem_map (216)
>   mem_map    : ffffea0017a00000
>   pfn_start  : 6c0000
>   pfn_end    : 6c8000
> mem_map (217)
>   mem_map    : ffffea0017bc0000
>   pfn_start  : 6c8000
>   pfn_end    : 6d0000
> mem_map (218)
>   mem_map    : ffffea0017d80000
>   pfn_start  : 6d0000
>   pfn_end    : 6d8000
> mem_map (219)
>   mem_map    : ffffea0017f40000
>   pfn_start  : 6d8000
>   pfn_end    : 6e0000
> mem_map (220)
>   mem_map    : ffffea0018100000
>   pfn_start  : 6e0000
>   pfn_end    : 6e8000
> mem_map (221)
>   mem_map    : ffffea00182c0000
>   pfn_start  : 6e8000
>   pfn_end    : 6f0000
> mem_map (222)
>   mem_map    : ffffea0018480000
>   pfn_start  : 6f0000
>   pfn_end    : 6f8000
> mem_map (223)
>   mem_map    : ffffea0018640000
>   pfn_start  : 6f8000
>   pfn_end    : 700000
> mem_map (224)
>   mem_map    : ffffea0018800000
>   pfn_start  : 700000
>   pfn_end    : 708000
> mem_map (225)
>   mem_map    : ffffea00189c0000
>   pfn_start  : 708000
>   pfn_end    : 710000
> mem_map (226)
>   mem_map    : ffffea0018b80000
>   pfn_start  : 710000
>   pfn_end    : 718000
> mem_map (227)
>   mem_map    : ffffea0018d40000
>   pfn_start  : 718000
>   pfn_end    : 720000
> mem_map (228)
>   mem_map    : ffffea0018f00000
>   pfn_start  : 720000
>   pfn_end    : 728000
> mem_map (229)
>   mem_map    : ffffea00190c0000
>   pfn_start  : 728000
>   pfn_end    : 730000
> mem_map (230)
>   mem_map    : ffffea0019280000
>   pfn_start  : 730000
>   pfn_end    : 738000
> mem_map (231)
>   mem_map    : ffffea0019440000
>   pfn_start  : 738000
>   pfn_end    : 740000
> mem_map (232)
>   mem_map    : ffffea0019600000
>   pfn_start  : 740000
>   pfn_end    : 748000
> mem_map (233)
>   mem_map    : ffffea00197c0000
>   pfn_start  : 748000
>   pfn_end    : 750000
> mem_map (234)
>   mem_map    : ffffea0019980000
>   pfn_start  : 750000
>   pfn_end    : 758000
> mem_map (235)
>   mem_map    : ffffea0019b40000
>   pfn_start  : 758000
>   pfn_end    : 760000
> mem_map (236)
>   mem_map    : ffffea0019d00000
>   pfn_start  : 760000
>   pfn_end    : 768000
> mem_map (237)
>   mem_map    : ffffea0019ec0000
>   pfn_start  : 768000
>   pfn_end    : 770000
> mem_map (238)
>   mem_map    : ffffea001a080000
>   pfn_start  : 770000
>   pfn_end    : 778000
> mem_map (239)
>   mem_map    : ffffea001a240000
>   pfn_start  : 778000
>   pfn_end    : 780000
> mem_map (240)
>   mem_map    : ffffea001a400000
>   pfn_start  : 780000
>   pfn_end    : 788000
> mem_map (241)
>   mem_map    : ffffea001a5c0000
>   pfn_start  : 788000
>   pfn_end    : 790000
> mem_map (242)
>   mem_map    : ffffea001a780000
>   pfn_start  : 790000
>   pfn_end    : 798000
> mem_map (243)
>   mem_map    : ffffea001a940000
>   pfn_start  : 798000
>   pfn_end    : 7a0000
> mem_map (244)
>   mem_map    : ffffea001ab00000
>   pfn_start  : 7a0000
>   pfn_end    : 7a8000
> mem_map (245)
>   mem_map    : ffffea001acc0000
>   pfn_start  : 7a8000
>   pfn_end    : 7b0000
> mem_map (246)
>   mem_map    : ffffea001ae80000
>   pfn_start  : 7b0000
>   pfn_end    : 7b8000
> mem_map (247)
>   mem_map    : ffffea001b040000
>   pfn_start  : 7b8000
>   pfn_end    : 7c0000
> mem_map (248)
>   mem_map    : ffffea001b200000
>   pfn_start  : 7c0000
>   pfn_end    : 7c8000
> mem_map (249)
>   mem_map    : ffffea001b3c0000
>   pfn_start  : 7c8000
>   pfn_end    : 7d0000
> mem_map (250)
>   mem_map    : ffffea001b580000
>   pfn_start  : 7d0000
>   pfn_end    : 7d8000
> mem_map (251)
>   mem_map    : ffffea001b740000
>   pfn_start  : 7d8000
>   pfn_end    : 7e0000
> mem_map (252)
>   mem_map    : ffffea001b900000
>   pfn_start  : 7e0000
>   pfn_end    : 7e8000
> mem_map (253)
>   mem_map    : ffffea001bac0000
>   pfn_start  : 7e8000
>   pfn_end    : 7f0000
> mem_map (254)
>   mem_map    : ffffea001bc80000
>   pfn_start  : 7f0000
>   pfn_end    : 7f8000
> mem_map (255)
>   mem_map    : ffffea001be40000
>   pfn_start  : 7f8000
>   pfn_end    : 800000
> mem_map (256)
>   mem_map    : ffffea001c000000
>   pfn_start  : 800000
>   pfn_end    : 808000
> mem_map (257)
>   mem_map    : ffffea001c1c0000
>   pfn_start  : 808000
>   pfn_end    : 810000
> mem_map (258)
>   mem_map    : ffffea001c380000
>   pfn_start  : 810000
>   pfn_end    : 818000
> mem_map (259)
>   mem_map    : ffffea001c540000
>   pfn_start  : 818000
>   pfn_end    : 820000
> mem_map (260)
>   mem_map    : ffffea001c700000
>   pfn_start  : 820000
>   pfn_end    : 828000
> mem_map (261)
>   mem_map    : ffffea001c8c0000
>   pfn_start  : 828000
>   pfn_end    : 830000
> mem_map (262)
>   mem_map    : ffffea001ca80000
>   pfn_start  : 830000
>   pfn_end    : 838000
> mem_map (263)
>   mem_map    : ffffea001cc40000
>   pfn_start  : 838000
>   pfn_end    : 840000
> mem_map (264)
>   mem_map    : ffffea001ce00000
>   pfn_start  : 840000
>   pfn_end    : 848000
> mem_map (265)
>   mem_map    : ffffea001cfc0000
>   pfn_start  : 848000
>   pfn_end    : 850000
> mem_map (266)
>   mem_map    : ffffea001d180000
>   pfn_start  : 850000
>   pfn_end    : 858000
> mem_map (267)
>   mem_map    : ffffea001d340000
>   pfn_start  : 858000
>   pfn_end    : 860000
> mem_map=0DExcluding unnecessary pages        : [  0 %] =0DExcluding unnec=
essary pages        : [  3 %] =0DExcluding unnecessary pages        : [ 17 =
%] =0DExcluding unnecessary pages        : [ 26 %] =0DExcluding unnecessary=
 pages        : [ 34 %] =0DExcluding unnecessary pages        : [ 42 %] =0D=
Excluding unnecessary pages        : [ 50 %] =0DExcluding unnecessary pages=
        : [ 59 %] =0DExcluding unnecessary pages        : [ 67 %] =0DExclud=
ing unnecessary pages        : [ 75 %] =0DExcluding unnecessary pages      =
  : [ 84 %] =0DExcluding unnecessary pages        : [ 92 %] =0DExcluding un=
necessary pages        : [100 %] =0DExcluding unnecessary pages        : [ =
 0 %] =0DExcluding unnecessary pages        : [ 13 %] =0DExcluding unnecess=
ary pages        : [ 22 %] =0DExcluding unnecessary pages        : [ 30 %] =
=0DExcluding unnecessary pages        : [ 38 %] =0DExcluding unnecessary pa=
ges        : [ 47 %] =0DExcluding unnecessary pages        : [ 55 %] =0DExc=
luding unnecessary pages        : [ 63 %] =0DExcluding unnecessary pages   =
     : [ 71 %] =0DExcluding unnecessary pages        : [ 80 %] =0DExcluding=
 unnecessary pages        : [ 88 %] =0DExcluding unnecessary pages        :=
 [ 96 %] =0DExcluding unnecessary pages        : [100 %]=20
>  (268)
>   mem_map    : ffffea001d500000
>   pfn_start  : 860000
>   pfn_end    : 868000
> mem_map (269)
>   mem_map    : ffffea001d6c0000
>   pfn_start  : 868000
>   pfn_end    : 870000
> mem_map (270)
>   mem_map    : ffffea001d880000
>   pfn_start  : 870000
>   pfn_end    : 878000
> mem_map (271)
>   mem_map    : ffffea001da40000
>   pfn_start  : 878000
>   pfn_end    : 880000
> STEP [Excluding unnecessary pages] : 11.224292 seconds
> STEP [Excluding unnecessary pages] : 11.250834 seconds
> STEP [Copying data               ] : 11.407836 seconds
> Writing erase info...
> offset_eraseinfo: 6c0eb8, size_eraseinfo: 0
>=20
> Original pages  : 0x00000000007ec289
>   Excluded pages   : 0x00000000007b9efb
>     Pages filled with zero  : 0x0000000000000000
>     Cache pages             : 0x0000000000012cff
>     Cache pages + private   : 0x0000000000012015
>     User process data pages : 0x0000000000001ece
>     Free pages              : 0x0000000000793319
>   Remaining pages  : 0x000000000003238e
>   (The number of pages is reduced to 2%.)
> Memory Hole     : 0x0000000000093d77
> --------------------------------------------------
> Total pages     : 0x0000000000880000
>=20
>=20
> The dumpfile is saved to /mnt///127.0.0.1-2012-12-07-16:45:20/vmcore-empt=
y-1.
>=20
> makedumpfile Completed.
> [ perf record: Woken up 55 times to write data ]
> [ perf record: Captured and wrote 13.735 MB /mnt///127.0.0.1-2012-12-07-1=
6:45:20/perf.data1 (~600084 samples) ]

> sadump: does not have partition header
> sadump: read dump device as unknown format
> sadump: unknown format
> LOAD (0)
>   phys_start : 1000000
>   phys_end   : 22f1000
>   virt_start : ffffffff81000000
>   virt_end   : ffffffff822f1000
> LOAD (1)
>   phys_start : 10000
>   phys_end   : 9b000
>   virt_start : ffff880000010000
>   virt_end   : ffff88000009b000
> LOAD (2)
>   phys_start : 100000
>   phys_end   : 27000000
>   virt_start : ffff880000100000
>   virt_end   : ffff880027000000
> LOAD (3)
>   phys_start : 37000000
>   phys_end   : 7b00d000
>   virt_start : ffff880037000000
>   virt_end   : ffff88007b00d000
> LOAD (4)
>   phys_start : 100000000
>   phys_end   : 880000000
>   virt_start : ffff880100000000
>   virt_end   : ffff880880000000
> Linux kdump
> page_size    : 4096
> page_size    : 4096
>=20
> max_mapnr    : 880000
>=20
> Buffer size for the cyclic mode: 2228224
>=20
> num of NODEs : 4
>=20
>=20
> Memory type  : SPARSEMEM_EX
>=20
> mem_map (0)
>   mem_map    : ffffea0000000000
>   pfn_start  : 0
>   pfn_end    : 8000
> mem_map (1)
>   mem_map    : ffffea00001c0000
>   pfn_start  : 8000
>   pfn_end    : 10000
> mem_map (2)
>   mem_map    : ffffea0000380000
>   pfn_start  : 10000
>   pfn_end    : 18000
> mem_map (3)
>   mem_map    : ffffea0000540000
>   pfn_start  : 18000
>   pfn_end    : 20000
> mem_map (4)
>   mem_map    : ffffea0000700000
>   pfn_start  : 20000
>   pfn_end    : 28000
> mem_map (5)
>   mem_map    : ffffea00008c0000
>   pfn_start  : 28000
>   pfn_end    : 30000
> mem_map (6)
>   mem_map    : ffffea0000a80000
>   pfn_start  : 30000
>   pfn_end    : 38000
> mem_map (7)
>   mem_map    : ffffea0000c40000
>   pfn_start  : 38000
>   pfn_end    : 40000
> mem_map (8)
>   mem_map    : ffffea0000e00000
>   pfn_start  : 40000
>   pfn_end    : 48000
> mem_map (9)
>   mem_map    : ffffea0000fc0000
>   pfn_start  : 48000
>   pfn_end    : 50000
> mem_map (10)
>   mem_map    : ffffea0001180000
>   pfn_start  : 50000
>   pfn_end    : 58000
> mem_map (11)
>   mem_map    : ffffea0001340000
>   pfn_start  : 58000
>   pfn_end    : 60000
> mem_map (12)
>   mem_map    : ffffea0001500000
>   pfn_start  : 60000
>   pfn_end    : 68000
> mem_map (13)
>   mem_map    : ffffea00016c0000
>   pfn_start  : 68000
>   pfn_end    : 70000
> mem_map (14)
>   mem_map    : ffffea0001880000
>   pfn_start  : 70000
>   pfn_end    : 78000
> mem_map (15)
>   mem_map    : ffffea0001a40000
>   pfn_start  : 78000
>   pfn_end    : 80000
> mem_map (16)
>   mem_map    : 0
>   pfn_start  : 80000
>   pfn_end    : 88000
> mem_map (17)
>   mem_map    : 0
>   pfn_start  : 88000
>   pfn_end    : 90000
> mem_map (18)
>   mem_map    : 0
>   pfn_start  : 90000
>   pfn_end    : 98000
> mem_map (19)
>   mem_map    : 0
>   pfn_start  : 98000
>   pfn_end    : a0000
> mem_map (20)
>   mem_map    : 0
>   pfn_start  : a0000
>   pfn_end    : a8000
> mem_map (21)
>   mem_map    : 0
>   pfn_start  : a8000
>   pfn_end    : b0000
> mem_map (22)
>   mem_map    : 0
>   pfn_start  : b0000
>   pfn_end    : b8000
> mem_map (23)
>   mem_map    : 0
>   pfn_start  : b8000
>   pfn_end    : c0000
> mem_map (24)
>   mem_map    : 0
>   pfn_start  : c0000
>   pfn_end    : c8000
> mem_map (25)
>   mem_map    : 0
>   pfn_start  : c8000
>   pfn_end    : d0000
> mem_map (26)
>   mem_map    : 0
>   pfn_start  : d0000
>   pfn_end    : d8000
> mem_map (27)
>   mem_map    : 0
>   pfn_start  : d8000
>   pfn_end    : e0000
> mem_map (28)
>   mem_map    : 0
>   pfn_start  : e0000
>   pfn_end    : e8000
> mem_map (29)
>   mem_map    : 0
>   pfn_start  : e8000
>   pfn_end    : f0000
> mem_map (30)
>   mem_map    : 0
>   pfn_start  : f0000
>   pfn_end    : f8000
> mem_map (31)
>   mem_map    : 0
>   pfn_start  : f8000
>   pfn_end    : 100000
> mem_map (32)
>   mem_map    : ffffea0003800000
>   pfn_start  : 100000
>   pfn_end    : 108000
> mem_map (33)
>   mem_map    : ffffea00039c0000
>   pfn_start  : 108000
>   pfn_end    : 110000
> mem_map (34)
>   mem_map    : ffffea0003b80000
>   pfn_start  : 110000
>   pfn_end    : 118000
> mem_map (35)
>   mem_map    : ffffea0003d40000
>   pfn_start  : 118000
>   pfn_end    : 120000
> mem_map (36)
>   mem_map    : ffffea0003f00000
>   pfn_start  : 120000
>   pfn_end    : 128000
> mem_map (37)
>   mem_map    : ffffea00040c0000
>   pfn_start  : 128000
>   pfn_end    : 130000
> mem_map (38)
>   mem_map    : ffffea0004280000
>   pfn_start  : 130000
>   pfn_end    : 138000
> mem_map (39)
>   mem_map    : ffffea0004440000
>   pfn_start  : 138000
>   pfn_end    : 140000
> mem_map (40)
>   mem_map    : ffffea0004600000
>   pfn_start  : 140000
>   pfn_end    : 148000
> mem_map (41)
>   mem_map    : ffffea00047c0000
>   pfn_start  : 148000
>   pfn_end    : 150000
> mem_map (42)
>   mem_map    : ffffea0004980000
>   pfn_start  : 150000
>   pfn_end    : 158000
> mem_map (43)
>   mem_map    : ffffea0004b40000
>   pfn_start  : 158000
>   pfn_end    : 160000
> mem_map (44)
>   mem_map    : ffffea0004d00000
>   pfn_start  : 160000
>   pfn_end    : 168000
> mem_map (45)
>   mem_map    : ffffea0004ec0000
>   pfn_start  : 168000
>   pfn_end    : 170000
> mem_map (46)
>   mem_map    : ffffea0005080000
>   pfn_start  : 170000
>   pfn_end    : 178000
> mem_map (47)
>   mem_map    : ffffea0005240000
>   pfn_start  : 178000
>   pfn_end    : 180000
> mem_map (48)
>   mem_map    : ffffea0005400000
>   pfn_start  : 180000
>   pfn_end    : 188000
> mem_map (49)
>   mem_map    : ffffea00055c0000
>   pfn_start  : 188000
>   pfn_end    : 190000
> mem_map (50)
>   mem_map    : ffffea0005780000
>   pfn_start  : 190000
>   pfn_end    : 198000
> mem_map (51)
>   mem_map    : ffffea0005940000
>   pfn_start  : 198000
>   pfn_end    : 1a0000
> mem_map (52)
>   mem_map    : ffffea0005b00000
>   pfn_start  : 1a0000
>   pfn_end    : 1a8000
> mem_map (53)
>   mem_map    : ffffea0005cc0000
>   pfn_start  : 1a8000
>   pfn_end    : 1b0000
> mem_map (54)
>   mem_map    : ffffea0005e80000
>   pfn_start  : 1b0000
>   pfn_end    : 1b8000
> mem_map (55)
>   mem_map    : ffffea0006040000
>   pfn_start  : 1b8000
>   pfn_end    : 1c0000
> mem_map (56)
>   mem_map    : ffffea0006200000
>   pfn_start  : 1c0000
>   pfn_end    : 1c8000
> mem_map (57)
>   mem_map    : ffffea00063c0000
>   pfn_start  : 1c8000
>   pfn_end    : 1d0000
> mem_map (58)
>   mem_map    : ffffea0006580000
>   pfn_start  : 1d0000
>   pfn_end    : 1d8000
> mem_map (59)
>   mem_map    : ffffea0006740000
>   pfn_start  : 1d8000
>   pfn_end    : 1e0000
> mem_map (60)
>   mem_map    : ffffea0006900000
>   pfn_start  : 1e0000
>   pfn_end    : 1e8000
> mem_map (61)
>   mem_map    : ffffea0006ac0000
>   pfn_start  : 1e8000
>   pfn_end    : 1f0000
> mem_map (62)
>   mem_map    : ffffea0006c80000
>   pfn_start  : 1f0000
>   pfn_end    : 1f8000
> mem_map (63)
>   mem_map    : ffffea0006e40000
>   pfn_start  : 1f8000
>   pfn_end    : 200000
> mem_map (64)
>   mem_map    : ffffea0007000000
>   pfn_start  : 200000
>   pfn_end    : 208000
> mem_map (65)
>   mem_map    : ffffea00071c0000
>   pfn_start  : 208000
>   pfn_end    : 210000
> mem_map (66)
>   mem_map    : ffffea0007380000
>   pfn_start  : 210000
>   pfn_end    : 218000
> mem_map (67)
>   mem_map    : ffffea0007540000
>   pfn_start  : 218000
>   pfn_end    : 220000
> mem_map (68)
>   mem_map    : ffffea0007700000
>   pfn_start  : 220000
>   pfn_end    : 228000
> mem_map (69)
>   mem_map    : ffffea00078c0000
>   pfn_start  : 228000
>   pfn_end    : 230000
> mem_map (70)
>   mem_map    : ffffea0007a80000
>   pfn_start  : 230000
>   pfn_end    : 238000
> mem_map (71)
>   mem_map    : ffffea0007c40000
>   pfn_start  : 238000
>   pfn_end    : 240000
> mem_map (72)
>   mem_map    : ffffea0007e00000
>   pfn_start  : 240000
>   pfn_end    : 248000
> mem_map (73)
>   mem_map    : ffffea0007fc0000
>   pfn_start  : 248000
>   pfn_end    : 250000
> mem_map (74)
>   mem_map    : ffffea0008180000
>   pfn_start  : 250000
>   pfn_end    : 258000
> mem_map (75)
>   mem_map    : ffffea0008340000
>   pfn_start  : 258000
>   pfn_end    : 260000
> mem_map (76)
>   mem_map    : ffffea0008500000
>   pfn_start  : 260000
>   pfn_end    : 268000
> mem_map (77)
>   mem_map    : ffffea00086c0000
>   pfn_start  : 268000
>   pfn_end    : 270000
> mem_map (78)
>   mem_map    : ffffea0008880000
>   pfn_start  : 270000
>   pfn_end    : 278000
> mem_map (79)
>   mem_map    : ffffea0008a40000
>   pfn_start  : 278000
>   pfn_end    : 280000
> mem_map (80)
>   mem_map    : ffffea0008c00000
>   pfn_start  : 280000
>   pfn_end    : 288000
> mem_map (81)
>   mem_map    : ffffea0008dc0000
>   pfn_start  : 288000
>   pfn_end    : 290000
> mem_map (82)
>   mem_map    : ffffea0008f80000
>   pfn_start  : 290000
>   pfn_end    : 298000
> mem_map (83)
>   mem_map    : ffffea0009140000
>   pfn_start  : 298000
>   pfn_end    : 2a0000
> mem_map (84)
>   mem_map    : ffffea0009300000
>   pfn_start  : 2a0000
>   pfn_end    : 2a8000
> mem_map (85)
>   mem_map    : ffffea00094c0000
>   pfn_start  : 2a8000
>   pfn_end    : 2b0000
> mem_map (86)
>   mem_map    : ffffea0009680000
>   pfn_start  : 2b0000
>   pfn_end    : 2b8000
> mem_map (87)
>   mem_map    : ffffea0009840000
>   pfn_start  : 2b8000
>   pfn_end    : 2c0000
> mem_map (88)
>   mem_map    : ffffea0009a00000
>   pfn_start  : 2c0000
>   pfn_end    : 2c8000
> mem_map (89)
>   mem_map    : ffffea0009bc0000
>   pfn_start  : 2c8000
>   pfn_end    : 2d0000
> mem_map (90)
>   mem_map    : ffffea0009d80000
>   pfn_start  : 2d0000
>   pfn_end    : 2d8000
> mem_map (91)
>   mem_map    : ffffea0009f40000
>   pfn_start  : 2d8000
>   pfn_end    : 2e0000
> mem_map (92)
>   mem_map    : ffffea000a100000
>   pfn_start  : 2e0000
>   pfn_end    : 2e8000
> mem_map (93)
>   mem_map    : ffffea000a2c0000
>   pfn_start  : 2e8000
>   pfn_end    : 2f0000
> mem_map (94)
>   mem_map    : ffffea000a480000
>   pfn_start  : 2f0000
>   pfn_end    : 2f8000
> mem_map (95)
>   mem_map    : ffffea000a640000
>   pfn_start  : 2f8000
>   pfn_end    : 300000
> mem_map (96)
>   mem_map    : ffffea000a800000
>   pfn_start  : 300000
>   pfn_end    : 308000
> mem_map (97)
>   mem_map    : ffffea000a9c0000
>   pfn_start  : 308000
>   pfn_end    : 310000
> mem_map (98)
>   mem_map    : ffffea000ab80000
>   pfn_start  : 310000
>   pfn_end    : 318000
> mem_map (99)
>   mem_map    : ffffea000ad40000
>   pfn_start  : 318000
>   pfn_end    : 320000
> mem_map (100)
>   mem_map    : ffffea000af00000
>   pfn_start  : 320000
>   pfn_end    : 328000
> mem_map (101)
>   mem_map    : ffffea000b0c0000
>   pfn_start  : 328000
>   pfn_end    : 330000
> mem_map (102)
>   mem_map    : ffffea000b280000
>   pfn_start  : 330000
>   pfn_end    : 338000
> mem_map (103)
>   mem_map    : ffffea000b440000
>   pfn_start  : 338000
>   pfn_end    : 340000
> mem_map (104)
>   mem_map    : ffffea000b600000
>   pfn_start  : 340000
>   pfn_end    : 348000
> mem_map (105)
>   mem_map    : ffffea000b7c0000
>   pfn_start  : 348000
>   pfn_end    : 350000
> mem_map (106)
>   mem_map    : ffffea000b980000
>   pfn_start  : 350000
>   pfn_end    : 358000
> mem_map (107)
>   mem_map    : ffffea000bb40000
>   pfn_start  : 358000
>   pfn_end    : 360000
> mem_map (108)
>   mem_map    : ffffea000bd00000
>   pfn_start  : 360000
>   pfn_end    : 368000
> mem_map (109)
>   mem_map    : ffffea000bec0000
>   pfn_start  : 368000
>   pfn_end    : 370000
> mem_map (110)
>   mem_map    : ffffea000c080000
>   pfn_start  : 370000
>   pfn_end    : 378000
> mem_map (111)
>   mem_map    : ffffea000c240000
>   pfn_start  : 378000
>   pfn_end    : 380000
> mem_map (112)
>   mem_map    : ffffea000c400000
>   pfn_start  : 380000
>   pfn_end    : 388000
> mem_map (113)
>   mem_map    : ffffea000c5c0000
>   pfn_start  : 388000
>   pfn_end    : 390000
> mem_map (114)
>   mem_map    : ffffea000c780000
>   pfn_start  : 390000
>   pfn_end    : 398000
> mem_map (115)
>   mem_map    : ffffea000c940000
>   pfn_start  : 398000
>   pfn_end    : 3a0000
> mem_map (116)
>   mem_map    : ffffea000cb00000
>   pfn_start  : 3a0000
>   pfn_end    : 3a8000
> mem_map (117)
>   mem_map    : ffffea000ccc0000
>   pfn_start  : 3a8000
>   pfn_end    : 3b0000
> mem_map (118)
>   mem_map    : ffffea000ce80000
>   pfn_start  : 3b0000
>   pfn_end    : 3b8000
> mem_map (119)
>   mem_map    : ffffea000d040000
>   pfn_start  : 3b8000
>   pfn_end    : 3c0000
> mem_map (120)
>   mem_map    : ffffea000d200000
>   pfn_start  : 3c0000
>   pfn_end    : 3c8000
> mem_map (121)
>   mem_map    : ffffea000d3c0000
>   pfn_start  : 3c8000
>   pfn_end    : 3d0000
> mem_map (122)
>   mem_map    : ffffea000d580000
>   pfn_start  : 3d0000
>   pfn_end    : 3d8000
> mem_map (123)
>   mem_map    : ffffea000d740000
>   pfn_start  : 3d8000
>   pfn_end    : 3e0000
> mem_map (124)
>   mem_map    : ffffea000d900000
>   pfn_start  : 3e0000
>   pfn_end    : 3e8000
> mem_map (125)
>   mem_map    : ffffea000dac0000
>   pfn_start  : 3e8000
>   pfn_end    : 3f0000
> mem_map (126)
>   mem_map    : ffffea000dc80000
>   pfn_start  : 3f0000
>   pfn_end    : 3f8000
> mem_map (127)
>   mem_map    : ffffea000de40000
>   pfn_start  : 3f8000
>   pfn_end    : 400000
> mem_map (128)
>   mem_map    : ffffea000e000000
>   pfn_start  : 400000
>   pfn_end    : 408000
> mem_map (129)
>   mem_map    : ffffea000e1c0000
>   pfn_start  : 408000
>   pfn_end    : 410000
> mem_map (130)
>   mem_map    : ffffea000e380000
>   pfn_start  : 410000
>   pfn_end    : 418000
> mem_map (131)
>   mem_map    : ffffea000e540000
>   pfn_start  : 418000
>   pfn_end    : 420000
> mem_map (132)
>   mem_map    : ffffea000e700000
>   pfn_start  : 420000
>   pfn_end    : 428000
> mem_map (133)
>   mem_map    : ffffea000e8c0000
>   pfn_start  : 428000
>   pfn_end    : 430000
> mem_map (134)
>   mem_map    : ffffea000ea80000
>   pfn_start  : 430000
>   pfn_end    : 438000
> mem_map (135)
>   mem_map    : ffffea000ec40000
>   pfn_start  : 438000
>   pfn_end    : 440000
> mem_map (136)
>   mem_map    : ffffea000ee00000
>   pfn_start  : 440000
>   pfn_end    : 448000
> mem_map (137)
>   mem_map    : ffffea000efc0000
>   pfn_start  : 448000
>   pfn_end    : 450000
> mem_map (138)
>   mem_map    : ffffea000f180000
>   pfn_start  : 450000
>   pfn_end    : 458000
> mem_map (139)
>   mem_map    : ffffea000f340000
>   pfn_start  : 458000
>   pfn_end    : 460000
> mem_map (140)
>   mem_map    : ffffea000f500000
>   pfn_start  : 460000
>   pfn_end    : 468000
> mem_map (141)
>   mem_map    : ffffea000f6c0000
>   pfn_start  : 468000
>   pfn_end    : 470000
> mem_map (142)
>   mem_map    : ffffea000f880000
>   pfn_start  : 470000
>   pfn_end    : 478000
> mem_map (143)
>   mem_map    : ffffea000fa40000
>   pfn_start  : 478000
>   pfn_end    : 480000
> mem_map (144)
>   mem_map    : ffffea000fc00000
>   pfn_start  : 480000
>   pfn_end    : 488000
> mem_map (145)
>   mem_map    : ffffea000fdc0000
>   pfn_start  : 488000
>   pfn_end    : 490000
> mem_map (146)
>   mem_map    : ffffea000ff80000
>   pfn_start  : 490000
>   pfn_end    : 498000
> mem_map (147)
>   mem_map    : ffffea0010140000
>   pfn_start  : 498000
>   pfn_end    : 4a0000
> mem_map (148)
>   mem_map    : ffffea0010300000
>   pfn_start  : 4a0000
>   pfn_end    : 4a8000
> mem_map (149)
>   mem_map    : ffffea00104c0000
>   pfn_start  : 4a8000
>   pfn_end    : 4b0000
> mem_map (150)
>   mem_map    : ffffea0010680000
>   pfn_start  : 4b0000
>   pfn_end    : 4b8000
> mem_map (151)
>   mem_map    : ffffea0010840000
>   pfn_start  : 4b8000
>   pfn_end    : 4c0000
> mem_map (152)
>   mem_map    : ffffea0010a00000
>   pfn_start  : 4c0000
>   pfn_end    : 4c8000
> mem_map (153)
>   mem_map    : ffffea0010bc0000
>   pfn_start  : 4c8000
>   pfn_end    : 4d0000
> mem_map (154)
>   mem_map    : ffffea0010d80000
>   pfn_start  : 4d0000
>   pfn_end    : 4d8000
> mem_map (155)
>   mem_map    : ffffea0010f40000
>   pfn_start  : 4d8000
>   pfn_end    : 4e0000
> mem_map (156)
>   mem_map    : ffffea0011100000
>   pfn_start  : 4e0000
>   pfn_end    : 4e8000
> mem_map (157)
>   mem_map    : ffffea00112c0000
>   pfn_start  : 4e8000
>   pfn_end    : 4f0000
> mem_map (158)
>   mem_map    : ffffea0011480000
>   pfn_start  : 4f0000
>   pfn_end    : 4f8000
> mem_map (159)
>   mem_map    : ffffea0011640000
>   pfn_start  : 4f8000
>   pfn_end    : 500000
> mem_map (160)
>   mem_map    : ffffea0011800000
>   pfn_start  : 500000
>   pfn_end    : 508000
> mem_map (161)
>   mem_map    : ffffea00119c0000
>   pfn_start  : 508000
>   pfn_end    : 510000
> mem_map (162)
>   mem_map    : ffffea0011b80000
>   pfn_start  : 510000
>   pfn_end    : 518000
> mem_map (163)
>   mem_map    : ffffea0011d40000
>   pfn_start  : 518000
>   pfn_end    : 520000
> mem_map (164)
>   mem_map    : ffffea0011f00000
>   pfn_start  : 520000
>   pfn_end    : 528000
> mem_map (165)
>   mem_map    : ffffea00120c0000
>   pfn_start  : 528000
>   pfn_end    : 530000
> mem_map (166)
>   mem_map    : ffffea0012280000
>   pfn_start  : 530000
>   pfn_end    : 538000
> mem_map (167)
>   mem_map    : ffffea0012440000
>   pfn_start  : 538000
>   pfn_end    : 540000
> mem_map (168)
>   mem_map    : ffffea0012600000
>   pfn_start  : 540000
>   pfn_end    : 548000
> mem_map (169)
>   mem_map    : ffffea00127c0000
>   pfn_start  : 548000
>   pfn_end    : 550000
> mem_map (170)
>   mem_map    : ffffea0012980000
>   pfn_start  : 550000
>   pfn_end    : 558000
> mem_map (171)
>   mem_map    : ffffea0012b40000
>   pfn_start  : 558000
>   pfn_end    : 560000
> mem_map (172)
>   mem_map    : ffffea0012d00000
>   pfn_start  : 560000
>   pfn_end    : 568000
> mem_map (173)
>   mem_map    : ffffea0012ec0000
>   pfn_start  : 568000
>   pfn_end    : 570000
> mem_map (174)
>   mem_map    : ffffea0013080000
>   pfn_start  : 570000
>   pfn_end    : 578000
> mem_map (175)
>   mem_map    : ffffea0013240000
>   pfn_start  : 578000
>   pfn_end    : 580000
> mem_map (176)
>   mem_map    : ffffea0013400000
>   pfn_start  : 580000
>   pfn_end    : 588000
> mem_map (177)
>   mem_map    : ffffea00135c0000
>   pfn_start  : 588000
>   pfn_end    : 590000
> mem_map (178)
>   mem_map    : ffffea0013780000
>   pfn_start  : 590000
>   pfn_end    : 598000
> mem_map (179)
>   mem_map    : ffffea0013940000
>   pfn_start  : 598000
>   pfn_end    : 5a0000
> mem_map (180)
>   mem_map    : ffffea0013b00000
>   pfn_start  : 5a0000
>   pfn_end    : 5a8000
> mem_map (181)
>   mem_map    : ffffea0013cc0000
>   pfn_start  : 5a8000
>   pfn_end    : 5b0000
> mem_map (182)
>   mem_map    : ffffea0013e80000
>   pfn_start  : 5b0000
>   pfn_end    : 5b8000
> mem_map (183)
>   mem_map    : ffffea0014040000
>   pfn_start  : 5b8000
>   pfn_end    : 5c0000
> mem_map (184)
>   mem_map    : ffffea0014200000
>   pfn_start  : 5c0000
>   pfn_end    : 5c8000
> mem_map (185)
>   mem_map    : ffffea00143c0000
>   pfn_start  : 5c8000
>   pfn_end    : 5d0000
> mem_map (186)
>   mem_map    : ffffea0014580000
>   pfn_start  : 5d0000
>   pfn_end    : 5d8000
> mem_map (187)
>   mem_map    : ffffea0014740000
>   pfn_start  : 5d8000
>   pfn_end    : 5e0000
> mem_map (188)
>   mem_map    : ffffea0014900000
>   pfn_start  : 5e0000
>   pfn_end    : 5e8000
> mem_map (189)
>   mem_map    : ffffea0014ac0000
>   pfn_start  : 5e8000
>   pfn_end    : 5f0000
> mem_map (190)
>   mem_map    : ffffea0014c80000
>   pfn_start  : 5f0000
>   pfn_end    : 5f8000
> mem_map (191)
>   mem_map    : ffffea0014e40000
>   pfn_start  : 5f8000
>   pfn_end    : 600000
> mem_map (192)
>   mem_map    : ffffea0015000000
>   pfn_start  : 600000
>   pfn_end    : 608000
> mem_map (193)
>   mem_map    : ffffea00151c0000
>   pfn_start  : 608000
>   pfn_end    : 610000
> mem_map (194)
>   mem_map    : ffffea0015380000
>   pfn_start  : 610000
>   pfn_end    : 618000
> mem_map (195)
>   mem_map    : ffffea0015540000
>   pfn_start  : 618000
>   pfn_end    : 620000
> mem_map (196)
>   mem_map    : ffffea0015700000
>   pfn_start  : 620000
>   pfn_end    : 628000
> mem_map (197)
>   mem_map    : ffffea00158c0000
>   pfn_start  : 628000
>   pfn_end    : 630000
> mem_map (198)
>   mem_map    : ffffea0015a80000
>   pfn_start  : 630000
>   pfn_end    : 638000
> mem_map (199)
>   mem_map    : ffffea0015c40000
>   pfn_start  : 638000
>   pfn_end    : 640000
> mem_map (200)
>   mem_map    : ffffea0015e00000
>   pfn_start  : 640000
>   pfn_end    : 648000
> mem_map (201)
>   mem_map    : ffffea0015fc0000
>   pfn_start  : 648000
>   pfn_end    : 650000
> mem_map (202)
>   mem_map    : ffffea0016180000
>   pfn_start  : 650000
>   pfn_end    : 658000
> mem_map (203)
>   mem_map    : ffffea0016340000
>   pfn_start  : 658000
>   pfn_end    : 660000
> mem_map (204)
>   mem_map    : ffffea0016500000
>   pfn_start  : 660000
>   pfn_end    : 668000
> mem_map (205)
>   mem_map    : ffffea00166c0000
>   pfn_start  : 668000
>   pfn_end    : 670000
> mem_map (206)
>   mem_map    : ffffea0016880000
>   pfn_start  : 670000
>   pfn_end    : 678000
> mem_map (207)
>   mem_map    : ffffea0016a40000
>   pfn_start  : 678000
>   pfn_end    : 680000
> mem_map (208)
>   mem_map    : ffffea0016c00000
>   pfn_start  : 680000
>   pfn_end    : 688000
> mem_map (209)
>   mem_map    : ffffea0016dc0000
>   pfn_start  : 688000
>   pfn_end    : 690000
> mem_map (210)
>   mem_map    : ffffea0016f80000
>   pfn_start  : 690000
>   pfn_end    : 698000
> mem_map (211)
>   mem_map    : ffffea0017140000
>   pfn_start  : 698000
>   pfn_end    : 6a0000
> mem_map (212)
>   mem_map    : ffffea0017300000
>   pfn_start  : 6a0000
>   pfn_end    : 6a8000
> mem_map (213)
>   mem_map    : ffffea00174c0000
>   pfn_start  : 6a8000
>   pfn_end    : 6b0000
> mem_map (214)
>   mem_map    : ffffea0017680000
>   pfn_start  : 6b0000
>   pfn_end    : 6b8000
> mem_map (215)
>   mem_map    : ffffea0017840000
>   pfn_start  : 6b8000
>   pfn_end    : 6c0000
> mem_map (216)
>   mem_map    : ffffea0017a00000
>   pfn_start  : 6c0000
>   pfn_end    : 6c8000
> mem_map (217)
>   mem_map    : ffffea0017bc0000
>   pfn_start  : 6c8000
>   pfn_end    : 6d0000
> mem_map (218)
>   mem_map    : ffffea0017d80000
>   pfn_start  : 6d0000
>   pfn_end    : 6d8000
> mem_map (219)
>   mem_map    : ffffea0017f40000
>   pfn_start  : 6d8000
>   pfn_end    : 6e0000
> mem_map (220)
>   mem_map    : ffffea0018100000
>   pfn_start  : 6e0000
>   pfn_end    : 6e8000
> mem_map (221)
>   mem_map    : ffffea00182c0000
>   pfn_start  : 6e8000
>   pfn_end    : 6f0000
> mem_map (222)
>   mem_map    : ffffea0018480000
>   pfn_start  : 6f0000
>   pfn_end    : 6f8000
> mem_map (223)
>   mem_map    : ffffea0018640000
>   pfn_start  : 6f8000
>   pfn_end    : 700000
> mem_map (224)
>   mem_map    : ffffea0018800000
>   pfn_start  : 700000
>   pfn_end    : 708000
> mem_map (225)
>   mem_map    : ffffea00189c0000
>   pfn_start  : 708000
>   pfn_end    : 710000
> mem_map (226)
>   mem_map    : ffffea0018b80000
>   pfn_start  : 710000
>   pfn_end    : 718000
> mem_map (227)
>   mem_map    : ffffea0018d40000
>   pfn_start  : 718000
>   pfn_end    : 720000
> mem_map (228)
>   mem_map    : ffffea0018f00000
>   pfn_start  : 720000
>   pfn_end    : 728000
> mem_map (229)
>   mem_map    : ffffea00190c0000
>   pfn_start  : 728000
>   pfn_end    : 730000
> mem_map (230)
>   mem_map    : ffffea0019280000
>   pfn_start  : 730000
>   pfn_end    : 738000
> mem_map (231)
>   mem_map    : ffffea0019440000
>   pfn_start  : 738000
>   pfn_end    : 740000
> mem_map (232)
>   mem_map    : ffffea0019600000
>   pfn_start  : 740000
>   pfn_end    : 748000
> mem_map (233)
>   mem_map    : ffffea00197c0000
>   pfn_start  : 748000
>   pfn_end    : 750000
> mem_map (234)
>   mem_map    : ffffea0019980000
>   pfn_start  : 750000
>   pfn_end    : 758000
> mem_map (235)
>   mem_map    : ffffea0019b40000
>   pfn_start  : 758000
>   pfn_end    : 760000
> mem_map (236)
>   mem_map    : ffffea0019d00000
>   pfn_start  : 760000
>   pfn_end    : 768000
> mem_map (237)
>   mem_map    : ffffea0019ec0000
>   pfn_start  : 768000
>   pfn_end    : 770000
> mem_map (238)
>   mem_map    : ffffea001a080000
>   pfn_start  : 770000
>   pfn_end    : 778000
> mem_map (239)
>   mem_map    : ffffea001a240000
>   pfn_start  : 778000
>   pfn_end    : 780000
> mem_map (240)
>   mem_map    : ffffea001a400000
>   pfn_start  : 780000
>   pfn_end    : 788000
> mem_map (241)
>   mem_map    : ffffea001a5c0000
>   pfn_start  : 788000
>   pfn_end    : 790000
> mem_map (242)
>   mem_map    : ffffea001a780000
>   pfn_start  : 790000
>   pfn_end    : 798000
> mem_map (243)
>   mem_map    : ffffea001a940000
>   pfn_start  : 798000
>   pfn_end    : 7a0000
> mem_map (244)
>   mem_map    : ffffea001ab00000
>   pfn_start  : 7a0000
>   pfn_end    : 7a8000
> mem_map (245)
>   mem_map    : ffffea001acc0000
>   pfn_start  : 7a8000
>   pfn_end    : 7b0000
> mem_map (246)
>   mem_map    : ffffea001ae80000
>   pfn_start  : 7b0000
>   pfn_end    : 7b8000
> mem_map (247)
>   mem_map    : ffffea001b040000
>   pfn_start  : 7b8000
>   pfn_end    : 7c0000
> mem_map (248)
>   mem_map    : ffffea001b200000
>   pfn_start  : 7c0000
>   pfn_end    : 7c8000
> mem_map (249)
>   mem_map    : ffffea001b3c0000
>   pfn_start  : 7c8000
>   pfn_end    : 7d0000
> mem_map (250)
>   mem_map    : ffffea001b580000
>   pfn_start  : 7d0000
>   pfn_end    : 7d8000
> mem_map (251)
>   mem_map    : ffffea001b740000
>   pfn_start  : 7d8000
>   pfn_end    : 7e0000
> mem_map (252)
>   mem_map    : ffffea001b900000
>   pfn_start  : 7e0000
>   pfn_end    : 7e8000
> mem_map (253)
>   mem_map    : ffffea001bac0000
>   pfn_start  : 7e8000
>   pfn_end    : 7f0000
> mem_map (254)
>   mem_map    : ffffea001bc80000
>   pfn_start  : 7f0000
>   pfn_end    : 7f8000
> mem_map (255)
>   mem_map    : ffffea001be40000
>   pfn_start  : 7f8000
>   pfn_end    : 800000
> mem_map (256)
>   mem_map    : ffffea001c000000
>   pfn_start  : 800000
>   pfn_end    : 808000
> mem_map (257)
>   mem_map    : ffffea001c1c0000
>   pfn_start  : 808000
>   pfn_end    : 810000
> mem_map (258)
>   mem_map    : ffffea001c380000
>   pfn_start  : 810000
>   pfn_end    : 818000
> mem_map (259)
>   mem_map    : ffffea001c540000
>   pfn_start  : 818000
>   pfn_end    : 820000
> mem_map (260)
>   mem_map    : ffffea001c700000
>   pfn_start  : 820000
>   pfn_end    : 828000
> mem_map (261)
>   mem_map    : ffffea001c8c0000
>   pfn_start  : 828000
>   pfn_end    : 830000
> mem_map (262)
>   mem_map    : ffffea001ca80000
>   pfn_start  : 830000
>   pfn_end    : 838000
> mem_map (263)
>   mem_map    : ffffea001cc40000
>   pfn_start  : 838000
>   pfn_end    : 840000
> mem_map (264)
>   mem_map    : ffffea001ce00000
>   pfn_start  : 840000
>   pfn_end    : 848000
> mem_map (265)
>   mem_map    : ffffea001cfc0000
>   pfn_start  : 848000
>   pfn_end    : 850000
> mem_map (266)
>   mem_map    : ffffea001d180000
>   pfn_start  : 850000
>   pfn_end    : 858000
> mem_map (267)
>   mem_map    : ffffea001d340000
>   pfn_start  : 858000
>   pfn_end    : 860000
> mem_map=0DExcluding unnecessary pages        : [  0 %] =0DExcluding unnec=
essary pages        : [100 %] =0DExcluding unnecessary pages        : [  0 =
%] =0DExcluding unnecessary pages        : [100 %]=20
>  (268)
>   mem_map    : ffffea001d500000
>   pfn_start  : 860000
>   pfn_end    : 868000
> mem_map (269)
>   mem_map    : ffffea001d6c0000
>   pfn_start  : 868000
>   pfn_end    : 870000
> mem_map (270)
>   mem_map    : ffffea001d880000
>   pfn_start  : 870000
>   pfn_end    : 878000
> mem_map (271)
>   mem_map    : ffffea001da40000
>   pfn_start  : 878000
>   pfn_end    : 880000
> STEP [Excluding unnecessary pages] : 0.438936 seconds
> STEP [Excluding unnecessary pages] : 0.467304 seconds
> STEP [Copying data               ] : 0.624328 seconds
> Writing erase info...
> offset_eraseinfo: 6c0eb8, size_eraseinfo: 0
>=20
> Original pages  : 0x00000000007ec289
>   Excluded pages   : 0x00000000007b9efb
>     Pages filled with zero  : 0x0000000000000000
>     Cache pages             : 0x0000000000012cff
>     Cache pages + private   : 0x0000000000012015
>     User process data pages : 0x0000000000001ece
>     Free pages              : 0x0000000000793319
>   Remaining pages  : 0x000000000003238e
>   (The number of pages is reduced to 2%.)
> Memory Hole     : 0x0000000000093d77
> --------------------------------------------------
> Total pages     : 0x0000000000880000
>=20
>=20
> The dumpfile is saved to /mnt///127.0.0.1-2012-12-07-16:45:20/vmcore-empt=
y-2.
>=20
> makedumpfile Completed.
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 0.598 MB /mnt///127.0.0.1-2012-12-07-16=
:45:20/perf.data2 (~26144 samples) ]

> Failed to open [ext4], continuing without symbols
> No kallsyms or vmlinux with build-id a77a2293aab413880b8b361bb5b863a1680c=
8eab was found
> [qla2xxx] with build id a77a2293aab413880b8b361bb5b863a1680c8eab not foun=
d, continuing without symbols
> Failed to open [dm_mirror], continuing without symbols
> No kallsyms or vmlinux with build-id 8e4a472eadb14fb0cde985ef8571b5438804=
72dd was found
> [megaraid_sas] with build id 8e4a472eadb14fb0cde985ef8571b543880472dd not=
 found, continuing without symbols
> No kallsyms or vmlinux with build-id 93346fc362be38e207aeaae310a339fb502d=
9acb was found
> [jbd2] with build id 93346fc362be38e207aeaae310a339fb502d9acb not found, =
continuing without symbols
> # =3D=3D=3D=3D=3D=3D=3D=3D
> # captured on: Fri Dec  7 16:45:43 2012
> # hostname : (none)
> # os release : 3.7.0-rc8-cliff-bench+
> # perf version : 3.7.rc8.3.ge0fb22
> # arch : x86_64
> # nrcpus online : 1
> # nrcpus avail : 1
> # cpudesc : Intel(R) Xeon(R) CPU E7- 4820 @ 2.00GHz
> # cpuid : GenuineIntel,6,47,2
> # total memory : 240104 kB
> # cmdline : /var/crash/perf record -g -o /mnt///127.0.0.1-2012-12-07-16:4=
5:20/perf.data1 /var/crash/makedumpfile-cliff --message-level 31 -i /var/cr=
ash/vmcoreinfo.txt -N -o -d 31 /proc/vmcore /mnt///127.0.0.1-2012-12-07-16:=
45:20/vmcore-empty-1=20
> # event : name =3D cycles, type =3D 0, config =3D 0x0, config1 =3D 0x0, c=
onfig2 =3D 0x0, excl_usr =3D 0, excl_kern =3D 0, excl_host =3D 0, excl_gues=
t =3D 1, precise_ip =3D 0, id =3D { 2 }
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # pmu mappings: cpu =3D 4, software =3D 1, tracepoint =3D 2, uncore_bbox_=
0 =3D 15, uncore_bbox_1 =3D 16, uncore_cbox_0 =3D 7, uncore_cbox_1 =3D 8, u=
ncore_cbox_2 =3D 9, uncore_cbox_3 =3D 10, uncore_cbox_4 =3D 11, uncore_cbox=
_5 =3D 12, uncore_cbox_6 =3D 13, uncore_cbox_7 =3D 14, uncore_mbox_0 =3D 19=
, uncore_mbox_1 =3D 20, uncore_rbox_0 =3D 21, uncore_rbox_1 =3D 22, uncore_=
sbox_0 =3D 17, uncore_sbox_1 =3D 18, breakpoint =3D 5, uncore_ubox =3D 6, u=
ncore_wbox =3D 23
> # =3D=3D=3D=3D=3D=3D=3D=3D
> #
> # Samples: 91K of event 'cycles'
> # Event count (approx.): 23676246537
> #
> # Overhead          Command         Shared Object
> # ........  ...............  ....................
> #
>     90.38%  makedumpfile-cl  [kernel.kallsyms]  =20
>             |         =20
>             |--19.73%-- __purge_vmap_area_lazy
>             |          |         =20
>             |          |--80.50%-- free_vmap_area_noflush
>             |          |          free_unmap_vmap_area
>             |          |          remove_vm_area
>             |          |          iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--66.59%-- 0x0
>             |          |          |         =20
>             |          |           --33.41%-- 0x45524f4300000001
>             |          |         =20
>             |          |--19.43%-- vm_unmap_aliases
>             |          |          change_page_attr_set_clr
>             |          |          _set_memory_wb
>             |          |          ioremap_change_attr
>             |          |          kernel_map_sync_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |           --0.07%-- [...]
>             |         =20
>             |--15.58%-- try_preserve_large_page
>             |          |         =20
>             |          |--99.97%-- __change_page_attr
>             |          |          __change_page_attr_set_clr
>             |          |          change_page_attr_set_clr
>             |          |          _set_memory_wb
>             |          |          ioremap_change_attr
>             |          |          kernel_map_sync_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |           --0.03%-- [...]
>             |         =20
>             |--14.51%-- iomem_map_sanity_check
>             |          |         =20
>             |          |--99.97%-- __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--50.01%-- 0x6e6d2f0065726f63
>             |          |          |         =20
>             |          |           --49.99%-- 0x45524f4300000001
>             |           --0.03%-- [...]
>             |         =20
>             |--11.06%-- walk_system_ram_range
>             |          |         =20
>             |          |--64.71%-- pat_pagerange_is_ram
>             |          |          |         =20
>             |          |          |--50.87%-- free_memtype
>             |          |          |          iounmap
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |           --49.13%-- reserve_memtype
>             |          |                     __ioremap_caller
>             |          |                     ioremap_cache
>             |          |                     copy_oldmem_page
>             |          |                     read_from_oldmem
>             |          |                     read_vmcore
>             |          |                     proc_reg_read
>             |          |                     vfs_read
>             |          |                     sys_read
>             |          |                     system_call_fastpath
>             |          |                     __read_nocancel
>             |          |         =20
>             |          |--34.75%-- page_is_ram
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |           --0.54%-- [...]
>             |         =20
>             |--4.84%-- __phys_addr
>             |          |         =20
>             |          |--52.48%-- __change_page_attr
>             |          |          __change_page_attr_set_clr
>             |          |          change_page_attr_set_clr
>             |          |          _set_memory_wb
>             |          |          ioremap_change_attr
>             |          |          kernel_map_sync_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |          |--45.72%-- try_preserve_large_page
>             |          |          __change_page_attr
>             |          |          __change_page_attr_set_clr
>             |          |          change_page_attr_set_clr
>             |          |          _set_memory_wb
>             |          |          ioremap_change_attr
>             |          |          kernel_map_sync_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |           --1.80%-- [...]
>             |         =20
>             |--4.82%-- __get_vm_area_node
>             |          |         =20
>             |          |--99.70%-- get_vm_area_caller
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |           --100.00%-- 0x0
>             |           --0.30%-- [...]
>             |         =20
>             |--4.13%-- iounmap
>             |          |         =20
>             |          |--99.59%-- copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--50.39%-- 0x45524f4300000001
>             |          |          |         =20
>             |          |           --49.61%-- 0x0
>             |           --0.41%-- [...]
>             |         =20
>             |--3.60%-- read_vmcore
>             |          |         =20
>             |          |--99.83%-- proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |           --0.17%-- [...]
>             |         =20
>             |--2.24%-- copy_user_generic_string
>             |          read_from_oldmem
>             |          read_vmcore
>             |          proc_reg_read
>             |          vfs_read
>             |          sys_read
>             |          system_call_fastpath
>             |          __read_nocancel
>             |         =20
>             |--1.92%-- remove_vm_area
>             |          |         =20
>             |          |--99.31%-- iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |           --100.00%-- 0x0
>             |          |         =20
>             |           --0.69%-- copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--1.82%-- do_kernel_range_flush
>             |          |         =20
>             |          |--99.20%-- on_each_cpu
>             |          |          flush_tlb_kernel_range
>             |          |          __purge_vmap_area_lazy
>             |          |          free_vmap_area_noflush
>             |          |          free_unmap_vmap_area
>             |          |          remove_vm_area
>             |          |          iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --0.80%-- flush_tlb_kernel_range
>             |                     __purge_vmap_area_lazy
>             |                     free_vmap_area_noflush
>             |                     free_unmap_vmap_area
>             |                     remove_vm_area
>             |                     iounmap
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--1.01%-- rbt_memtype_erase
>             |          |         =20
>             |          |--96.66%-- free_memtype
>             |          |          iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --3.34%-- iounmap
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.87%-- kfree
>             |          |         =20
>             |          |--55.52%-- free_memtype
>             |          |          iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |          |--29.00%-- iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |          |--12.42%-- rcu_do_batch
>             |          |          __rcu_process_callbacks
>             |          |          rcu_process_callbacks
>             |          |          __do_softirq
>             |          |          call_softirq
>             |          |          do_softirq
>             |          |          irq_exit
>             |          |          smp_apic_timer_interrupt
>             |          |          apic_timer_interrupt
>             |          |          |         =20
>             |          |          |--20.23%-- free_vmap_area_noflush
>             |          |          |          free_unmap_vmap_area
>             |          |          |          remove_vm_area
>             |          |          |          iounmap
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--19.11%-- __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--16.82%-- __change_page_attr
>             |          |          |          __change_page_attr_set_clr
>             |          |          |          change_page_attr_set_clr
>             |          |          |          _set_memory_wb
>             |          |          |          ioremap_change_attr
>             |          |          |          kernel_map_sync_memtype
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--6.75%-- pat_pagerange_is_ram
>             |          |          |          |         =20
>             |          |          |          |--66.67%-- reserve_memtype
>             |          |          |          |          __ioremap_caller
>             |          |          |          |          ioremap_cache
>             |          |          |          |          copy_oldmem_page
>             |          |          |          |          read_from_oldmem
>             |          |          |          |          read_vmcore
>             |          |          |          |          proc_reg_read
>             |          |          |          |          vfs_read
>             |          |          |          |          sys_read
>             |          |          |          |          system_call_fastp=
ath
>             |          |          |          |          __read_nocancel
>             |          |          |          |         =20
>             |          |          |           --33.33%-- free_memtype
>             |          |          |                     iounmap
>             |          |          |                     copy_oldmem_page
>             |          |          |                     read_from_oldmem
>             |          |          |                     read_vmcore
>             |          |          |                     proc_reg_read
>             |          |          |                     vfs_read
>             |          |          |                     sys_read
>             |          |          |                     system_call_fastp=
ath
>             |          |          |                     __read_nocancel
>             |          |          |         =20
>             |          |          |--5.62%-- vm_unmap_aliases
>             |          |          |          change_page_attr_set_clr
>             |          |          |          _set_memory_wb
>             |          |          |          ioremap_change_attr
>             |          |          |          kernel_map_sync_memtype
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--4.50%-- proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--4.49%-- copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--3.37%-- get_vm_area_caller
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--3.37%-- readmem
>             |          |          |         =20
>             |          |          |--2.25%-- page_is_ram
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--2.25%-- __exclude_unnecessary_pages
>             |          |          |          exclude_unnecessary_pages_cy=
clic
>             |          |          |          writeout_dumpfile
>             |          |          |          0x7fff6c26de6d
>             |          |          |          0x64656b616d2f6873
>             |          |          |         =20
>             |          |          |--2.25%-- paddr_to_offset
>             |          |          |          exclude_unnecessary_pages_cy=
clic
>             |          |          |          |         =20
>             |          |          |           --100.00%-- writeout_dumpfi=
le
>             |          |          |                     0x7fff6c26de6d
>             |          |          |                     0x64656b616d2f6873
>             |          |          |         =20
>             |          |          |--1.13%-- try_preserve_large_page
>             |          |          |          __change_page_attr
>             |          |          |          __change_page_attr_set_clr
>             |          |          |          change_page_attr_set_clr
>             |          |          |          _set_memory_wb
>             |          |          |          ioremap_change_attr
>             |          |          |          kernel_map_sync_memtype
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- reserve_memtype
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- __lseek_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- proc_reg_llseek
>             |          |          |          vfs_llseek
>             |          |          |          sys_lseek
>             |          |          |          system_call_fastpath
>             |          |          |          __lseek_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- free_memtype
>             |          |          |          iounmap
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- on_each_cpu
>             |          |          |          flush_tlb_kernel_range
>             |          |          |          __purge_vmap_area_lazy
>             |          |          |          free_vmap_area_noflush
>             |          |          |          free_unmap_vmap_area
>             |          |          |          remove_vm_area
>             |          |          |          iounmap
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--1.12%-- __get_vm_area_node
>             |          |          |          get_vm_area_caller
>             |          |          |          __ioremap_caller
>             |          |          |          ioremap_cache
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |         =20
>             |          |           --1.12%-- vtop4_x86_64
>             |          |         =20
>             |          |--2.09%-- copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --0.98%-- __rcu_process_callbacks
>             |                     rcu_process_callbacks
>             |                     __do_softirq
>             |                     call_softirq
>             |                     do_softirq
>             |                     irq_exit
>             |                     smp_apic_timer_interrupt
>             |                     apic_timer_interrupt
>             |                     |         =20
>             |                     |--57.11%-- __change_page_attr
>             |                     |          __change_page_attr_set_clr
>             |                     |          change_page_attr_set_clr
>             |                     |          _set_memory_wb
>             |                     |          ioremap_change_attr
>             |                     |          kernel_map_sync_memtype
>             |                     |          __ioremap_caller
>             |                     |          ioremap_cache
>             |                     |          copy_oldmem_page
>             |                     |          read_from_oldmem
>             |                     |          read_vmcore
>             |                     |          proc_reg_read
>             |                     |          vfs_read
>             |                     |          sys_read
>             |                     |          system_call_fastpath
>             |                     |          __read_nocancel
>             |                     |         =20
>             |                     |--14.30%-- flush_tlb_kernel_range
>             |                     |          __purge_vmap_area_lazy
>             |                     |          free_vmap_area_noflush
>             |                     |          free_unmap_vmap_area
>             |                     |          remove_vm_area
>             |                     |          iounmap
>             |                     |          copy_oldmem_page
>             |                     |          read_from_oldmem
>             |                     |          read_vmcore
>             |                     |          proc_reg_read
>             |                     |          vfs_read
>             |                     |          sys_read
>             |                     |          system_call_fastpath
>             |                     |          __read_nocancel
>             |                     |         =20
>             |                     |--14.30%-- free_vmap_area_noflush
>             |                     |          free_unmap_vmap_area
>             |                     |          remove_vm_area
>             |                     |          iounmap
>             |                     |          copy_oldmem_page
>             |                     |          read_from_oldmem
>             |                     |          read_vmcore
>             |                     |          proc_reg_read
>             |                     |          vfs_read
>             |                     |          sys_read
>             |                     |          system_call_fastpath
>             |                     |          __read_nocancel
>             |                     |         =20
>             |                      --14.30%-- copy_oldmem_page
>             |                                read_from_oldmem
>             |                                read_vmcore
>             |                                proc_reg_read
>             |                                vfs_read
>             |                                sys_read
>             |                                system_call_fastpath
>             |                                __read_nocancel
>             |         =20
>             |--0.58%-- __insert_vmap_area
>             |          |         =20
>             |          |--98.32%-- alloc_vmap_area
>             |          |          __get_vm_area_node
>             |          |          get_vm_area_caller
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --1.68%-- __get_vm_area_node
>             |                     get_vm_area_caller
>             |                     __ioremap_caller
>             |                     ioremap_cache
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.57%-- kmem_cache_alloc_node_trace
>             |          |         =20
>             |          |--55.58%-- __get_vm_area_node
>             |          |          get_vm_area_caller
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |          |--41.85%-- alloc_vmap_area
>             |          |          __get_vm_area_node
>             |          |          get_vm_area_caller
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --2.56%-- get_vm_area_caller
>             |                     __ioremap_caller
>             |                     ioremap_cache
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.54%-- vfs_read
>             |          |         =20
>             |          |--98.21%-- sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |           --100.00%-- 0x0
>             |          |         =20
>             |           --1.79%-- system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.54%-- memtype_rb_check_conflict
>             |          |         =20
>             |          |--95.54%-- rbt_memtype_check_insert
>             |          |          reserve_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --4.46%-- reserve_memtype
>             |                     __ioremap_caller
>             |                     ioremap_cache
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.51%-- __mtrr_type_lookup
>             |          |         =20
>             |          |--96.91%-- mtrr_type_lookup
>             |          |          reserve_memtype
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |         =20
>             |           --3.09%-- reserve_memtype
>             |                     __ioremap_caller
>             |                     ioremap_cache
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>              --11.15%-- [...]
>=20
>      9.19%  makedumpfile-cl  makedumpfile-cliff =20
>             |         =20
>             |--37.97%-- __exclude_unnecessary_pages
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--18.73%-- set_bitmap_cyclic
>             |          |         =20
>             |           --100.00%-- exclude_unnecessary_pages_cyclic
>             |                     |         =20
>             |                      --100.00%-- writeout_dumpfile
>             |                                0x7fff6c26de6d
>             |                                0x64656b616d2f6873
>             |         =20
>             |--13.79%-- paddr_to_offset
>             |          |         =20
>             |           --100.00%-- exclude_unnecessary_pages_cyclic
>             |                     |         =20
>             |                      --100.00%-- writeout_dumpfile
>             |                                0x7fff6c26de6d
>             |                                0x64656b616d2f6873
>             |         =20
>             |--4.71%-- readmem
>             |          |         =20
>             |           --100.00%-- exclude_unnecessary_pages_cyclic
>             |                     writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--4.12%-- get_num_dumpable_cyclic
>             |         =20
>             |--2.90%-- is_in_same_page
>             |         =20
>             |--2.66%-- page_is_buddy_v3
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--2.37%-- clear_bit_on_2nd_bitmap_for_kernel
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--2.35%-- create_1st_bitmap_cyclic
>             |         =20
>             |--2.04%-- is_xen_memory
>             |          |         =20
>             |           --100.00%-- exclude_unnecessary_pages_cyclic
>             |                     |         =20
>             |                      --100.00%-- writeout_dumpfile
>             |                                0x7fff6c26de6d
>             |                                0x64656b616d2f6873
>             |         =20
>             |--2.02%-- vtop4_x86_64
>             |         =20
>             |--1.67%-- set_bit_on_1st_bitmap
>             |         =20
>             |--1.53%-- clear_bit_on_2nd_bitmap
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--1.25%-- write_kdump_pages_and_bitmap_cyclic
>             |          writeout_dumpfile
>             |          0x7fff6c26de6d
>             |          0x64656b616d2f6873
>             |         =20
>             |--1.15%-- update_cyclic_region
>             |         =20
>             |--0.66%-- vaddr_to_paddr_x86_64
>              --0.07%-- [...]
>=20
>      0.42%  makedumpfile-cl  libc.so.6          =20
>             |         =20
>             |--40.25%-- __lseek_nocancel
>             |         =20
>             |--36.91%-- __read_nocancel
>             |         =20
>             |--8.64%-- __GI___libc_read
>             |         =20
>             |--5.01%-- __memset_sse2
>             |          |         =20
>             |           --100.00%-- 0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--3.90%-- __GI___libc_lseek64
>             |         =20
>             |--3.72%-- memcpy
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff6c26de6d
>             |                     0x64656b616d2f6873
>             |         =20
>             |--0.53%-- memchr
>              --1.04%-- [...]
>=20
>      0.01%  makedumpfile-cl  ld-linux-x86-64.so.2
>             |         =20
>             |--49.69%-- strcmp
>             |          |         =20
>             |          |--67.41%-- 0x8922974
>             |          |          0x42494c4700342e33
>             |          |         =20
>             |           --32.59%-- 0x9691a75
>             |                     0x42494c4700352e32
>             |         =20
>             |--17.46%-- _dl_name_match_p
>             |          _dl_check_all_versions
>             |         =20
>             |--16.51%-- do_lookup_x
>             |         =20
>              --16.34%-- _dl_lookup_symbol_x
>                        _dl_relocate_object
>                        dl_main
>                        _dl_sysdep_start
>                        0x4156415741e58948
>=20
>      0.00%  makedumpfile-cl  libstdc++.so.6     =20
>             |
>             --- 0x37282bb470
>                 0x3728253b43
>                 0x7fff6c26de6d
>                 0x64656b616d2f6873
>=20
>      0.00%  makedumpfile-cl  [megaraid_sas]     =20
>             |
>             --- megasas_isr
>                 handle_irq_event_percpu
>                 handle_irq_event
>                 handle_edge_irq
>                 handle_irq
>                 do_IRQ
>                 ret_from_intr
>                 __exclude_unnecessary_pages
>                 exclude_unnecessary_pages_cyclic
>                 writeout_dumpfile
>                 0x7fff6c26de6d
>                 0x64656b616d2f6873
>=20
>      0.00%  makedumpfile-cl  [qla2xxx]          =20
>             |
>             --- qla24xx_mbx_completion
>                 qla24xx_msix_default
>                 handle_irq_event_percpu
>                 handle_irq_event
>                 handle_edge_irq
>                 handle_irq
>                 do_IRQ
>                 ret_from_intr
>                 __change_page_attr
>                 __change_page_attr_set_clr
>                 change_page_attr_set_clr
>                 _set_memory_wb
>                 ioremap_change_attr
>                 kernel_map_sync_memtype
>                 __ioremap_caller
>                 ioremap_cache
>                 copy_oldmem_page
>                 read_from_oldmem
>                 read_vmcore
>                 proc_reg_read
>                 vfs_read
>                 sys_read
>                 system_call_fastpath
>                 __read_nocancel
>=20
>      0.00%  makedumpfile-cl  [jbd2]             =20
>             |
>             --- jbd2_journal_start
>                 ext4_dirty_inode
>                 __mark_inode_dirty
>                 update_time
>                 file_update_time
>                 __generic_file_aio_write
>                 generic_file_aio_write
>                 ext4_file_write
>                 do_sync_write
>                 vfs_write
>                 sys_write
>                 system_call_fastpath
>                 __write_nocancel
>                 0xffffff0000003725
>=20
>=20
>=20

> Failed to open [dm_mirror], continuing without symbols
> Failed to open [ext4], continuing without symbols
> # =3D=3D=3D=3D=3D=3D=3D=3D
> # captured on: Fri Dec  7 16:45:46 2012
> # hostname : (none)
> # os release : 3.7.0-rc8-cliff-bench+
> # perf version : 3.7.rc8.3.ge0fb22
> # arch : x86_64
> # nrcpus online : 1
> # nrcpus avail : 1
> # cpudesc : Intel(R) Xeon(R) CPU E7- 4820 @ 2.00GHz
> # cpuid : GenuineIntel,6,47,2
> # total memory : 240104 kB
> # cmdline : /var/crash/perf record -g -o /mnt///127.0.0.1-2012-12-07-16:4=
5:20/perf.data2 /var/crash/makedumpfile-cliff --message-level 31 -i /var/cr=
ash/vmcoreinfo.txt -N -d 31 /proc/vmcore /mnt///127.0.0.1-2012-12-07-16:45:=
20/vmcore-empty-2=20
> # event : name =3D cycles, type =3D 0, config =3D 0x0, config1 =3D 0x0, c=
onfig2 =3D 0x0, excl_usr =3D 0, excl_kern =3D 0, excl_host =3D 0, excl_gues=
t =3D 1, precise_ip =3D 0, id =3D { 3 }
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # pmu mappings: cpu =3D 4, software =3D 1, tracepoint =3D 2, uncore_bbox_=
0 =3D 15, uncore_bbox_1 =3D 16, uncore_cbox_0 =3D 7, uncore_cbox_1 =3D 8, u=
ncore_cbox_2 =3D 9, uncore_cbox_3 =3D 10, uncore_cbox_4 =3D 11, uncore_cbox=
_5 =3D 12, uncore_cbox_6 =3D 13, uncore_cbox_7 =3D 14, uncore_mbox_0 =3D 19=
, uncore_mbox_1 =3D 20, uncore_rbox_0 =3D 21, uncore_rbox_1 =3D 22, uncore_=
sbox_0 =3D 17, uncore_sbox_1 =3D 18, breakpoint =3D 5, uncore_ubox =3D 6, u=
ncore_wbox =3D 23
> # =3D=3D=3D=3D=3D=3D=3D=3D
> #
> # Samples: 5K of event 'cycles'
> # Event count (approx.): 1493942335
> #
> # Overhead          Command         Shared Object
> # ........  ...............  ....................
> #
>     51.45%  makedumpfile-cl  makedumpfile-cliff =20
>             |         =20
>             |--51.45%-- set_bitmap_cyclic
>             |          |         =20
>             |           --100.00%-- exclude_unnecessary_pages_cyclic
>             |                     |         =20
>             |                      --100.00%-- writeout_dumpfile
>             |                                0x7fff0b66fe70
>             |                                0x64656b616d2f6873
>             |         =20
>             |--11.66%-- get_num_dumpable_cyclic
>             |         =20
>             |--7.96%-- clear_bit_on_2nd_bitmap_for_kernel
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--6.93%-- create_1st_bitmap_cyclic
>             |         =20
>             |--4.52%-- __exclude_unnecessary_pages_kernel
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--4.35%-- clear_bit_on_2nd_bitmap
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--4.05%-- set_bit_on_1st_bitmap
>             |         =20
>             |--3.63%-- update_cyclic_region
>             |         =20
>             |--3.52%-- write_kdump_pages_and_bitmap_cyclic
>             |          writeout_dumpfile
>             |          0x7fff0b66fe70
>             |          0x64656b616d2f6873
>             |         =20
>             |--1.87%-- is_xen_memory
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>              --0.07%-- [...]
>=20
>     47.68%  makedumpfile-cl  [kernel.kallsyms]  =20
>             |         =20
>             |--77.89%-- write_vmcore_get_excludes
>             |          write_vmcore_pfn_lists
>             |          proc_reg_write
>             |          vfs_write
>             |          sys_write
>             |          system_call_fastpath
>             |          __write_nocancel
>             |          exclude_unnecessary_pages_cyclic
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--15.34%-- walk_system_ram_range
>             |          |         =20
>             |          |--96.92%-- page_is_ram
>             |          |          __ioremap_caller
>             |          |          ioremap_cache
>             |          |          |         =20
>             |          |          |--99.51%-- write_vmcore_get_memmap
>             |          |          |          write_vmcore_pfn_lists
>             |          |          |          proc_reg_write
>             |          |          |          vfs_write
>             |          |          |          sys_write
>             |          |          |          system_call_fastpath
>             |          |          |          __write_nocancel
>             |          |          |          0x7fff0b66fe70
>             |          |          |          0x64656b616d2f6873
>             |          |           --0.49%-- [...]
>             |          |         =20
>             |          |--2.84%-- pat_pagerange_is_ram
>             |          |          |         =20
>             |          |          |--58.30%-- free_memtype
>             |          |          |          iounmap
>             |          |          |          copy_oldmem_page
>             |          |          |          read_from_oldmem
>             |          |          |          read_vmcore
>             |          |          |          proc_reg_read
>             |          |          |          vfs_read
>             |          |          |          sys_read
>             |          |          |          system_call_fastpath
>             |          |          |          __read_nocancel
>             |          |          |          |         =20
>             |          |          |           --100.00%-- 0x45524f4300000=
001
>             |          |          |         =20
>             |          |           --41.70%-- reserve_memtype
>             |          |                     __ioremap_caller
>             |          |                     ioremap_cache
>             |          |                     copy_oldmem_page
>             |          |                     read_from_oldmem
>             |          |                     read_vmcore
>             |          |                     proc_reg_read
>             |          |                     vfs_read
>             |          |                     sys_read
>             |          |                     system_call_fastpath
>             |          |                     __read_nocancel
>             |           --0.24%-- [...]
>             |         =20
>             |--0.76%-- __purge_vmap_area_lazy
>             |          |         =20
>             |          |--76.20%-- free_vmap_area_noflush
>             |          |          free_unmap_vmap_area
>             |          |          remove_vm_area
>             |          |          iounmap
>             |          |          copy_oldmem_page
>             |          |          read_from_oldmem
>             |          |          read_vmcore
>             |          |          proc_reg_read
>             |          |          vfs_read
>             |          |          sys_read
>             |          |          system_call_fastpath
>             |          |          __read_nocancel
>             |          |          |         =20
>             |          |          |--50.02%-- 0x45524f4300000001
>             |          |          |         =20
>             |          |           --49.98%-- 0x0
>             |          |         =20
>             |           --23.80%-- vm_unmap_aliases
>             |                     change_page_attr_set_clr
>             |                     _set_memory_wb
>             |                     ioremap_change_attr
>             |                     kernel_map_sync_memtype
>             |                     __ioremap_caller
>             |                     ioremap_cache
>             |                     copy_oldmem_page
>             |                     read_from_oldmem
>             |                     read_vmcore
>             |                     proc_reg_read
>             |                     vfs_read
>             |                     sys_read
>             |                     system_call_fastpath
>             |                     __read_nocancel
>             |         =20
>             |--0.66%-- iomem_map_sanity_check
>             |          __ioremap_caller
>             |          ioremap_cache
>             |          copy_oldmem_page
>             |          read_from_oldmem
>             |          read_vmcore
>             |          proc_reg_read
>             |          vfs_read
>             |          sys_read
>             |          system_call_fastpath
>             |          __read_nocancel
>             |          |         =20
>             |          |--50.44%-- 0x45524f4300000001
>             |          |         =20
>             |           --49.56%-- 0x0
>             |         =20
>             |--0.51%-- try_preserve_large_page
>             |          __change_page_attr
>             |          __change_page_attr_set_clr
>             |          change_page_attr_set_clr
>             |          _set_memory_wb
>             |          ioremap_change_attr
>             |          kernel_map_sync_memtype
>             |          __ioremap_caller
>             |          ioremap_cache
>             |          copy_oldmem_page
>             |          read_from_oldmem
>             |          read_vmcore
>             |          proc_reg_read
>             |          vfs_read
>             |          sys_read
>             |          system_call_fastpath
>             |          __read_nocancel
>              --4.84%-- [...]
>=20
>      0.72%  makedumpfile-cl  libc.so.6          =20
>             |         =20
>             |--36.59%-- __memset_sse2
>             |          |         =20
>             |           --100.00%-- 0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--31.88%-- memcpy
>             |          |         =20
>             |           --100.00%-- writeout_dumpfile
>             |                     0x7fff0b66fe70
>             |                     0x64656b616d2f6873
>             |         =20
>             |--4.88%-- time
>             |         =20
>             |--4.80%-- _IO_file_xsputn@@GLIBC_2.2.5
>             |          0x7f7e97029000
>             |         =20
>             |--2.46%-- _IO_file_init@@GLIBC_2.2.5
>             |         =20
>             |--2.45%-- _int_free
>             |         =20
>             |--2.45%-- 0x372527ffa0
>             |         =20
>             |--2.44%-- _IO_default_xsputn
>             |          0x71e4ef
>             |         =20
>             |--2.42%-- __lseek_nocancel
>             |         =20
>             |--2.41%-- _IO_getline_info
>             |         =20
>             |--2.41%-- __strlen_sse42
>             |          0x61705f6769746e6f
>             |         =20
>             |--2.41%-- _IO_fgets
>             |          0x3638343533313d45
>             |         =20
>              --2.40%-- vfprintf
>                        fprintf
>=20
>      0.13%  makedumpfile-cl  ld-linux-x86-64.so.2
>             |         =20
>             |--28.61%-- _dl_relocate_object
>             |          dl_main
>             |          _dl_sysdep_start
>             |          0x4156415741e58948
>             |         =20
>             |--28.61%-- do_lookup_x
>             |         =20
>             |--14.96%-- strcmp
>             |          0x6e696c2d646c0036
>             |         =20
>             |--14.34%-- _dl_lookup_symbol_x
>             |          _dl_relocate_object
>             |          dl_main
>             |          _dl_sysdep_start
>             |          0x4156415741e58948
>             |         =20
>              --13.48%-- _dl_sort_fini
>                        _dl_fini
>                        exit
>=20
>      0.02%  makedumpfile-cl  libstdc++.so.6     =20
>             |
>             --- std::basic_ios<char, std::char_traits<char> >::init(std::=
basic_streambuf<char, std::char_traits<char> >*)
>                 0x37284ebbe0
>                 std::basic_ostream<char, std::char_traits<char> >::~basic=
_ostream()
>=20
>=20
>=20


--=20
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="121210.proc_vmcore2"

To: kumagai-atsushi@mxc.nes.nec.co.jp d.hatayama@jp.fujitsu.com
Cc: kexec@lists.infradead.org
Subject: [PATCH] makedumpfile: request the kernel do page scans
From: Cliff Wickman <cpw@sgi.com>

I've been experimenting with asking the kernel to scan the page tables
instead of reading all those page structures through /proc/vmcore.
The results are rather dramatic.
On a small, idle UV: about 4 sec. versus about 40 sec.
On a 8TB UV the unnecessary page scan takes 4 minutes, vs. about 200 min
through /proc/vmcore.

This patch incorporates this scheme into version 1.5.1, so that the cyclic
processing can use the kernel scans.
It also uses the page_is_buddy logic to speed the finding of free pages.
And also allows makedumpfile to work as before with a kernel that does
not provide /proc/vmcore_pfn_lists.

This patch:
  - writes requests to new kernel file /proc/vmcore_pfn_lists
  - makes request PL_REQUEST_MEMMAP to pass the crash kernel information about
    the boot kernel
  - makes requests PL_REQUEST_FREE and PL_REQUEST_EXCLUDE, asking the kernel
    to return lists of PFNs
  - adds page scan timing options -n -o and -t

The patch [PATCH] makedumpfile: fix to exclude_unnecessary_pages_cyclic
is re-done by the below, so that patch should not be applied.

This patch depends on a kernel patch.

Diffed against the released makedumpfile-1.5.1

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 dwarf_info.c   |    2 
 makedumpfile.c |  523 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 makedumpfile.h |   92 +++++++++-
 print_info.c   |    5 
 print_info.h   |    3 
 5 files changed, 601 insertions(+), 24 deletions(-)


Index: makedumpfile-1.5.1.released/makedumpfile.h
===================================================================
--- makedumpfile-1.5.1.released.orig/makedumpfile.h
+++ makedumpfile-1.5.1.released/makedumpfile.h
@@ -86,6 +86,8 @@ int get_mem_type(void);
 #define LSEEKED_PDESC	(2)
 #define LSEEKED_PDATA	(3)
 
+#define EXTRA_MEMMAPS	100
+
 /*
  * Xen page flags
  */
@@ -418,7 +420,7 @@ do { \
 #define KVER_MIN_SHIFT 16
 #define KERNEL_VERSION(x,y,z) (((x) << KVER_MAJ_SHIFT) | ((y) << KVER_MIN_SHIFT) | (z))
 #define OLDEST_VERSION		KERNEL_VERSION(2, 6, 15)/* linux-2.6.15 */
-#define LATEST_VERSION		KERNEL_VERSION(3, 6, 7)/* linux-3.6.7 */
+#define LATEST_VERSION		KERNEL_VERSION(3, 7, 8)/* linux-3.7.8 */
 
 /*
  * vmcoreinfo in /proc/vmcore
@@ -794,9 +796,20 @@ typedef struct {
 } xen_crash_info_v2_t;
 
 struct mem_map_data {
+	/*
+	 * pfn_start/pfn_end are the pfn's represented by this mem_map entry.
+	 * mem_map is the virtual address of the array of page structures
+	 * that represent these pages.
+	 * paddr is the physical address of that array of structures.
+	 * ending_paddr would be (pfn_end - pfn_start) * sizeof(struct page).
+	 * section_vaddr is the address we get from ioremap_cache().
+	 */
 	unsigned long long	pfn_start;
 	unsigned long long	pfn_end;
-	unsigned long	mem_map;
+	unsigned long		mem_map;
+	unsigned long long	paddr;		/* filled in by makedumpfile */
+	unsigned long long	ending_paddr;	/* filled in by kernel */
+	void 			*section_vaddr;	/* filled in by kernel */
 };
 
 struct dump_bitmap {
@@ -875,6 +888,7 @@ struct DumpInfo {
 	int		flag_rearrange;      /* flag of creating dumpfile from
 						flattened format */
 	int		flag_split;	     /* splitting vmcore */
+	int		flag_use_kernel_lists;
   	int		flag_cyclic;	     /* cyclic processing to keep memory consumption */
 	int		flag_reassemble;     /* reassemble multiple dumpfiles into one */
 	int		flag_refiltering;    /* refilter from kdump-compressed file */
@@ -1384,6 +1398,80 @@ struct domain_list {
 	unsigned int  pickled_id;
 };
 
+#define PL_REQUEST_FREE		1	/* request for a list of free pages */
+#define PL_REQUEST_EXCLUDE	2	/* request for a list of excludable
+					   pages */
+#define PL_REQUEST_MEMMAP	3	/* request to pass in the makedumpfile
+					   mem_map_data table */
+/*
+ * limit the size of the pfn list to this many pfn_element structures
+ */
+#define MAX_PFN_LIST 10000
+
+/*
+ * one element in the pfn_list
+ */
+struct pfn_element {
+	unsigned long pfn;
+	unsigned long order;
+};
+
+/*
+ * a request for finding pfn's that can be excluded from the dump
+ * they may be pages of particular types or free pages
+ */
+struct pfn_list_request {
+	int request;		/* PL_REQUEST_FREE PL_REQUEST_EXCLUDE or */
+				/* PL_REQUEST_MEMMAP */
+	int debug;
+	unsigned long paddr;	/* mem_map address for PL_REQUEST_EXCLUDE */
+	unsigned long pfn_start;/* pfn represented by paddr */
+	unsigned long pgdat_paddr; /* for PL_REQUEST_FREE */
+	unsigned long pgdat_vaddr; /* for PL_REQUEST_FREE */
+	int node;		/* for PL_REQUEST_FREE */
+	int exclude_bits;	/* for PL_REQUEST_EXCLUDE */
+	int count;		/* for PL_REQUEST_EXCLUDE */
+	void *reply_ptr;	/* address of user's pfn_reply, for reply */
+	void *pfn_list_ptr;	/* address of user's pfn array (*pfn_list) */
+	int map_count;		/* for PL_REQUEST_MEMMAP; elements */
+	int map_size;		/* for PL_REQUEST_MEMMAP; bytes in table */
+	void *map_ptr;		/* for PL_REQUEST_MEMMAP; address of table */
+	long list_size;		/* for PL_REQUEST_MEMMAP negotiation */
+	/* resume info: */
+	int more;		/* 0 for done, 1 for "there's more" */
+				/* PL_REQUEST_EXCLUDE: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+};
+
+/*
+ * the reply from a pfn_list_request
+ * the list of pfn's itself is pointed to by pfn_list
+ */
+struct pfn_reply {
+	long pfn_list_elements;	/* negoiated on PL_REQUEST_MEMMAP */
+	long in_pfn_list;	/* returned by PL_REQUEST_EXCLUDE and
+				   PL_REQUEST_FREE */
+	/* resume info */
+	int more;		/* 0 == done, 1 == there is more */
+				/* PL_REQUEST_MEMMAP: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+	/* statistic counters: */
+	unsigned long long pfn_cache;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_cache_private;	/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_user;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_free;		/* PL_REQUEST_FREE */
+};
+
 #define PAGES_PER_MAPWORD 	(sizeof(unsigned long) * 8)
 #define MFNS_PER_FRAME		(info->page_size / sizeof(unsigned long))
 
Index: makedumpfile-1.5.1.released/dwarf_info.c
===================================================================
--- makedumpfile-1.5.1.released.orig/dwarf_info.c
+++ makedumpfile-1.5.1.released/dwarf_info.c
@@ -324,6 +324,8 @@ get_data_member_location(Dwarf_Die *die,
 	return TRUE;
 }
 
+int dwarf_formref(Dwarf_Attribute *, Dwarf_Off *);
+
 static int
 get_die_type(Dwarf_Die *die, Dwarf_Die *die_type)
 {
Index: makedumpfile-1.5.1.released/print_info.c
===================================================================
--- makedumpfile-1.5.1.released.orig/print_info.c
+++ makedumpfile-1.5.1.released/print_info.c
@@ -244,6 +244,11 @@ print_usage(void)
 	MSG("  [-f]:\n");
 	MSG("      Overwrite DUMPFILE even if it already exists.\n");
 	MSG("\n");
+	MSG("  [-o]:\n");
+	MSG("      Read page structures from /proc/vmcore in the scan for\n");
+	MSG("      free and excluded pages regardless of whether\n");
+	MSG("      /proc/vmcore_pfn_lists is present.\n");
+	MSG("\n");
 	MSG("  [-h]:\n");
 	MSG("      Show help message and LZO/snappy support status (enabled/disabled).\n");
 	MSG("\n");
Index: makedumpfile-1.5.1.released/print_info.h
===================================================================
--- makedumpfile-1.5.1.released.orig/print_info.h
+++ makedumpfile-1.5.1.released/print_info.h
@@ -43,7 +43,8 @@ void print_execution_time(char *step_nam
  */
 #define MIN_MSG_LEVEL		(0)
 #define MAX_MSG_LEVEL		(31)
-#define DEFAULT_MSG_LEVEL	(7)	/* Print the progress indicator, the
+// cpw: was 7  but add x10 for testing
+#define DEFAULT_MSG_LEVEL	(23)	/* Print the progress indicator, the
 					   common message, the error message */
 #define ML_PRINT_PROGRESS	(0x001) /* Print the progress indicator */
 #define ML_PRINT_COMMON_MSG	(0x002)	/* Print the common message */
Index: makedumpfile-1.5.1.released/makedumpfile.c
===================================================================
--- makedumpfile-1.5.1.released.orig/makedumpfile.c
+++ makedumpfile-1.5.1.released/makedumpfile.c
@@ -13,6 +13,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+#define _GNU_SOURCE
+#include <stdio.h>
 #include "makedumpfile.h"
 #include "print_info.h"
 #include "dwarf_info.h"
@@ -31,6 +33,13 @@ struct srcfile_table	srcfile_table;
 
 struct vm_table		vt = { 0 };
 struct DumpInfo		*info = NULL;
+int pfn_list_fd;
+struct pfn_element *pfn_list;
+int nflag = 0;
+int oflag = 0;
+int tflag = 0;
+struct timeval scan_start;
+int max_pfn_list;
 
 char filename_stdout[] = FILENAME_STDOUT;
 
@@ -2415,6 +2424,22 @@ get_mm_sparsemem(void)
 	unsigned long long pfn_start, pfn_end;
 	unsigned long section, mem_map;
 	unsigned long *mem_sec = NULL;
+	unsigned long vaddr;
+	unsigned long paddr;
+	unsigned long lastvaddr;
+	unsigned long lastpaddr;
+	unsigned long diff;
+	long j;
+	int i;
+	int npfns;
+	int pagesize;
+	int num_mem_map;
+	int num_added = 0;
+	struct mem_map_data *mmd;
+	struct mem_map_data *curmmd;
+	struct mem_map_data *work1mmd;
+	struct mem_map_data *work2mmd;
+	struct mem_map_data *lastmmd;
 
 	int ret = FALSE;
 
@@ -2441,7 +2466,8 @@ get_mm_sparsemem(void)
 	}
 	info->num_mem_map = num_section;
 	if ((info->mem_map_data = (struct mem_map_data *)
-	    malloc(sizeof(struct mem_map_data)*info->num_mem_map)) == NULL) {
+	    malloc(sizeof(struct mem_map_data) *
+		   		(EXTRA_MEMMAPS + info->num_mem_map))) == NULL) {
 		ERRMSG("Can't allocate memory for the mem_map_data. %s\n",
 		    strerror(errno));
 		goto out;
@@ -2459,6 +2485,74 @@ get_mm_sparsemem(void)
 		dump_mem_map(pfn_start, pfn_end, mem_map, section_nr);
 	}
 	ret = TRUE;
+
+	/* add paddr to the table */
+	mmd = &info->mem_map_data[0];
+	num_mem_map = info->num_mem_map;
+	lastmmd = mmd + num_mem_map;
+	for (i = 0; i < num_mem_map; i++) {
+		if (mmd[i].mem_map == 0) {
+			mmd[i].paddr = 0;
+		} else {
+			mmd[i].paddr = vaddr_to_paddr(mmd[i].mem_map);
+			if (mmd[i].paddr == 0) {
+				printf("! can't translate %#lx to paddr\n",
+					mmd[i].mem_map);
+				exit(1);
+			}
+			/*
+			 * When we pass a mem_map and its paddr to the kernel
+			 * it will be ioremap'd assuming the entire range
+			 * of pfn's are consecutive. If they are not then
+			 * we need to split the range into two.
+			 */
+			pagesize = SIZE(page);
+			npfns = mmd[i].pfn_end - mmd[i].pfn_start;
+			vaddr = (unsigned long)mmd[i].mem_map;
+			paddr = vaddr_to_paddr(vaddr);
+			diff = vaddr - paddr;
+			lastvaddr = vaddr + (pagesize * (npfns-1));
+			lastpaddr = vaddr_to_paddr(lastvaddr);
+			if (lastvaddr - lastpaddr != diff) {
+			/* there is a break in vtop somewhere in this range */
+			  for (j = 0; j < npfns; j++) {
+			    paddr = vaddr_to_paddr(vaddr);
+			    if (vaddr - paddr != diff) {
+				diff = vaddr - paddr;
+				/* insert a new entry if we have room */
+				if (num_added < EXTRA_MEMMAPS) {
+					curmmd = &info->mem_map_data[i];
+					num_added++;
+					work1mmd = lastmmd - 1;
+					for (work2mmd = lastmmd;
+						work2mmd > curmmd; work2mmd--) {
+						work1mmd = work2mmd - 1;
+						*work2mmd = *work1mmd;
+					}
+					work2mmd = work1mmd + 1;
+					work1mmd->pfn_end =
+							work1mmd->pfn_start + j;
+					work2mmd->pfn_start =
+							work1mmd->pfn_end;
+					work2mmd->mem_map =
+					  work1mmd->mem_map + (pagesize * j);
+					lastmmd++;
+					num_mem_map++;
+					info->num_mem_map++;
+					/*
+					 * need only 1 split, the new
+					 * one will be checked also.
+					 */
+					break;
+				} else
+					printf("warn: out of EXTRA_MEMMAPS\n");
+			    }
+				vaddr += pagesize;
+			  }
+			}
+		}
+	}
+
 out:
 	if (mem_sec != NULL)
 		free(mem_sec);
@@ -2571,6 +2665,105 @@ initialize_bitmap_memory(void)
 	return TRUE;
 }
 
+/*
+ * construct a version of the mem_map_data table to pass to the kernel
+ */
+void *
+make_kernel_mmap(int *kmap_elements, int *kmap_size)
+{
+	int i, j;
+	int elements = 0;
+	int page_structs;
+	int elem;
+	unsigned long base_end_pfn;
+	unsigned long end_paddr;
+	struct mem_map_data *mmdo, *mmdn;
+	struct mem_map_data *mmdbase, *mmdnext, *mmdend, *mmdwork;
+	struct mem_map_data temp_mmd;
+	struct mem_map_data *mmap;
+
+	mmap = malloc(info->num_mem_map * sizeof(struct mem_map_data));
+	if (mmap == NULL) {
+		ERRMSG("Can't allocate memory kernel map\n");
+		return NULL;
+	}
+
+	/* condense them down to the valid ones */
+	for (i = 0, mmdn = mmap, mmdo = &info->mem_map_data[0];
+				i < info->num_mem_map; i++, mmdo++) {
+		if (mmdo->mem_map && mmdo->paddr) {
+			*mmdn = *mmdo;
+			mmdn++;
+			elements++;
+		}
+	}
+
+	/* make sure it is sorted by mem_map (it should be already) */
+	mmdn = mmap;
+	for (i = 0; i < elements - 1; i++) {
+		for (j = i + 1; j < elements; j++) {
+			if (mmdn[j].mem_map < mmdn[i].mem_map) {
+				temp_mmd = mmdn[j];
+				mmdn[j] = mmdn[i];
+				mmdn[i] = temp_mmd;
+			}
+		}
+	}
+
+	/*
+	 * consolidate those mem_map's with occupying consecutive physical
+	 * addresses
+	 *  pages represented by these pages structs:       addr of page struct
+	 * pfns 0x1000000-1008000 mem_map 0xffffea0038000000 paddr 0x11f7e00000
+	 * pfns 0x1008000-1010000 mem_map 0xffffea00381c0000 paddr 0x11f7fc0000
+	 * pfns 0x1010000-1018000 mem_map 0xffffea0038380000 paddr 0x11f8180000
+	 *           8000 increments                             inc's:  1c0000
+	 *        8000000 of memory (128M)                    8000 page structs
+	 *
+	 */
+	mmdbase = mmap;
+	mmdnext = mmap + 1;
+	mmdend = mmap + elements;
+	while (mmdnext < mmdend) {
+		elem = mmdend - mmdnext;
+		/*  test mmdbase vs. mmdwork and onward: */
+		for (i = 0, mmdwork = mmdnext; i < elem; i++, mmdwork++) {
+			base_end_pfn = mmdbase->pfn_end;
+			if (base_end_pfn == mmdwork->pfn_start) {
+				page_structs = (mmdbase->pfn_end -
+							mmdbase->pfn_start);
+				end_paddr = (page_structs * SIZE(page))
+							+ mmdbase->paddr;
+				if (mmdwork->paddr == end_paddr) {
+					/* extend base by the work one */
+					mmdbase->pfn_end = mmdwork->pfn_end;
+					/* next is where to begin next time */
+					mmdnext = mmdwork + 1;
+				} else {
+					/* gap in address of page
+					   structs; end of section */
+					mmdbase++;
+					if (mmdwork - mmdbase > 0)
+						*mmdbase = *mmdwork;
+					mmdnext = mmdwork + 1;
+					break;
+				}
+			} else {
+				/* gap in pfns; end of section */
+				mmdbase++;
+				if (mmdwork - mmdbase > 0)
+					*mmdbase = *mmdwork;
+				mmdnext = mmdwork + 1;
+				break;
+			}
+		}
+	}
+	elements = (mmdbase - mmap) + 1;
+	*kmap_elements = elements;
+	*kmap_size = elements * sizeof(struct mem_map_data);
+	return mmap;
+}
+
 int
 initial(void)
 {
@@ -2833,7 +3026,19 @@ out:
 	if (!get_value_for_old_linux())
 		return FALSE;
 
+	/*
+	 * page_is_buddy will tell us whether free pages can be identified
+	 * by flags and counts in the page structure without making an extra
+	 * pass through the free lists.
+	 * This is applicable to using /proc/vmcore or using the kernel.
+	 *   force all old (-o) forms to search free lists
+	 */
+/*
 	if (info->flag_cyclic && (info->dump_level & DL_EXCLUDE_FREE))
+ 	if ((info->flag_cyclic || !oflag) &&
+	    (info->dump_level & DL_EXCLUDE_FREE))
+*/
+	if (info->dump_level & DL_EXCLUDE_FREE)
 		setup_page_is_buddy();
 
 	return TRUE;
@@ -3549,6 +3754,65 @@ out:
 	return ret;
 }
 
+/*
+ * let the kernel find excludable pages from one node
+ */
+void
+__exclude_free_pages_kernel(unsigned long pgdat, int node)
+{
+	int i, j, ret, pages;
+	unsigned long pgdat_paddr;
+	struct pfn_list_request request;
+	struct pfn_reply reply;
+	struct pfn_element *pe;
+
+	if ((pgdat_paddr = vaddr_to_paddr(pgdat)) == NOT_PADDR) {
+		ERRMSG("Can't convert virtual address(%#lx) to physical.\n",
+			pgdat);
+		return;
+	}
+
+	/*
+	 * Get the list of free pages.
+	 * This may be broken up into MAX_PFN_list arrays of PFNs.
+	 */
+	memset(&request, 0, sizeof(request));
+	request.request = PL_REQUEST_FREE;
+	request.node = node;
+	request.pgdat_paddr = pgdat_paddr;
+	request.pgdat_vaddr = pgdat;
+	request.reply_ptr = (void *)&reply;
+	request.pfn_list_ptr = (void *)pfn_list;
+	memset(&reply, 0, sizeof(reply));
+
+	do {
+		request.more = 0;
+		if (reply.more) {
+			/* this is to be a continuation of the last request */
+			request.more = 1;
+			request.zone_index = reply.zone_index;
+			request.freearea_index = reply.freearea_index;
+			request.type_index = reply.type_index;
+			request.list_ct = reply.list_ct;
+		}
+		ret = write(pfn_list_fd, &request, sizeof(request));
+		if (ret != sizeof(request)) {
+			printf("PL_REQUEST_FREE failed\n");
+			return;
+		}
+		pfn_free += reply.pfn_free;
+
+		for (i = 0; i < reply.in_pfn_list; i++) {
+			pe = &pfn_list[i];
+			pages = (1 << pe->order);
+                        for (j = 0; j < pages; j++) {
+				clear_bit_on_2nd_bitmap_for_kernel(pe->pfn + j);
+			}
+		}
+	} while (reply.more);
+
+	return;
+}
 
 int
 _exclude_free_page(void)
@@ -3556,6 +3820,7 @@ _exclude_free_page(void)
 	int i, nr_zones, num_nodes, node;
 	unsigned long node_zones, zone, spanned_pages, pgdat;
 	struct timeval tv_start;
+int ct=0;
 
 	if ((node = next_online_node(0)) < 0) {
 		ERRMSG("Can't get next online node.\n");
@@ -3568,7 +3833,24 @@ _exclude_free_page(void)
 	gettimeofday(&tv_start, NULL);
 
 	for (num_nodes = 1; num_nodes <= vt.numnodes; num_nodes++) {
-
+		if (!info->flag_cyclic && info->flag_use_kernel_lists) {
+			node_zones = pgdat + OFFSET(pglist_data.node_zones);
+			if (!readmem(VADDR,
+				pgdat + OFFSET(pglist_data.nr_zones),
+				&nr_zones, sizeof(nr_zones))) {
+					ERRMSG("Can't get nr_zones.\n");
+				return FALSE;
+			}
+			print_progress(PROGRESS_FREE_PAGES, num_nodes - 1,
+								vt.numnodes);
+			/* ask the kernel to do one node */
+			__exclude_free_pages_kernel(pgdat, node);
+			goto next_pgdat;
+		}
+		/*
+		 * kernel does not have the pfn_list capability
+		 * use the old way
+		 */
 		print_progress(PROGRESS_FREE_PAGES, num_nodes - 1, vt.numnodes);
 
 		node_zones = pgdat + OFFSET(pglist_data.node_zones);
@@ -3592,9 +3874,11 @@ _exclude_free_page(void)
 			}
 			if (!spanned_pages)
 				continue;
+ct++;
 			if (!reset_bitmap_of_free_pages(zone))
 				return FALSE;
 		}
+	next_pgdat:
 		if (num_nodes < vt.numnodes) {
 			if ((node = next_online_node(node + 1)) < 0) {
 				ERRMSG("Can't get next online node.\n");
@@ -3612,6 +3896,8 @@ _exclude_free_page(void)
 	 */
 	print_progress(PROGRESS_FREE_PAGES, vt.numnodes, vt.numnodes);
 	print_execution_time(PROGRESS_FREE_PAGES, &tv_start);
+	if (tflag)
+		print_execution_time("Total time", &scan_start);
 
 	return TRUE;
 }
@@ -3755,7 +4041,6 @@ setup_page_is_buddy(void)
 		}
 	} else
 		info->page_is_buddy = page_is_buddy_v2;
-
 out:
 	if (!info->page_is_buddy)
 		DEBUG_MSG("Can't select page_is_buddy handler; "
@@ -3964,10 +4249,88 @@ exclude_zero_pages(void)
 	return TRUE;
 }
 
+/*
+ * let the kernel find excludable pages from one mem_section
+ */
+int
+__exclude_unnecessary_pages_kernel(int mm, struct mem_map_data *mmd)
+{
+	unsigned long long pfn_start = mmd->pfn_start;
+	unsigned long long pfn_end = mmd->pfn_end;
+	int i, j, ret, pages, flag;
+	struct pfn_list_request request;
+	struct pfn_reply reply;
+	struct pfn_element *pe;
+
+	/*
+	 * Get the list of to-be-excluded pages in this section.
+	 * It may be broken up by groups of max_pfn_list size.
+	 */
+	memset(&request, 0, sizeof(request));
+	request.request = PL_REQUEST_EXCLUDE;
+	request.paddr = mmd->paddr; /* phys addr of mem_map */
+	request.reply_ptr = (void *)&reply;
+	request.pfn_list_ptr = (void *)pfn_list;
+	request.exclude_bits = 0;
+	request.pfn_start = pfn_start;
+	request.count = pfn_end - pfn_start;
+	if (info->dump_level & DL_EXCLUDE_CACHE)
+	 	request.exclude_bits |= DL_EXCLUDE_CACHE;
+	if (info->dump_level & DL_EXCLUDE_CACHE_PRI)
+	 	request.exclude_bits |= DL_EXCLUDE_CACHE_PRI;
+	if (info->dump_level & DL_EXCLUDE_USER_DATA)
+	 	request.exclude_bits |= DL_EXCLUDE_USER_DATA;
+	/* if we try for free pages from the freelists then we don't need
+           to ask here for 'buddy' pages */
+	if (info->dump_level & DL_EXCLUDE_FREE)
+	 	request.exclude_bits |= DL_EXCLUDE_FREE;
+	memset(&reply, 0, sizeof(reply));
+
+	do {
+		/* pfn represented by paddr */
+		request.more = 0;
+		if (reply.more) {
+			/* this is to be a continuation of the last request */
+			request.more = 1;
+			request.map_index = reply.map_index;
+		}
+
+		ret = write(pfn_list_fd, &request, sizeof(request));
+		if (ret != sizeof(request))
+			return FALSE;
+
+		pfn_cache += reply.pfn_cache;
+		pfn_cache_private += reply.pfn_cache_private;
+		pfn_user += reply.pfn_user;
+		pfn_free += reply.pfn_free;
+
+		flag = 0;
+		for (i = 0; i < reply.in_pfn_list; i++) {
+			pe = &pfn_list[i];
+			pages = (1 << pe->order);
+                        for (j = 0; j < pages; j++) {
+				if (clear_bit_on_2nd_bitmap_for_kernel(
+							pe->pfn + j) == FALSE) {
+					printf("fail: mm %d slot %d pfn %#lx\n",
+						mm, i, pe->pfn + j);
+					printf("paddr %#llx pfn %#llx-%#llx mem_map %#lx\n", mmd->paddr, mmd->pfn_start, mmd->pfn_end, mmd->mem_map);
+					flag = 1;
+					break;
+				}
+				if (flag) break;
+			}
+		}
+	} while (reply.more);
+
+	return TRUE;
+}
+
 int
-__exclude_unnecessary_pages(unsigned long mem_map,
-    unsigned long long pfn_start, unsigned long long pfn_end)
+__exclude_unnecessary_pages(int mm, struct mem_map_data *mmd)
 {
+	unsigned long long pfn_start = mmd->pfn_start;
+	unsigned long long pfn_end = mmd->pfn_end;
+	unsigned long mem_map = mmd->mem_map;
 	unsigned long long pfn, pfn_mm, maddr;
 	unsigned long long pfn_read_start, pfn_read_end, index_pg;
 	unsigned char page_cache[SIZE(page) * PGMM_CACHED];
@@ -3975,6 +4338,12 @@ __exclude_unnecessary_pages(unsigned lon
 	unsigned int _count, _mapcount = 0;
 	unsigned long flags, mapping, private = 0;
 
+	if (info->flag_use_kernel_lists) {
+		if (__exclude_unnecessary_pages_kernel(mm, mmd) == FALSE)
+			return FALSE;
+		return TRUE;
+	}
+
 	/*
 	 * Refresh the buffer of struct page, when changing mem_map.
 	 */
@@ -4012,7 +4381,6 @@ __exclude_unnecessary_pages(unsigned lon
 				pfn_mm = PGMM_CACHED - index_pg;
 			else
 				pfn_mm = pfn_end - pfn;
-
 			if (!readmem(VADDR, mem_map,
 			    page_cache + (index_pg * SIZE(page)),
 			    SIZE(page) * pfn_mm)) {
@@ -4036,7 +4404,6 @@ __exclude_unnecessary_pages(unsigned lon
 		 * Exclude the free page managed by a buddy
 		 */
 		if ((info->dump_level & DL_EXCLUDE_FREE)
-		    && info->flag_cyclic
 		    && info->page_is_buddy
 		    && info->page_is_buddy(flags, _mapcount, private, _count)) {
 			int i;
@@ -4085,19 +4452,78 @@ __exclude_unnecessary_pages(unsigned lon
 	return TRUE;
 }
 
+/*
+ * Pass in the mem_map_data table.
+ * Must do this once, and before doing PL_REQUEST_FREE or PL_REQUEST_EXCLUDE.
+ */
+int
+setup_kernel_mmap()
+{
+	int ret;
+	int kmap_elements, kmap_size;
+	long malloc_size;
+	void *kmap_addr;
+	struct pfn_list_request request;
+	struct pfn_reply reply;
+
+	kmap_addr = make_kernel_mmap(&kmap_elements, &kmap_size);
+	if (kmap_addr == NULL)
+		return FALSE;
+	memset(&request, 0, sizeof(request));
+	request.request = PL_REQUEST_MEMMAP;
+	request.map_ptr = kmap_addr;
+	request.reply_ptr = (void *)&reply;
+	request.map_count = kmap_elements;
+	request.map_size = kmap_size;
+	request.list_size = MAX_PFN_LIST;
+
+	ret = write(pfn_list_fd, &request, sizeof(request));
+	if (ret < 0) {
+		fprintf(stderr, "PL_REQUEST_MEMMAP returned %d\n", ret);
+		return FALSE;
+	}
+	/* the reply tells us how long the kernel's list actually is */
+	max_pfn_list = reply.pfn_list_elements;
+	if (max_pfn_list <= 0) {
+		fprintf(stderr,
+			"PL_REQUEST_MEMMAP returned max_pfn_list %d\n",
+			max_pfn_list);
+		return FALSE;
+	}
+	if (max_pfn_list < MAX_PFN_LIST) {
+		printf("length of pfn list dropped from %d to %d\n",
+			MAX_PFN_LIST, max_pfn_list);
+	}
+	free(kmap_addr);
+	/*
+	 * Allocate the buffer for the PFN list (just once).
+	 */
+	malloc_size = max_pfn_list * sizeof(struct pfn_element);
+	if ((pfn_list = (struct pfn_element *)malloc(malloc_size)) == NULL) {
+		ERRMSG("Can't allocate pfn_list of %ld\n", malloc_size);
+		return FALSE;
+	}
+	return TRUE;
+}
+
 int
 exclude_unnecessary_pages(void)
 {
-	unsigned int mm;
-	struct mem_map_data *mmd;
-	struct timeval tv_start;
+ 	unsigned int mm;
+ 	struct mem_map_data *mmd;
+ 	struct timeval tv_start;
 
 	if (is_xen_memory() && !info->dom0_mapnr) {
 		ERRMSG("Can't get max domain-0 PFN for excluding pages.\n");
 		return FALSE;
 	}
 
+	if (!info->flag_cyclic && info->flag_use_kernel_lists) {
+		if (setup_kernel_mmap() == FALSE)
+			return FALSE;
+	}
 	gettimeofday(&tv_start, NULL);
+	gettimeofday(&scan_start, NULL);
 
 	for (mm = 0; mm < info->num_mem_map; mm++) {
 		print_progress(PROGRESS_UNN_PAGES, mm, info->num_mem_map);
@@ -4106,9 +4532,9 @@ exclude_unnecessary_pages(void)
 
 		if (mmd->mem_map == NOT_MEMMAP_ADDR)
 			continue;
-
-		if (!__exclude_unnecessary_pages(mmd->mem_map,
-						 mmd->pfn_start, mmd->pfn_end))
+		if (mmd->paddr == 0)
+			continue;
+		if (!__exclude_unnecessary_pages(mm, mmd))
 			return FALSE;
 	}
 
@@ -4139,7 +4565,11 @@ exclude_unnecessary_pages_cyclic(void)
 	 */
 	copy_bitmap_cyclic();
 
-	if ((info->dump_level & DL_EXCLUDE_FREE) && !info->page_is_buddy)
+	/*
+	 * If free pages cannot be identified with the buddy flag and/or
+	 * count then we have to search free lists.
+	 */
+	if ((info->dump_level & DL_EXCLUDE_FREE) && (!info->page_is_buddy))
 		if (!exclude_free_page())
 			return FALSE;
 
@@ -4164,8 +4594,7 @@ exclude_unnecessary_pages_cyclic(void)
 
 			if (mmd->pfn_end >= info->cyclic_start_pfn &&
 			    mmd->pfn_start <= info->cyclic_end_pfn) {
-				if (!__exclude_unnecessary_pages(mmd->mem_map,
-								 mmd->pfn_start, mmd->pfn_end))
+				if (!__exclude_unnecessary_pages(mm, mmd))
 					return FALSE;
 			}
 		}
@@ -4195,7 +4624,7 @@ update_cyclic_region(unsigned long long 
 	if (!create_1st_bitmap_cyclic())
 		return FALSE;
 
-	if (!exclude_unnecessary_pages_cyclic())
+	if (exclude_unnecessary_pages_cyclic() == FALSE)
 		return FALSE;
 
 	return TRUE;
@@ -4255,7 +4684,7 @@ create_2nd_bitmap(void)
 	if (info->dump_level & DL_EXCLUDE_CACHE ||
 	    info->dump_level & DL_EXCLUDE_CACHE_PRI ||
 	    info->dump_level & DL_EXCLUDE_USER_DATA) {
-		if (!exclude_unnecessary_pages()) {
+		if (exclude_unnecessary_pages() == FALSE) {
 			ERRMSG("Can't exclude unnecessary pages.\n");
 			return FALSE;
 		}
@@ -4263,8 +4692,10 @@ create_2nd_bitmap(void)
 
 	/*
 	 * Exclude free pages.
+	 * If free pages cannot be identified with the buddy flag and/or
+	 * count then we have to search free lists.
 	 */
-	if (info->dump_level & DL_EXCLUDE_FREE)
+	if ((info->dump_level & DL_EXCLUDE_FREE) && (!info->page_is_buddy))
 		if (!exclude_free_page())
 			return FALSE;
 
@@ -4395,6 +4826,10 @@ create_dump_bitmap(void)
 	int ret = FALSE;
 
 	if (info->flag_cyclic) {
+		if (info->flag_use_kernel_lists) {
+			if (setup_kernel_mmap() == FALSE)
+				goto out;
+		}
 		if (!prepare_bitmap_buffer_cyclic())
 			goto out;
 
@@ -4872,6 +5307,7 @@ get_num_dumpable_cyclic(void)
 {
 	unsigned long long pfn, num_dumpable=0;
 
+	gettimeofday(&scan_start, NULL);
 	for (pfn = 0; pfn < info->max_mapnr; pfn++) {
 		if (!update_cyclic_region(pfn))
 			return FALSE;
@@ -5201,7 +5637,7 @@ get_loads_dumpfile_cyclic(void)
 	info->cyclic_end_pfn = info->pfn_cyclic;
 	if (!create_1st_bitmap_cyclic())
 		return FALSE;
-	if (!exclude_unnecessary_pages_cyclic())
+	if (exclude_unnecessary_pages_cyclic() == FALSE)
 		return FALSE;
 
 	if (!(phnum = get_phnum_memory()))
@@ -5613,6 +6049,10 @@ write_kdump_pages(struct cache_data *cd_
 			pfn_zero++;
 			continue;
 		}
+
+		if (nflag)
+			continue;
+
 		/*
 		 * Compress the page data.
 		 */
@@ -5768,6 +6208,7 @@ write_kdump_pages_cyclic(struct cache_da
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 
 		if ((num_dumped % per) == 0)
+
 			print_progress(PROGRESS_COPY, num_dumped, info->num_dumpable);
 
 		/*
@@ -5786,11 +6227,17 @@ write_kdump_pages_cyclic(struct cache_da
 		 */
 		if ((info->dump_level & DL_EXCLUDE_ZERO)
 		    && is_zero_page(buf, info->page_size)) {
+if (!nflag) {
 			if (!write_cache(cd_header, pd_zero, sizeof(page_desc_t)))
 				goto out;
+}
 			pfn_zero++;
 			continue;
 		}
+
+		if (nflag)
+			continue;
+
 		/*
 		 * Compress the page data.
 		 */
@@ -6208,6 +6655,8 @@ write_kdump_pages_and_bitmap_cyclic(stru
 		if (!update_cyclic_region(pfn))
                         return FALSE;
 
+		if (tflag)
+			print_execution_time("Total time", &scan_start);
 		if (!write_kdump_pages_cyclic(cd_header, cd_page, &pd_zero, &offset_data))
 			return FALSE;
 
@@ -8231,6 +8680,22 @@ static struct option longopts[] = {
 	{0, 0, 0, 0}
 };
 
+/*
+ * test for the presence of capability in the kernel to provide lists
+ * of pfn's:
+ *   /proc/vmcore_pfn_lists
+ * return 1 for present
+ * return 0 for not present
+ */
+int
+test_kernel_pfn_lists(void)
+{
+	if ((pfn_list_fd = open("/proc/vmcore_pfn_lists", O_WRONLY)) < 0) {
+		return 0;
+	}
+	return 1;
+}
+
 int
 main(int argc, char *argv[])
 {
@@ -8256,7 +8721,7 @@ main(int argc, char *argv[])
 	
 	info->block_order = DEFAULT_ORDER;
 	message_level = DEFAULT_MSG_LEVEL;
-	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:lMpRrsvXx:", longopts,
+	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:MnoRrstVvXx:Y", longopts,
 	    NULL)) != -1) {
 		switch (opt) {
 		case 'b':
@@ -8314,6 +8779,13 @@ main(int argc, char *argv[])
 		case 'M':
 			info->flag_dmesg = 1;
 			break;
+		case 'n':
+			/* -n undocumented, for testing page scanning time */
+			nflag = 1;
+			break;
+		case 'o':
+			oflag = 1;
+			break;
 		case 'p':
 			info->flag_compress = DUMP_DH_COMPRESSED_SNAPPY;
 			break;
@@ -8329,6 +8801,9 @@ main(int argc, char *argv[])
 		case 'r':
 			info->flag_reassemble = 1;
 			break;
+		case 't':
+			tflag = 1;
+			break;
 		case 'V':
 			info->vaddr_for_vtop = strtoul(optarg, NULL, 0);
 			break;
@@ -8360,6 +8835,12 @@ main(int argc, char *argv[])
 			goto out;
 		}
 	}
+
+	if (oflag)
+		info->flag_use_kernel_lists = 0;
+	else
+		info->flag_use_kernel_lists = test_kernel_pfn_lists();
+
 	if (flag_debug)
 		message_level |= ML_PRINT_DEBUG_MSG;
 

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="121207.vmcore_pagescans.sles"

To: kumagai-atsushi@mxc.nes.nec.co.jp d.hatayama@jp.fujitsu.com
Cc: kexec@lists.infradead.org
Subject: [PATCH] scan page tables for makedumpfile, 3.0.13 kernel
From: Cliff Wickman <cpw@sgi.com>

This patch provides the kernel support for makedumpfile to request
a list of PFNs.

Accompanies 
   [PATCH v2] makedumpfile: request the kernel do page scans

---
 fs/proc/vmcore.c             |  571 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/makedumpfile.h |  115 ++++++++
 2 files changed, 686 insertions(+)

Index: linux/fs/proc/vmcore.c
===================================================================
--- linux.orig/fs/proc/vmcore.c
+++ linux/fs/proc/vmcore.c
@@ -18,8 +18,18 @@
 #include <linux/init.h>
 #include <linux/crash_dump.h>
 #include <linux/list.h>
+#include <linux/makedumpfile.h>
+#include <linux/mmzone.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/page.h>
+static int num_mem_map_data = 0;
+static struct mem_map_data *mem_map_data;
+static struct pfn_element *pfn_list;
+static long in_pfn_list;
+static int last_found_vaddr = 0;
+static int last_found_paddr = 0;
+static int max_pfn_list;
 
 /* List representing chunks of contiguous memory areas and their offsets in
  * vmcore file.
@@ -34,6 +44,7 @@ static size_t elfcorebuf_sz;
 static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
+static struct proc_dir_entry *proc_vmcore_pfn_lists = NULL;
 
 /*
  * Returns > 0 for RAM pages, 0 for non-RAM pages, < 0 on error
@@ -207,11 +218,567 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
+/*
+ * Given the boot-kernel-relative virtual address of a page
+ * return its crashkernel-relative virtual address.
+ *
+ * We have a memory map named mem_map_data
+ *
+ * return 0 if it cannot be found
+ */
+unsigned long
+find_local_vaddr(unsigned long orig_vaddr)
+{
+	int i;
+	int fnd = 0;
+	struct mem_map_data *mmd, *next_mmd;
+	unsigned long paddr;
+	unsigned long local_vaddr;
+	unsigned long offset;
+
+	if (!num_mem_map_data) {
+		printk("find_page_paddr !! num_mem_map_data is %d\n",
+			num_mem_map_data);
+		return 0;
+	}
+
+fullsearch:
+	for (i = last_found_vaddr, mmd = mem_map_data + last_found_vaddr,
+		next_mmd = mem_map_data + last_found_vaddr + 1;
+		i < num_mem_map_data; i++, mmd++, next_mmd++) {
+		if (mmd->mem_map && mmd->paddr) {
+			if (orig_vaddr >= mmd->mem_map &&
+			    orig_vaddr < next_mmd->mem_map) {
+				offset = orig_vaddr - mmd->mem_map;
+				paddr = mmd->paddr + offset;
+				fnd++;
+				/* caching gives about 99% hit on first pass */
+				last_found_vaddr = i;
+				break;
+			}
+		}
+	}
+
+	if (! fnd) {
+		if (last_found_vaddr > 0) {
+			last_found_vaddr = 0;
+			goto fullsearch;
+		}
+		return 0;
+	}
+
+	/* paddr is now the physical address of the page structure */
+	/* and offset is the offset into the found section, and we have
+	   a table of how those sections are ioremap_cache'd */
+	local_vaddr = (unsigned long)mmd->section_vaddr + offset;
+	return local_vaddr;
+}
+
+/*
+ * Given a paddr, return its crashkernel-relative virtual address.
+ *
+ * We have a memory map named mem_map_data
+ *
+ * return 0 if it cannot be found
+ */
+void *
+find_local_from_paddr(unsigned long paddr)
+{
+	int i;
+	struct mem_map_data *mmd;
+	unsigned long offset;
+
+	if (!num_mem_map_data) {
+		printk("find_page_paddr !! num_mem_map_data is %d\n",
+			num_mem_map_data);
+		return 0;
+	}
+
+fullsearch:
+	for (i = last_found_paddr, mmd = mem_map_data + last_found_paddr;
+		i < num_mem_map_data; i++, mmd++) {
+		if ((paddr >= mmd->paddr) && (paddr < mmd->ending_paddr)) {
+			offset = paddr - mmd->paddr;
+			last_found_paddr = i;
+			/* caching gives about 98% hit on first pass */
+			return (void *)(mmd->section_vaddr + offset);
+		}
+	}
+
+	if (last_found_paddr > 0) {
+		last_found_paddr = 0;
+		goto fullsearch;
+	}
+	return 0;
+}
+
+/*
+ * given an anchoring list_head, walk the list of free pages
+ * 'root' is a virtual address based on the ioremap_cache'd pointer pgp
+ * 'boot_root' is the virtual address of the list root, boot kernel relative
+ *
+ * return the number of pages found on the list
+ */
+int
+walk_freelist(struct list_head *root, int node, int zone, int order, int list,
+		int restart_list, int start_page, struct pfn_list_request *reqp,
+		struct pfn_reply *replyp, struct list_head *boot_root)
+{
+	int list_ct = 0;
+	int list_free_pages = 0;
+	int doit;
+	unsigned long start_pfn;
+	struct page *pagep;
+	struct page *local_pagep;
+	struct list_head *lhp;
+	struct list_head *local_lhp; /* crashkernel-relative */
+	struct list_head *prev;
+	struct pfn_element *pe;
+
+	/*
+	 * root is the crashkernel-relative address of the anchor of the
+	 * free_list.
+	 */
+	prev = root;
+	if (root == NULL) {
+		printk(KERN_EMERG "root is null!!, node %d order %d\n",
+			node, order);
+			return 0;
+	}
+
+	if (root->next == boot_root)
+		/* list is empty */
+		return 0;
+
+	lhp = root->next;
+	local_lhp = (struct list_head *)find_local_vaddr((unsigned long)lhp);
+	if (!local_lhp) {
+		return 0;
+	}
+
+	while (local_lhp != boot_root) {
+		list_ct++;
+		if (lhp == NULL) {
+			printk(KERN_EMERG
+			 "The free list has a null!!, node %d order %d\n",
+				node, order);
+			break;
+		}
+		if (list_ct > 1 && local_lhp->prev != prev) {
+			/* can't be compared to root, as that is local */
+			printk(KERN_EMERG "The free list is broken!!\n");
+			break;
+		}
+
+		/* we want the boot kernel's pfn that this page represents */
+		pagep = container_of((struct list_head *)lhp,
+							struct page, lru);
+		start_pfn = pagep - vmemmap;
+		local_pagep = container_of((struct list_head *)local_lhp,
+							struct page, lru);
+		doit = 1;
+		if (restart_list && list_ct < start_page)
+			doit = 0;
+		if (doit) {
+			if (in_pfn_list == max_pfn_list) {
+			 	/* if array would overflow, come back to
+				   this page with a continuation */
+				replyp->more = 1;
+				replyp->zone_index = zone;
+				replyp->freearea_index = order;
+				replyp->type_index = list;
+				replyp->list_ct = list_ct;
+				goto list_is_full;
+			}
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = start_pfn;
+			pe->order = order;
+			list_free_pages += (1 << order);
+		}
+		prev = lhp;
+		lhp = local_pagep->lru.next;
+		/* the local node-relative vaddr: */
+		local_lhp = (struct list_head *)
+					find_local_vaddr((unsigned long)lhp);
+		if (!local_lhp)
+			break;
+	}
+
+list_is_full:
+	return list_free_pages;
+}
+
+/*
+ * Return the pfns of free pages on this node
+ */
+int
+write_vmcore_get_free(struct pfn_list_request *reqp)
+{
+	int node;
+	int nr_zones;
+	int nr_orders = MAX_ORDER;
+	int nr_freelist = MIGRATE_TYPES;
+	int zone;
+	int order;
+	int list;
+	int start_zone = 0;
+	int start_order = 0;
+	int start_list = 0;
+	int ret;
+	int restart = 0;
+	int start_page = 0;
+	int node_free_pages = 0;
+	struct pfn_reply rep;
+	struct pglist_data *pgp;
+	struct zone *zonep;
+	struct free_area *fap;
+	struct list_head *flp;
+	struct list_head *boot_root;
+	unsigned long pgdat_paddr;
+	unsigned long pgdat_vaddr;
+	unsigned long page_aligned_pgdat;
+	unsigned long page_aligned_size;
+	void *mapped_vaddr;
+
+	node = reqp->node;
+	pgdat_paddr = reqp->pgdat_paddr;
+	pgdat_vaddr = reqp->pgdat_vaddr;
+
+	/* map this pglist_data structure within a page-aligned area */
+	page_aligned_pgdat = pgdat_paddr & ~(PAGE_SIZE - 1);
+	page_aligned_size = sizeof(struct pglist_data) +
+					(pgdat_paddr - page_aligned_pgdat);
+	page_aligned_size = ((page_aligned_size + (PAGE_SIZE - 1))
+				>> PAGE_SHIFT) << PAGE_SHIFT;
+	mapped_vaddr = ioremap_cache(page_aligned_pgdat, page_aligned_size);
+	if (!mapped_vaddr) {
+		printk("ioremap_cache of pgdat %#lx failed\n",
+				page_aligned_pgdat);
+        	return -EINVAL;
+	}
+	pgp = (struct pglist_data *)(mapped_vaddr +
+				(pgdat_paddr - page_aligned_pgdat));
+	nr_zones = pgp->nr_zones;
+	memset(&rep, 0, sizeof(rep));
+
+	if (reqp->more) {
+		restart = 1;
+		start_zone = reqp->zone_index;
+		start_order = reqp->freearea_index;
+		start_list = reqp->type_index;
+		start_page = reqp->list_ct;
+	}
+
+	in_pfn_list = 0;
+	for (zone = start_zone; zone < nr_zones; zone++) {
+		zonep = &pgp->node_zones[zone];
+		for (order = start_order; order < nr_orders; order++) {
+			fap = &zonep->free_area[order];
+			/* some free_area's are all zero */
+			if (fap->nr_free) {
+				for (list = start_list; list < nr_freelist;
+								list++) {
+					flp = &fap->free_list[list];
+					boot_root = (struct list_head *)
+						(pgdat_vaddr +
+				    		 ((unsigned long)flp -
+						 (unsigned long)pgp));
+					ret = walk_freelist(flp, node, zone,
+						order, list, restart,
+						start_page, reqp, &rep,
+						boot_root);
+					node_free_pages += ret;
+					restart = 0;
+					if (rep.more)
+						goto list_full;
+				}
+			}
+		}
+	}
+list_full:
+
+	iounmap(mapped_vaddr);
+
+	/* copy the reply and the valid part of our pfn list to the user */
+	rep.pfn_free = node_free_pages; /* the total, for statistics */
+	rep.in_pfn_list = in_pfn_list;
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	if (in_pfn_list) {
+		if (copy_to_user(reqp->pfn_list_ptr, pfn_list,
+				(in_pfn_list * sizeof(struct pfn_element))))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/*
+ * Get the memap_data table from makedumpfile
+ * and do the single allocate of the pfn_list.
+ */
+int
+write_vmcore_get_memmap(struct pfn_list_request *reqp)
+{
+	int i;
+	int count;
+	int size;
+	int ret = 0;
+	long pfn_list_elements;
+	long malloc_size;
+	unsigned long page_section_start;
+	unsigned long page_section_size;
+	struct mem_map_data *mmd, *dum_mmd;
+	struct pfn_reply rep;
+	void *bufptr;
+
+	rep.pfn_list_elements = 0;
+	if (num_mem_map_data) {
+		/* shouldn't have been done before, but if it was.. */
+		printk(KERN_INFO "warning: PL_REQUEST_MEMMAP is repeated\n");
+		for (i = 0, mmd = mem_map_data; i < num_mem_map_data;
+								i++, mmd++) {
+			iounmap(mmd->section_vaddr);
+		}
+		kfree(mem_map_data);
+		mem_map_data = NULL;
+		num_mem_map_data = 0;
+		kfree(pfn_list);
+		pfn_list = NULL;
+	}
+
+	count = reqp->map_count;
+	size = reqp->map_size;
+	bufptr = reqp->map_ptr;
+	if (size != (count * sizeof(struct mem_map_data))) {
+		printk("Error in mem_map_data, %d * %ld != %d\n",
+			count, sizeof(struct mem_map_data), size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* add a dummy at the end to limit the size of the last entry */
+	size += sizeof(struct mem_map_data);
+
+	mem_map_data = kzalloc(size, GFP_KERNEL);
+	if (!mem_map_data) {
+		printk("kmalloc of mem_map_data for %d failed\n", size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+        if (copy_from_user(mem_map_data, bufptr, size)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	num_mem_map_data = count;
+
+	/* construct the dummy entry to limit the size of 'next_mmd->mem_map' */
+	/* (see find_local_vaddr() ) */
+	mmd = mem_map_data + (num_mem_map_data - 1);
+	page_section_size = (mmd->pfn_end - mmd->pfn_start) *
+							sizeof(struct page);
+	dum_mmd = mmd + 1;
+	*dum_mmd = *mmd;
+	dum_mmd->mem_map += page_section_size;
+
+	/* Fill in the ending address of array of page struct */
+	for (i = 0, mmd = mem_map_data; i < num_mem_map_data; i++, mmd++) {
+		mmd->ending_paddr = mmd->paddr +
+			((mmd->pfn_end - mmd->pfn_start) * sizeof(struct page));
+	}
+
+	/* Map each section of page structures to local virtual addresses */
+	/* (these are never iounmap'd, as this is the crash kernel) */
+	for (i = 0, mmd = mem_map_data; i < num_mem_map_data; i++, mmd++) {
+		page_section_start = mmd->paddr;
+		page_section_size = (mmd->pfn_end - mmd->pfn_start) *
+							sizeof(struct page);
+		mmd->section_vaddr = ioremap_cache(page_section_start,
+							page_section_size);
+		if (!mmd->section_vaddr) {
+			printk(
+			  "ioremap_cache of [%d] node %#lx for %#lx failed\n",
+				i, page_section_start, page_section_size);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/*
+	 * allocate the array for PFN's (just once)
+	 * get as much as we can, up to what the user specified, and return
+	 * that count to the user
+	 */
+	pfn_list_elements = reqp->list_size;
+	do {
+		malloc_size = pfn_list_elements * sizeof(struct pfn_element);
+		if ((pfn_list = kmalloc(malloc_size, GFP_KERNEL)) != NULL) {
+			rep.pfn_list_elements = pfn_list_elements;
+			max_pfn_list = pfn_list_elements;
+			goto out;
+		}
+		pfn_list_elements -= 1000;
+	} while (pfn_list == NULL && pfn_list_elements > 0);
+
+	ret = -EINVAL;
+out:
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	return ret;
+}
+
+/*
+ * Return the pfns of to-be-excluded pages fulfilling this request.
+ * This is called for each mem_map in makedumpfile's list.
+ */
+int
+write_vmcore_get_excludes(struct pfn_list_request *reqp)
+{
+	int i;
+	int start = 0;
+	int end;
+	unsigned long paddr;
+	unsigned long pfn;
+	void *vaddr;
+	struct page *pagep;
+	struct pfn_reply rep;
+	struct pfn_element *pe;
+
+	if (!num_mem_map_data) {
+		/* sanity check */
+		printk(
+		"ERROR:PL_REQUEST_MEMMAP not done before PL_REQUEST_EXCLUDE\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * the request contains (besides request type and bufptr):
+	 *  paddr (physical address of the page[0]
+	 *  count of pages in the block
+	 *  exclude bits (DL_EXCLUDE_...)
+	 */
+	paddr = reqp->paddr;
+	end = reqp->count;
+	pfn = reqp->pfn_start;
+	/* find the already-mapped vaddr of this paddr */
+	vaddr = find_local_from_paddr(paddr);
+	if (!vaddr) {
+		printk("ERROR: PL_REQUEST_EXCLUDE cannot find paddr %#lx\n",
+			paddr);
+		return -EINVAL;
+	}
+	if (reqp->more) {
+		start = reqp->map_index;
+		vaddr += (reqp->map_index * sizeof(struct page));
+		pfn += reqp->map_index;
+	}
+	memset(&rep, 0, sizeof(rep));
+	in_pfn_list = 0;
+
+	for (i = start, pagep = (struct page *)vaddr; i < end;
+							i++, pagep++, pfn++) {
+		if (in_pfn_list == max_pfn_list) {
+			rep.in_pfn_list = in_pfn_list;
+			rep.more = 1;
+			rep.map_index = i;
+			break;
+		}
+		/*
+		 * Exclude the free page managed by a buddy
+		 */
+		if ((reqp->exclude_bits & DL_EXCLUDE_FREE)
+		    && ((pagep->flags & (1UL << PG_slab)) == 0)
+		    && (atomic_read(&pagep->_mapcount) ==
+					PAGE_BUDDY_MAPCOUNT_VALUE)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = pagep->private;
+			rep.pfn_free += (1 << pe->order);
+		}
+		/*
+		 * Exclude the cache page without the private page.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_CACHE)
+		    && (isLRU(pagep->flags) || isSwapCache(pagep->flags))
+		    && !isPrivate(pagep->flags) && !isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_cache++;
+		}
+		/*
+		 * Exclude the cache page with the private page.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_CACHE_PRI)
+		    && (isLRU(pagep->flags) || isSwapCache(pagep->flags))
+		    && !isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_cache_private++;
+		}
+		/*
+		 * Exclude the data page of the user process.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_USER_DATA)
+		    && isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_user++;
+		}
+
+	}
+	rep.in_pfn_list = in_pfn_list;
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	if (in_pfn_list) {
+		if (copy_to_user(reqp->pfn_list_ptr, pfn_list,
+				(in_pfn_list * sizeof(struct pfn_element))))
+			return -EFAULT;
+	}
+        return 0;
+}
+
+static ssize_t write_vmcore_pfn_lists(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	int ret;
+	struct pfn_list_request pfn_list_request;
+
+	if (count != sizeof(struct pfn_list_request)) {
+                return -EINVAL;
+	}
+
+        if (copy_from_user(&pfn_list_request, user_buf, count))
+                return -EFAULT;
+
+	if (pfn_list_request.request == PL_REQUEST_FREE) {
+		ret = write_vmcore_get_free(&pfn_list_request);
+	} else if (pfn_list_request.request == PL_REQUEST_EXCLUDE) {
+		ret = write_vmcore_get_excludes(&pfn_list_request);
+	} else if (pfn_list_request.request == PL_REQUEST_MEMMAP) {
+		ret = write_vmcore_get_memmap(&pfn_list_request);
+	} else {
+                return -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+        return count;
+}
+
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 	.llseek		= default_llseek,
 };
 
+static const struct file_operations proc_vmcore_pfn_lists_operations = {
+	.write		= write_vmcore_pfn_lists,
+};
+
 static struct vmcore* __init get_new_element(void)
 {
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
@@ -696,6 +1263,10 @@ static int __init vmcore_init(void)
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
+
+	proc_vmcore_pfn_lists = proc_create("vmcore_pfn_lists", S_IWUSR, NULL,
+					&proc_vmcore_pfn_lists_operations);
+
 	return 0;
 }
 module_init(vmcore_init)
Index: linux/include/linux/makedumpfile.h
===================================================================
--- /dev/null
+++ linux/include/linux/makedumpfile.h
@@ -0,0 +1,115 @@
+/*
+ * makedumpfile.h
+ * portions Copyright (C) 2006, 2007, 2008, 2009  NEC Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define isLRU(flags)		(flags & (1UL << PG_lru))
+#define isPrivate(flags)	(flags & (1UL << PG_private))
+#define isSwapCache(flags)	(flags & (1UL << PG_swapcache))
+
+static inline int
+isAnon(struct address_space *mapping)
+{
+	return ((unsigned long)mapping & PAGE_MAPPING_ANON) != 0;
+}
+
+#define DL_EXCLUDE_ZERO		(0x001) /* Exclude Pages filled with Zeros */
+#define DL_EXCLUDE_CACHE	(0x002) /* Exclude Cache Pages
+				           without Private Pages */
+#define DL_EXCLUDE_CACHE_PRI	(0x004) /* Exclude Cache Pages
+				           with Private Pages */
+#define DL_EXCLUDE_USER_DATA	(0x008) /* Exclude UserProcessData Pages */
+#define DL_EXCLUDE_FREE		(0x010)	/* Exclude Free Pages */
+
+#define PL_REQUEST_FREE		1	/* request for a list of free pages */
+#define PL_REQUEST_EXCLUDE	2	/* request for a list of excludable
+					   pages */
+#define PL_REQUEST_MEMMAP	3	/* request to pass in the makedumpfile
+					   mem_map_data table */
+/*
+ * a request for finding pfn's that can be excluded from the dump
+ * they may be pages of particular types or free pages
+ */
+struct pfn_list_request {
+	int request;		/* PL_REQUEST_FREE PL_REQUEST_EXCLUDE or */
+				/* PL_REQUEST_MEMMAP */
+	int debug;
+	unsigned long paddr;	/* mem_map address for PL_REQUEST_EXCLUDE */
+	unsigned long pfn_start;/* pfn represented by paddr */
+	unsigned long pgdat_paddr; /* for PL_REQUEST_FREE */
+	unsigned long pgdat_vaddr; /* for PL_REQUEST_FREE */
+	int node;		/* for PL_REQUEST_FREE */
+	int exclude_bits;	/* for PL_REQUEST_EXCLUDE */
+	int count;		/* for PL_REQUEST_EXCLUDE */
+	void *reply_ptr;	/* address of user's pfn_reply, for reply */
+	void *pfn_list_ptr;	/* address of user's pfn array (*pfn_list) */
+	int map_count;		/* for PL_REQUEST_MEMMAP; elements */
+	int map_size;		/* for PL_REQUEST_MEMMAP; bytes in table */
+	void *map_ptr;		/* for PL_REQUEST_MEMMAP; address of table */
+	long list_size;		/* for PL_REQUEST_MEMMAP negotiation */
+	/* resume info: */
+	int more;		/* 0 for done, 1 for "there's more" */
+				/* PL_REQUEST_EXCLUDE: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+};
+
+/*
+ * the reply from a pfn_list_request
+ * the list of pfn's itself is pointed to by pfn_list
+ */
+struct pfn_reply {
+	long pfn_list_elements;	/* negotiated on PL_REQUEST_MEMMAP */
+	long in_pfn_list;	/* returned by PL_REQUEST_EXCLUDE and
+				   PL_REQUEST_FREE */
+	/* resume info */
+	int more;		/* 0 == done, 1 == there is more */
+				/* PL_REQUEST_MEMMAP: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+	/* statistic counters: */
+	unsigned long long pfn_cache;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_cache_private;	/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_user;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_free;		/* PL_REQUEST_FREE */
+};
+
+struct pfn_element {
+        unsigned long pfn;
+        unsigned long order;
+};
+
+struct mem_map_data {
+	/*
+	 * pfn_start/pfn_end are the pfn's represented by this mem_map entry.
+	 * mem_map is the virtual address of the array of page structures
+	 * that represent these pages.
+	 * paddr is the physical address of that array of structures.
+	 * ending_paddr would be (pfn_end - pfn_start) * sizeof(struct page).
+	 * section_vaddr is the address we get from ioremap_cache().
+	 */
+	unsigned long long	pfn_start;
+	unsigned long long	pfn_end;
+	unsigned long		mem_map;
+	unsigned long long	paddr;		/* filled in by makedumpfile */
+	unsigned long long	ending_paddr;	/* filled in by kernel */
+	void 			*section_vaddr;	/* filled in by kernel */
+};

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="121207.vmcore_pagescans.rhel"

Subject: [PATCH] scan page tables for makedumpfile

---
 fs/proc/vmcore.c             |  568 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/makedumpfile.h |  115 ++++++++
 2 files changed, 683 insertions(+)

Index: linux/fs/proc/vmcore.c
===================================================================
--- linux.orig/fs/proc/vmcore.c
+++ linux/fs/proc/vmcore.c
@@ -17,8 +17,18 @@
 #include <linux/init.h>
 #include <linux/crash_dump.h>
 #include <linux/list.h>
+#include <linux/makedumpfile.h>
+#include <linux/mmzone.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/page.h>
+static int num_mem_map_data = 0;
+static struct mem_map_data *mem_map_data;
+static struct pfn_element *pfn_list;
+static long in_pfn_list;
+static int last_found_vaddr = 0;
+static int last_found_paddr = 0;
+static int max_pfn_list;
 
 /* List representing chunks of contiguous memory areas and their offsets in
  * vmcore file.
@@ -33,6 +43,7 @@ static size_t elfcorebuf_sz;
 static u64 vmcore_size;
 
 static struct proc_dir_entry *proc_vmcore = NULL;
+static struct proc_dir_entry *proc_vmcore_pfn_lists = NULL;
 
 /* Reads a page from the oldmem device from given offset. */
 static ssize_t read_from_oldmem(char *buf, size_t count,
@@ -160,10 +171,563 @@ static ssize_t read_vmcore(struct file *
 	return acc;
 }
 
+/*
+ * Given the boot-kernel-relative virtual address of a page
+ * return its crashkernel-relative virtual address.
+ *
+ * We have a memory map named mem_map_data
+ *
+ * return 0 if it cannot be found
+ */
+unsigned long
+find_local_vaddr(unsigned long orig_vaddr)
+{
+	int i;
+	int fnd = 0;
+	struct mem_map_data *mmd, *next_mmd;
+	unsigned long paddr;
+	unsigned long local_vaddr;
+	unsigned long offset;
+
+	if (!num_mem_map_data) {
+		printk("find_page_paddr !! num_mem_map_data is %d\n",
+			num_mem_map_data);
+		return 0;
+	}
+
+fullsearch:
+	for (i = last_found_vaddr, mmd = mem_map_data + last_found_vaddr,
+		next_mmd = mem_map_data + last_found_vaddr + 1;
+		i < num_mem_map_data; i++, mmd++, next_mmd++) {
+		if (mmd->mem_map && mmd->paddr) {
+			if (orig_vaddr >= mmd->mem_map &&
+			    orig_vaddr < next_mmd->mem_map) {
+				offset = orig_vaddr - mmd->mem_map;
+				paddr = mmd->paddr + offset;
+				fnd++;
+				/* caching gives about 99% hit on first pass */
+				last_found_vaddr = i;
+				break;
+			}
+		}
+	}
+
+	if (! fnd) {
+		if (last_found_vaddr > 0) {
+			last_found_vaddr = 0;
+			goto fullsearch;
+		}
+		return 0;
+	}
+
+	/* paddr is now the physical address of the page structure */
+	/* and offset is the offset into the found section, and we have
+	   a table of how those sections are ioremap_cache'd */
+	local_vaddr = (unsigned long)mmd->section_vaddr + offset;
+	return local_vaddr;
+}
+
+/*
+ * Given a paddr, return its crashkernel-relative virtual address.
+ *
+ * We have a memory map named mem_map_data
+ *
+ * return 0 if it cannot be found
+ */
+void *
+find_local_from_paddr(unsigned long paddr)
+{
+	int i;
+	struct mem_map_data *mmd;
+	unsigned long offset;
+
+	if (!num_mem_map_data) {
+		printk("find_page_paddr !! num_mem_map_data is %d\n",
+			num_mem_map_data);
+		return 0;
+	}
+
+fullsearch:
+	for (i = last_found_paddr, mmd = mem_map_data + last_found_paddr;
+		i < num_mem_map_data; i++, mmd++) {
+		if ((paddr >= mmd->paddr) && (paddr < mmd->ending_paddr)) {
+			offset = paddr - mmd->paddr;
+			last_found_paddr = i;
+			/* caching gives about 98% hit on first pass */
+			return (void *)(mmd->section_vaddr + offset);
+		}
+	}
+
+	if (last_found_paddr > 0) {
+		last_found_paddr = 0;
+		goto fullsearch;
+	}
+	return 0;
+}
+
+/*
+ * given an anchoring list_head, walk the list of free pages
+ * 'root' is a virtual address based on the ioremap_cache'd pointer pgp
+ * 'boot_root' is the virtual address of the list root, boot kernel relative
+ *
+ * return the number of pages found on the list
+ */
+int
+walk_freelist(struct list_head *root, int node, int zone, int order, int list,
+		int restart_list, int start_page, struct pfn_list_request *reqp,
+		struct pfn_reply *replyp, struct list_head *boot_root)
+{
+	int list_ct = 0;
+	int list_free_pages = 0;
+	int doit;
+	unsigned long start_pfn;
+	struct page *pagep;
+	struct page *local_pagep;
+	struct list_head *lhp;
+	struct list_head *local_lhp; /* crashkernel-relative */
+	struct list_head *prev;
+	struct pfn_element *pe;
+
+	/*
+	 * root is the crashkernel-relative address of the anchor of the
+	 * free_list.
+	 */
+	prev = root;
+	if (root == NULL) {
+		printk(KERN_EMERG "root is null!!, node %d order %d\n",
+			node, order);
+			return 0;
+	}
+
+	if (root->next == boot_root)
+		/* list is empty */
+		return 0;
+
+	lhp = root->next;
+	local_lhp = (struct list_head *)find_local_vaddr((unsigned long)lhp);
+	if (!local_lhp) {
+		return 0;
+	}
+
+	while (local_lhp != boot_root) {
+		list_ct++;
+		if (lhp == NULL) {
+			printk(KERN_EMERG
+			 "The free list has a null!!, node %d order %d\n",
+				node, order);
+			break;
+		}
+		if (list_ct > 1 && local_lhp->prev != prev) {
+			/* can't be compared to root, as that is local */
+			printk(KERN_EMERG "The free list is broken!!\n");
+			break;
+		}
+
+		/* we want the boot kernel's pfn that this page represents */
+		pagep = container_of((struct list_head *)lhp,
+							struct page, lru);
+		start_pfn = pagep - vmemmap;
+		local_pagep = container_of((struct list_head *)local_lhp,
+							struct page, lru);
+		doit = 1;
+		if (restart_list && list_ct < start_page)
+			doit = 0;
+		if (doit) {
+			if (in_pfn_list == max_pfn_list) {
+			 	/* if array would overflow, come back to
+				   this page with a continuation */
+				replyp->more = 1;
+				replyp->zone_index = zone;
+				replyp->freearea_index = order;
+				replyp->type_index = list;
+				replyp->list_ct = list_ct;
+				goto list_is_full;
+			}
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = start_pfn;
+			pe->order = order;
+			list_free_pages += (1 << order);
+		}
+		prev = lhp;
+		lhp = local_pagep->lru.next;
+		/* the local node-relative vaddr: */
+		local_lhp = (struct list_head *)
+					find_local_vaddr((unsigned long)lhp);
+		if (!local_lhp)
+			break;
+	}
+
+list_is_full:
+	return list_free_pages;
+}
+
+/*
+ * Return the pfns of free pages on this node
+ */
+int
+write_vmcore_get_free(struct pfn_list_request *reqp)
+{
+	int node;
+	int nr_zones;
+	int nr_orders = MAX_ORDER;
+	int nr_freelist = MIGRATE_TYPES;
+	int zone;
+	int order;
+	int list;
+	int start_zone = 0;
+	int start_order = 0;
+	int start_list = 0;
+	int ret;
+	int restart = 0;
+	int start_page = 0;
+	int node_free_pages = 0;
+	struct pfn_reply rep;
+	struct pglist_data *pgp;
+	struct zone *zonep;
+	struct free_area *fap;
+	struct list_head *flp;
+	struct list_head *boot_root;
+	unsigned long pgdat_paddr;
+	unsigned long pgdat_vaddr;
+	unsigned long page_aligned_pgdat;
+	unsigned long page_aligned_size;
+	void *mapped_vaddr;
+
+	node = reqp->node;
+	pgdat_paddr = reqp->pgdat_paddr;
+	pgdat_vaddr = reqp->pgdat_vaddr;
+
+	/* map this pglist_data structure within a page-aligned area */
+	page_aligned_pgdat = pgdat_paddr & ~(PAGE_SIZE - 1);
+	page_aligned_size = sizeof(struct pglist_data) +
+					(pgdat_paddr - page_aligned_pgdat);
+	page_aligned_size = ((page_aligned_size + (PAGE_SIZE - 1))
+				>> PAGE_SHIFT) << PAGE_SHIFT;
+	mapped_vaddr = ioremap_cache(page_aligned_pgdat, page_aligned_size);
+	if (!mapped_vaddr) {
+		printk("ioremap_cache of pgdat %#lx failed\n",
+				page_aligned_pgdat);
+        	return -EINVAL;
+	}
+	pgp = (struct pglist_data *)(mapped_vaddr +
+				(pgdat_paddr - page_aligned_pgdat));
+	nr_zones = pgp->nr_zones;
+	memset(&rep, 0, sizeof(rep));
+
+	if (reqp->more) {
+		restart = 1;
+		start_zone = reqp->zone_index;
+		start_order = reqp->freearea_index;
+		start_list = reqp->type_index;
+		start_page = reqp->list_ct;
+	}
+
+	in_pfn_list = 0;
+	for (zone = start_zone; zone < nr_zones; zone++) {
+		zonep = &pgp->node_zones[zone];
+		for (order = start_order; order < nr_orders; order++) {
+			fap = &zonep->free_area[order];
+			/* some free_area's are all zero */
+			if (fap->nr_free) {
+				for (list = start_list; list < nr_freelist;
+								list++) {
+					flp = &fap->free_list[list];
+					boot_root = (struct list_head *)
+						(pgdat_vaddr +
+				    		 ((unsigned long)flp -
+						 (unsigned long)pgp));
+					ret = walk_freelist(flp, node, zone,
+						order, list, restart,
+						start_page, reqp, &rep,
+						boot_root);
+					node_free_pages += ret;
+					restart = 0;
+					if (rep.more)
+						goto list_full;
+				}
+			}
+		}
+	}
+list_full:
+
+	iounmap(mapped_vaddr);
+
+	/* copy the reply and the valid part of our pfn list to the user */
+	rep.pfn_free = node_free_pages; /* the total, for statistics */
+	rep.in_pfn_list = in_pfn_list;
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	if (in_pfn_list) {
+		if (copy_to_user(reqp->pfn_list_ptr, pfn_list,
+				(in_pfn_list * sizeof(struct pfn_element))))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/*
+ * Get the memap_data table from makedumpfile
+ * and do the single allocate of the pfn_list.
+ */
+int
+write_vmcore_get_memmap(struct pfn_list_request *reqp)
+{
+	int i;
+	int count;
+	int size;
+	int ret = 0;
+	long pfn_list_elements;
+	long malloc_size;
+	unsigned long page_section_start;
+	unsigned long page_section_size;
+	struct mem_map_data *mmd, *dum_mmd;
+	struct pfn_reply rep;
+	void *bufptr;
+
+	rep.pfn_list_elements = 0;
+	if (num_mem_map_data) {
+		/* shouldn't have been done before, but if it was.. */
+		printk(KERN_INFO "warning: PL_REQUEST_MEMMAP is repeated\n");
+		for (i = 0, mmd = mem_map_data; i < num_mem_map_data;
+								i++, mmd++) {
+			iounmap(mmd->section_vaddr);
+		}
+		kfree(mem_map_data);
+		mem_map_data = NULL;
+		num_mem_map_data = 0;
+		kfree(pfn_list);
+		pfn_list = NULL;
+	}
+
+	count = reqp->map_count;
+	size = reqp->map_size;
+	bufptr = reqp->map_ptr;
+	if (size != (count * sizeof(struct mem_map_data))) {
+		printk("Error in mem_map_data, %d * %ld != %d\n",
+			count, sizeof(struct mem_map_data), size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* add a dummy at the end to limit the size of the last entry */
+	size += sizeof(struct mem_map_data);
+
+	mem_map_data = kzalloc(size, GFP_KERNEL);
+	if (!mem_map_data) {
+		printk("kmalloc of mem_map_data for %d failed\n", size);
+		ret = -EINVAL;
+		goto out;
+	}
+
+        if (copy_from_user(mem_map_data, bufptr, size)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	num_mem_map_data = count;
+
+	/* construct the dummy entry to limit the size of 'next_mmd->mem_map' */
+	/* (see find_local_vaddr() ) */
+	mmd = mem_map_data + (num_mem_map_data - 1);
+	page_section_size = (mmd->pfn_end - mmd->pfn_start) *
+							sizeof(struct page);
+	dum_mmd = mmd + 1;
+	*dum_mmd = *mmd;
+	dum_mmd->mem_map += page_section_size;
+
+	/* Fill in the ending address of array of page struct */
+	for (i = 0, mmd = mem_map_data; i < num_mem_map_data; i++, mmd++) {
+		mmd->ending_paddr = mmd->paddr +
+			((mmd->pfn_end - mmd->pfn_start) * sizeof(struct page));
+	}
+
+	/* Map each section of page structures to local virtual addresses */
+	/* (these are never iounmap'd, as this is the crash kernel) */
+	for (i = 0, mmd = mem_map_data; i < num_mem_map_data; i++, mmd++) {
+		page_section_start = mmd->paddr;
+		page_section_size = (mmd->pfn_end - mmd->pfn_start) *
+							sizeof(struct page);
+		mmd->section_vaddr = ioremap_cache(page_section_start,
+							page_section_size);
+		if (!mmd->section_vaddr) {
+			printk(
+			  "ioremap_cache of [%d] node %#lx for %#lx failed\n",
+				i, page_section_start, page_section_size);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/*
+	 * allocate the array for PFN's (just once)
+	 * get as much as we can, up to what the user specified, and return
+	 * that count to the user
+	 */
+	pfn_list_elements = reqp->list_size;
+	do {
+		malloc_size = pfn_list_elements * sizeof(struct pfn_element);
+		if ((pfn_list = kmalloc(malloc_size, GFP_KERNEL)) != NULL) {
+			rep.pfn_list_elements = pfn_list_elements;
+			max_pfn_list = pfn_list_elements;
+			goto out;
+		}
+		pfn_list_elements -= 1000;
+	} while (pfn_list == NULL && pfn_list_elements > 0);
+
+	ret = -EINVAL;
+out:
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	return ret;
+}
+
+/*
+ * Return the pfns of to-be-excluded pages fulfilling this request.
+ * This is called for each mem_map in makedumpfile's list.
+ */
+int
+write_vmcore_get_excludes(struct pfn_list_request *reqp)
+{
+	int i;
+	int start = 0;
+	int end;
+	unsigned long paddr;
+	unsigned long pfn;
+	void *vaddr;
+	struct page *pagep;
+	struct pfn_reply rep;
+	struct pfn_element *pe;
+
+	if (!num_mem_map_data) {
+		/* sanity check */
+		printk(
+		"ERROR:PL_REQUEST_MEMMAP not done before PL_REQUEST_EXCLUDE\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * the request contains (besides request type and bufptr):
+	 *  paddr (physical address of the page[0]
+	 *  count of pages in the block
+	 *  exclude bits (DL_EXCLUDE_...)
+	 */
+	paddr = reqp->paddr;
+	end = reqp->count;
+	pfn = reqp->pfn_start;
+	/* find the already-mapped vaddr of this paddr */
+	vaddr = find_local_from_paddr(paddr);
+	if (!vaddr) {
+		printk("ERROR: PL_REQUEST_EXCLUDE cannot find paddr %#lx\n",
+			paddr);
+		return -EINVAL;
+	}
+	if (reqp->more) {
+		start = reqp->map_index;
+		vaddr += (reqp->map_index * sizeof(struct page));
+		pfn += reqp->map_index;
+	}
+	memset(&rep, 0, sizeof(rep));
+	in_pfn_list = 0;
+
+	for (i = start, pagep = (struct page *)vaddr; i < end;
+							i++, pagep++, pfn++) {
+		if (in_pfn_list == max_pfn_list) {
+			rep.in_pfn_list = in_pfn_list;
+			rep.more = 1;
+			rep.map_index = i;
+			break;
+		}
+		/*
+		 * Exclude the free page managed by a buddy
+		 */
+		if ((reqp->exclude_bits & DL_EXCLUDE_FREE)
+		    && (pagep->flags & (1UL << PG_buddy))) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = pagep->private;
+			rep.pfn_free += (1 << pe->order);
+		}
+		/*
+		 * Exclude the cache page without the private page.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_CACHE)
+		    && (isLRU(pagep->flags) || isSwapCache(pagep->flags))
+		    && !isPrivate(pagep->flags) && !isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_cache++;
+		}
+		/*
+		 * Exclude the cache page with the private page.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_CACHE_PRI)
+		    && (isLRU(pagep->flags) || isSwapCache(pagep->flags))
+		    && !isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_cache_private++;
+		}
+		/*
+		 * Exclude the data page of the user process.
+		 */
+		else if ((reqp->exclude_bits & DL_EXCLUDE_USER_DATA)
+		    && isAnon(pagep->mapping)) {
+			pe = &pfn_list[in_pfn_list++];
+			pe->pfn = pfn;
+			pe->order = 0; /* assume 4k */
+			rep.pfn_user++;
+		}
+
+	}
+	rep.in_pfn_list = in_pfn_list;
+	if (copy_to_user(reqp->reply_ptr, &rep, sizeof(struct pfn_reply)))
+		return -EFAULT;
+	if (in_pfn_list) {
+		if (copy_to_user(reqp->pfn_list_ptr, pfn_list,
+				(in_pfn_list * sizeof(struct pfn_element))))
+			return -EFAULT;
+	}
+        return 0;
+}
+
+static ssize_t write_vmcore_pfn_lists(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	int ret;
+	struct pfn_list_request pfn_list_request;
+
+	if (count != sizeof(struct pfn_list_request)) {
+                return -EINVAL;
+	}
+
+        if (copy_from_user(&pfn_list_request, user_buf, count))
+                return -EFAULT;
+
+	if (pfn_list_request.request == PL_REQUEST_FREE) {
+		ret = write_vmcore_get_free(&pfn_list_request);
+	} else if (pfn_list_request.request == PL_REQUEST_EXCLUDE) {
+		ret = write_vmcore_get_excludes(&pfn_list_request);
+	} else if (pfn_list_request.request == PL_REQUEST_MEMMAP) {
+		ret = write_vmcore_get_memmap(&pfn_list_request);
+	} else {
+                return -EINVAL;
+	}
+
+	if (ret)
+		return ret;
+        return count;
+}
+
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
 };
 
+static const struct file_operations proc_vmcore_pfn_lists_operations = {
+	.write		= write_vmcore_pfn_lists,
+};
+
 static struct vmcore* __init get_new_element(void)
 {
 	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
@@ -648,6 +1212,10 @@ static int __init vmcore_init(void)
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
+
+	proc_vmcore_pfn_lists = proc_create("vmcore_pfn_lists", S_IWUSR, NULL,
+					&proc_vmcore_pfn_lists_operations);
+
 	return 0;
 }
 module_init(vmcore_init)
Index: linux/include/linux/makedumpfile.h
===================================================================
--- /dev/null
+++ linux/include/linux/makedumpfile.h
@@ -0,0 +1,115 @@
+/*
+ * makedumpfile.h
+ * portions Copyright (C) 2006, 2007, 2008, 2009  NEC Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define isLRU(flags)		(flags & (1UL << PG_lru))
+#define isPrivate(flags)	(flags & (1UL << PG_private))
+#define isSwapCache(flags)	(flags & (1UL << PG_swapcache))
+
+static inline int
+isAnon(struct address_space *mapping)
+{
+	return ((unsigned long)mapping & PAGE_MAPPING_ANON) != 0;
+}
+
+#define DL_EXCLUDE_ZERO		(0x001) /* Exclude Pages filled with Zeros */
+#define DL_EXCLUDE_CACHE	(0x002) /* Exclude Cache Pages
+				           without Private Pages */
+#define DL_EXCLUDE_CACHE_PRI	(0x004) /* Exclude Cache Pages
+				           with Private Pages */
+#define DL_EXCLUDE_USER_DATA	(0x008) /* Exclude UserProcessData Pages */
+#define DL_EXCLUDE_FREE		(0x010)	/* Exclude Free Pages */
+
+#define PL_REQUEST_FREE		1	/* request for a list of free pages */
+#define PL_REQUEST_EXCLUDE	2	/* request for a list of excludable
+					   pages */
+#define PL_REQUEST_MEMMAP	3	/* request to pass in the makedumpfile
+					   mem_map_data table */
+/*
+ * a request for finding pfn's that can be excluded from the dump
+ * they may be pages of particular types or free pages
+ */
+struct pfn_list_request {
+	int request;		/* PL_REQUEST_FREE PL_REQUEST_EXCLUDE or */
+				/* PL_REQUEST_MEMMAP */
+	int debug;
+	unsigned long paddr;	/* mem_map address for PL_REQUEST_EXCLUDE */
+	unsigned long pfn_start;/* pfn represented by paddr */
+	unsigned long pgdat_paddr; /* for PL_REQUEST_FREE */
+	unsigned long pgdat_vaddr; /* for PL_REQUEST_FREE */
+	int node;		/* for PL_REQUEST_FREE */
+	int exclude_bits;	/* for PL_REQUEST_EXCLUDE */
+	int count;		/* for PL_REQUEST_EXCLUDE */
+	void *reply_ptr;	/* address of user's pfn_reply, for reply */
+	void *pfn_list_ptr;	/* address of user's pfn array (*pfn_list) */
+	int map_count;		/* for PL_REQUEST_MEMMAP; elements */
+	int map_size;		/* for PL_REQUEST_MEMMAP; bytes in table */
+	void *map_ptr;		/* for PL_REQUEST_MEMMAP; address of table */
+	long list_size;		/* for PL_REQUEST_MEMMAP negotiation */
+	/* resume info: */
+	int more;		/* 0 for done, 1 for "there's more" */
+				/* PL_REQUEST_EXCLUDE: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+};
+
+/*
+ * the reply from a pfn_list_request
+ * the list of pfn's itself is pointed to by pfn_list
+ */
+struct pfn_reply {
+	long pfn_list_elements;	/* negotiated on PL_REQUEST_MEMMAP */
+	long in_pfn_list;	/* returned by PL_REQUEST_EXCLUDE and
+				   PL_REQUEST_FREE */
+	/* resume info */
+	int more;		/* 0 == done, 1 == there is more */
+				/* PL_REQUEST_MEMMAP: */
+	int map_index;		/* slot in the mem_map array of page structs */
+				/* PL_REQUEST_FREE: */
+	int zone_index;		/* zone within the node's pgdat_list */
+	int freearea_index;	/* free_area within the zone */
+	int type_index;		/* free_list within the free_area */
+	int list_ct;		/* page within the list */
+	/* statistic counters: */
+	unsigned long long pfn_cache;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_cache_private;	/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_user;		/* PL_REQUEST_EXCLUDE */
+	unsigned long long pfn_free;		/* PL_REQUEST_FREE */
+};
+
+struct pfn_element {
+        unsigned long pfn;
+        unsigned long order;
+};
+
+struct mem_map_data {
+	/*
+	 * pfn_start/pfn_end are the pfn's represented by this mem_map entry.
+	 * mem_map is the virtual address of the array of page structures
+	 * that represent these pages.
+	 * paddr is the physical address of that array of structures.
+	 * ending_paddr would be (pfn_end - pfn_start) * sizeof(struct page).
+	 * section_vaddr is the address we get from ioremap_cache().
+	 */
+	unsigned long long	pfn_start;
+	unsigned long long	pfn_end;
+	unsigned long		mem_map;
+	unsigned long long	paddr;		/* filled in by makedumpfile */
+	unsigned long long	ending_paddr;	/* filled in by kernel */
+	void 			*section_vaddr;	/* filled in by kernel */
+};

--azLHFNyN32YCQGCU--
