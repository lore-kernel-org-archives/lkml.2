Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2BCRS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:18:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab2BCRS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:18:27 -0500
Date: Fri, 3 Feb 2012 12:18:09 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v4 -next 1/4] Move kmsg_dump(KMSG_DUMP_PANIC) below
 smp_send_stop()
Message-ID: <20120203171809.GL5650@redhat.com>
References: <20120105210123.GI5650@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C5827BBD8@USINDEVS01.corp.hds.com>
 <4F0BAB33.2090201@linux.intel.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C583163B0@USINDEVS01.corp.hds.com>
 <4F0D3A0B.4090709@linux.intel.com>
 <20120111172544.GS5650@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28FD61F@ORSMSX104.amr.corp.intel.com>
 <32727E9A83EE9A42A1F0906295A3A77B2C78F49973@USINDEVS01.corp.hds.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DA7B65F2A@USINDEVS01.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F0275EE@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:56:15PM +0000, Luck, Tony wrote:
> > Do you have any comments?
> 
> I'm stuck in because I don't know how assign probabilities to
> the failure cases with kmsg_dump() before and after the smp_send_stop().
> 
> There's a well documented tendency in humans to stick with the status
> quo in such situations.  I'm definitely finding it hard to provide
> a positive recommendation (ACK).
> 
> So I'll just talk out loud here for a bit in case someone sees
> something obviously flawed in my understanding.

Thanks for trying to think this through.

> 
> Problem statement: We'd like to maximize our chances of saving the
> tail of the kernel log when the system goes down. With the current
> ordering there is a concern that other cpus will interfere with the
> one that is saving the log.
> 
> Problems in current code flow:
> *) Other cpus might hold locks that we need. Our options are to fail,
>    or to "bust" the locks (but busting the locks may lead to other
>    problems in the code path - those locks were there for a reason).
>    There are only a couple of ways that this could be an issue.
>    1) The lock is held because someone is doing some other pstore
>    filesystem operation (reading and erasing records). This has a
>    very low probability. Normal code flow will have some process harvest
>    records from pstore in some /etc/rc.d/* script - this process should
>    take much less than a second.

ok.

>    2) The lock is held because some other kmsg_dump() store is in progress.
>    This one seems more worrying - think of an OOPS (or several) right
>    before we panic

I think Seiji had another patch to address this.

> 
> Problems in proposed code flow:
> *) smp_send_stop() fails:
>    1) doesn't actually stop other cpus (we are no worse off than before we
>    made this change)
>    2) doesn't return - so we don't even try to dump to pstore back end. x86
>    code has recently been hardened (though I can still imagine a pathological
>    case where in a crash the cpu calling this is uncertain of its own
>    identity, and somehow manages to stop itself - perhaps we are so screwed up
>    in this case that we have no hope anyway)

Where in the code do you see that it might not return?  We can also
conceive of a scenario such that pstore or apei code has a bug and oops
the box a second time and we are no better off.  That code has a lot more
churn then the shutdown code, I believe.

> *) Even if it succeeds - we may still run into problems busting locks because
>    even though the cpu that held them isn't executing, the data structures
>    or device registers protected by the lock may be in an inconsistent state.
> *) If we had just let this other cpus keep running, they'd have finished their
>    operation and freed up the problem lock anyway

So this is an interesting concern and it would be nice to have that extra
second to finish things off before breaking the spin lock.  I was trying
to figure out if there was a way to do that.

On x86 I think we can (and maybe others).  I had a thought, most
spinlocks are taken by disabling interrupts (ie spin_lock_irqsave).  By
disabling interrupts you block IPIs.  Originally the shutdown code would
use the REBOOT_IPI to stop other cpus but would fail if some piece of code
on another cpu was spinning forever with irqs disabled.  I modified it to
use NMIs to be more robust.

What if we send the REBOOT_IPI first and let it block for up to a second.
Most code paths that are done with spin_locks will use
spin_lock_irqrestore.  As soon as the interrupts are re-enabled the
REBOOT_IPI comes in and takes the processor.  If after a second the cpu
still is blocking interrupts, just use the NMI as a big hammer to shut it
down.

This would allow the pstore stuff to block shutting things down for a
little bit to finish writing its data out before accepting the IPI (at
least for a second).  Otherwise if it takes more than a second and the NMI
has to come in, we may have to investigate what is going on.

Would that help win you over?

I know that is x86 specific, but other arches might be able to adapt a
similar approach?

Cheers,
Don
