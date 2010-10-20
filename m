Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0JTVeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:34:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37251 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab0JTVeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:34:07 -0400
Message-ID: <4CBF603D.5040808@zytor.com>
Date: Wed, 20 Oct 2010 14:33:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com> <1287551880.2700.79.camel@edumazet-laptop>
In-Reply-To: <1287551880.2700.79.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 10:18 PM, Eric Dumazet wrote:
> 
> We can see many holes because of 2^5 alignments of
> individual .o  .data..percpu sections.
> 
> find . -name "*.o"|xargs objdump -h|grep percpu
> 
> Linker promotes a section alignment from natural alignment to 2^5 as
> soon as the size reaches 2^5
> 
> For example in net/ipv4/route.o, we have a per_cpu structure
> (rt_cache_stat), that is an array of 16 integers. The natural alignement
> should be 4 (alignof(int)), but we get :
> 
> # objdump -h net/ipv4/route.o|grep percpu
>  19 .data..percpu 00000040  0000000000000000  0000000000000000  00007a80  2**5
> 
> For a section replicated N times, this really is a concern.
> 

That wouldn't be the linker, that would be the compiler or assembler
-- I suspect it's the compiler -- and that needs to be fixed.

To reduce linker-induced padding, we may want to use SORT_BY_ALIGNMENT()
in the linker script.

	-hpa
