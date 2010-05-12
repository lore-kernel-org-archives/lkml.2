Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0ELMLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:11:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0ELMLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:11:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-6-git-send-email-walken@google.com>
References: <1273634462-2672-6-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 05/12] x86 rwsem: take advantage of new RWSEM_WAITING_BIAS semantics
Date: Wed, 12 May 2010 13:10:29 +0100
Message-ID: <20188.1273666229@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

>  static inline void __up_write(struct rw_semaphore *sem)
>  {
> ...
>  		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
> -		     /* tries to transition
> -			0xffff0001 -> 0x00000000 */
> -		     "  jz       1f\n"
> +		     /* substracts 0xffff0001, returns the old value */
> +		     "  cmp      %4,%1\n\t"
> +		     /* are there waiting threads and no active threads ? */
> +		     "  jne      1f\n"
>  		     "  call call_rwsem_wake\n"

It looks like you're betting on there being fast-path contention.  If the
common case is no fast-path contention, then you'd be better off putting the
comparison out of line in the medium-path and retaining the JZ instruction.

The same goes for __up_read(): you could retain the JNS there and put the
comparison out of line into the medium-path.

Doing this also saves you some code space.

David
