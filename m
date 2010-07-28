Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0G1VLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:11:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16891 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0G1VLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:11:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="48974054"
Message-ID: <4C509CF2.1000509@codeaurora.org>
Date: Wed, 28 Jul 2010 14:11:14 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>	<20100728132314.29cd68c5.akpm@linux-foundation.org>	<4C509772.1070407@codeaurora.org> <20100728135857.2a0ab8bd.akpm@linux-foundation.org> <4C509B6F.8000200@linux.intel.com>
In-Reply-To: <4C509B6F.8000200@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 02:04 PM, Arjan van de Ven wrote:
> On 7/28/2010 1:58 PM, Andrew Morton wrote:
>>
>> My main concern is that someone will type usleep(50) and won't realise
>> that it goes and sleeps for 100 usecs and their code gets slow as a
>> result.  This sort of thing takes *years* to discover and fix.  If we'd
>> forced them to type usleep_range() instead, it would never have happened.
>>
>>
>>
>> Another question: what is the typical overhead of a usleep()?  IOW, at
>> what delay value does it make more sense to use udelay()?  Another way
>> of asking that would be "how long does a usleep(1) take"?  If it
>> reliably consumes 2us CPU time then we shouldn't do it.
>>
>> But it's not just CPU time, is it?  A smart udelay() should put the CPU
>> into a lower power state, so a udelay(3) might consume less energy than
>> a usleep(2), because the usleep() does much more work in schedule() and
>> friends?
>>    
> 
> for very low values of udelay() you're likely right.... but we could and
> should catch that inside usleep imo and fall back to a udelay
> it'll likely be 10 usec or so where we'd cut off.
> 

You're saying:

usleep(usecs) {
   if (usecs <= 10) /* or some other cutoff */
	return udelay (usecs)
   ...
}

ish?

> now there is no such thing as a "low power udelay", not really anyway....
> 
> but the opposite is true; the cpu idle code will effectively do the
> equivalent of udelay() if you're asking for a very short delay, so
> short that any power saving thing isn't giong to be worth it. ( +
> hitting scheduler overhead
> 
> 

I think the cpu idle code covers you in the case where there's nothing
else to do, but if schedule tries to let something else run and then
is almost immediately interrupted, this is probably a net loss / BadThing.

I have no idea what an appropriate cutoff for this would be, I found two dated
(2007) papers discussing the overhead of a context switch:

      http://www.cs.rochester.edu/u/cli/research/switch.pdf
      IBM eServer, dual 2.0GHz Pentium Xeon; 512 KB L2, cache line 128B
      Linux 2.6.17, RHEL 9, gcc 3.2.2 (-O0)
      3.8 us / context switch

      http://delivery.acm.org/10.1145/1290000/1281703/a3-david.pdf
      ARMv5, ARM926EJ-S on an OMAP1610 (set to 120MHz clock)
      Linux 2.6.20-rc5-omap1
      48 us / context switch

but nothing more recent on a quick search.


Any thoughts on how to determine an appropriate cutoff?

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
