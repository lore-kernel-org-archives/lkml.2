Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0GMNXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 09:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab0GMNXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 09:23:45 -0400
Message-ID: <4C3C68C8.4060409@redhat.com>
Date: Tue, 13 Jul 2010 16:23:20 +0300
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
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org>
In-Reply-To: <20100713102350.GW15122@anguilla.noreply.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 01:23 PM, Peter Palfrader wrote:
> Sorry for the delay.
>    

A good trace is worth it.

>   [<ffffffff810373c0>] ? child_rip+0x0/0x20
> Code: 78 4f 44 89 e1 48 d3 e0 44 89 f2 48 f7 e2 48 0f ac d0 20 4a 8d 0c 38 44 39 03 75 a4 48 8b 15 15 df 6b 00 48 39 ca 77 17 48 89 d0<f0>  48 0f b1 0d 04 df 6b 00 48 39 c1 48 89 c2 75 e7 48 89 ca 48
> RIP  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
>   RSP<ffff88007fb47880>
> CR2: ffffffff81712e80
> ---[ end trace 38f25e02ae34d4c1 ]---
> BUG: unable to handle kernel paging request at ffffffff81712e80
> IP: [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
> PGD 1003067 PUD 1007063 PMD 7e8b1063 PTE 8000000001712161
>    

Read-only pte

> Oops: 0003 [#2] SMP
>    

Write fault.

> Code: 78 4f 44 89 e1 48 d3 e0 44 89 f2 48 f7 e2 48 0f ac d0 20 4a 8d 0c 38 44 39 03 75 a4 48 8b 15 15 df 6b 00 48 39 ca 77 17 48 89 d0<f0>  48 0f b1 0d 04 df 6b 00 48 39 c1 48 89 c2 75 e7 48 89 ca 48
> RIP  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
>    

--> lock cmpxchg %rcx,0x6bdf04(%rip)

> static atomic64_t last_value = ATOMIC64_INIT(0);
>
> cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
> {
>

[...]

>     last = atomic64_read(&last_value);
>     do {
>         if (ret < last)
>             return last;
>         last = atomic64_cmpxchg(&last_value, last, ret);
>     } while (unlikely(last != ret));
>
>     return ret;
> }

So it looks like last_value was placed in a read only section.  Please 
post your System.map somewhere.

-- 
error compiling committee.c: too many arguments to function

