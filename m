Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1BATzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:55:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1BATzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:55:46 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296586771.26581.298.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
	 <1296575996.5081.20.camel@mothafucka.localdomain>
	 <1296577168.26581.240.camel@laptop>
	 <1296577358.5081.23.camel@mothafucka.localdomain>
	 <1296586771.26581.298.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 17:55:29 -0200
Message-ID: <1296590129.5081.130.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 19:59 +0100, Peter Zijlstra wrote:
> On Tue, 2011-02-01 at 14:22 -0200, Glauber Costa wrote:
> > 
> > 
> > Which tick accounting? In your other e-mail , you pointed that this only
> > runs in touch_steal_time, which is fine, will change.
> 
> That tick ;-), all the account_foo muck is per tick.
> 
> >  But all the rest
> > here, that is behind the hypervisor specific vs generic code has nothing
> > to do with ticks at all.
> 
> But I don't get it, there is no generic code needed, all that's needed
> is u64 steal_time_clock(int cpu), and the first part of your
> kvm_account_steal_time() function is exactly that if you add the cpu
> argument.
> 
> +static u64 steal_time_clock(int cpu)
> +{
> +       u64 steal_time;
> +       struct kvm_steal_time *src;
> +       int version;
> +
> +	preempt_disable();
> +       src = &per_cpu_ptr(steal_time, cpu);
> +       do {
> +               version = src->version;
> +               rmb();
> +               steal_time = src->steal;
> +               rmb();
> +       } while ((src->version & 1) || (version != src->version));
> +       preempt_enable();
> +
> +       return steal_time
> +}
> 
> And you're done.. no need to for any of that steal_time_{read,write} business.

update_rq_clock_task still have to keep track of what was the last steal
time value we saw, in the same way it does for irq. One option is to
call update_rq_clock_task from inside kvm-code, but I don't really like
it very much.

But okay, there are many ways to work around it, I'll cook something.

