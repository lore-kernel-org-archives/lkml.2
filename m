Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0G1VZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:25:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:45245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab0G1VZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="822655089"
Message-ID: <4C50A054.8030503@linux.intel.com>
Date: Wed, 28 Jul 2010 14:25:40 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Patrick Pannuto <ppannuto@codeaurora.org>, linux-kernel@vger.kernel.org,
        apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>	<20100728132314.29cd68c5.akpm@linux-foundation.org>	<4C509772.1070407@codeaurora.org>	<20100728135857.2a0ab8bd.akpm@linux-foundation.org>	<4C509B6F.8000200@linux.intel.com> <20100728142239.d8dd468b.akpm@linux-foundation.org>
In-Reply-To: <20100728142239.d8dd468b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/2010 2:22 PM, Andrew Morton wrote:
> On Wed, 28 Jul 2010 14:04:47 -0700
> Arjan van de Ven<arjan@linux.intel.com>  wrote:
>
>    
>> On 7/28/2010 1:58 PM, Andrew Morton wrote:
>>      
>>> My main concern is that someone will type usleep(50) and won't realise
>>> that it goes and sleeps for 100 usecs and their code gets slow as a
>>> result.  This sort of thing takes *years* to discover and fix.  If we'd
>>> forced them to type usleep_range() instead, it would never have happened.
>>>
>>>
>>>
>>> Another question: what is the typical overhead of a usleep()?  IOW, at
>>> what delay value does it make more sense to use udelay()?  Another way
>>> of asking that would be "how long does a usleep(1) take"?  If it
>>> reliably consumes 2us CPU time then we shouldn't do it.
>>>
>>> But it's not just CPU time, is it?  A smart udelay() should put the CPU
>>> into a lower power state, so a udelay(3) might consume less energy than
>>> a usleep(2), because the usleep() does much more work in schedule() and
>>> friends?
>>>
>>>        
>> for very low values of udelay() you're likely right.... but we could and
>> should catch that inside usleep imo and fall back to a udelay
>> it'll likely be 10 usec or so where we'd cut off.
>>
>> now there is no such thing as a "low power udelay", not really anyway....
>>      
> Yup.  I can't find any arch which tries to do anything fancy.
>
> x86's rep_nop() tries to save a bit of juice, doesn't it?  Should we be
> using that?
>    

it doesn't save juice so much as it is a "yield to my hyperthreading 
brother"
(there is some power saved as well potentially...)

afaik we already use this in udelay()    (cpu_relax is rep_nop after all)

> Because we use udelay() in many places - it wouldn't surprise me if
> some people's machines were consuming significant amounts of
> time/energy in there, if they have suitably broken hardware or drivers.
>    

the only real place I've seen it used (based on profiles) is in libata 
in the intel piix sata driver
(the non-AHCI one)... and those are completly wrong, Alan Cox had 
patches to fix it but those somehow went nowhere


