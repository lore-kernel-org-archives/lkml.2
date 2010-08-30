Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0H3A57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0H3A56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:57:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger
 OOM-killer
In-Reply-To: Kees Cook's message of  Friday, 27 August 2010 15:02:58 -0700 <20100827220258.GF4703@outflux.net>
References: <20100827220258.GF4703@outflux.net>
X-Shopping-List: (1) Tenuous contraptions
   (2) Syncopated expectations
   (3) Dubious illusions
   (4) Reddy-Mix Preserves axes
   (5) Linty socks
Message-Id: <20100830005648.431B7400D9@magilla.sf.frob.com>
Date: Sun, 29 Aug 2010 17:56:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO unlimited should mean unlimited.  So, on that score, I'd leave this
constraint out and just say whatever deficiencies in the OOM killer (or in
whatever should make a manifestly too-large allocation get ENOMEM) should
just be fixed separately.

But that aside, I'll just consider the intent stated in the comment in
get_arg_page:
		 * Limit to 1/4-th the stack size for the argv+env strings.
		 * This ensures that:
		 *  - the remaining binfmt code will not run out of stack space,
		 *  - the program will have a reasonable amount of stack left
		 *    to work from.
To effect "1/4th the stack size", a cap at TASK_SIZE/4 does make some sense,
since TASK_SIZE is less than RLIM_INFINITY even in the pure 32-bit world,
and that is the true theoretical limit on stack size.

The trouble here, both for that stated intent, and for this "exploit",
is which TASK_SIZE that is on a biarch machine.  In fact, it's the
TASK_SIZE of the process that called execve.  (get_arg_page is called
from copy_strings, from do_execve before search_binary_handler--i.e.,
before anything has looked at the file to decide whether it's going to
be a 32-bit or 64-bit task on exec.)  If it's a 32-bit process exec'ing
a 64-bit program, it's the 32-bit TASK_SIZE (perhaps as little as 3GB).
So that's a limit of 0.75GB on a 64-bit program, which might actually do
just fine with 2 or 3GB.  If it's a 64-bit process exec'ing a 32-bit
program, it's the 64-bit TASK_SIZE (128TB on x86-64).  So that's a limit
of 32TB, which is perhaps not that helpfully less than 2PB minus 1 byte
(RLIM_INFINITY/4) as far as preventing any over-allocation DoS in practice.

So IMHO your change does marginal harm in some cases (32 execs 64)
and makes no appreciable difference to anyone interested in malice
(who can just dodge by exploiting it via 64 execs 64 or 64 execs 32).

If you want to constrain it this way, it's probably simpler just to use
a smaller hard limit for RLIM_STACK at boot time (and hence system-wide).
But it sounds like all you really need is to fix the OOM/allocation
behavior for huge stack allocations.


Thanks,
Roland
