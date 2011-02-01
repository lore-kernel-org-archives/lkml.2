Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1BAVdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:33:37 -0500
Received: from claw.goop.org ([74.207.240.146]:49750 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1BAVdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:33:36 -0500
Message-ID: <4D487C25.4080901@goop.org>
Date: Tue, 01 Feb 2011 13:33:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH 02/11] xen/mmu: Add the notion of identity (1-1) mapping.
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com> <1296513876-31415-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1296513876-31415-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 02:44 PM, Konrad Rzeszutek Wilk wrote:
> Our P2M tree structure is a three-level. On the leaf nodes
> we set the Machine Frame Number (MFN) of the PFN. What this means
> is that when one does: pfn_to_mfn(pfn), which is used when creating
> PTE entries, you get the real MFN of the hardware. When Xen sets
> up a guest it initially populates a array which has descending
> (or ascending) MFN values, as so:
>
>  idx: 0,  1,       2
>  [0x290F, 0x290E, 0x290D, ..]
>
> so pfn_to_mfn(2)==0x290D. If you start, restart many guests that list
> starts looking quite random.
>
> We graft this structure on our P2M tree structure and stick in
> those MFN in the leafs. But for all other leaf entries, or for the top
> root, or middle one, for which there is a void entry, we assume it is
> "missing". So
>  pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.
>
> We add the possibility of setting 1-1 mappings on certain regions, so
> that:
>  pfn_to_mfn(0xc0000)=0xc0000
>
> The benefit of this is, that we can assume for non-RAM regions (think
> PCI BARs, or ACPI spaces), we can create mappings easily b/c we
> get the PFN value to match the MFN.
>
> For this to work efficiently we introduce one new page p2m_identity and
> allocate (via reserved_brk) any other pages we need to cover the sides
> (1GB or 4MB boundary violations). All entries in p2m_identity are set to
> INVALID_P2M_ENTRY type (Xen toolstack only recognizes that and MFNs,
> no other fancy value).
>
> On lookup we spot that the entry points to p2m_identity and return the identity
> value instead of dereferencing and returning INVALID_P2M_ENTRY. If the entry
> points to an allocated page, we just proceed as before and return the PFN.
> If the PFN has IDENTITY_FRAME_BIT set we unmask that in appropriate functions
> (pfn_to_mfn).
>
> The reason for having the IDENTITY_FRAME_BIT instead of just returning the
> PFN is that we could find ourselves where pfn_to_mfn(pfn)==pfn for a
> non-identity pfn. To protect ourselves against we elect to set (and get) the
> IDENTITY_FRAME_BIT on all identity mapped PFNs.
>
> This simplistic diagram is used to explain the more subtle piece of code.
> There is also a digram of the P2M at the end that can help.
> Imagine your E820 looking as so:
>
>                    1GB                                           2GB
> /-------------------+---------\/----\         /----------\    /---+-----\
> | System RAM        | Sys RAM ||ACPI|         | reserved |    | Sys RAM |
> \-------------------+---------/\----/         \----------/    \---+-----/
>                               ^- 1029MB                       ^- 2001MB
>
> [1029MB = 263424 (0x40500), 2001MB = 512256 (0x7D100), 2048MB = 524288 (0x80000)]
>
> And dom0_mem=max:3GB,1GB is passed in to the guest, meaning memory past 1GB
> is actually not present (would have to kick the balloon driver to put it in).
>
> When we are told to set the PFNs for identity mapping (see patch: "xen/setup:
> Set identity mapping for non-RAM E820 and E820 gaps.") we pass in the start
> of the PFN and the end PFN (263424 and 512256 respectively). The first step is
> to reserve_brk a top leaf page if the p2m[1] is missing. The top leaf page
> covers 512^2 of page estate (1GB) and in case the start or end PFN is not
> aligned on 512^2*PAGE_SIZE (1GB) we loop on aligned 1GB PFNs from start pfn to
> end pfn.  We reserve_brk top leaf pages if they are missing (means they point
> to p2m_mid_missing).
>
> With the E820 example above, 263424 is not 1GB aligned so we allocate a
> reserve_brk page which will cover the PFNs estate from 0x40000 to 0x80000.
> Each entry in the allocate page is "missing" (points to p2m_missing).
>
> Next stage is to determine if we need to do a more granular boundary check
> on the 4MB (or 2MB depending on architecture) off the start and end pfn's.
> We check if the start pfn and end pfn violate that boundary check, and if
> so reserve_brk a middle (p2m[x][y]) leaf page. This way we have a much finer
> granularity of setting which PFNs are missing and which ones are identity.
> In our example 263424 and 512256 both fail the check so we reserve_brk two
> pages. Populate them with INVALID_P2M_ENTRY (so they both have "missing" values)
> and assign them to p2m[1][2] and p2m[1][488] respectively.
>
> At this point we would at minimum reserve_brk one page, but could be up to
> three. Each call to set_phys_range_identity has at maximum a three page
> cost. If we were to query the P2M at this stage, all those entries from
> start PFN through end PFN (so 1029MB -> 2001MB) would return INVALID_P2M_ENTRY
> ("missing").
>
> The next step is to walk from the start pfn to the end pfn setting
> the IDENTITY_FRAME_BIT on each PFN. This is done in '__set_phys_to_machine'.
> If we find that the middle leaf is pointing to p2m_missing we can swap it over
> to p2m_identity - this way covering 4MB (or 2MB) PFN space.  At this point we
> do not need to worry about boundary aligment (so no need to reserve_brk a middle
> page, figure out which PFNs are "missing" and which ones are identity), as that
> has been done earlier.  If we find that the middle leaf is not occupied by
> p2m_identity or p2m_missing, we dereference that page (which covers
> 512 PFNs) and set the appropriate PFN with IDENTITY_FRAME_BIT. In our example
> 263424 and 512256 end up there, and we set from p2m[1][2][256->511] and
> p2m[1][488][0->256] with IDENTITY_FRAME_BIT set.
>
> All other regions that are void (or not filled) either point to p2m_missing
> (considered missing) or have the default value of INVALID_P2M_ENTRY (also
> considered missing). In our case, p2m[1][2][0->255] and p2m[1][488][257->511]
> contain the INVALID_P2M_ENTRY value and are considered "missing."
>
> This is what the p2m ends up looking (for the E820 above) with this
> fabulous drawing:
>
>    p2m         /--------------\
>  /-----\       | &mfn_list[0],|                           /-----------------\
>  |  0  |------>| &mfn_list[1],|    /---------------\      | ~0, ~0, ..      |
>  |-----|       |  ..., ~0, ~0 |    | ~0, ~0, [x]---+----->| IDENTITY [@256] |
>  |  1  |---\   \--------------/    | [p2m_identity]+\     | IDENTITY [@257] |
>  |-----|    \                      | [p2m_identity]+\\    | ....            |
>  |  2  |--\  \-------------------->|  ...          | \\   \----------------/
>  |-----|   \                       \---------------/  \\
>  |  3  |\   \                                          \\  p2m_identity
>  |-----| \   \-------------------->/---------------\   /-----------------\
>  | ..  +->+                        | [p2m_identity]+-->| ~0, ~0, ~0, ... |
>  \-----/ /                         | [p2m_identity]+-->| ..., ~0         |
>         / /---------------\        | ....          |   \-----------------/
>        /  | IDENTITY[@0]  |      /-+-[x], ~0, ~0.. |
>       /   | IDENTITY[@256]|<----/  \---------------/
>      /    | ~0, ~0, ....  |
>     |     \---------------/
>     |
>     p2m_missing             p2m_missing
> /------------------\     /------------\
> | [p2m_mid_missing]+---->| ~0, ~0, ~0 |
> | [p2m_mid_missing]+---->| ..., ~0    |
> \------------------/     \------------/
>
> where ~0 is INVALID_P2M_ENTRY. IDENTITY is (PFN | IDENTITY_BIT)
>
> [v4: Squished patches in just this one]
> [v5: Changed code to use ranges, added ASCII art]
> [v6: Rebased on top of xen->p2m code split]
> [v7: Added RESERVE_BRK for potentially allocated pages]
> [v8: Fixed alignment problem]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/xen/page.h |    6 ++-
>  arch/x86/xen/p2m.c              |  109 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 112 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 8ea9772..47c1b59 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -30,7 +30,9 @@ typedef struct xpaddr {
>  /**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
>  #define INVALID_P2M_ENTRY	(~0UL)
>  #define FOREIGN_FRAME_BIT	(1UL<<31)
> +#define IDENTITY_FRAME_BIT	(1UL<<30)

These need to be BITS_PER_LONG-1 and -2.

    J
