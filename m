Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab0GMQfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:35:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab0GMQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:35:06 -0400
Message-ID: <4C3C9589.4090602@redhat.com>
Date: Tue, 13 Jul 2010 19:34:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization	point
 for pvclock
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com> <20100713162207.GC15122@anguilla.noreply.org>
In-Reply-To: <20100713162207.GC15122@anguilla.noreply.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:22 PM, Peter Palfrader wrote:
>>>
>>> weasel@intrepid:~$ publish System.map
>>> http://asteria.noreply.org/~weasel/volatile/2010-07-13-mbm2xEdd8Q4/System.map
>>> weasel@intrepid:~$ grep -i last_value System.map
>>> ffffffff81712e80 r last_value
>>> ffffffff81b05240 b last_value.26163
>>>
>>>        
>> "r" = "read only"
>>
>> How does it look in 'nm arch/x86/kernel/pvclock.o'?
>>      
> The same:
>
> [git|v2.6.32.16] weasel@thelma:/scratch/kernel/2.6.32.16$ nm arch/x86/kernel/pvclock.o
> 0000000000000000 r last_value
>                   U native_read_tsc
> 0000000000000040 T pvclock_clocksource_read
> 0000000000000100 T pvclock_read_wallclock
> 0000000000000000 T pvclock_tsc_khz
>                   U set_normalized_timespec
>    

But it's

>
> static atomic64_t last_value = ATOMIC64_INIT(0);
>

Doesn't make any sense.

Let's try to see if the toolchain is confused:

- rename last_value to some random name
- drop the 'static' qualifier
- drop the '= ATOMIC64_INIT(0)'
- all of the above

(better start with the last).

No need to rebuild everything, just look at the output of nm pvclock.o.

My bet is that dropping 'static' will fix it.  We may have the wrong 
constraints on atomic64_cmpxchg64(), so the compiler thinks we never 
change last_value.

-- 
error compiling committee.c: too many arguments to function

