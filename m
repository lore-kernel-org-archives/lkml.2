Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2LJQmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJQmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:42:44 -0500
Date: Mon, 10 Dec 2012 11:42:15 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Message-ID: <20121210164215.GZ53431@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 09:41:13PM +0000, Seiji Aguchi wrote:
> [Issue]
> 
> If one cpu ,which is taking a psinfo->buf_lock, 
> receive NMI from a panicked cpu via smp_send_stop(),
> the panicked cpu hangs up in pstore_dump() called by kmsg_dump(KMSG_DUMP_PANIC)
> because the psinfo->buf_lock is taken again in it.

Hi Seiji,

I am trying to understand this scenario.  You said it is theoretical.
Looking through smp_send_stop, it only sends an NMI if the IRQ did not
work after a second.

So the scenario you are looking at is:

cpuA grabs psinfo->buf_lock
cpuB panics and calls smp_send_stop
smp_send_stop sends IRQ to cpuA
after 1 second, cpuB gives up on cpuA and sends an NMI instead
cpuA is now in an NMI handler while still holding buf_lock
cpuB is deadlocked


Now my first reaction would be, if that is the scenario, why couldn't cpuA
release the lock within one second.  Because if cpuA is stuck talking with
firmware, then your patch to force the unlock is probably going to trip
over the same problems.
(those problems include dealing with resetting a firmware state machine)

IOW, your patch is just one of many minefields you will have to cross in
order to be successful.  

Without any testing to show that you have cleared all those minefields, I
am leaning against your patch for now.  I would rather have a complete
patchset that fixes all the problems in this path.


> 
> To avoid the deadlock, an easy solution is moving kmsg_dump above
> smp_send_stop() in panic path.
> 
> But, it is not safe to kick pstore while multiple cpus are running in panic case,
> because they may touch corrupted data/variables and unnecessary failures may happen.
> In that case, we can't guarantee that a panicked cpu can log messages reliably
> because it may have harmful effects due to the failures.
> 
> [Solution]
> 
> This patch skips taking a psinfo->buf_lock when just one cpu is online
> because stopped cpus turn to offline via smp_send_stop()
> in some architectures like x86, powerpc or arm64.
> 
> It may be a hack but solves my concern deadlocking in x86 architecture.

If you did have to go this route, why not take the 'reason' variable and
pass it to some function 'in_panic_path(reason)' that tells you if you are
panicing or not.  Then you can change the 'if in_nmi()' to 'if in_nmi() ||
in_panic'.

The panic path already disables irqs for you, not sure you need to do it
again.  Unless you have some other path you are trying to protect in mind.

Cheers,
Don
