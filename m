Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2G3BTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:19:41 -0400
Received: from ozlabs.org ([203.10.76.45]:58988 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2G3BTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:19:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@us.ibm.com>
Subject: Re: [PATCH] x86: don't ever patch back to UP if we unplug cpus.
In-Reply-To: <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
References: <87y5m5mz6o.fsf@rustcorp.com.au> <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 30 Jul 2012 10:45:04 +0930
Message-ID: <87d33em4mf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 13:28:29 -0700, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Fri, 2012-07-27 at 17:08 +0930, Rusty Russell wrote:
> > Paul McKenney points out:
> > 
> >  mean offline overhead is 6251/48=130.2 milliseconds.
> > 
> >  If I remove the alternatives_smp_switch() from the offline
> >  path [...] the mean offline overhead is 550/42=13.1 milliseconds
> > 
> > Basically, we're never going to get those 120ms back, and the code is
> > pretty messy.
> 
> I am ok with this proposal. If I follow correctly, you are still
> allowing the patching to UP happen on boot if there is only one online
> cpu currently but a possiblity of multiple cpu's that can come online
> later. Perhaps make this little more explicit in the changelog.

That's right.  How's this:

Subject: x86: don't ever patch back to UP if we unplug cpus.

We still patch SMP instructions to UP variants if we boot with a
single CPU, but not at any other time.  In particular, not if we
unplug CPUs to return to a single cpu.

Paul McKenney points out:

 mean offline overhead is 6251/48=130.2 milliseconds.

 If I remove the alternatives_smp_switch() from the offline
 path [...] the mean offline overhead is 550/42=13.1 milliseconds

Basically, we're never going to get those 120ms back, and the code is
pretty messy.

We get rid of:
1) The "smp-alt-once" boot option.  It's actually "smp-alt-boot", the
   documentation is wrong.  It's now the default.
2) The skip_smp_alternatives flag used by suspend.
3) arch_disable_nonboot_cpus_begin() and arch_disable_nonboot_cpus_end()
   which were only used to set this one flag.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

> Also,
> 
> > +	/* Patch to UP if other cpus not imminent. */
> > +	if (noreplace_smp || num_present_cpus() == 1 || setup_max_cpus <= 1) {
> 
> shouldn't this be
> 
> 	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1))

Yes, good point.

> also, to be consistent with other checks, may be just use
> "num_possible_cpus() == 1" check instead of "setup_max_cpus <= 1".

I think that should work.  Will test variations...

Thanks,
Rusty.
