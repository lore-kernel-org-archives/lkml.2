Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1BNXeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:34:14 -0500
Received: from blu0-omc1-s33.blu0.hotmail.com ([65.55.116.44]:35902 "EHLO
	blu0-omc1-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab1BNXeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:34:11 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP7346C4AACBF72B473334996D00@phx.gbl>
Date: Mon, 14 Feb 2011 18:34:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
CC: matt@console-pimps.org, rostedt@goodmis.org, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com> <BLU0-SMTP637B2E9372CFBF3A0B5B0996D00@phx.gbl> <20110214.152500.104069812.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110214.152500.104069812.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:30:47 up 313 days,  9:20,  6 users,  load average: 1.39, 1.46,
	1.41
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 23:34:10.0725 (UTC) FILETIME=[AE5AE550:01CBCC9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Mon, 14 Feb 2011 18:03:01 -0500
> 
> > If this is true, then we have bugs in lots of xchg/cmpxchg users (which
> > do not reside in atomic.h), e.g.:
> > 
> > fs/fs_struct.c:
> > int current_umask(void)
> > {
> >         return current->fs->umask;
> > }
> > EXPORT_SYMBOL(current_umask);
> > 
> > kernel/sys.c:
> > SYSCALL_DEFINE1(umask, int, mask)
> > {
> >         mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
> >         return mask;
> > }
> > 
> > The solution to this would be to force all xchg/cmpxchg users to swap to
> > atomic.h variables, which would force the ll semantic on read. But I'd
> > really like to see where this is documented first -- or which PowerPC
> > engineer we should talk to.
> 
> We can't wholesale to atomic_t because we do this on variables of
> all sizes, not just 32-bit ones.
> 
> We do them on pointers in the networking for example.

We have atomic_long_t for this, but yeah, it would kind of suck to have
to create

union {
	atomic_long_t atomic;
	void *ptr;
}

all around the place. Let's see if we can get to know which PowerPC
processor family all this fuss is about, and where this rumour
originates from.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
