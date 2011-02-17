Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1BQDgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:36:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1BQDgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:36:20 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=99VrQWRHyRAWe3_n8KEA:9 a=JPB1XeQJwz7gHK4ED-AA:7 a=T-TbmHhHDsNEYj_8di8x2-3F1tAA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Will Newton <will.newton@gmail.com>, Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <BLU0-SMTP71BCB155CBAE79997EE08D96D20@phx.gbl>
References: <4D59B891.8010300@zytor.com>
	 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	 <20110215211123.GA3094@ele.uri.edu>
	 <20110215.132702.39199169.davem@davemloft.net>
	 <20110215215604.GA3177@ele.uri.edu>
	 <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
	 <1297858734.23343.138.camel@gandalf.stny.rr.com>
	 <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
	 <BLU0-SMTP71BCB155CBAE79997EE08D96D20@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Feb 2011 22:36:14 -0500
Message-ID: <1297913774.23343.905.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Removed Andi as I believe this is the mysterious thread he was talking
about. Anyone else want to be removed? ]


On Wed, 2011-02-16 at 08:24 -0500, Mathieu Desnoyers wrote:
> * Will Newton (will.newton@gmail.com) wrote:

> initially:
> foo = 0
> bar = 0
> 
> CPU A                            CPU B
> 
> xchg(&foo, 1);
>   ll foo
>   sc foo
> 
>   -> interrupt
> 
>   if (foo == 1)
>     xchg(&bar, 1);
>       ll bar
>       sc bar
>       invalidate bar
> 
>                                  lbar = bar;
>                                  smp_mb()

Question: Does a mb() flush all cache or does it just make sure that
read/write operations finish before starting new ones?

>                                  lfoo = foo;

IOW, will that smp_mb() really make lfoo read the new foo in memory? If
foo happens to still be in cache and no coherency has been performed to
flush it, would it just simply read foo straight from the cache?

-- Steve

>                                  BUG_ON(lbar == 1 && lfoo == 0);
>   invalidate foo
> 
> It should be valid to expect that every time "bar" read by CPU B is 1,
> then "foo" is always worth 1. However, in this case, the lack of
> invalidate on foo is keeping the cacheline from reaching CPU B. There
> seems to be a problem with interrupts/NMIs coming right between sc and
> invalidate, as Ingo pointed out.
> 
> Thanks,
> 
> Mathieu
> 


