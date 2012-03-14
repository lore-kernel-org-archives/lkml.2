Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab2CNH7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:59:15 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:50141 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256Ab2CNH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:59:09 -0400
Message-ID: <3f56b0860272f4ca8925c0a249a30539.squirrel@webmail.greenhost.nl>
In-Reply-To: <1331704535.2456.37.camel@edumazet-laptop>
References: <1331587715-26069-1-git-send-email-wad@chromium.org>
    <0c55cb258e0b5bbd615923ee2a9f06b9.squirrel@webmail.greenhost.nl>
    <1331658828.4449.16.camel@edumazet-glaptop>
    <3e4fc1efb5d7dbe0dd966e3192e84645.squirrel@webmail.greenhost.nl>
    <1331704535.2456.37.camel@edumazet-laptop>
Date: Wed, 14 Mar 2012 08:59:04 +0100
Subject: Re: [PATCH v14 01/13] sk_run_filter: add BPF_S_ANC_SECCOMP_LD_W
From: "Indan Zupancic" <indan@nul.nu>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 40b81d93390a3dca3ee709c9c36a2335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 14, 2012 06:55, Eric Dumazet wrote:
> Le mercredi 14 mars 2012 à 06:12 +0100, Indan Zupancic a écrit :
>
>> Problem is that 'old_size' can be up to 32kB in size and it would be nice
>> if that memory could be released. If it isn't, then using JIT increases
>> memory usage, while also not accounting it to the socket.
>>
>
> It is accounted for, since jit size is in relation with standard filter
> size. Check sock_kmalloc()
>
> Fact we can have a litle underestimation was already the case without
> jit, since kmalloc() does a roundup to next power of two.

OK.

> I dont think this discussion has anything to do with SECCOMP anyway.

Certainly true.

> These accounting dont need to be 100% precise, we only want a limit to
> prevent rogue users from using all kernel memory.

Fair enough.

The only remaining question is, is it worth the extra code to release
up to 32kB of unused memory? It seems a waste to not free it, but if
people think it's not worth it then let's just leave it around.

>> >
>> > If it did, this kind of 'optimization' can actually be not good, because
>> > sizeof(*fp) is small enough (less than half cache line size) to trigger
>> > a possible false sharing issue. (other part of the cache line could be
>> > used to hold a often dirtied object)
>>
>> It could avoid this by allocating at least a cache size. But this is a
>> problem for all small kmalloc's, isn't it?
>
> Its a problem that was already met on several critical paths :
>
> # find net|xargs grep -n L1_CACHE_BYTES
> net/core/dev_addr_lists.c:51:	if (alloc_size < L1_CACHE_BYTES)
> net/core/dev_addr_lists.c:52:		alloc_size = L1_CACHE_BYTES;
> net/core/net-sysfs.c:586:	    RPS_MAP_SIZE(cpumask_weight(mask)), L1_CACHE_BYTES),
> net/core/net-sysfs.c:1111:	    XPS_DEV_MAPS_SIZE, L1_CACHE_BYTES), GFP_KERNEL);
> net/ipv6/ip6_fib.c:1612:	size = max_t(size_t, size, L1_CACHE_BYTES);
> net/ipv4/fib_frontend.c:1049:	size = max_t(size_t, size, L1_CACHE_BYTES);

So using L1_CACHE_BYTES is the more common thing to do, I'll keep that in
mind for next time.

Thanks,

Indan


