Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1AZAJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:09:36 -0500
Received: from netnation.com ([204.174.223.2]:32866 "EHLO peace.netnation.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1AZAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:09:35 -0500
Date: Tue, 25 Jan 2011 16:09:32 -0800
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: sys_epoll_wait high CPU load in 2.6.37
Message-ID: <20110126000932.GA23089@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Since upgrading 2.6.36 -> 2.6.37, dovecot's "anvil" process seems to end
up taking a lot more time in "top", and "perf top" shows output like this
(system-wide):

  samples  pcnt function                      DSO
  _______ _____ _____________________________ __________________________

  2405.00 68.8% sys_epoll_wait                [kernel.kallsyms]
    33.00  0.9% mail_cache_lookup_iter_next   libdovecot-storage.so.0.0.0
    30.00  0.9% _raw_spin_lock                [kernel.kallsyms]
    ...etc...

It only wakes up 5-10 times per second or so (on this box), and does
stuff like this:

epoll_wait(12, {{EPOLLIN, {u32=19417616, u64=19417616}}}, 25, 2147483647) = 1
read(29, "PENALTY-GET\t192.168.31.10\n"..., 738) = 26
write(29, "0 0\n"..., 4)                = 4
epoll_wait(12, {{EPOLLIN, {u32=19395632, u64=19395632}}}, 25, 2147483647) = 1
read(18, "LOOKUP\tpop3/192.168.31.10/tshield"..., 668) = 58
write(18, "0\n"..., 2)                  = 2
epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
read(7, "CONNECT\t3490\tpop3/192.168.31.10/t"..., 254) = 64
epoll_wait(12, {{EPOLLIN, {u32=19373072, u64=19373072}}}, 25, 2147483647) = 1
read(7, "DISCONNECT\t3482\tpop3/192.168.31.1"..., 190) = 62

Anything obvious here?  anvil talks over UNIX sockets to the rest of
dovecot, and uses epoll_wait.  So, suspect commits might be:

95aac7b1cd224f568fb83937044cd303ff11b029
5456f09aaf88731e16dbcea7522cb330b6846415
or other bits from
 git log v2.6.36..v2.6.37 net/unix/af_unix.c fs/eventpoll.c

I suspect it has something to do with that "infinite value" check removal
in that first commit.  It doesn't show up easily on a test box, but I can
try reverting 95aac7b1cd in production if it's not obvious.

Simon-
