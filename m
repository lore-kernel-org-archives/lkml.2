Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272Ab2CNFzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 01:55:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55680 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2CNFzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 01:55:41 -0400
Message-ID: <1331704535.2456.37.camel@edumazet-laptop>
Subject: Re: [PATCH v14 01/13] sk_run_filter: add BPF_S_ANC_SECCOMP_LD_W
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Date: Tue, 13 Mar 2012 22:55:35 -0700
In-Reply-To: <3e4fc1efb5d7dbe0dd966e3192e84645.squirrel@webmail.greenhost.nl>
References: <1331587715-26069-1-git-send-email-wad@chromium.org>
	 <0c55cb258e0b5bbd615923ee2a9f06b9.squirrel@webmail.greenhost.nl>
	 <1331658828.4449.16.camel@edumazet-glaptop>
	 <3e4fc1efb5d7dbe0dd966e3192e84645.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 mars 2012 à 06:12 +0100, Indan Zupancic a écrit :

> Problem is that 'old_size' can be up to 32kB in size and it would be nice
> if that memory could be released. If it isn't, then using JIT increases
> memory usage, while also not accounting it to the socket.
> 

It is accounted for, since jit size is in relation with standard filter
size. Check sock_kmalloc()

Fact we can have a litle underestimation was already the case without
jit, since kmalloc() does a roundup to next power of two.

I dont think this discussion has anything to do with SECCOMP anyway.

These accounting dont need to be 100% precise, we only want a limit to
prevent rogue users from using all kernel memory.

> >
> > If it did, this kind of 'optimization' can actually be not good, because
> > sizeof(*fp) is small enough (less than half cache line size) to trigger
> > a possible false sharing issue. (other part of the cache line could be
> > used to hold a often dirtied object)
> 
> It could avoid this by allocating at least a cache size. But this is a
> problem for all small kmalloc's, isn't it?

Its a problem that was already met on several critical paths :

# find net|xargs grep -n L1_CACHE_BYTES
net/core/dev_addr_lists.c:51:	if (alloc_size < L1_CACHE_BYTES)
net/core/dev_addr_lists.c:52:		alloc_size = L1_CACHE_BYTES;
net/core/net-sysfs.c:586:	    RPS_MAP_SIZE(cpumask_weight(mask)), L1_CACHE_BYTES),
net/core/net-sysfs.c:1111:	    XPS_DEV_MAPS_SIZE, L1_CACHE_BYTES), GFP_KERNEL);
net/ipv6/ip6_fib.c:1612:	size = max_t(size_t, size, L1_CACHE_BYTES);
net/ipv4/fib_frontend.c:1049:	size = max_t(size_t, size, L1_CACHE_BYTES);



