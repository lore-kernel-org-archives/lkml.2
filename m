Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0HOQlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:41:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44507 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab0HOQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=glg/YP/TNt80Gv2DSShetCb3NSxQX110BNOJhIxgsh6VgiS6ghecS7C7L50AezuvzN
         Tqw3gA9Tsq6Hccx6AfPQpBmAXtS00aJdJwKSUO6ZfPMZV/yXFlmw8tDeGdrARdBgJmYb
         ZK394ZQZyP89QV9ASWZbvJ36EJ2u9+dDUtrPs=
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100814.220945.232761341.davem@davemloft.net>
References: <20100812.161050.246523792.davem@davemloft.net>
	 <AANLkTinGy+-ELbVx_2WJ1wOJCsz4Rez26Q2Baisws9+C@mail.gmail.com>
	 <20100814.220945.232761341.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 12:55:22 +0200
Message-ID: <1281869722.2942.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 août 2010 à 22:09 -0700, David Miller a écrit :
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sat, 14 Aug 2010 11:05:54 -0700
> 
> > Anyway, the lock warning I do get seems to be networking-related, and
> > is appended. Does this ring any bells? It could easily be something
> > old: I turn on lock debugging only when I look for bugs (or when
> > people point out bugs that I've created :^/ )
> 
> This is a false positive but I have no idea how we can annotate
> this to not trigger in lockdep.
> 
> These are per-cpu locks for counter management.
> 
> The get_counters() code knows that the locks for other cpu's counters
> can only be taken in software interrupt context of that other cpu.  So
> it is legal to turn software interrupts back on when grabbing their
> locks in base context.
> 
> CC:'ing Eric Dumazet since he put the code the way it is now :-)
> Via commit 24b36f0193467fa727b85b4c004016a8dae999b9
> ("netfilter: {ip,ip6,arp}_tables: dont block bottom half more than necessary")

Hmm... thats right.

We have one lock per cpu, and only one cpu can possibly lock its
associated lock under softirq. So the usual lockdep check, warning a
lock is taken with BH enabled, while same lock was taken inside softirq
handler is triggering a false positive here.

I believe no existing lockdep annotation can instruct lockdep this use
is OK, I guess we have following choice :

1) Mask BH again, using xt_info_wrlock_lockdep(cpu) instead of
xt_info_wrlock(cpu).

xt_info_wrlock_lockdep() being a variant, that disables BH in case
CONFIG_PROVE_LOCKING=y

2) temporally switch off lockdep in get_counters(), using a
lockdep_off()/lockdep_on() pair, and a comment why this is necessary.

I'll provide a patch with either way, just tell me which one you
prefer !

Thanks


