Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1ELPlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:41:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1ELPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:41:43 -0400
Date: Thu, 12 May 2011 17:40:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 08/11] ptrace: move fallback JOBCTL_TRAPPING clearing
	to get_signal_to_deliver()
Message-ID: <20110512154019.GB18599@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-9-git-send-email-tj@kernel.org> <20110511154834.GA23688@redhat.com> <20110511191731.GA24245@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511191731.GA24245@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> On Wed, May 11, 2011 at 05:48:34PM +0200, Oleg Nesterov wrote:
> > On 05/08, Tejun Heo wrote:
> > > Move the fallback clearing to the end of get_signal_to_deliver() so
> > > that TRAPPING is maintained while tracee is inside signal delivery
> > > path.  When killed, tracee is guaranteed to leave signal delivery path
> > > in finite amount of time and thus TRAPPING is still guaranteed to be
> > > cleared on kill.
> >
> > Mostly yes, but we can race with freeze_processes() and deadlock.
>
> Ah... the try_to_freeze().  Nice spotting.  It isn't necessarily a
> deadlock tho.

Yes, it is not "fatal" for the system.

> I
> think the right thing to do here is making the TRAPPING sleep an
> interruptible one and let the syscall restart logic deal with it.

Oh, yes, we can. But this adds more complications again. We can fix
this particular problem simpler. Say, freezer_do_not_count(). There
are other options afaics.

> * Make TRAPPING wait INTERRUPTIBLE.

I am starting to strongly dislike TRAPPING outside of do_signal_stop().

> * Move clearing of pending group stop and traps to the actions which
>   require such clearing.

Not sure this is enough. OTOH, perhaps this is unnneeded.

I'll write another email to explain what I mean.

Oleg.

