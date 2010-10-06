Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab0JFCbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:31:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36493 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab0JFCbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:31:06 -0400
Message-ID: <4CABDF3A.2020501@zytor.com>
Date: Tue, 05 Oct 2010 19:30:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatches in memblock
References: <4CABAAB4.3090707@zytor.com> <4CABB4FD.2090304@kernel.org>
In-Reply-To: <4CABB4FD.2090304@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 04:30 PM, Yinghai Lu wrote:
> 
> looks like gcc problem.

What makes you say that?

> | static int memblock_search(struct memblock_type *type, phys_addr_t addr)
> | {
> |	.....
> | }
> |
> |int __init memblock_is_reserved(phys_addr_t addr)
> |{
> |        return memblock_search(&memblock.reserved, addr) != -1;
> |}
> |
> |int __init_memblock memblock_is_memory(phys_addr_t addr)
> |{
> |        return memblock_search(&memblock.memory, addr) != -1;
> |}
> 
> Because We already have __init for those two functions.
> 
> Just make memblock_search to have __init_memblock atribute.
> 

Wrong functions!  Furhtermore, at least the tip tree definitely does not
have __init_memblock here:


static int memblock_search(struct memblock_type *type, phys_addr_t addr)
{
        unsigned int left = 0, right = type->cnt;

        do {
                unsigned int mid = (right + left) / 2;

                if (addr < type->regions[mid].base)
                        right = mid;
                else if (addr >= (type->regions[mid].base +
                                  type->regions[mid].size))
                        left = mid + 1;
                else
                        return mid;
        } while (left < right);
        return -1;
}

int __init memblock_is_reserved(phys_addr_t addr)
{
        return memblock_search(&memblock.reserved, addr) != -1;
}

int memblock_is_memory(phys_addr_t addr)
{
        return memblock_search(&memblock.memory, addr) != -1;
}

int memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
{
        int idx = memblock_search(&memblock.reserved, base);

        if (idx == -1)
                return 0;
        return memblock.reserved.regions[idx].base <= base &&
                (memblock.reserved.regions[idx].base +
                 memblock.reserved.regions[idx].size) >= (base + size);
}


... so I don't know why you're saying that you already have them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

