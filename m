Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031658Ab2CGAU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:20:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030948Ab2CGAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:20:55 -0500
Message-ID: <4F56A9CB.2010504@redhat.com>
Date: Tue, 06 Mar 2012 21:20:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: EDAC devel <linux-edac@vger.kernel.org>
CC: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv7] EDAC core changes in order to properly report errors from
 all types of memory controllers
References: <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab> <4F54A6FF.50502@redhat.com> <20120305124411.GD1070@aftab> <4F54C133.6040709@redhat.com> <20120305141349.GF1070@aftab> <4F54D4AF.9060802@redhat.com> <4F553764.5070305@redhat.com> <20120305232319.GA7175@aftab> <4F55F598.7050406@redhat.com> <20120306121616.GB11661@aftab>
In-Reply-To: <20120306121616.GB11661@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here it is the version 7 of the EDAC core changes.

Version 6 skipped due to a small issue on the series.

This series has only "cosmetic" changes over the last one. No
functional changes. What's different:

- Instead of 43 patches, this series contain 21 patches. Most of the
  dirty history were removed. It is now cleaner for review.

- A few coding style changes were applied (24 lines changed, most on
  some comments with more than 80 lines).

- The first approach to address the needs for non-csrow-based memory
  controllers were removed from the history. This made the series
  cleaner, as several patches could be folded, improving patch
  readability;

- patch descriptions were changed/improved.

The series now contains:

- 2 fix patches over upstream:
      edac/ppc4xx_edac: Fix compilation
      i5400_edac: Avoid calling pci_put_device() twice

- 1 comments improvements:
      edac: Improve the comments to better describe the memory concepts

- 1 internal struct renaming patch:
      edac: rename channel_info to rank_info

- 6 patches that prepare the internal structures to represent the memory
  properties per dimm, instead of per csrow. This is needed for modern
  controllers, where the memories at different channels may be different:
      edac: Create a dimm struct and move the labels into it
      edac: Add per dimm's sysfs nodes
      edac: move dimm properties to struct memset_info
      edac: Don't initialize csrow's first_page & friends when not needed
      edac: move nr_pages to dimm struct
      edac: Add per-dimm sysfs show nodes

- 2 patches that add proper support for FB-DIMM and for the modern Intel
  DDR2/DDR3 memory controllers: 
      edac: Fix core support for MC's that see DIMMS instead of ranks
      edac: Export MC hierarchy counters for CE and UE

- 1 log cleanup patch, that prepares for using a MCA based tracepoint:
      edac: Cleanup the logs for i7core and sb edac drivers

- 2 debug improvement patches:
      edac: Add a sysfs node to test the EDAC error report facility
      edac: Initialize the dimm label with the known information

- 5 post-FB-DIMM patches that cleans, fix and/or improve a few random things:
      edac_mc_sysfs: don't create inactive errcount sysfs nodes
      i5000_edac: Fix the logic that retrieves memory information
      edac: add a sysfs node that stores the max possible memory location
      edac: Call the sysfs nodes as "rank" instead of "dimm" if chip select is used
      i5400_edac: improve debug messages to better represent the filled memory

- 1 patch that adds a trace event to report memory errors:
      events/hw_event: Create a Hardware Events Report Mecanism (HERM)

While the preliminar tests is working ok on the machines I'm testing,
as I didn't finish the tests yet, some other fix patches may be needed,
but I'll insert them at the end of the series, as rebasing a large patchset
like that is very time-consuming.

So,  I think it is time to merge it at -next, in order to give more visibility
to it. So, tomorrow, I'll add it there, if I got no complains.

The above changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v7


Em 06-03-2012 09:16, Borislav Petkov escreveu:
> On Tue, Mar 06, 2012 at 08:31:36AM -0300, Mauro Carvalho Chehab wrote:

>> For a FB-DIMM controller, the number of ranks is just a detail associated with
>> a given DIMM slot, as the memory is selected by slot, and not by rank.
>>
>> So, the logic is completely broken for single-rank memories and half-broken for 
>> double-rank ones.
> 
> I'm still wondering whether FBDIMM-based drivers should get their own
> EDAC infrastructure and own nomenclature instead of fitting them in the
> existing scheme...

A typical driver using csrow/channel describes the memory based on ranks. 
A FB-DIMM memory controller describes memory based on DIMMs. But those
are just the to opposite sides of the issue. There's a number of other
situations between them. Creating a FBDIMM-based won't cover them.

There are "non-typical" DDR2/DDR3 drivers that also describes the memory
internally using DIMMs, due to several factors:
	1) a rank is not a FRU. The FRU is a DIMM;
	2) several memory controllers hide the ranks information;
	3) some memory controllers have the number of ranks as a property
	   for a dimm;
	4) Some memory controllers allow using different dimms on separate
	   channels[1]. So, the memory at slot 0 at channel 0 can be different
	   than the one at channel 1.

[1] probably, there are some limits on it, depending on how the memory
    channels are interlaced, but it seems that the Intel memory controllers
    with 3 or 4 channels allow the usage of different memory sticks on
    each channel or channel pair.

After analyzing all EDAC drivers, the "typical" case is actually a minority,
nowadays.

Also, the upstream version currently has a per-rank memory label, with is
very bad, as two ranks at the same DIMM may receive two different labels.

So, it is actually better to convert the existing drivers to internally
represent the memory DIMMs.


Regards,
Mauro
