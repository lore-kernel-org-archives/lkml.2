Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2JEITs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:19:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48006 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2JEITo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 5 Oct 2012 04:19:44 -0400
Message-Id: <506EB43D020000780009FD4F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 05 Oct 2012 09:19:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: <mingo@kernel.org>, <x86@kernel.org>, <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
 <506C4C3A020000780008D041@nat28.tlf.novell.com>
 <506DFAD8.5060701@zytor.com>
 <506E9CDC020000780009FD13@nat28.tlf.novell.com>
 <1349419680.15966.32.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1349419680.15966.32.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.10.12 at 08:48, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 2012-10-05 at 07:39 +0100, Jan Beulich wrote:
>> >>> On 04.10.12 at 23:08, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> > On 10/03/2012 06:31 AM, Jan Beulich wrote:
>> >>>>> Matt Fleming <matt@console-pimps.org> 10/03/12 2:59 PM >>>
>> >>> +static int insert_identity_mapping(resource_size_t paddr, unsigned long 
>> > vaddr,
>> >>> +                    unsigned long size)
>> >>> +{
>> >>> +    unsigned long end = vaddr + size;
>> >>> +    unsigned long next;
>> >>> +    pgd_t *vpgd, *ppgd;
>> >>> +
>> >>> +#ifdef CONFIG_X86_32
>> >>> +    ppgd = initial_page_table + pgd_index(paddr);
>> >>> +
>> >>> +    if (paddr >= PAGE_OFFSET || paddr + size > PAGE_OFFSET)
>> >>> +        return 1;
>> >>> +#else
>> >>> +    ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);
>> >>
>> >> Missing equivalent code (to the 32-bit one above) here - after all, you're 
>> > trying
>> >> to potentially insert a 52-bit physical address into 48-bit virtual space.
>> >>
>> > 
>> > We should have the check, but at least for Linux support we require
>> > P <= V-2.
>> 
>> Not really imo - P <= V - 1 should be sufficient here, as all that is
>> necessary is that the result represents a 1:1 mapping. Specifically,
>> there's no constraint to the virtual space limitation of the direct
>> mapping of RAM.
> 
> Just to be clear, I was going to add this check,
> 
>         /* Don't map over the guard hole. */
>         if (paddr >= 0x7fffffffffff || paddr + size > 0x7fffffffffff)
>                 return 1;

0x800000000000 would be the right numbers in both cases.

> Since I'm guessing mapping over the guard hole would be bad. 

Really, you just can't map anything there (you'd most likely end
up mapping something at 0xffff800000000000, and that would
indeed be bad).

Jan

