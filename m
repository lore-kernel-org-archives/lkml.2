Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1HPTd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:33:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55245 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1HPTdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:33:25 -0400
Subject: Re: [PATCH 18/41] OpenRISC: Don't reimplement force_sigsegv()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110816164928.GA29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-19-git-send-email-matt@console-pimps.org>
	 <20110816164928.GA29190@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 20:33:22 +0100
Message-ID: <1313523202.3436.180.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 18:49 +0200, Oleg Nesterov wrote:
> On 08/11, Matt Fleming wrote:
> >
> > Instead of open coding the sequence from force_sigsegv() just call
> > it. This also fixes a race because sa_handler was being modified
> > without holding ->sighand->siglock.
> >
> > --- a/arch/openrisc/kernel/signal.c
> > +++ b/arch/openrisc/kernel/signal.c
> > @@ -257,9 +257,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
> >  	return;
> >
> >  give_sigsegv:
> > -	if (sig == SIGSEGV)
> > -		ka->sa.sa_handler = SIG_DFL;
> > -	force_sig(SIGSEGV, current);
> > +	force_sigsegv(sig, current);
> >  }
> 
> Agreed, but...
> 
> I don't really understand the changelog, which race this patch fix?
> 
> Yes, we shouldn't change sa_handler lockless, this "breaks the rules"
> but I do not see any immediate problem. And since force_sigsegv() drops
> the lock after setting SIG_DFL we can "race" with the sub-thread anyway.

Argh, yeah this and the rest of patches that try to fixup 'ka' are
wrong, because like you say, we're operating on a copy on the stack, so
there's no race. I missed that :-(

I did notice that race in force_sigsegv() too, is it a real problem? It
certainly looked to me like it could be a real problem.

> Hmm. Looking more, I think that this patch is not the cleanup, but the
> bugfix. The current code is simply wrong, it plays with ka, and it points
> to the _copy_ of sighand->action[], so this code is simply pointless.

Yeah, I will make that more explicit in the changelog.

> Unless I missed something, could you fix the changelog and resend?

Nope you haven't missed anything, you're spot on. I will resend.

-- 
Matt Fleming, Intel Open Source Technology Center

