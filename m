Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2DPM6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2DPM6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:58:37 -0400
Message-ID: <4F8C176F.5020706@redhat.com>
Date: Mon, 16 Apr 2012 09:58:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 00/13] Convert EDAC internal strutures to support all
 types of Memory Controllers
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com> <20120402135959.GC24238@aftab>
In-Reply-To: <20120402135959.GC24238@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-04-2012 10:59, Borislav Petkov escreveu:
> On Thu, Mar 29, 2012 at 01:45:33PM -0300, Mauro Carvalho Chehab wrote:
>> This is the 12th and final rebase of this patch series.
>>
>> It is the first patchset for the EDAC rewrite. On this patchset,
>> there are all the internal changes at the EDAC core, needed
>> to properly represent memories at modern memory controllers that
>> aren't oriented per rank/channel.
>>
>> It is needed in order to fix a long-term bug at the EDAC drivers
>> for the Intel memory controllers deployed since 2005 (well, in fact,
>> there is one Rambus that it is older, but also suffers from the same
>> syndrome), including the drivers for the recent Intel Nehalem and
>> Sandy Bridge architectures.
>>
>> The new EDAC architecture supports both per rank/channel memory
>> controllers and per-DIMM ones.
>>
>> On this changeset, there are no changes at the sysfs nodes. Just 
>> like before this changeset, non-per-rank memory controllers 
>> will expose memories as "virtual csrows/virtual channels[1].
>>
>> [1] It sounds better to say "virtual" than to admit that all
>> EDAC Intel drivers since 2005 need to lie about their age to
>> the EDAC core, in order for the Kernel to accept them ;)
>>
>> Mauro Carvalho Chehab (13):
>>   edac: Create a dimm struct and move the labels into it
>>   edac: move dimm properties to struct memset_info
>>   edac: Don't initialize csrow's first_page & friends when not needed
>>   edac: move nr_pages to dimm struct
>>   edac: Fix core support for MC's that see DIMMS instead of ranks
> 
> I was wondering why 6/13 doesn't apply cleanly but there's the patch
> above, 5/13 missing in the submission. It looks like vger has eaten it
> at least for the linux-edac mailing list - the patch is still on lkml
> though.

That's weird. Maybe it was just a temporary error at vger. I'll contact vger
maintainers in order to double check what's happening there.

> 
> And what a patch it is: almost 5000 lines.

No. It is half of it (2449 lines):
---
 drivers/edac/amd64_edac.c      |  137 ++++++---
 drivers/edac/amd76x_edac.c     |   30 ++-
 drivers/edac/cell_edac.c       |   26 ++-
 drivers/edac/cpc925_edac.c     |   25 ++-
 drivers/edac/e752x_edac.c      |   51 +++-
 drivers/edac/e7xxx_edac.c      |   39 ++-
 drivers/edac/edac_core.h       |   48 +--
 drivers/edac/edac_device.c     |   27 +-
 drivers/edac/edac_mc.c         |  657 +++++++++++++++++++++++-----------------
 drivers/edac/edac_mc_sysfs.c   |   91 +++---
 drivers/edac/edac_module.h     |    2 +-
 drivers/edac/edac_pci.c        |    7 +-
 drivers/edac/i3000_edac.c      |   27 ++-
 drivers/edac/i3200_edac.c      |   34 ++-
 drivers/edac/i5000_edac.c      |   58 +++--
 drivers/edac/i5100_edac.c      |   90 +++---
 drivers/edac/i5400_edac.c      |  217 ++++++++------
 drivers/edac/i7300_edac.c      |   81 ++---
 drivers/edac/i7core_edac.c     |  202 +++---------
 drivers/edac/i82443bxgx_edac.c |   28 +-
 drivers/edac/i82860_edac.c     |   44 ++-
 drivers/edac/i82875p_edac.c    |   31 ++-
 drivers/edac/i82975x_edac.c    |   29 ++-
 drivers/edac/mpc85xx_edac.c    |   28 ++-
 drivers/edac/mv64x60_edac.c    |   25 ++-
 drivers/edac/pasemi_edac.c     |   27 +-
 drivers/edac/ppc4xx_edac.c     |   33 ++-
 drivers/edac/r82600_edac.c     |   29 ++-
 drivers/edac/sb_edac.c         |  159 ++++-------
 drivers/edac/tile_edac.c       |   16 +-
 drivers/edac/x38_edac.c        |   30 ++-
 include/linux/edac.h           |  121 +++++++-
 32 files changed, 1392 insertions(+), 1057 deletions(-)

This patch series is all about the edac.h changes: the old per-csrow/channel
way of allocating/describing/reporting memory errors got replaced. As a side
effect of this single change, all the rest needed to be fixed, to avoid compilation
breakage.

The API change at edac.h has 121 lines, and it directly caused the changes at
edac_mc/edac_mc_sysfs. An EDAC core reviewer should start reading this patch by
those changes.

On non-FB-DIMM/Nehalem/SB drivers, the driver changes are trivial: just function calls
got replaced and a few code were re-ordered on a few places, in order to provide more 
info to the error report function when part of the parser fails. It shouldn't be
hard for driver maintainers to review those changes.

