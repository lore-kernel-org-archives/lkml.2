Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1AZHS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:18:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49517 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1AZHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:18:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gN/LS3RllL7VOb7RNolEPxXYZxactp8VXepsZtJ4FQv6qEbhuWxqW5s09mLeFEopUL
         QDuOVoR80tU3/iqPmRVZ/omp8F2XiSHQXL4OaXF9QzfuJJv0PiqUXpvOWYF/ERMi7ESp
         8cRx0B9obCy6OfvrG+13YMOM7IBK+y/hVy2ok=
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <20110126000932.GA23089@hostway.ca>
References: <20110126000932.GA23089@hostway.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 08:18:18 +0100
Message-ID: <1296026298.2633.19.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 25 janvier 2011 à 16:09 -0800, Simon Kirby a écrit :
> Hello!
> 
> Since upgrading 2.6.36 -> 2.6.37, dovecot's "anvil" process seems to end
> up taking a lot more time in "top", and "perf top" shows output like this
> (system-wide):
> 
>   samples  pcnt function                      DSO
>   _______ _____ _____________________________ __________________________
> 
>   2405.00 68.8% sys_epoll_wait                [kernel.kallsyms]
>     33.00  0.9% mail_cache_lookup_iter_next   libdovecot-storage.so.0.0.0
>     30.00  0.9% _raw_spin_lock                [kernel.kallsyms]
>     ...etc...
> 
> It only wakes up 5-10 times per second or so (on this box), and does
> stuff like this:
> 
> epoll_wait(12, {{EPOLLIN, {u32=19417616, u64=19417616}}}, 25, 2147483647) = 1
> read(29, "PENALTY-GET\t192.168.31.10\n"..., 738) = 26
> write(29, "0 0\n"..., 4)                = 4
> epoll_wait(12, {{EPOLLIN, {u32=19395632, u64=19395632}}}, 25, 2147483647) = 1
> read(18, "LOOKUP\tpop3/192.168.31.10/tshield"..., 668) = 58
> write(18, "0\n"..., 2)                  = 2
> epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
> read(7, "CONNECT\t3490\tpop3/192.168.31.10/t"..., 254) = 64
> epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
> read(7, "DISCONNECT\t3482\tpop3/192.168.31.1"..., 190) = 62
> 
> Anything obvious here?  anvil talks over UNIX sockets to the rest of
> dovecot, and uses epoll_wait.  So, suspect commits might be:
> 
> 95aac7b1cd224f568fb83937044cd303ff11b029
> 5456f09aaf88731e16dbcea7522cb330b6846415
> or other bits from
>  git log v2.6.36..v2.6.37 net/unix/af_unix.c fs/eventpoll.c
> 
> I suspect it has something to do with that "infinite value" check removal
> in that first commit.  It doesn't show up easily on a test box, but I can
> try reverting 95aac7b1cd in production if it's not obvious.
> 
> Simon-

Yes, 95aac7b1cd is the problem, but anvil should use a 0 (no) timeout
instead of 2147483647 ms : epoll_wait() doesnt have to arm a timer in
this case, it is a bit faster.



