Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1CEFs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 00:48:26 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:29033 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1CEFsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 00:48:25 -0500
Message-ID: <4D71CE24.1090302@kernel.org>
Date: Fri, 04 Mar 2011 21:46:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC] memblock; Properly handle overlaps
References: <1299297946.8833.931.camel@pasglop>
In-Reply-To: <1299297946.8833.931.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D71CE63.0087,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 08:05 PM, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> This is not fully tested yet (I'm toying with a little userspace
> test bench, it seems to work well so far but I haven't yet tested
> the cases with no-coalesce boundaries which at least ARM needs).
> 
> But it's good enough to get comments...
> 
> So currently, things like memblock_reserve() or memblock_free()
> don't deal well -at-all- with overlaps of all kinds. Some specific
> cases are handled but the code is clumsy and things will fall over
> in many cases.
> 
> This is annoying because typically memblock_reserve() is used to
> mark regions passed by the firmware as reserved and we all know
> how much we can trust our firmwares right ?
> 
> I have also a case I need to deal with on powerpc where the flat
> device-tree is fully enclosed within some other FW blob that has
> its own reserve map entry, so when I end up trying to reserve
> both, the current memblock code pukes.

did you try remove and add tricks?

diff --git a/mm/memblock.c b/mm/memblock.c
index 4618fda..ba4ffdc 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -453,6 +453,9 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 
        BUG_ON(0 == size);
 
+       while (__memblock_remove(_rgn, base, size) >= 0)
+               ;
+
        return memblock_add_region(_rgn, base, size);
 }
 

Yinghai
