Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0HBPHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:07:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:52376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0HBPHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:07:33 -0400
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
	 <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 17:07:19 +0200
Message-ID: <1280761639.1923.213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
> +       register union {
> +               struct __raw_tickets tickets;
> +               unsigned short slock;
> +       } inc = { .slock = 1 << TICKET_SHIFT };

  register arch_spinlock_t inc = { .tickets = { .head = 1, .tail = 0 } };

>From a quick look you can basically replace all TICKET_SHIFT usage (1 <<
TICKET_SHIFT) with such a constant.

[ Also, does gcc really listen to the register hint these days? ]

> +       asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
> +                     : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");

 "+Q" (inc->slock)

> +       for (;;) {
> +               if (inc.tickets.head == inc.tickets.tail)
> +                       return;
> +               cpu_relax();
> +               inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
> +       }
> +       barrier();              /* make sure nothing creeps before the lock is taken */
>  } 

How will it ever get to that barrier() ?
