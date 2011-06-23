Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065Ab1FWJ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:28:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43657 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1FWJ2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:28:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p9liSJg4ODDOJUjF4e3n6G0tfhWazgYKIKlk/sOQXA8RxW0yRoUbj6SfjxeSZ6TQRI
         v6soTyJu4O4YlhM+3lnnAM1TUwW0RnePgIFkidBgYkLnMaLDxq05OxTzpXdhIdEPFfFa
         uXfYhao1oHPx+vNSQcc7yDKaf8sAZXUZybYrA=
Date: Thu, 23 Jun 2011 11:28:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, trenn@novell.com, prarit@redhat.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        youquan.song@intel.com
Subject: Re: [patch 3/4] stop_machine: implement
 stop_machine_from_offline_cpu()
Message-ID: <20110623092845.GJ30101@htj.dyndns.org>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
 <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
 <1308821119.1022.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308821119.1022.84.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Jun 23, 2011 at 11:25:19AM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> > +int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
> > +                                 const struct cpumask *cpus)
> > +{
> > +       struct stop_machine_data smdata = { .fn = fn, .data = data,
> > +                                           .active_cpus = cpus };
> > +       struct cpu_stop_done done;
> > +       int ret;
> > +
> > +       /* Local CPU must be offline and CPU hotplug in progress. */
> > +       BUG_ON(cpu_online(raw_smp_processor_id()));
> > +       smdata.num_threads = num_online_cpus() + 1;     /* +1 for local */
> > +
> > +       /* No proper task established and can't sleep - busy wait for lock. */
> > +       while (!mutex_trylock(&stop_cpus_mutex))
> > +               cpu_relax();
> > +
> > +       /* Schedule work on other CPUs and execute directly for local CPU */
> > +       set_state(&smdata, STOPMACHINE_PREPARE);
> > +       cpu_stop_init_done(&done, num_online_cpus());
> > +       queue_stop_cpus_work(cpu_online_mask, stop_machine_cpu_stop, &smdata,
> > +                            &done);
> > +       ret = stop_machine_cpu_stop(&smdata);
> > +
> > +       /* Busy wait for completion. */
> > +       while (!completion_done(&done.completion))
> > +               cpu_relax();
> > +
> > +       mutex_unlock(&stop_cpus_mutex);
> > +       return ret ?: done.ret;
> > +} 
> 
> Damn thats ugly, I sure hope you're going to make those hardware folks
> pay for this :-)

Oh, I agree it's fugly.  It's trying to orchestrate stop_machine from
a CPU which doesn't have proper scheduler/task set up.  At least it's
contained in a single relatively short function.

Thanks.

-- 
tejun
