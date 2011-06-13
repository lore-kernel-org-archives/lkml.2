Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1FMOOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:14:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1FMOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:14:16 -0400
Date: Mon, 13 Jun 2011 16:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
Message-ID: <20110613141408.GA16126@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
 <20110613092940.GB8282@elte.hu>
 <BANLkTi=eLODKcTfXb8Z1eAy4KnSE16icow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=eLODKcTfXb8Z1eAy4KnSE16icow@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Mon, Jun 13, 2011 at 5:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Andrew Lutomirski <luto@mit.edu> wrote:
> >
> >> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >> > Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
> >> >
> >> >   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
> >> >   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
> >>
> >> What's the code path that uses ret without initializing it?
> >
> > If the code is correct but GCC got confused then please use the
> > simplest possible patch to help GCC find its way around the code.
> 
> The simplest patch is to mark ret as uninitialized_var.

No - that primitive really sucks as it might hide *future* debug 
warnings and silently break code.

The problem with uninitialized_var() is that such code:

	int test(void)
	{
		int uninitialized_var(ret);

		return ret;
	}

Builds without a single warning but it is very broken code.

So if we use uninitialized_var() and the code is changed in the 
future to have the above broken sequence, we'll have a silent runtime 
failure ...

So we try to avoid using uninitialized_var() in arch/x86/ and use 
explicit initialization instead.

That way GCC that can see through the flow will optimize away the 
superfluous initialization - GCC versions that are older will 
generate one more instruction but that's OK.

Thanks,

	Ingo
