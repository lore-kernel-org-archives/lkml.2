Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2EVJUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:20:41 -0400
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:42567 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab2EVJUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:20:40 -0400
Message-ID: <4FBB5A72.2080101@codethink.co.uk>
Date: Tue, 22 May 2012 10:20:50 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "Turquette, Mike" <mturquette@ti.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
References: <1337227884.2066.9.camel@pgaikwad-dt2> <20120517062131.GA9305@gmail.com> <1337316517.22560.19.camel@pgaikwad-dt2> <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com> <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com> <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/12 09:46, Peter De Schrijver wrote:
>>
>> On OMAP I think the only "gotcha" is setting up the timer.  One
>> solution is to open code the register reads and the rate calculation
>> in the timer code.  That is ugly... but it works.
>>
>>> Which advantages do you see in dynamically allocating all this?
>>>
>>
>> There are many but I'll name a couple.  The most significant point is
>> that we can avoid exposing the definition of struct clk if we
>> dynamically allocate stuff.  One can use struct clk_hw_init to
>> statically initialize data, or instead rely on direct calls to
>> clk_register with a bunch of parameters.
>>
>
> Which means if you make a mistake in specifying parents for example, it will
> only fail at runtime, possibly before any console is active. With static
> initialization, this will fail at compiletime. Much easier to debug.
>
>> Another point is that copying the data at registration-time makes
>> __initdata possible.  I haven't done the math yet to see if this
>> really makes a difference.  However if we start doing single zImage's
>> with multiple different ARM SoCs then this could recover some pages.
>>
>
> On the other hand most clock structures are small, so there will be internal
> fragmentation. Also the arrays of parent clock pointers can be shared between
> different clocks. We have about 70 muxes in Tegra30 and 12 different parent
> arrays.

We had at-least that on the older Samsung parts and they where still
growing. I would suggest that in a multi-kernel image situation the
more data that can be discarded after init-time the better.

Also, __initdata gets gathered into one place so there's no possibility
of page fragmentation there. If you mean fragmentation of the memory
map, then allocate the size of all the clocks you know of at init time
in one go.

It would possible even be useful to have construction code that took
some brief details of the clocks and constructed the list/tree of clocks
at start time.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
