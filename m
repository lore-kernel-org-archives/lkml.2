Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0LXAYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 19:24:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0LXAYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 19:24:20 -0500
Message-ID: <4D13E7D5.7020503@zytor.com>
Date: Thu, 23 Dec 2010 16:22:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
References: <20101214174847.887713690@linux.com> <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org> <alpine.DEB.2.00.1012231812280.22549@router.home>
In-Reply-To: <alpine.DEB.2.00.1012231812280.22549@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 04:16 PM, Christoph Lameter wrote:
> On Wed, 22 Dec 2010, Tejun Heo wrote:
> 
>>> I'm a bit confused on this one.  The standard cmpxchg() takes a scalar
>>> and a pointer, and returns a scalar.  The equivalent for the "double"
>>> variety would be to return a compound object, basically:
>>>
>>> struct double_ulong {
>>> 	unsigned long v[2];
>>> };
>>>
>>> ... which can be returned in registers on both i386 and x86-64.
> 
> Really? How would that work? I tried with uint128 but could not get the
> compiler to do the right thing.
> 

There are two return registers; two machine registers can be returned in
registers.  [u]int128 is poorly implemented in a lot of gcc versions,
since it really hasn't been exercised.  However, two-word structures
should work.  I do not believe a two-word *array* works, though.

>>> It's a bit clumsy from a type perspective, but I'm not sure that that is
>>> a bad thing.  Doing too much type genericity has caused us problems in
>>> the past.
>>
>> Yeah, the above might be better too.  Is there any reason to use
>> cmpxchg_double on anything smaller?
> 
> Yes. You may want to use cmpxchg_double on 32 bit entities for backwards
> compatibilities sake or any other smaller unit size. But those could also
> be realized using this_cpu_cmpxchg_<double the size> by just aggregating
> the amount.
> 
> If we can indeed pass 128 bit entities (as claimed by hpa) via registers
> then the logical choice would be to do
> 
> 	this_cpu_cmpxchg_16(pcp, old, new)
> 
> instead of cmpxchg_double. All parameters would have to be bit.
> Then we can avoid the strange cmpxchg_double semantics and can completely
> avoid introducing those.

I'm not sure it works with passing in a structure.

	-hpa
