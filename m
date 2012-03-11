Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2CKPtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 11:49:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47795 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2CKPs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 11:48:56 -0400
Date: Sun, 11 Mar 2012 15:48:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
Message-ID: <20120311154846.GD13336@n2100.arm.linux.org.uk>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com> <20120311132746.GA13336@n2100.arm.linux.org.uk> <CAOD=uF7kQHABCmxUL3-J-hZ1E2mXrb7dgsYq7msHhiPJ4Gm-Ew@mail.gmail.com> <20120311143615.GB13336@n2100.arm.linux.org.uk> <CAOD=uF5GbsyHS5iXjJ1YcqJyGLHwT8Wjhiie1daJAVqu527Umg@mail.gmail.com> <20120311150311.GC13336@n2100.arm.linux.org.uk> <CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 08:49:27PM +0530, santosh prasad nayak wrote:
> On Sun, Mar 11, 2012 at 8:33 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > in_interrupt() won't tell us if we're being called with spinlocks held,
> > which _is_ a possibility because this can be called from printk(), for
> > oops dumps and the like.
> >
> > in_interrupt() just means that we're inside a hard or soft interrupt,
> > or nmi.  It says nothing about whether msleep() is possible.
> 
> 
> in_atomic() is also not  error free.  I found following comment in
> include/linux/hardirq.h.  How do you handle it in non-preemptible
> kernel ?
> 
> /*
>  * Are we running in atomic context?  WARNING: this macro cannot
>  * always detect atomic context; in particular, it cannot know about
>  * held spinlocks in non-preemptible kernels.  Thus it should not be
>  * used in the general case to determine whether sleeping is possible.
>  * Do not use in_atomic() in driver code.
>  */
> #define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != 0)

That may be, but the fact of the matter is that no one has *ever*
reported an incident where this has failed at this point - and when
it does people will end up with a might_sleep() warning from msleep().

Maybe those who are saying people should not use this should instead
be analysing why people use this, and suggest an alternative solution
to the problem instead of a basic and uninformative "you shouldn't use
this" statement.

As I've said, if we aren't going to use this, then the only solution is
to completely omit the msleep() there and just say "sod you to running
anything else for 20ms while this driver busy-spins."  That's
ultimately the safe thing to do, and at the moment I see no other
alternative there.
