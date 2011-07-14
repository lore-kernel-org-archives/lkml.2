Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1GNUKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1GNUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:10:34 -0400
Message-ID: <4E1F4D2C.3000507@zytor.com>
Date: Thu, 14 Jul 2011 13:10:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, tglx@linutronix.de, benh@kernel.crashing.org,
        yinghai@kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
References: <1310462166-31469-1-git-send-email-tj@kernel.org> <1310462166-31469-14-git-send-email-tj@kernel.org>
In-Reply-To: <1310462166-31469-14-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 02:16 AM, Tejun Heo wrote:
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -449,6 +449,9 @@ long __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
>  
>  long __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
>  {
> +	memblock_dbg("   memblock_free: [%#016llx-%#016llx] %pF\n",
> +		     base, base + size, (void *)_RET_IP_);
> +
>  	return __memblock_remove(&memblock.reserved, base, size);
>  }
>  
> @@ -456,6 +459,8 @@ long __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
>  {
>  	struct memblock_type *_rgn = &memblock.reserved;
>  
> +	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
> +		     base, base + size, (void *)_RET_IP_);
>  	BUG_ON(0 == size);
>  
>  	return memblock_add_region(_rgn, base, size);

This assumes phys_addr_t == unsigned long long, which is just plain
wrong.  I will fix it up, but please take more care with that in the
future.  This triggers a warning when building for i386 non-PAE, which
is a good thing because it is a real error.

Also, don't we usually display resources as an *inclusive* range,
meaning that the last one should be base + size - 1?

	-hpa
