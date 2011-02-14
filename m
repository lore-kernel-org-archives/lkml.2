Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1BNXY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:24:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35340
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab1BNXYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:24:25 -0500
Date: Mon, 14 Feb 2011 15:25:00 -0800 (PST)
Message-Id: <20110214.152500.104069812.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: matt@console-pimps.org, rostedt@goodmis.org, peterz@infradead.org,
        will.newton@gmail.com, jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <BLU0-SMTP637B2E9372CFBF3A0B5B0996D00@phx.gbl>
References: <20110214.134600.179933733.davem@davemloft.net>
	<20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
	<BLU0-SMTP637B2E9372CFBF3A0B5B0996D00@phx.gbl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 14 Feb 2011 18:03:01 -0500

> If this is true, then we have bugs in lots of xchg/cmpxchg users (which
> do not reside in atomic.h), e.g.:
> 
> fs/fs_struct.c:
> int current_umask(void)
> {
>         return current->fs->umask;
> }
> EXPORT_SYMBOL(current_umask);
> 
> kernel/sys.c:
> SYSCALL_DEFINE1(umask, int, mask)
> {
>         mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
>         return mask;
> }
> 
> The solution to this would be to force all xchg/cmpxchg users to swap to
> atomic.h variables, which would force the ll semantic on read. But I'd
> really like to see where this is documented first -- or which PowerPC
> engineer we should talk to.

We can't wholesale to atomic_t because we do this on variables of
all sizes, not just 32-bit ones.

We do them on pointers in the networking for example.
