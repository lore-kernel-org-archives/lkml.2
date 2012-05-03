Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2ECXrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:47:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42995 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab2ECXri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWEdsB4YEs+oueyGm99Umi0p4jYaEDEnwsHi5mgYGXBJA@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
 <CAErSpo7RNLdP4sRfg_3NE78rbvKM5HyRrApmLSLJOA8ggX=VvQ@mail.gmail.com> <CAE9FiQWEdsB4YEs+oueyGm99Umi0p4jYaEDEnwsHi5mgYGXBJA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 May 2012 17:47:16 -0600
Message-ID: <CAErSpo6Mtt2E=3Uc5CO9oxqsVL-EALAsWq5wv-wT8ei6ZXrX3w@mail.gmail.com>
Subject: Re: [PATCH -v11 00/30] PCI: allocate pci bus num range for unassigned
 bridge busn
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 3:08 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, May 2, 2012 at 2:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Set up iobusn_resource tree, and register bus number range to it.
>>> Later when need to find bus range, will try to allocate from the tree
>>>
>>> Need to test on arches other than x86. esp for ia64 and powerpc that support
>>>  more than on peer root buses.

>>  - I think we really want a [bus 00-ff] resource for each *domain*,
>> with each host bridge in the domain requesting part of that range.  I
>> think these patches only track bus number usage within each host
>> bridge, and I'm not sure there's any place we would detect conflicts
>> between host bridges.
>
> I updated the patch set a bit. now it have domain busn_res.

I like the domain bus range stuff ("Add busn_res for pci domain").
I'd like it better if we centralized more of the PCI domain support in
the core, e.g., supply the domain directly to pci_scan_root_bus() and
get rid of the arch-specific pci_domain_nr() implementations.  But
that can be done later.

> It could detect the conflicts. later could add code to resolve the conflicts.

This is in "Add busn_res operation functions".  I think this makes
sense, too.  If you look at the branch I started merging
(topic/yinghai-busn-alloc), I tweaked it to print the conflicting
resource when the insertion fails.  That information is almost always
useful when debugging, so it'd be nice if you picked that up, too.

>>  - In some of the arches (sparc, powerpc), you added a bus number
>> resource right next to existing first_busno, last_busno fields.  So
>> now that data lives two places, which will bite us later.
>
> then later we should kill first_busno and last_busno in those arches.

I want to be sensitive to the arch maintainers by doing our homework,
minimizing the number of patches we ask them to review, and grouping
related changes all at one time.  I propose the following, using
powerpc as an example:

  - Add "struct resource busn_res" to struct pci_bus.
  - powerpc: Replace pci_controller.first_busno/last_busno by "struct
resource busno" everywhere.  This will touch many places, but should
be completely mechanical and obvious.
  - powerpc: Replace all pci_bus.secondary/subordinate references with
busn_res.  This also be only obvious changes.
  - powerpc: Add the pci_add_resource() and pci_bus_update_busn_res_end() calls.
  - powerpc: Add pci_bus_insert_busn_res() call in
of_scan_pci_bridge().  (This is currently buried in the "Remove
secondary/subordinate in pci_bus" patch, but it doesn't fit there.)
  - Replace all non-arch pci_bus.secondary/subordinate references with
busn_res.  Obvious changes only.
  - Remove secondary/subordinate from struct pci_bus.
  - Add pci_bus_insert_busn_res() calls.  Again, this is logically
separate from "Remove secondary/subordinate in pci_bus".

I would split up the "Remove secondary/subordinate in pci_bus" patch,
which currently touches 30 files across 11 arches, so an arch
maintainer doesn't have to read the whole patch.

Ben, Dave, feel free to chime in if I'm going astray.

I did a fair amount of work updating changelogs and tweaking the code
in my topic/yinghai-busn-alloc branch.  I know I'm currently a
bottleneck here, and it's worse because I'm a bit obsessive.  It would
save me time if you picked up those tweaks so I don't have to re-do
them.

You have over 100 patches outstanding, and I'm having a hard time
making forward progress.  I think we need to focus on just replacing
secondary/subordinate with busn_res, doing the corresponding
arch-specific replacements, and adding the insert_resource() stuff to
build the resource trees for bus numbers.  I'm not going to merge the
probe_resource() stuff, so let's defer that and the resource
assignment stuff for later.  Also defer the unrelated
pci_hp_add_bridge() stuff that crept into your for-pci-busn-alloc
branch.  If you defer all that stuff and split out the arch stuff,
that should leave us with around 30 patches that deal *only* with
adding busn_res and building the resource trees.  I don't think this
will fix any bugs or add any new functionality, but at least it's a
manageable step towards getting the infrastructure in place, so it's
reasonable to consider merging it.

These patches need to appear on the mailing list.  In general, people
aren't going to pull your git tree and review them as I've been doing.
 But *only* post the stuff mentioned above (busn_res and related
things).  I'm not ready to consider the rest yet, so they would only
confuse things.

Bjorn
