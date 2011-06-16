Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab1FPSRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:17:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:42707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1FPSRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:17:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,376,1304319600"; 
   d="scan'208";a="17152360"
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308246910.13240.238.camel@twins>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308071218-5912-2-git-send-email-tj@kernel.org>
	 <1308226372.13240.42.camel@twins>
	 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1308246910.13240.238.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 16 Jun 2011 11:17:40 -0700
Message-Id: <1308248260.2682.413.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 10:55 -0700, Peter Zijlstra wrote:
> On Thu, 2011-06-16 at 10:37 -0700, Suresh Siddha wrote:
> > On Thu, 2011-06-16 at 05:12 -0700, Peter Zijlstra wrote:
> > > On Tue, 2011-06-14 at 19:06 +0200, Tejun Heo wrote:
> > > Please have a look at: 
> > > 
> > > ---
> > > commit d91309f69b7bdb64aeb30106fde8d18c5dd354b5
> > > Author: Peter Zijlstra <peterz@infradead.org>
> > > Date:   Fri Feb 11 22:07:46 2011 +0100
> > > 
> > >     x86: Fix text_poke_smp_batch() deadlock
> > >     
> > >     Fix this deadlock - we are already holding the mutex:
> > >     
> > ...
> > > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > > index 1236085..7038b95 100644
> > > --- a/arch/x86/kernel/alternative.c
> > > +++ b/arch/x86/kernel/alternative.c
> > > @@ -671,7 +671,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
> > >  
> > >  	atomic_set(&stop_machine_first, 1);
> > >  	wrote_text = 0;
> > > -	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> > > +	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> > >  }
> > >  
> > >  #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
> > > 
> > 
> > Peter, So it looks like we are allowing a new cpu to come online in
> > parallel, while we poke the text? Isn't it a problem? What am I missing?
> 
> the caller already did get_online_cpus(), 
> 
> do_optimize_kprobes()
>   get_online_cpus()
>   arch_optimize_kprobes()
>     text_poke_smp_batch()
>   put_online_cpus()

So the circular dependency reported is not possible in practice right?

Above patch is working around a false positive.

thanks,
suresh

