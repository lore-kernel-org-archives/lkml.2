Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1CBSlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1CBSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:41:07 -0500
Date: Wed, 2 Mar 2011 13:40:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
Message-ID: <20110302184053.GW11359@redhat.com>
References: <4D6E631B.6040701@openvz.org>
 <20110302154645.GA11827@elte.hu>
 <4D6E6886.2060707@openvz.org>
 <20110302160315.GA12620@elte.hu>
 <4D6E6CB6.7000700@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E6CB6.7000700@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 07:13:42PM +0300, Cyrill Gorcunov wrote:
> On 03/02/2011 07:03 PM, Ingo Molnar wrote:
> ...
> > 
> > Well, the lock serializes the read-out of the 'NMI reason' port, the handling of 
> > whatever known reason and then the reassertion of the NMI (on 32-bit). 
> > 
> > EDAC has a callback in pci_serr_error() - and this lock serializes that. So we 
> > cannot just remove a lock like that, if there's any chance of parallel execution on 
> > multiple CPUs.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> OK, probably we need some UV person CC'ed (not sure whom) just to explain the
> reason for such nmi-listening model. Meanwhile -- lets drop my patch.

It's for debugging reasons.  When their huge machine deadlocks, they
wanted an easy mechanism to dump the cpu stacks.  That mechanism was an
nmi button.  The problem was the button would only dump the first cpu.  By
opening up the other cpus to accept external nmis, they could dump all the
cpus.

Now this spinlock doesn't affect them, because they registered an nmi
handler to catch it and dump their stack (I modified the code to use
DIE_NMIUNKNOWN instead of DIE_NMI to avoid conflict with the
nmi_watchdog).  But I don't know what the affect is, if that spinlock is
not there (I sent a private email to SGI inquiring, their guy wasn't
around this week).

Personally I am indifferent to this patch.  I don't have any problems with
the code the way it is now, but can understand what you mean having stuff
lying around as 'dead code'.  I had thought Intel would have pushed more
patches upstream to remove the BSP lock-in by now.

Cheers,
Don

