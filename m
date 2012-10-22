Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2JVQrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:47:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51566 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2JVQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:46:58 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 09:46:57 -0700
X-Google-Sender-Auth: LbHYKyZ5QuxsfUwnXWLCn-cg1tw
Message-ID: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
Subject: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted this problem some time back on the linux-rt-users and
netfilter lists.  Since then, we thought we had a workaround to avoid
this problem, so we dropped the issue.  But now 5 months later, the
problem has reappeared.  And this time it is much more serious and
much more difficult to re-create.  After perusing both those lists,
I'm not sure if those were the proper places to post.  The netfilter
list seems to be more focused on the user space side of things, and
the RT page indicates that kernel side RT issues should go to lkml.

Anyway, here's a repost of that problem from July.  Perhaps somebody
here can point us in the right direction.

We are running 3.0.36-rt57 on a powerpc box.  During some testing with
heavy loads and interfaces coming up/going down (specifically PPP), we
have run into a case where iptables hangs and cannot be killed.  It
requires a reboot to fix the problem.

Connecting the BDI and debugging the kernel, we get:

#0  get_counters (t=0xdd5145a0, counters=0xe3458000)
    at include/linux/seqlock.h:66
#1  0xc026b4ac in do_ipt_get_ctl (sk=<value optimized out>,
    cmd=<value optimized out>, user=0x10612078, len=<value optimized out>)
    at net/ipv4/netfilter/ip_tables.c:918
#2  0xc022226c in nf_sockopt (sk=<value optimized out>, pf=2 '\002',
    val=<value optimized out>, opt=<value optimized out>, len=0xdd4c7d4c,
    get=1) at net/netfilter/nf_sockopt.c:109
#3  0xc0236b1c in ip_getsockopt (sk=0xdf071480, level=<value optimized out>,
    optname=65, optval=0x10612078 <Address 0x10612078 out of bounds>,
    optlen=0xbfbe0c2c) at net/ipv4/ip_sockglue.c:1308
#4  0xc02522a8 in raw_getsockopt (sk=0xdf071480, level=<value optimized out>,
    optname=<value optimized out>, optval=<value optimized out>,
    optlen=<value optimized out>) at net/ipv4/raw.c:811
#5  0xc01f4c38 in sock_common_getsockopt (sock=<value optimized out>,
    level=<value optimized out>, optname=<value optimized out>,
    optval=<value optimized out>, optlen=<value optimized out>)
    at net/core/sock.c:2157
#6  0xc01f2df8 in sys_getsockopt (fd=<value optimized out>, level=0,
    optname=65, optval=0x10612078 <Address 0x10612078 out of bounds>,
    optlen=0xbfbe0c2c) at net/socket.c:1839
#7  0xc01f45b4 in sys_socketcall (call=15, args=<value optimized out>)
    at net/socket.c:2421

It seems to be stuck in __read_seqcount_begin.  From include/linux/seqlock.h:

static inline unsigned __read_seqcount_begin(const seqcount_t *s)
{
        unsigned ret;

repeat:
        ret = ACCESS_ONCE(s->sequence);
        if (unlikely(ret & 1)) {
                cpu_relax();
  <----- It is always here
                goto repeat;
        }
        return ret;
}

I've been scouring the mailing lists and Google searches trying to
find something, but thus far have come up with nothing.

Any tips would be appreciated.

Thanks,
Pete
