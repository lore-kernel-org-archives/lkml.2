Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1AZPbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:31:11 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59860 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AZPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:31:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Jan 2011 07:31:01 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
In-Reply-To: <1296040578.2899.59.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>  <1296026298.2633.19.camel@edumazet-laptop> <1296040578.2899.59.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810047-1284779374-1296055868=:1889"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810047-1284779374-1296055868=:1889
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jan 2011, Eric Dumazet wrote:

> Le mercredi 26 janvier 2011 à 08:18 +0100, Eric Dumazet a écrit :
> > Le mardi 25 janvier 2011 à 16:09 -0800, Simon Kirby a écrit :
> > > Hello!
> > > 
> > > Since upgrading 2.6.36 -> 2.6.37, dovecot's "anvil" process seems to end
> > > up taking a lot more time in "top", and "perf top" shows output like this
> > > (system-wide):
> > > 
> > >   samples  pcnt function                      DSO
> > >   _______ _____ _____________________________ __________________________
> > > 
> > >   2405.00 68.8% sys_epoll_wait                [kernel.kallsyms]
> > >     33.00  0.9% mail_cache_lookup_iter_next   libdovecot-storage.so.0.0.0
> > >     30.00  0.9% _raw_spin_lock                [kernel.kallsyms]
> > >     ...etc...
> > > 
> > > It only wakes up 5-10 times per second or so (on this box), and does
> > > stuff like this:
> > > 
> > > epoll_wait(12, {{EPOLLIN, {u32=19417616, u64=19417616}}}, 25, 2147483647) = 1
> > > read(29, "PENALTY-GET\t192.168.31.10\n"..., 738) = 26
> > > write(29, "0 0\n"..., 4)                = 4
> > > epoll_wait(12, {{EPOLLIN, {u32=19395632, u64=19395632}}}, 25, 2147483647) = 1
> > > read(18, "LOOKUP\tpop3/192.168.31.10/tshield"..., 668) = 58
> > > write(18, "0\n"..., 2)                  = 2
> > > epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
> > > read(7, "CONNECT\t3490\tpop3/192.168.31.10/t"..., 254) = 64
> > > epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
> > > read(7, "DISCONNECT\t3482\tpop3/192.168.31.1"..., 190) = 62
> > > 
> > > Anything obvious here?  anvil talks over UNIX sockets to the rest of
> > > dovecot, and uses epoll_wait.  So, suspect commits might be:
> > > 
> > > 95aac7b1cd224f568fb83937044cd303ff11b029
> > > 5456f09aaf88731e16dbcea7522cb330b6846415
> > > or other bits from
> > >  git log v2.6.36..v2.6.37 net/unix/af_unix.c fs/eventpoll.c
> > > 
> > > I suspect it has something to do with that "infinite value" check removal
> > > in that first commit.  It doesn't show up easily on a test box, but I can
> > > try reverting 95aac7b1cd in production if it's not obvious.
> > > 
> > > Simon-
> > 
> > Yes, 95aac7b1cd is the problem, but anvil should use a 0 (no) timeout
> > instead of 2147483647 ms : epoll_wait() doesnt have to arm a timer in
> > this case, it is a bit faster.
> > 
> > 
> 
> Slowness comes from timespec_add_ns() : This one assumed small 'ns'
> argument, since it wants to avoid a divide instruction.
> 
> static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
> {
>         a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
>         a->tv_nsec = ns;
> }
> 
> We should do this differently for epoll usage ;)
> 
> Please try following patch :
> 
> [PATCH] epoll: epoll_wait() should be careful in timespec_add_ns use
> 
> commit 95aac7b1cd224f (epoll: make epoll_wait() use the hrtimer range
> feature) added a performance regression because it used
> timespec_add_ns() with potential very large 'ns' values.
> 
> Reported-by: Simon Kirby <sim@hostway.ca>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Shawn Bohrer <shawn.bohrer@gmail.com>
> CC: Davide Libenzi <davidel@xmailserver.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/eventpoll.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cc8a9b7..7ec0890 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1126,7 +1126,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  
>  	if (timeout > 0) {
>  		ktime_get_ts(&end_time);
> -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> +		end_time.tv_sec += timeout / MSEC_PER_SEC;
> +		timeout %= MSEC_PER_SEC;
> +		timespec_add_ns(&end_time, timeout * NSEC_PER_MSEC);
>  		slack = select_estimate_accuracy(&end_time);
>  		to = &expires;
>  		*to = timespec_to_ktime(end_time);

Yep, we can overflow the timeout, with the calculation above.
A timespec_add_ms()?

---1463810047-1284779374-1296055868=:1889--
