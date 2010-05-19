Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0ESLs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0ESLs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:48:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1274135154-24082-2-git-send-email-walken@google.com>
References: <1274135154-24082-2-git-send-email-walken@google.com> <1274135154-24082-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 01/10] x86 rwsem: minor cleanups
Date: Wed, 19 May 2010 12:47:57 +0100
Message-ID: <30356.1274269677@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> The only functional change here is that __up_write won't call
> call_rwsem_wake anymore if the new rwsem value is >0. This makes
> no real difference since call_rwsem_wake would have noticed the
> active count being nonzero and done nothing anyway.

Given that you describe this first, this would suggest that the subject of the
patch should be this.  I'm not sure I'd count this as a minor cleanup.  I think
I'd split it into its own patch.

> Besides that, I clarified a few comments.

Mostly okay, except where you said "expects old value in %edx" - that's only
true on i386, not x86_64.  On the latter it would be %rdi.  However, I can live
with that: it's true enough.

> -	rwsem_count_t tmp;
> +	rwsem_count_t tmp = -RWSEM_ACTIVE_WRITE_BIAS;
> ...
>  		     : "+m" (sem->count), "=d" (tmp)
> -		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
> +		     : "a" (sem), "1" (tmp)

If you're going to put the initialisation of EDX/RDI on tmp (which isn't really
necessary), rather than directly on the asm statement, you could change the
'"=d" (tmp)' output constraint to be '"+d" (tmp)' and drop the '"1" (tmp)'
constraint entirely.

However, apart from that, feel free to add my Acked-by to this patch or its
split resultant patches.

David
