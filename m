Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0G1Rys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:54:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57386 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0G1Ryq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:54:46 -0400
Message-ID: <4C506E9B.4070501@zytor.com>
Date: Wed, 28 Jul 2010 10:53:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>	 <4C4FD04B.5090503@zytor.com> <1280336548.30808.489.camel@mulgrave.site>
In-Reply-To: <1280336548.30808.489.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 10:02 AM, James Bottomley wrote:
> On Tue, 2010-07-27 at 23:38 -0700, H. Peter Anvin wrote:
>> On 07/27/2010 11:08 PM, Yinghai Lu wrote:
>>>
>>> for example: 
>>> high/low allocation, from first kernel to kexec second kernel, always work fine except system with Qlogic card.
>>> because Qlogic card is using main RAM as EFT etc for card's FW log trace. second kernel have not idea that those RAM
>>>  is used by first kernel for that purpose. that the CARD still use that between two kernels.
>>> second kernel could have crash it try to use those ram.
>>>
>>
>> Uhm, no.  That's a bug in the Qlogic driver not shutting the card down
>> cleanly.  Hacking around that in memory allocation order is braindamaged
>> in the extreme.  kexec *cannot* be safe in any way if we don't shut down
>> pending DMA, and what you describe above is DMA.
> 
> That's not the kexec for crash dump requirement as it was communicated
> to us.  We were specifically told that the shutdown routines *may* not
> be called before booting the kexec kernel and thus we have to take
> action to stop the DMA engines in the init routines so the kexec kernel
> can halt all in-progress DMA as it boots.  This implies that kexec must
> be able to cope with in-progress DMA.
> 

kexec for crash dump is a special case: for crash dump, there is a chunk
of memory pre-reserved for the crash kernel, and that is the *only*
memory that the crash kernel will use.  In other words, everything else
is reserved memory as far as the crash kernel is concerned.  As such, it
should not be affected; there may be DMA still pending to the main
kernel's memory area, of course, but as far as the crash kernel is
concerned, that should just be input data.

If allocation order somehow matters for the *crash kernel*, then we have
even more fundamental problems...

Obviously, if there is DMA going on to the crash kernel reserved region
then all bets are off, but at that point the system is so screwed anyway
that it shouldn't matter.

	-hpa

