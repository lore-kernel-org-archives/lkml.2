Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab2BONfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:35:18 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53134 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758246Ab2BONfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:35:13 -0500
Date: Wed, 15 Feb 2012 08:35:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] char random: fix boot id uniqueness race (v2)
Message-ID: <20120215133505.GA3659@Krystal>
References: <20120215041014.GA15846@Krystal> <1329284916.2555.34.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1329284916.2555.34.camel@edumazet-laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:29:40 up 448 days, 18:32,  5 users,  load average: 0.41, 0.22,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (eric.dumazet@gmail.com) wrote:
> Le mardi 14 février 2012 à 23:10 -0500, Mathieu Desnoyers a écrit :
> > The proc file /proc/sys/kernel/random/boot_id can be read concurrently
> > by user-space processes. If two (or more) user-space processes
> > concurrently read boot_id when sysctl_bootid is not yet assigned, a race
> > can occur making boot_id differ between the reads. Because the whole
> > point of the boot id is to be unique across a kernel execution, fix this
> > by protecting this operation with a mutex, and introduce a
> > boot_id_generated flag, along with appropriate memory barriers, to let
> > the fast-path know if the boot ID has been generated without having to
> > hold the mutex.
> > 
> > I propose this approach rather than setting it up within an initcall(),
> > because letting execution randomness add to entropy before populating
> > the boot id seems to be a wanted property. Also, populating it lazily
> > rather than at boot time only makes the performance hit be taken when
> > boot_id is being read.
> > 
> > 
> > Q: Why are these memory barriers required ? Aren't the mutexes already
> >    dealing with ordering ?
> > 
> > The need for memory barriers is a consequence of letting the fast-path
> > run without holding this mutex.
> > 
> > Here is the race dealt with by the smp_rmb()/smp_wmb(). I'm showing the
> > result of reversed write order here:
> > 
> > CPU A                             CPU B
> > 
> > Load boot_id_generated            
> >   (test -> false)
> > mutex_lock(&boot_id_mutex)
> >   (implied memory barrier
> >    with acquire semantic)
> > Load boot_id_generated again
> >    (test -> false)
> > boot_id_generated = 1
> >   (both the compiler and
> >    CPU are free to reorder
> >    the boot_id_generated
> >    store before uuid stores)
> >                                   Load boot_id_generated
> >                                     (test -> true)
> >                                   Load uuid content
> >                                     (races with generate_random_uuid:
> >                                      result either 0 or corrupted)
> >                                   Return corrupted uuid.
> > generate_random_uuid(uuid)
> > mutex_unlock(&boot_id_mutex)
> > 
> > I prefer not requiring the fast-path to take a mutex, because this
> > would transform a read-mostly operation into an operation that
> > requires cache-line exchanges (the mutex). However, if we want the
> > fast-path to be mutex-free, we need to enforce order with
> > memory barriers: smp_rmb on the read-side, smp_wmb on the
> > update-side. Failure to do so leads to the race shown above, where
> > a corrupted boot_id can be returned.
> > 
> > 
> > * Changelog since v1:
> > - boot_id_mutex is now declared within the proc_do_uuid scope.
> > - added explanation for memory barriers.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: "Theodore Ts'o" <tytso@mit.edu>
> > CC: Matt Mackall <mpm@selenic.com>
> > CC: Greg Kroah-Hartman <greg@kroah.com>
> > ---
> >  drivers/char/random.c |   20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6-lttng/drivers/char/random.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/drivers/char/random.c
> > +++ linux-2.6-lttng/drivers/char/random.c
> > @@ -1244,16 +1244,30 @@ static char sysctl_bootid[16];
> >  static int proc_do_uuid(ctl_table *table, int write,
> >  			void __user *buffer, size_t *lenp, loff_t *ppos)
> >  {
> > +	static int boot_id_generated;
> > +	static DEFINE_MUTEX(boot_id_mutex);
> >  	ctl_table fake_table;
> >  	unsigned char buf[64], tmp_uuid[16], *uuid;
> >  
> >  	uuid = table->data;
> >  	if (!uuid) {
> >  		uuid = tmp_uuid;
> > -		uuid[8] = 0;
> > -	}
> > -	if (uuid[8] == 0)
> >  		generate_random_uuid(uuid);
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
> >  
> >  	sprintf(buf, "%pU", uuid);
> >  
> > 
> 
> This seems overly complex to me.
> 
> I doubt this is performance critical path ?

Fair point, I don't see many use-cases where an application would like
to get the boot_id value (which stays constant over an entire kernel
execution) very frequently, unlike /proc/sys/kernel/random/uuid.

> 
> What about a basic patch like :
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 54ca8b2..af6040d 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1260,11 +1260,15 @@ static int proc_do_uuid(ctl_table *table, int write,
>  	uuid = table->data;
>  	if (!uuid) {
>  		uuid = tmp_uuid;
> -		uuid[8] = 0;
> -	}
> -	if (uuid[8] == 0)
>  		generate_random_uuid(uuid);
> +	} else {
> +		static DEFINE_SPINLOCK(bootid_spinlock);
>  
> +		spin_lock(&bootid_spinlock);
> +		if (!uuid[8])
> +			generate_random_uuid(uuid);
> +		spin_unlock(&bootid_spinlock);

That would make sense, as long as we're OK about turning a read-mostly
operation into a fully serialized operation that requires to exchange
the lock between processor cache-lines. But as you point out, it should
be fairly unfrequently used.

Any particular reason to use a spin lock rather than a mutex ? I did put
a mutex in my implementation assuming that it would be a little more
RT-friendly.

Thanks,

Mathieu

> +	}
>  	sprintf(buf, "%pU", uuid);
>  
>  	fake_table.data = buf;
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
