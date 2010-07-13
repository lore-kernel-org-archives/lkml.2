Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0GMSGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0GMSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:06:20 -0400
Message-ID: <4C3CAAC6.501@redhat.com>
Date: Tue, 13 Jul 2010 21:04:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100701175144.GA2116@kroah.com>	<20100701173218.125822294@clark.site>	<20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com> <AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>
In-Reply-To: <AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:34 PM, Linus Torvalds wrote:
>
> I bet it is the same. And I have a suspicion: because the only write
> access to that variable is in an asm that uses the "memory" clobber to
> say it wrote to it (rather than say it writes to it directly), and
> because the variable is marked 'static', gcc decides that nothing ever
> writes to it in that compilation unit, and it can be made read-only.
>
> Look at our definition for "xchg()" in
> arch/x86/include/asm/cmpxchg_64.h. It boils down to
>
>                  asm volatile("xchgq %0,%1"                              \
>                               : "=r" (__x)                               \
>                               : "m" (*__xg(ptr)), "0" (__x)              \
>                               : "memory");                               \
>
> for the 8-byte case (which is obviously what atomic64_xchg() uses).
> And the _reason_ we do that thing where we use a memory _input_ and
> then a clobber is that older versions of gcc did not accept the thing
> we _want_ to use, namely using "+m" to say that we actually change the
> memory.  So the above is "wrong", but has historical reasons - and
> it's apparently never been changed.
>
> However, the "+m" was fixed, and we use it elsewhere, so I think the
> "m" plus memory clobber is now purely historical. Does a patch
> something like the appended fix it? I also suspect we should look at
> some other uses in this area. The atomic64_64.h file uses "=m" and
> "m", which looks like another legacy thing (again, "+m" historically
> wasn't allowed, and then later became the 'correct' way to do things).
>
>    

Well, current upstream uses "m":

>         case 8:                                                         \
>                 asm volatile(lock "cmpxchgq %1,%2"                      \
>                              : "=a"(__ret)                              \
>                              : "r"(__new), "m"(*__xg(ptr)), "0"(__old)  \
>                              : "memory");                               \
>                 break;                                                  \

and works; I also failed to reproduce with 2.6.32.16.  So I expect some 
toolchain involvement.

Peter, what gcc are you using?


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

