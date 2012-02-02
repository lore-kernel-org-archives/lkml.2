Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2BBUFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:05:52 -0500
Received: from ozlabs.org ([203.10.76.45]:43589 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab2BBUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:05:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
In-Reply-To: <20120201140125.c656df41.akpm@linux-foundation.org>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com> <1328055439-9441-1-git-send-email-venki@google.com> <20120201140125.c656df41.akpm@linux-foundation.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 03 Feb 2012 06:33:02 +1030
Message-ID: <87d39xj955.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 14:01:25 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Though most of the callers of these two routines are init time (with few
> > exceptions of runtime calls), it is cleaner to use variables
> > and not go through this repeated mask based calculation.
> 
> Looks good to me.

But, I wonder who's asking num_possible_cpus().  It's not a very useful
thing to know, though some arch's "know" it's contiguous, so can cheat.

Optimizing it seems particularly foolish.  We either audit and wean
everyone off who's using it incorrectly, or insist on contiguous CPU
numbers and drop the mask altogether.

> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -604,9 +604,13 @@ EXPORT_SYMBOL(cpu_all_bits);
> >  #ifdef CONFIG_INIT_ALL_POSSIBLE
> >  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
> >  	= CPU_BITS_ALL;
> > +unsigned int nr_possible_cpus __read_mostly = CONFIG_NR_CPUS;
> >  #else
> >  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
> > +unsigned int nr_possible_cpus __read_mostly;
> >  #endif
> > +EXPORT_SYMBOL(nr_possible_cpus);
> 
> What the heck is CONFIG_INIT_ALL_POSSIBLE?
> 
> <blames Rusty>
> 
> :    1) Some archs (m32, parisc, s390) set possible_map to all 1, so we add a
> :       CONFIG_INIT_ALL_POSSIBLE for this rather than break them.
> 
> Seems strange.  Do these architectures really need to initialise
> cpu_possible_map at compile-time, when all the other architectures
> manage to do it at runtime?

IIRC playing with 3 archs boot code seemed like a recipe for disaster.
Feel free to try to fix this in -next though, and see what breaks...

Cheers,
Rusty.
