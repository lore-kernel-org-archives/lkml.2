Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1HPPmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1HPPmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:42:36 -0400
Date: Tue, 16 Aug 2011 17:39:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: avr32: handle_signal() bug?
Message-ID: <20110816153938.GA20428@redhat.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com> <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com> <1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com> <CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com> <1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Matt Fleming wrote:
>
> On Mon, 2011-08-15 at 22:55 -0700, Håvard Skinnemoen wrote:
> >
> > Thanks for the test. Unfortunately, the result is the same regardless
> > of whether I apply the patches or not. In both cases:
> >
> > /root # ./nodefer
> > SIGUSR2: not blocked
> > SIGTERM: not blocked
>
> Hmm.. that's interesting. I had a quick look through the rest of the
> code in the signal path and couldn't find anything obviously wrong.

Agreed, I am puzzled too.

> The
> only thing that looked suspicious is that you don't clear
> TIF_RESTORE_SIGMASK if you successsfully deliver a signal.

Indeed this is wrong. TIF_RESTORE_SIGMASK should be always cleared,
unless setup_rt_frame/valid_user_regs fails.

> Maybe try
> adding a clear_thread_flag(TIF_RESTORE_SIGMASK); to the success path in
> handle_signal() and see if you get better results?

I will be surprised if this helps with this particular test-case,
but I agree this should be fixed anyway.

> > Your patch doesn't appear to do any harm though, and it looks correct
> > to me. Perhaps there's another bug lurking somewhere as well. Some
> > preliminary debugging makes me suspicious about libc, but I can't tell
> > for sure yet.
>
> Which libc is this by the way?

may be you can run the test-case under strace? On my machine
strace -f -e rt_sigprocmask ./test shows

	[pid 25610] --- SIGUSR1 (User defined signal 1) @ 0 (0) ---
	[pid 25610] rt_sigprocmask(SIG_BLOCK, NULL, [USR2 TERM], 8) = 0

Oleg.

