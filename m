Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0DIDl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:41:28 -0400
Received: from claw.goop.org ([74.207.240.146]:50193 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab0DIDl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:41:26 -0400
Message-ID: <4BBEA1E4.1050205@goop.org>
Date: Thu, 08 Apr 2010 20:41:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Liang Li <liang.li@windriver.com>
CC: linux-kernel@vger.kernel.org, wangchen@cn.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, yinghai@kernel.org,
       akpm@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       konrad.wilk@oracle.com, Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH v3] x86: let 'reservetop' functioning right
References: <1270773835-2689-1-git-send-email-liang.li@windriver.com> <4BBE9B12.1070209@goop.org> <20100409032316.GA19938@localhost>
In-Reply-To: <20100409032316.GA19938@localhost>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 08:23 PM, Liang Li wrote:
> On Thu, Apr 08, 2010 at 08:12:18PM -0700, Jeremy Fitzhardinge wrote:
>   
>> On 04/08/2010 05:43 PM, Liang Li wrote:
>>     
>>> When specify 'reservetop=0xbadc0de' kernel parameter, the kernel will
>>> stop booting due to a early_ioremap bug that relate to commit 8827247ff.
>>>
>>> The root cause of boot failure problem is the value of 'slot_virt[i]'
>>> was initialized in setup_arch->early_ioremap_init. But later in
>>> setup_arch, the function 'parse_early_param' will modify 'FIXADDR_TOP'
>>> when 'reservetop=0xbadc0de' being specified.
>>>
>>> The simplest fix might be use __fix_to_virt(idx0) to get updated value
>>> of 'FIXADDR_TOP' in '__early_ioremap' instead of reference old value
>>> from slot_virt[slot] directly.
>>>   
>>>       
>> While I guess this patch works OK, I have to say that I'm worried by the
>> need for it at all; it seems to be papering over a more serious
>> problem.  reserve_top_address() is supposed to be called very early,
>> before anything has used or referenced FIXADDR_TOP.  If we're seeing
>> problems with FIXADDR_TOP changing after it has been used, then it means
>> that reserve_top_address() is being called too late.  Fixing that would
>> be the real fix.
>>     
> The ideal thing is FIXADDR_TOP should not be touched after
> early_ioremap_init. The late call to reserve_top_address is from
> parse_reservetop, aka when reservetop=0xabcd0000 being passed as kernel
> commandline parameter. In setup_arch, the call sequence is:
>
> setup_arch
>   -> early_ioremap_init
>   -> parse_early_param
>     -> parse_reservetop
> 	  ->reserve_top_address
>
> See, how could we solve the confliction better?
>   

Well, the first question is "do we need the reservetop= kernel
parameter"?  Zach added it, I think, so that VMI could be loaded
dynamically as a module.  Given that VMI is deprecated anyway, I wonder
if we can just drop support for modular VMI and remove the reservetop=
kernel parameter.  Or are there other uses for it?

    J
