Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0HTMfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab0HTMfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:35:52 -0400
Date: Fri, 20 Aug 2010 08:34:59 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100820123459.GD4879@redhat.com>
References: <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817103948.GA5352@swordfish.minsk.epam.com>
 <20100817131320.GX4879@redhat.com>
 <20100818024802.GA24748@nowhere>
 <20100818130156.43a183d9.akpm@linux-foundation.org>
 <20100820025749.GB4879@redhat.com>
 <20100819204256.3380bf6f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819204256.3380bf6f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 08:42:56PM -0700, Andrew Morton wrote:
> On Thu, 19 Aug 2010 22:57:49 -0400 Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Wed, Aug 18, 2010 at 01:01:56PM -0700, Andrew Morton wrote:
> > @@ -430,6 +437,9 @@ static int watchdog_enable(int cpu)
> >  		wake_up_process(p);
> >  	}
> >  
> > +	/* if any cpu succeeds, watchdog is considered enabled for the system */
> > +	watchdog_enabled = 1;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -452,9 +462,6 @@ static void watchdog_disable(int cpu)
> >  		per_cpu(softlockup_watchdog, cpu) = NULL;
> >  		kthread_stop(p);
> >  	}
> > -
> > -	/* if any cpu succeeds, watchdog is considered enabled for the system */
> > -	watchdog_enabled = 1;
> >  }
> >  
> >  static void watchdog_enable_all_cpus(void)
> 
> hm, the code seems a bit screwy.  Maybe it was always thus.

No, watchdog_enabled was something newly created for the lockup dectector.

> 
> watchdog_enabled gets set in the per-cpu function but it gets cleared
> in the all-cpus function.  Asymmetric.

Yes it is by design.  I was using watchdog_enabled as a global state
variable.  As soon as one cpu was enabled, I would set the bit.  But only
if all the cpus disabled the watchdog would I clear the bit.

> 
> Also afacit the action of cpu-hotunplug+cpu-hotplug will reenable the
> watchdog on a CPU which was supposed to have it disabled.  Perhaps you
> could recheck that and make sure it all makes sense - perhaps we need a
> separate state variable which is purely "current setting of
> /proc/sys/kernel/nmi_watchdog" and doesn't get altered internally.

I wasn't tracking it on a per cpu basis.  I didn't see a need to.  The
watchdog should globally be on/off across the system.  If a system comes
up and one of the cpus could not bring the watchdog online for some
reason, then that is a problem.  If a cpu-hotunplug+cpu-hotplug fixes it,
all the better. :-)

Also, if I wanted to track it per cpu, there is a bunch of status bits in
per-cpu variables that could let the code know whether a particular cpu
watchdog is on/off for either hardlockup or softlockup.

Cheers,
Don
