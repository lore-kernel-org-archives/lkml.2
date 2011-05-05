Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1EEFoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 01:44:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46469 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1EEFoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 01:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CeuL7aC9BV0bs/pBW/odPID/0B+9VhWIqSXXZWSSB80TrDnvSCfvLlpmv4qwXa6Ms7
         T55WOeJ1+HnASPTOlOVnzp+GexvQLBdLh1Tcp0kR4mdbA0Xw3SBVfQOzWH4L7SkjdYHn
         lcP+GgOpcdzcYijRBTUiD5vdEx6D06avRgU6E=
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304564090.2943.36.camel@work-vm>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 07:44:04 +0200
Message-ID: <1304574244.32152.666.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 04 mai 2011 à 19:54 -0700, john stultz a écrit :
> On Tue, 2011-05-03 at 20:52 -0700, Andi Kleen wrote:
> > John Stultz <john.stultz@linaro.org> writes:
> > 
> > > From: John Stultz <johnstul@us.ibm.com>
> > >
> > > So get_seconds() has always been lock free, with the assumption
> > > that accessing a long will be atomic.
> > >
> > > However, recently I came across an odd bug where time() access could
> > > occasionally be inconsistent, but only on power7 hardware. The
> > 
> > Shouldn't a single rmb() be enough to avoid that?
> > 
> > If not then I suspect there's a lot more code buggy on that CPU than
> > just the time.
> 
> So interestingly, I've found that the issue was not as complex as I
> first assumed.  While the rmb() is probably a good idea for
> get_seconds(), but it alone does not solve the issue I was seeing,
> making it clear my theory wasn't correct.
> 
> The problem was reported against the 2.6.32-stable kernel, and had not
> been seen in later kernels. I had assumed the change to logarithmic time
> accumulation basically reduced the window for for the issue to be seen,
> but it would likely still show up eventually.
> 
> When the rmb() alone did not solve this issue, I looked to see why the
> locking did resolve it, and then it was clear: The old
> update_xtime_cache() function doesn't set the xtime_cache values
> atomically.
> 
> Now, the xtime_cache writing is done under the xtime_lock, so the
> get_seconds() locking resolves the issue, but isn't appropriate since
> get_seconds() is called from machine check handlers.
> 
> So the fix here for the 2.6.32-stable tree is to just update xtime_cache
> in one go as done with the following patch.
> 
> I also added the rmb() for good measure, and the rmb() should probably
> also go upstream since theoretically there maybe a platform that could
> do out of order syscalls.
> 
> I suspect the reason this hasn't been triggered on x86 or power6 is due
> to compiler or processor optimizations reordering the assignment to in
> effect make it atomic. Or maybe the timing window to see the issue is
> harder to observe?
> 
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> Index: linux-2.6.32.y/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.32.y.orig/kernel/time/timekeeping.c	2011-05-04 19:34:21.604314152 -0700
> +++ linux-2.6.32.y/kernel/time/timekeeping.c	2011-05-04 19:39:09.972203989 -0700
> @@ -168,8 +168,10 @@ int __read_mostly timekeeping_suspended;
>  static struct timespec xtime_cache __attribute__ ((aligned (16)));
>  void update_xtime_cache(u64 nsec)
>  {
> -	xtime_cache = xtime;
> -	timespec_add_ns(&xtime_cache, nsec);
> +	/* use temporary timespec so xtime_cache is updated atomically */

Atomically is not possible on 32bit platform, so this comment is
misleading.

What about a comment saying :
	/*
	 * use temporary variable so get_seconds() cannot catch
	 * intermediate value (one second backward)
	 */


> +	struct timespec ts = xtime;
> +	timespec_add_ns(&ts, nsec);
> +	xtime_cache = ts;
>  }
>  
>  /* must hold xtime_lock */
> @@ -859,6 +861,7 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased
>  
>  unsigned long get_seconds(void)
>  {
> +	rmb();

Please dont, this makes no sense, and with no comment anyway.

>  	return xtime_cache.tv_sec;
>  }
>  EXPORT_SYMBOL(get_seconds);
> 


