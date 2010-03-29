Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0C2BBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:01:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56794 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0C2BBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:01:17 -0400
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: john stultz <johnstul@us.ibm.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Yury Polyanskiy <ypolyans@princeton.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <20100326214648.GF9984@mail.oracle.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Mar 2010 18:00:36 -0700
Message-ID: <1269824436.1880.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 14:46 -0700, Joel Becker wrote:
> On Tue, Mar 23, 2010 at 11:36:11PM -0400, Yury Polyanskiy wrote:
> > Second, and more importantly, loops_per_jiffy has little to do with the conversion from the
> > the time scale of get_cycles() (aka rdtsc) to the time scale of jiffies.
> 
> 	It used to!  Fundamentally, of course, we didn't have a
> monotonic clock everywhere that satisfied hangcheck-timer's needs.  So
> we had to use different approaches on different architectures.
> 
> > @@ -130,7 +129,9 @@ extern unsigned long long monotonic_clock(void);
> >  #else
> >  static inline unsigned long long monotonic_clock(void)
> >  {
> > -	return get_cycles();
> > +	struct timespec ts;
> > +	getrawmonotonic(&ts);
> > +	return timespec_to_ns(&ts);
> >  }
> >  #endif  /* HAVE_MONOTONIC */
> 
> 	I have two questions:
> 
> 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
> it always return the wallclock nanoseconds even in the face of CPU speed
> changes, suspend, udelay, or any other suspension of kernel operation?
> Yes, I know this is a tougher standard than rdtsc(), but this is what
> hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.

getrawmonotonic() can be stalled and will wrap on some hardware (acpi pm
timer wraps every 5 seconds).

I think the read_persistent_clock() is really what you want to use here.
On arches that do not support it, it returns 0 every time. 

thanks
-john



