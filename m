Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab2HWPj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:39:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54728 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059Ab2HWPjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:39:15 -0400
Message-ID: <50364E9E.6020104@zytor.com>
Date: Thu, 23 Aug 2012 08:39:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com> <1344983957-4996-4-git-send-email-jacob.shin@amd.com> <50356BA9.5030906@zytor.com> <20120823145043.GA4671@jshin-Toonie>
In-Reply-To: <20120823145043.GA4671@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 07:50 AM, Jacob Shin wrote:
>>
>> I have one concern with this, which is that it leaves in place mapping
>> below the initial max_pfn_mapped.  Although that neatly resolves the
>> legacy area (0-1 MiB) issues, it really isn't right above the 1 MiB
>> point.  Any way I could get you to seek out and unmap any such ranges?
>> We have already seen some Dell machines which put memory holes in low
>> RAM, and perhaps there are still some machines out there with an I/O
>> hole at 15 MiB.
>
> So I believe in V2 of the patchset this was done, however, Dave Young
> from redhat reported that it broke their KVM guest with a user supplied
> memory map that looked like this:
>
>>> [    0.000000] e820: user-defined physical RAM map:
>>> [    0.000000] user: [mem 0x0000000000010000-0x000000000009dbff] usable
>>> [    0.000000] user: [mem 0x0000000024000000-0x0000000033f6bfff] usable
>
> And looking into that scenario, the early boot code seems to allocates
> space for fixmap right under initial max_pfn_mapped, which is no longer
> direct mapped with my patch, and that seems to cause problems for later
> APIC code that initializes APIC base address into the fixmap area.
>
> So I guess to address your concern, we need to go back to V2 and try to
> resolve the fixmap problem with user supplied memory map that reserves
> memory below initial max_pfn_mapped ?
>

Okay... I think I need to grok that a bit better.  For memory 
allocations, we probably should just use brk allocations, for virtual 
space allocations it is called the fixmap for a reason (even though the 
Xen people managed to break that on 32 bits, sigh!)

I guess I need to go back and look at David's bug report...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

