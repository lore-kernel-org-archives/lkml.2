Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1FPTA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:00:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab1FPTA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:00:26 -0400
Subject: Re: [PATCH 1/3] stop_machine: kill __stop_machine()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308071218-5912-2-git-send-email-tj@kernel.org>
	 <1308226372.13240.42.camel@twins>
	 <1308245872.2682.369.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Jun 2011 19:55:10 +0200
Message-ID: <1308246910.13240.238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 10:37 -0700, Suresh Siddha wrote:
> On Thu, 2011-06-16 at 05:12 -0700, Peter Zijlstra wrote:
> > On Tue, 2011-06-14 at 19:06 +0200, Tejun Heo wrote:
> > Please have a look at: 
> > 
> > ---
> > commit d91309f69b7bdb64aeb30106fde8d18c5dd354b5
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Fri Feb 11 22:07:46 2011 +0100
> > 
> >     x86: Fix text_poke_smp_batch() deadlock
> >     
> >     Fix this deadlock - we are already holding the mutex:
> >     
> ...
> > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > index 1236085..7038b95 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -671,7 +671,7 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
> >  
> >  	atomic_set(&stop_machine_first, 1);
> >  	wrote_text = 0;
> > -	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> > +	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> >  }
> >  
> >  #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
> > 
> 
> Peter, So it looks like we are allowing a new cpu to come online in
> parallel, while we poke the text? Isn't it a problem? What am I missing?

the caller already did get_online_cpus(), 

do_optimize_kprobes()
  get_online_cpus()
  arch_optimize_kprobes()
    text_poke_smp_batch()
  put_online_cpus()


