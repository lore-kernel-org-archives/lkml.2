Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1GMP0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:26:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab1GMP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:26:03 -0400
Date: Wed, 13 Jul 2011 17:23:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
Message-ID: <20110713152331.GB4850@redhat.com>
References: <20110710182203.GA27979@redhat.com> <20110713102520.0065c7de@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713102520.0065c7de@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13, Matt Fleming wrote:
>
> On Sun, 10 Jul 2011 20:22:03 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > 1. do_signal() looks at TS_RESTORE_SIGMASK and calculates the
> >    mask which should be stored in the signal frame, then it
> >    passes "oldset" to the callees, down to setup_rt_frame().
> >
> >    This is ugly, setup_rt_frame() can do this itself and nobody
> >    else needs this sigset_t. Move this code into setup_rt_frame.
> >
> > 2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
> >    succeeds.
> >
> >    We can move this to setup_rt_frame() as well, this avoids the
> >    unnecessary checks and makes the logic more clear.
> >
> > 3. use set_current_blocked() instead of sigprocmask(SIG_SETMASK),
> >    sigprocmask() should be avoided.
>
> Could you please mention commit e6fa16ab "signal: sigprocmask() should
> do retarget_shared_pending()", since it's not immediately obvious in
> this changelog why sigprocmask() should be avoided.

Well, sigprocmask(SIG_SETMASK) is fine from the correctness pov,
it calls set_current_blocked().

sigprocmask() should be avoided because it is strange interface.
It has numeruos callers, but in fact almost all of them could use
set_current_blocked() (ignoring sys_rt_sigprocmask).

Linus suggested to simply kill sigprocmask(). I am not sure, but
at least it shouldn't be abused and its last argument is confusing.

> Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks for looking!

Oleg.

