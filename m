Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2AaQZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:25:09 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53520 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752270Ab2AaQZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:25:08 -0500
Date: Tue, 31 Jan 2012 11:25:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Ted Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] char random: fix boot id uniqueness race
Message-ID: <20120131162505.GA8298@Krystal>
References: <20120130044012.GA31966@Krystal> <20120131155955.GA24356@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131155955.GA24356@thunk.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:00:24 up 433 days, 21:03,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ted Ts'o (tytso@mit.edu) wrote:
> On Sun, Jan 29, 2012 at 11:40:12PM -0500, Mathieu Desnoyers wrote:
> > Index: linux-2.6-lttng/drivers/char/random.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/drivers/char/random.c
> > +++ linux-2.6-lttng/drivers/char/random.c
> > @@ -1231,6 +1231,8 @@ static int min_read_thresh = 8, min_writ
> >  static int max_read_thresh = INPUT_POOL_WORDS * 32;
> >  static int max_write_thresh = INPUT_POOL_WORDS * 32;
> >  static char sysctl_bootid[16];
> > +static int boot_id_generated;
> > +static DEFINE_MUTEX(boot_id_mutex);

Hi Ted,

> 
> My preference would be to put these statics in proc_do_uuid(), but
> that's arguably a nit.

No problem, can do.

> 
> > +	} else {
> > +		if (unlikely(!ACCESS_ONCE(boot_id_generated))) {
> > +			mutex_lock(&boot_id_mutex);
> > +			if (!boot_id_generated) {
> > +				generate_random_uuid(uuid);
> > +				/* Store uuid before boot_id_generated. */
> > +				smp_wmb();
> > +				boot_id_generated = 1;
> > +			}
> > +			mutex_unlock(&boot_id_mutex);
> > +		} else {
> > +			/* Load boot_id_generated before uuid */
> > +			smp_rmb();
> > +		}
> > +	}
> 
> I don't believe the smp_wmb() and smp_rmb() are necessary here; the
> mutex_lock() and mutex_unlock() should put the necessary memory
> barriers in place.

The need for memory barriers is a consequence of letting the fast-path
run without holding this mutex.

Here is the race dealt with by the smp_rmb()/smp_wmb(). I'm showing the
result of reversed write order here:

CPU A                             CPU B

Load boot_id_generated            
  (test -> false)
mutex_lock(&boot_id_mutex)
  (implied memory barrier
   with acquire semantic)
Load boot_id_generated again
  (test -> false)
boot_id_generated = 1
  (both the compiler and
   CPU are free to reorder
   the boot_id_generated
   store before uuid stores)
                                  Load boot_id_generated
                                    (test -> true)
                                  Load uuid content
                                    (races with generate_random_uuid:
                                     result either 0 or corrupted)
                                  Return corrupted uuid.
generate_random_uuid(uuid)
mutex_unlock(&boot_id_mutex)

I prefer not requiring the fast-path to take a mutex, because this
would transform a read-mostly operation into an operation that
requires cache-line exchanges (the mutex). However, if we want the
fast-path to be mutex-free, we need to enforce order with
memory barriers: smp_rmb on the read-side, smp_wmb on the
update-side. Failure to do so leads to the race shown above,
where a corrupted boot_id can be returned.

Please let me know if there are aspects of your question I can
address better,

Thanks,

Mathieu

> 
> Regards,
> 
> 						- Ted

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
