Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0LGJbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0LGJbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:31:39 -0500
Message-ID: <4CFDFEE5.6030509@redhat.com>
Date: Tue, 07 Dec 2010 11:31:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [rfc: cpuops adv V1 3/8] x86: this_cpu_cmpxchg and this_cpu_cmpxchg_double
 operations
References: <20101202215340.562309713@linux.com> <20101202215400.609058574@linux.com> <4CFD1A05.3020900@redhat.com> <alpine.DEB.2.00.1012061134170.2866@router.home>
In-Reply-To: <alpine.DEB.2.00.1012061134170.2866@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 07:35 PM, Christoph Lameter wrote:
> On Mon, 6 Dec 2010, Avi Kivity wrote:
>
> >  On 12/02/2010 11:53 PM, Christoph Lameter wrote:
> >  >  Provide support as far as the hardware capabilities of the x86 cpus
> >  >  allow.
> >  >
> >  >
> >  >
> >  >  +/*
> >  >  + * Beware: xchg on x86 has an implied lock prefix. There will be the cost
> >  >  of
> >  >  + * full lock semantics even though they are not needed.
> >  >  + */
> >
> >  Perhaps we can use cmpxchg instead of xchg to avoid this? costs one more
> >  instruction but may be worth it.
>
> Hmmm... Maybe good since I also need a xchg_double. And xchg_double can
> only be realized with cmpxchg16b. Using cmpxchg would make it consistent.

I don't think we need to worry about consistency, this is an 
implementation not an interface.

We have three choices:

   xchg %1, %0

atomic, one instruction

   1: cmpxchg %2, %0
   jnz 1b

two non-atomic instructions, potential mispredicted jump, extra clobber 
(%1 == "=a")

   mov %0, %1
   1: cmpxchg %2, %0
   jnz 1b

three non-atomic instructions, no mispredict, extra clobber

-- 
error compiling committee.c: too many arguments to function

