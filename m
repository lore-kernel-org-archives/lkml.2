Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1HYRjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:39:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:60828 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab1HYRjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:39:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,281,1312182000"; 
   d="scan'208";a="42428653"
Subject: Re: mtrr failure, 3.1-rc1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Anders Eriksson <aeriksson@fastmail.fm>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Aug 2011 10:43:01 -0700
In-Reply-To: <20110825164649.GL2803@mtj.dyndns.org>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
	 <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
	 <20110825164649.GL2803@mtj.dyndns.org>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 09:46 -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 25, 2011 at 08:55:12AM -0700, Linus Torvalds wrote:
> > Hmm. Some of those commits are marked for stable too.
> > 
> > I'm adding appropriate parties to the discussion (authors and
> > sign-offs from the five commits that that merge brings in), but it
> > would also be great if you could bisect exactly which commit broke for
> > you. You can make it quick by just doing
> > 
> >   git bisect start
> >   git bisect bad dc43d9fa73d82083656fb9c02f4823bcdcfb9f91
> >   git bisect good dc43d9fa73d82083656fb9c02f4823bcdcfb9f91^
> > 
> > and it should take just a couple of tests. I *assume* it's the
> > stop_machine changes by Tejun &co, but who knows..
> > 
> > Anders, is this a single-CPU system?
> 
> Indeed, while removing custom rendezvous code and switching to
> stop_machine, commit 192d8857427d "x86, mtrr: use stop_machine APIs
> for doing MTRR rendezvous" completely dropped mtrr setting code on
> !CONFIG_SMP.

oops. My bad. Linus, Bad commit is not marked for stable.

I was able to reproduce the issue and tested the below patch. It looks
good.

Thanks.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> 
> Anders, if your kernel didn't have SMP turned on, can you please
> verify the following patch fixes the problem?
> 
> Thanks.
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index 08119a3..6b96110 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -149,7 +149,6 @@ struct set_mtrr_data {
>   */
>  static int mtrr_rendezvous_handler(void *info)
>  {
> -#ifdef CONFIG_SMP
>  	struct set_mtrr_data *data = info;
>  
>  	/*
> @@ -171,7 +170,6 @@ static int mtrr_rendezvous_handler(void *info)
>  	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
>  		mtrr_if->set_all();
>  	}
> -#endif
>  	return 0;
>  }
>  


