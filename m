Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0ELLqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab0ELLp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:45:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1273634462-2672-5-git-send-email-walken@google.com>
References: <1273634462-2672-5-git-send-email-walken@google.com> <1273634462-2672-1-git-send-email-walken@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 04/12] rwsem: consistently use adjustment variable
Date: Wed, 12 May 2010 12:45:37 +0100
Message-ID: <1195.1273664737@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> Cleanup: previous change introduced an adjustment variable used in
> waking writers; the code to wake readers can be made nicer by making
> use of that same variable.
> 
> Reducing variable count should hopefully help both humans and compilers
> looking at this function :)

Actually, no.  The compiler doesn't care.  With optimisation, the variable
'woken' would cease to exist after being copied to loop and added into
adjustment.  What it would probably do is just relabel 'woken' internally as
'loop'.

>From a human point of view, I would say keep woken, but use it to initialise
adjustment:

	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;

and use it to initialise 'loop':

	for (loop = woken; loop > 0; loop--) {

or just ditch 'loop' and use 'woken' directly, since the number of processes
to be woken goes down as the loop iterates.

Whatever, the compiler won't care, since loop and woken will just be names for
the same value.

David
