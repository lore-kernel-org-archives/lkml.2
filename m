Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1GZWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:34:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34603 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1GZWer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:34:47 -0400
Message-ID: <4E2F40EA.70308@zytor.com>
Date: Tue, 26 Jul 2011 15:34:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@amd.com>
CC: Borislav Petkov <bp@amd64.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab> <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab> <4E2F09BB.9060605@zytor.com> <4E2F1889.8030708@amd.com>
In-Reply-To: <4E2F1889.8030708@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 12:42 PM, Andre Przywara wrote:
>>
>> In other words, it's completely ad hoc.
> 
> There is no need to determine it by calculating, because it caused by 
> the special design of the BD L1 cache and thus fixed.
> And a calculation would be even more confusing:
> 
> The L1I is virtually indexed, but physically tagged.
> 64KB L1I cache, 64 Bytes per Cacheline = 1024 cache lines
> 1024 lines / 2 way associative = 512 indexes
> 64 Bytes per Cacheline (6 bits) + 512 indexes (9 bits) = bits [14:0]
> virtual and physical addresses are the same for bits [11:0], which 
> leaves the remaining 14:12 susceptible for aliasing.
> 
> So bit 12 comes from PAGESIZE and yes, the 14 could be derived from the 
> CPUID cache info, but I don't see much value in breaking this down this way.
> But I agree that there should be some comment in the patch which at 
> least notes that bits [14:12] are due to the L1I design, maybe we can 
> copy a nicer version of the above math in the commit message for reference.
> 

The right thing to do this would be to have a bit in CPUID which would
indicate that the kernel has to perform the above calculation -- because
obviously not all CPUs have this issue.  From that we can calculate a
mask to insert into whatever appropriate location... depending on the
exact tack we have to apply to deal with this situation.

	-hpa