The changes on the other drivers aren't a direct function call conversion.
They got real fixes, in order to proper address the FB-DIMM way of working
with memories. I am the author/maintainer of most of those drivers, so I should
know exactly what I'm doing there. Yet, I had to dig for several hours on
datasheets, in order to double check some of the changes there, and being sure
that the new code will work properly.

Also, I tested the changes there on real hardware.

> 
> Please split it!
> 
> And don't tell me it cannot be done: each patch needs to do one thing
> and one thing only. From looking at this monster, here's one possible
> way to split it:
> 
> * add all changes to include/linux/edac.h

No way. Applying just the include/linux/edac.h changes:

drivers/edac/edac_mc.c: In function ‘edac_mc_dump_channel’:
drivers/edac/edac_mc.c:47:2: error: ‘struct dimm_info’ has no member named ‘ce_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_dump_mci’:
drivers/edac/edac_mc.c:71:2: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c: In function ‘edac_mc_alloc’:
drivers/edac/edac_mc.c:195:5: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:217:25: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:221:8: error: ‘struct dimm_info’ has no member named ‘csrow_channel’
drivers/edac/edac_mc.c:223:7: error: ‘struct mem_ctl_info’ has no member named ‘nr_dimms’
drivers/edac/edac_mc.c: In function ‘edac_mc_add_mc’:
drivers/edac/edac_mc.c:531:22: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c: In function ‘edac_mc_find_csrow_by_page’:
drivers/edac/edac_mc.c:663:21: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_ce’:
drivers/edac/edac_mc.c:710:16: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:712:3: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:741:5: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/edac_mc.c:743:41: error: ‘struct dimm_info’ has no member named ‘ce_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_ce_no_info’:
drivers/edac/edac_mc.c:772:5: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_ue’:
drivers/edac/edac_mc.c:791:16: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:793:3: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:826:5: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_ue_no_info’:
drivers/edac/edac_mc.c:840:5: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_fbd_ue’:
drivers/edac/edac_mc.c:859:18: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:861:3: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:888:5: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/edac_mc.c: In function ‘edac_mc_handle_fbd_ce’:
drivers/edac/edac_mc.c:923:18: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:925:3: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc.c:948:5: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/edac_mc.c:950:43: error: ‘struct dimm_info’ has no member named ‘ce_count’
drivers/edac/edac_mc_sysfs.c: In function ‘mci_reset_counters_store’:
drivers/edac/edac_mc_sysfs.c:428:5: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/edac_mc_sysfs.c:429:5: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/edac_mc_sysfs.c:431:25: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc_sysfs.c: In function ‘mci_ue_count_show’:
drivers/edac/edac_mc_sysfs.c:498:34: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/edac_mc_sysfs.c: In function ‘mci_ce_count_show’:
drivers/edac/edac_mc_sysfs.c:503:34: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/edac_mc_sysfs.c: In function ‘mci_size_mb_show’:
drivers/edac/edac_mc_sysfs.c:530:37: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc_sysfs.c: In function ‘edac_create_sysfs_mci_device’:
drivers/edac/edac_mc_sysfs.c:942:21: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc_sysfs.c: In function ‘edac_remove_sysfs_mci_device’:
drivers/edac/edac_mc_sysfs.c:995:21: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’
drivers/edac/edac_mc_sysfs.c: In function ‘mci_ce_count_show’:
drivers/edac/edac_mc_sysfs.c:504:1: warning: control reaches end of non-void function [-Wreturn-type]
drivers/edac/edac_mc_sysfs.c: In function ‘mci_ue_count_show’:
drivers/edac/edac_mc_sysfs.c:499:1: warning: control reaches end of non-void function [-Wreturn-type]
drivers/edac/i5100_edac.c: In function ‘i5100_handle_ce’:
drivers/edac/i5100_edac.c:442:5: error: ‘struct mem_ctl_info’ has no member named ‘ce_count’
drivers/edac/i5100_edac.c: In function ‘i5100_handle_ue’:
drivers/edac/i5100_edac.c:468:5: error: ‘struct mem_ctl_info’ has no member named ‘ue_count’
drivers/edac/i5100_edac.c: In function ‘i5100_init_csrows’:
drivers/edac/i5100_edac.c:850:21: error: ‘struct mem_ctl_info’ has no member named ‘nr_csrows’

The changes at edac.h are replacing the csrow-dependent broken internal ABI
to a csrow-independent one. Due to that single change, all existing code needs to
be touched.

> * a bunch of changes to edac_mc.c like edac_align_ptr etc

edac_align_ptr changes can indeed be put on a separate patch. I'll work on it.

> * changes to edac_mc_alloc

Those are also related with the edac.h changes: the data got moved from one place to 
another one, some fields disappeared, others appeared.

The alloc routine need to follow the representation changes that happened at edac.h.

> * add edac_mc_handle_error
> * switch old edac_mc_handle* stuff to edac_mc_handle_error

Same here: all edac_mc_handle* are dependent on the internal representation
of the memory architecture. For example, all edac_mc_handle*_fbd_* are related
to the way FB-DIMMs got faked inside the EDAC core. Fixing the internal representation
means that all those arch-dependent methods should cease to exist at the patch that
fixes it, as the old way doesn't work anymore.

Basically, except for edac_align_ptr() changes that can indeed be split,
all the rest are just a side effect of changing include/linux/edac.h.

Regards,
Mauro
