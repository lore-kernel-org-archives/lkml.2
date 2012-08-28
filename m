Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2H1QGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:06:41 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36853
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022Ab2H1QGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:06:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371I1432I179dNzz1202hzz8275bhz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9H3EX-02-KUC-02
X-M-MSG: 
Date: Tue, 28 Aug 2012 11:06:31 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120828160626.GA21454@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
 <CAE9FiQUjaBSn0q=+om7+CPjLXVD9Pemf=mNvgYG7C3bE5XxOSw@mail.gmail.com>
 <20120825042409.GD26127@jshin-Toonie>
 <CAE9FiQX2DApN=OU=xTK3VA+p1mDJ=U+qFyyRkaeTiH+xF5dQXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQX2DApN=OU=xTK3VA+p1mDJ=U+qFyyRkaeTiH+xF5dQXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 09:54:04PM -0700, Yinghai Lu wrote:
> On Fri, Aug 24, 2012 at 9:24 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > On Fri, Aug 24, 2012 at 06:07:01PM -0700, Yinghai Lu wrote:
> >> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> >>
> >> looks like you could avoid add pfn_mapped[] array.
> >>
> >> pfn_range_is_mapped() should be
> >> check max_low_pfn_mapped, max_pfn_mapped with
> >> e820_all_mapped(start, end, E820_RAM).
> >
> > Hmm .. I guess that could work .. but what about EFI code that keys off of
> > EFI memory map? Does the EFI code update e820 and mark as E820_RAM whatever
> > ranges that it calls init_memory_mapping on (via efi_ioremap?)
> 
> they are converted to e820 memmap before init_memory_mapping is called.

Yinghai, looking into this further on my EFI enabled machine, there is a
memory range where:

- e820 marks it as E820_RESERVED
- EFI memory map marks it as EFI_RUNTIME_SERVICES_DATA

During EFI init, the range is added (redundantly) to e820 as E820_RESERVED,
but during efi_enter_virtual_mode, direct mappings are created for the
range with a call to efi_ioremap.

Another such region is EFI_RUNTIME_SERVICES_CODE which is marked as
ACPI NVS.

So these are not E820_RAM, but direct mapped by EFI code path .. what do
we do here? I think we should just stick with keeping the pfn_mapped[]
array .. no?

-Jacob

> 
> Thanks
> 
> Yinghai
> 

