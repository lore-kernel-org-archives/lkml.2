Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab1CIUnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:43:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1CIUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:43:19 -0500
Message-ID: <4D77E5E0.6010706@kernel.org>
Date: Wed, 09 Mar 2011 12:41:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH/v2] mm/memblock: Properly handle overlaps and fix error
 path
References: <1299466980.8833.973.camel@pasglop>
In-Reply-To: <1299466980.8833.973.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D77E636.005B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 07:03 PM, Benjamin Herrenschmidt wrote:
> Currently memblock_reserve() or memblock_free() don't handle overlaps
> of any kind. There is some special casing for coalescing exactly
> adjacent regions but that's about it.
> 
> This is annoying because typically memblock_reserve() is used to
> mark regions passed by the firmware as reserved and we all know
> how much we can trust our firmwares...
> 
> Also, with the current code, if we do something it doesn't handle
> right such as trying to memblock_reserve() a large range spanning
> multiple existing smaller reserved regions for example, or doing
> overlapping reservations, it can silently corrupt the internal
> region array, causing odd errors much later on, such as allocations
> returning reserved regions etc...
> 
> This patch rewrites the underlying functions that add or remove a
> region to the arrays. The new code is a lot more robust as it fully
> handles overlapping regions. It's also, imho, simpler than the previous
> implementation.
> 
> In addition, while doing so, I found a bug where if we fail to double
> the array while adding a region, we would remove the last region of
> the array rather than the region we just allocated. This fixes it too.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Hopefully not damaged with a spurious bit of email header this
> time around... sorry about that.

works on my setups...

[    0.000000] Subtract (26 early reservations)
[    0.000000]   [000009a000-000009efff]
[    0.000000]   [000009f400-00000fffff]
[    0.000000]   [0001000000-0003495048]
...
before:
[    0.000000] Subtract (27 early reservations)
[    0.000000]   [000009a000-000009efff]
[    0.000000]   [000009f400-00000fffff]
[    0.000000]   [00000f85b0-00000f86b3]
[    0.000000]   [0001000000-0003495048]

Acked-by: Yinghai Lu <yinghai@kernel.org>
