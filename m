Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab2EDUHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:07:37 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:53194 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759542Ab2EDUHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:07:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Mtt2E=3Uc5CO9oxqsVL-EALAsWq5wv-wT8ei6ZXrX3w@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<CAErSpo7RNLdP4sRfg_3NE78rbvKM5HyRrApmLSLJOA8ggX=VvQ@mail.gmail.com>
	<CAE9FiQWEdsB4YEs+oueyGm99Umi0p4jYaEDEnwsHi5mgYGXBJA@mail.gmail.com>
	<CAErSpo6Mtt2E=3Uc5CO9oxqsVL-EALAsWq5wv-wT8ei6ZXrX3w@mail.gmail.com>
Date: Fri, 4 May 2012 13:07:35 -0700
X-Google-Sender-Auth: DJ8eTj112uhhDxkRL3TbG0V2A58
Message-ID: <CAE9FiQU7s2Qt1VEASsaMOXWm+1_Hv=LDaOLeECTUwTPjKHiAZw@mail.gmail.com>
Subject: Re: [PATCH -v11 00/30] PCI: allocate pci bus num range for unassigned
 bridge busn
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 4:47 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> It could detect the conflicts. later could add code to resolve the conflicts.
>
> This is in "Add busn_res operation functions".  I think this makes
> sense, too.  If you look at the branch I started merging
> (topic/yinghai-busn-alloc), I tweaked it to print the conflicting
> resource when the insertion fails.  That information is almost always
> useful when debugging, so it'd be nice if you picked that up, too.

ok, will check that branch and put that change in.

>
>>>  - In some of the arches (sparc, powerpc), you added a bus number
>>> resource right next to existing first_busno, last_busno fields.  So
>>> now that data lives two places, which will bite us later.
>>
>> then later we should kill first_busno and last_busno in those arches.
>
> I want to be sensitive to the arch maintainers by doing our homework,
> minimizing the number of patches we ask them to review, and grouping
> related changes all at one time.  I propose the following, using
> powerpc as an example:
>
>  - Add "struct resource busn_res" to struct pci_bus.
>  - powerpc: Replace pci_controller.first_busno/last_busno by "struct
> resource busno" everywhere.  This will touch many places, but should
> be completely mechanical and obvious.
>  - powerpc: Replace all pci_bus.secondary/subordinate references with
> busn_res.  This also be only obvious changes.
>  - powerpc: Add the pci_add_resource() and pci_bus_update_busn_res_end() calls.
>  - powerpc: Add pci_bus_insert_busn_res() call in
> of_scan_pci_bridge().  (This is currently buried in the "Remove
> secondary/subordinate in pci_bus" patch, but it doesn't fit there.)
>  - Replace all non-arch pci_bus.secondary/subordinate references with
> busn_res.  Obvious changes only.
>  - Remove secondary/subordinate from struct pci_bus.
>  - Add pci_bus_insert_busn_res() calls.  Again, this is logically
> separate from "Remove secondary/subordinate in pci_bus".
>
> I would split up the "Remove secondary/subordinate in pci_bus" patch,
> which currently touches 30 files across 11 arches, so an arch
> maintainer doesn't have to read the whole patch.

could split that a little. not sure if it is worth it.

1. core update subordinate and busn_res.end at same time.
2. update subordinate and busn_res.end at same time
2. remove using secondary/subordinate in arch
3. remove using secondary/suborindate in core

>
> Ben, Dave, feel free to chime in if I'm going astray.
>
> I did a fair amount of work updating changelogs and tweaking the code
> in my topic/yinghai-busn-alloc branch.  I know I'm currently a
> bottleneck here, and it's worse because I'm a bit obsessive.  It would
> save me time if you picked up those tweaks so I don't have to re-do
> them.

ok, will pick them up.

>
> You have over 100 patches outstanding, and I'm having a hard time
> making forward progress.  I think we need to focus on just replacing
> secondary/subordinate with busn_res, doing the corresponding
> arch-specific replacements, and adding the insert_resource() stuff to
> build the resource trees for bus numbers.  I'm not going to merge the
> probe_resource() stuff, so let's defer that and the resource
> assignment stuff for later.  Also defer the unrelated
> pci_hp_add_bridge() stuff that crept into your for-pci-busn-alloc
> branch.  If you defer all that stuff and split out the arch stuff,
> that should leave us with around 30 patches that deal *only* with
> adding busn_res and building the resource trees.  I don't think this
> will fix any bugs or add any new functionality, but at least it's a
> manageable step towards getting the infrastructure in place, so it's
> reasonable to consider merging it.

let me check if i change to that order.

>
> These patches need to appear on the mailing list.  In general, people
> aren't going to pull your git tree and review them as I've been doing.
>  But *only* post the stuff mentioned above (busn_res and related
> things).  I'm not ready to consider the rest yet, so they would only
> confuse things.

ok.

Yinghai
