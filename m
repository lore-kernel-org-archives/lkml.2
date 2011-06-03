Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1FCBe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:34:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45190 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1FCBe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hneOWUNB0pgf7mNe676nZkjd/srGOgxrBHD+csQYxsjtymRP1b1zU/S0ZWemSWhI4F
         dZnBIZy2H2mO01+szmU+V9ybaV66J7X4TkrpiQPo0ocDOfzjswhVZWWo3F6I+3IJ/91Z
         iOhs71baZVkbkGSr0Fh2d1RgnYBkgSkqtNeQ8=
Date: Fri, 3 Jun 2011 10:34:23 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
Message-ID: <20110603013423.GB14872@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110602123105.GD10410@mtj.dyndns.org>
 <20110602182744.GA21705@redhat.com>
 <201106022309.44663.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106022309.44663.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg, Denys.

On Thu, Jun 02, 2011 at 11:09:44PM +0200, Denys Vlasenko wrote:
> > and signr is roughly calculated as
> > 
> > 	if (group_stop_count || SIGNAL_STOP_STOPPED)
> > 		signr = jobctl & JOBCTL_STOP_SIGMASK;
> > 	else if (JOBCTL_TRAP_NOTIFY)
> > 		signr = SIGCONT;
> > 	else
> > 		signr =  SIGTRAP; // PTRACE_INTERRUPT
> > 
> > In this case we can avoid all siginfo changes. The tracer does wait(status)
> > anyway, it can see the state without GETSIGINFO. The only problem, the tracer
> > should be careful to avoid the confusion with ptrace_signal(), it should
> > check status & (PTRACE_EVENT_STOP << 16).
> > 
> > What do you think?

Yeap, it makes sense.

> This should alleviate Linus' concerns that we are suffering from unnecessary
> featuritis - that we invent API which is significantly different
> from existing one, and as such users will not use it.
> 
> Existing API doesn't use GETSIGINFO data per se to distinguish group-stop from
> signal-delivery-stop, it uses the fact that GETSIGINFO fails on group-stop.
> (Well, arguably it's not a "designed" API, more like "accidentally created API",
> but nevertheless it exists right now). Oleg's proposal means that the new way
> may be makde to work very similarly.

Okay, you want to preserve %NULL SIGINFO on all STOP traps.  Dropping
si_pt_flags and using exit_code makes sense but I think we'll be
better off enabling GETSIGINFO.  The affected part of code has to be
changed anyway and with %NULL GETSIGINFO we effectively would have
driven ourselves into corner if more information needs to be added
later on.  Don't current users unconditionally issue CONT(sig) anyway?

> The less we deverge in handling of group-stop from existing API while fixing it,
> the better. If the only thing strace needs to change is to issue PTRACE_LISTEN
> instead of PTRACE_CONT on group-stop, then it's wonderful.
> 
> I understand that this patchset doesn't do exactly that yet, but it appears
> it can be achieved relatively easy by a future change. Don't take this
> as a request to respin the patchset yet again.

Heh, don't worry about re-spinning.  It's only take#4 now after all. :)

Thanks.

-- 
tejun
