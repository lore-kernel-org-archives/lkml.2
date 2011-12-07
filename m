Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1LGNqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:46:13 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53822 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755801Ab1LGNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:46:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6iWJzNEH6xTS8fjy4BwwrDUwYtubPbC4oRCqoGk
	EEWlnXhKZyaQYS
Subject: Re: [patch] intel_idle: convert i7300_idle_lock to raw spinlock
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1323263113.2832.7.camel@pippen.local.home>
References: <1323258522.5057.73.camel@marge.simson.net>
	 <1323263113.2832.7.camel@pippen.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 14:46:00 +0100
Message-ID: <1323265560.5057.99.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 08:05 -0500, Steven Rostedt wrote:
> Looks as this should also go mainline (Cc'd LKML)
> 
> Note, as I want to release 3.0.12-rt30 today, this wont make it. It will
> have to wait till -rt31.

No hurry.  (20 synchronized core jitter test was horrid).

> -- Steve
> 
> On Wed, 2011-12-07 at 12:48 +0100, Mike Galbraith wrote:
> > 24 core Intel box's first exposure to 3.0.12-rt30-rc3 didn't go well.
> > 
> > [   27.104159] i7300_idle: loaded v1.55
> > [   27.104192] BUG: scheduling while atomic: swapper/2/0/0x00000002
> > [   27.104309] Pid: 0, comm: swapper/2 Tainted: G           N  3.0.12-rt30-rc3-rt #1
> > [   27.104317] Call Trace:
> > [   27.104338]  [<ffffffff810046a5>] dump_trace+0x85/0x2e0
> > [   27.104372]  [<ffffffff8144eb00>] thread_return+0x12b/0x30b
> > [   27.104381]  [<ffffffff8144f1b9>] schedule+0x29/0xb0
> > [   27.104389]  [<ffffffff814506e5>] rt_spin_lock_slowlock+0xc5/0x240
> > [   27.104401]  [<ffffffffa01f818f>] i7300_idle_notifier+0x3f/0x360 [i7300_idle]
> > [   27.104415]  [<ffffffff814546c7>] notifier_call_chain+0x37/0x70
> > [   27.104426]  [<ffffffff81454748>] __atomic_notifier_call_chain+0x48/0x70
> > [   27.104439]  [<ffffffff81001a39>] cpu_idle+0x89/0xb0
> > [   27.104449] bad: scheduling from the idle thread!
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > 
> > ---
> >  drivers/idle/i7300_idle.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > Index: linux-3.2-rt/drivers/idle/i7300_idle.c
> > ===================================================================
> > --- linux-3.2-rt.orig/drivers/idle/i7300_idle.c
> > +++ linux-3.2-rt/drivers/idle/i7300_idle.c
> > @@ -75,7 +75,7 @@ static unsigned long past_skip;
> >  
> >  static struct pci_dev *fbd_dev;
> >  
> > -static spinlock_t i7300_idle_lock;
> > +static raw_spinlock_t i7300_idle_lock;
> >  static int i7300_idle_active;
> >  
> >  static u8 i7300_idle_thrtctl_saved;
> > @@ -457,7 +457,7 @@ static int i7300_idle_notifier(struct no
> >  		idle_begin_time = ktime_get();
> >  	}
> >  
> > -	spin_lock_irqsave(&i7300_idle_lock, flags);
> > +	raw_spin_lock_irqsave(&i7300_idle_lock, flags);
> >  	if (val == IDLE_START) {
> >  
> >  		cpumask_set_cpu(smp_processor_id(), idle_cpumask);
> > @@ -506,7 +506,7 @@ static int i7300_idle_notifier(struct no
> >  		}
> >  	}
> >  end:
> > -	spin_unlock_irqrestore(&i7300_idle_lock, flags);
> > +	raw_spin_unlock_irqrestore(&i7300_idle_lock, flags);
> >  	return 0;
> >  }
> >  
> > @@ -554,7 +554,7 @@ struct debugfs_file_info {
> >  
> >  static int __init i7300_idle_init(void)
> >  {
> > -	spin_lock_init(&i7300_idle_lock);
> > +	raw_spin_lock_init(&i7300_idle_lock);
> >  	total_us = 0;
> >  
> >  	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev, forceload))
> > 
> 
> 


