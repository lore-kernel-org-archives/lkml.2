Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2JVSjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:39:15 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:33814
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab2JVSjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:39:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zzbb2dI98dI9371I103dK148cI1432Izz1202h1d1ah1d2ahzz177df4h17326ah8275bh8275dhf73b6uz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1155h)
X-WSS-ID: 0MCB550-01-NSI-02
X-M-MSG: 
Date: Mon, 22 Oct 2012 13:38:58 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Tom Rini <trini@ti.com>, <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
Message-ID: <20121022183858.GA31185@jshin-Toonie>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
 <d556fc0f-da5d-4531-b331-6dc086461f34@blur>
 <50833F30.4020802@ti.com>
 <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
 <20121021041858.GA14809@jshin-Toonie>
 <50843627.4020103@ti.com>
 <20121021210633.GA14311@jshin-Toonie>
 <508467EE.4040807@ti.com>
 <20121022144020.GA14425@jshin-Toonie>
 <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:05:29AM -0700, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 7:40 AM, Jacob Shin <jacob.shin@amd.com> wrote:
> > On Sun, Oct 21, 2012 at 02:23:58PM -0700, Tom Rini wrote:
> >> On 10/21/12 14:06, Jacob Shin wrote:
> >> > Ah, sorry, this one should apply on top of 3.7-rc2:
> >> >
> >> > https://lkml.org/lkml/2012/8/24/469
> >> >
> >> > Could you try that? Just that single patch, not the whole patchset.
> >>
> >> That fixes it, replied with a note and Tested-by, thanks!
> >
> > Thanks for testing!
> >
> > hpa, so sorry, but it looks like we need one more patch [PATCH 2/5] x86:
> > find_early_table_space based on memory ranges that are being mapped:
> >
> >   https://lkml.org/lkml/2012/8/24/469
> >
> > on top of this, because find_early_table_space calculation does not come out
> > correctly for this particular E820 table that Tom has:
> >
> >   http://pastebin.com/4eSPEAvB
> >
> > The reason why we hit this now, and never hit it before is because before the
> > start was hard coded to 1UL<<32.
> >
> 
> I'm afraid that  we may need add more patches to make v3.7 really
> handle every corner case.
> 
> During testing, I found more problem:
> 1. E820_RAM and E820_RESEVED_KERN
>    EFI change some E820_RAM to E820_RESREVED_KERN to cover
>    efi setup_data. and will pass to e820_saved, to next kexec-ed kernel.
>   So we can use E820_RAM to loop it, and should still E820_RAM and
> E820_RESERVED_KERN combined.
>   otherwise will render page table with small pages, or every some partial
>   is not covered.
>   So i change to for_each_mem_pfn_range(), we fill the memblock with
>   E820_RAM and E820_RESERVED_KERN, and memblock will merge
>   range together, that will make mapping still use big page size.

Does EFI do this on above 4G memory? All the EFI BIOSes we have in house looked
to be only touching under 4G.

> 
> 2. partial page:
>    E820 or user could pass memmap that  is not page aligned.
>    old cold will guarded by max_low_pfn and max_pfn. so the end partial
>    page will be trimmed down, and memblock can one use it.
>    middle partial page will still get covered by directly mapping, and
> memblock still can use them.
>    Now we will not map middle partial page and memblock still try to use it
> we could get panic when accessing those pages.
> 
> So I would suggest to just revert that temporary patch at this time,
> and later come out one complete patch for stable kernels.

Hm okay, I was hoping not, but if it has to be ..

> 
> Thanks
> 
> Yinghai
> 

