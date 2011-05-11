Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1EKTRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:17:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56598 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1EKTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P9oMiVQS4SOyy5E1NcOYKIPTeMjIQs/sKo9fkBDXm/KTKCwp+paxj+dCli8kVpPQ/J
         lxiwQq0damEkasrYXCPinfj1PHIX+1c1CyAIFtb6Z1i888MR6DeKrqclfrPvIPnNE120
         k/e7m6bF0LQzUolbl3Z66xa28at3oo7djdV0Q=
Date: Wed, 11 May 2011 21:17:31 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 08/11] ptrace: move fallback JOBCTL_TRAPPING clearing
 to get_signal_to_deliver()
Message-ID: <20110511191731.GA24245@mtj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-9-git-send-email-tj@kernel.org>
 <20110511154834.GA23688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511154834.GA23688@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 11, 2011 at 05:48:34PM +0200, Oleg Nesterov wrote:
> On 05/08, Tejun Heo wrote:
> > Move the fallback clearing to the end of get_signal_to_deliver() so
> > that TRAPPING is maintained while tracee is inside signal delivery
> > path.  When killed, tracee is guaranteed to leave signal delivery path
> > in finite amount of time and thus TRAPPING is still guaranteed to be
> > cleared on kill.
> 
> Mostly yes, but we can race with freeze_processes() and deadlock.

Ah... the try_to_freeze().  Nice spotting.  It isn't necessarily a
deadlock tho.  freeze_processes() will back out after a while.  I
think the right thing to do here is making the TRAPPING sleep an
interruptible one and let the syscall restart logic deal with it.
This will also remove the dreaded unkillable tracer even if we get
something wrong somewhere.  How does that sound?

> And. The main problem is that "leave signal delivery path" is not true
> at all. When the tracee dequeues SIGKILL it calls do_group_exit() inside
> the main loop.
> 
> So far this all looks easily fixeable though...

Yeah, as I wrote before, I wanna do two things.

* Make TRAPPING wait INTERRUPTIBLE.

* Move clearing of pending group stop and traps to the actions which
  require such clearing.

Thanks.

-- 
tejun
