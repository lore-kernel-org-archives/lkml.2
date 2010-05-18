Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0ERPMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:12:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:54534 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab0ERPM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:12:29 -0400
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
 update_cpu_load (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <AANLkTik4EvvSwz9rD3zemuaSN3FMAIqsncZ5AKYOdaEn@mail.gmail.com>
References: <1273886490-15627-1-git-send-email-venki@google.com>
	 <1274084399.5605.3655.camel@twins>
	 <AANLkTikWWEYpwmqhQ0oYz30SUFY-y2erqStw2T6h0WXg@mail.gmail.com>
	 <1274117717.1674.1539.camel@laptop>
	 <AANLkTik4EvvSwz9rD3zemuaSN3FMAIqsncZ5AKYOdaEn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 17:12:02 +0200
Message-ID: <1274195522.5605.8141.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 10:52 -0700, Venkatesh Pallipadi wrote:
> > load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * load_(i-1)
> >
> > not
> >
> > load_i = ((2^i)-1)/(2^i) * load_i + 1/(2^i) * cur_load
> 
> Hmm. I assumed you meant
> load_(i-1) is same as cur_load when you said
> >> >Where load_-1 == current load.
> 
> No? Or did I miss something?

load_(i-1) is only load_-1 when i == 0.

But it seems you're right and I misread the code. update_cpu_load() does
take a copy of this_load for each iteration, initially I thought it used
the load of the last iteration.

> For the updates done every tick, it is
> load = degrade * load + (1-degrade) * cur_load
> For updates done with missed ticks
> load = degrade^(missed-1) * load
> load = degrade * load + (1-degrade) * cur_load
> 
> So, cur_load is only accounted for the last tick, and zero load
> assumed for all the missed ticks. 

Right.
