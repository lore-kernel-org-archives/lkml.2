Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2JVSFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:05:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46076 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2JVSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121022144020.GA14425@jshin-Toonie>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
	<d556fc0f-da5d-4531-b331-6dc086461f34@blur>
	<50833F30.4020802@ti.com>
	<CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
	<20121021041858.GA14809@jshin-Toonie>
	<50843627.4020103@ti.com>
	<20121021210633.GA14311@jshin-Toonie>
	<508467EE.4040807@ti.com>
	<20121022144020.GA14425@jshin-Toonie>
Date: Mon, 22 Oct 2012 11:05:29 -0700
X-Google-Sender-Auth: lfH9_z8D44287UOOO0FA-5lDcuE
Message-ID: <CAE9FiQWvVNCK8Ka6rq+RMf3u4JFn8D18rGMy4Hpz7Rhnrn6VTA@mail.gmail.com>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on boot
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tom Rini <trini@ti.com>, hpa@zytor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 7:40 AM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Sun, Oct 21, 2012 at 02:23:58PM -0700, Tom Rini wrote:
>> On 10/21/12 14:06, Jacob Shin wrote:
>> > Ah, sorry, this one should apply on top of 3.7-rc2:
>> >
>> > https://lkml.org/lkml/2012/8/24/469
>> >
>> > Could you try that? Just that single patch, not the whole patchset.
>>
>> That fixes it, replied with a note and Tested-by, thanks!
>
> Thanks for testing!
>
> hpa, so sorry, but it looks like we need one more patch [PATCH 2/5] x86:
> find_early_table_space based on memory ranges that are being mapped:
>
>   https://lkml.org/lkml/2012/8/24/469
>
> on top of this, because find_early_table_space calculation does not come out
> correctly for this particular E820 table that Tom has:
>
>   http://pastebin.com/4eSPEAvB
>
> The reason why we hit this now, and never hit it before is because before the
> start was hard coded to 1UL<<32.
>

I'm afraid that  we may need add more patches to make v3.7 really
handle every corner case.

During testing, I found more problem:
1. E820_RAM and E820_RESEVED_KERN
   EFI change some E820_RAM to E820_RESREVED_KERN to cover
   efi setup_data. and will pass to e820_saved, to next kexec-ed kernel.
  So we can use E820_RAM to loop it, and should still E820_RAM and
E820_RESERVED_KERN combined.
  otherwise will render page table with small pages, or every some partial
  is not covered.
  So i change to for_each_mem_pfn_range(), we fill the memblock with
  E820_RAM and E820_RESERVED_KERN, and memblock will merge
  range together, that will make mapping still use big page size.

2. partial page:
   E820 or user could pass memmap that  is not page aligned.
   old cold will guarded by max_low_pfn and max_pfn. so the end partial
   page will be trimmed down, and memblock can one use it.
   middle partial page will still get covered by directly mapping, and
memblock still can use them.
   Now we will not map middle partial page and memblock still try to use it
we could get panic when accessing those pages.

So I would suggest to just revert that temporary patch at this time,
and later come out one complete patch for stable kernels.

Thanks

Yinghai
