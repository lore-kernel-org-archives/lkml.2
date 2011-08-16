Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HPRxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1HPRxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:53:04 -0400
Date: Tue, 16 Aug 2011 18:49:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 18/41] OpenRISC: Don't reimplement force_sigsegv()
Message-ID: <20110816164928.GA29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-19-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-19-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> Instead of open coding the sequence from force_sigsegv() just call
> it. This also fixes a race because sa_handler was being modified
> without holding ->sighand->siglock.
>
> --- a/arch/openrisc/kernel/signal.c
> +++ b/arch/openrisc/kernel/signal.c
> @@ -257,9 +257,7 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  	return;
>
>  give_sigsegv:
> -	if (sig == SIGSEGV)
> -		ka->sa.sa_handler = SIG_DFL;
> -	force_sig(SIGSEGV, current);
> +	force_sigsegv(sig, current);
>  }

Agreed, but...

I don't really understand the changelog, which race this patch fix?

Yes, we shouldn't change sa_handler lockless, this "breaks the rules"
but I do not see any immediate problem. And since force_sigsegv() drops
the lock after setting SIG_DFL we can "race" with the sub-thread anyway.


Hmm. Looking more, I think that this patch is not the cleanup, but the
bugfix. The current code is simply wrong, it plays with ka, and it points
to the _copy_ of sighand->action[], so this code is simply pointless.


Unless I missed something, could you fix the changelog and resend?

Oleg.

