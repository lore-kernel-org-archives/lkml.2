Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab0CaGY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:24:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757669Ab0CaGY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:24:27 -0400
Date: Tue, 30 Mar 2010 23:22:21 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@amd64.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-Id: <20100330232221.826fe933.akpm@linux-foundation.org>
In-Reply-To: <20100331061343.GA28659@aftab>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
	<1269610800-23847-3-git-send-email-bp@amd64.org>
	<20100330154229.dc8ebd24.akpm@linux-foundation.org>
	<20100331061343.GA28659@aftab>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 08:13:43 +0200 Borislav Petkov <bp@amd64.org> wrote:

> > > +static void _cpb_toggle_msrs(bool t)
> > > +{
> > > +	int cpu;
> > > +
> > > +	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > > +
> > > +	for_each_cpu(cpu, cpu_online_mask) {
> > > +		struct msr *reg = per_cpu_ptr(msrs, cpu);
> > > +		if (t)
> > > +			reg->l &= ~BIT(25);
> > > +		else
> > > +			reg->l |= BIT(25);
> > > +	}
> > > +	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > > +}
> > 
> > What prevents cpu_online_mask from changing while this is happening?
> 
> Frankly, nothing.

Sneak a get_online_cpus()/put_online_cpus() in there?

> And yes, we talked a lot about this internally, since,
> you need this bit cleared on _all_ cores for the processor to boost.
> Now, if you've offlined some of the cores, you won't be able to execute
> any code on them and thus clear this bit.
> 
> However, this interface is there only for benchmarking purposes and
> stuff, i.e. normally, you shouldn't need to touch it _at_ _all_ and
> boosting will work out of the box and without user interaction.
> 
> So, IMHO, hotplug notifiers won't work since you need all cores online
> at that particular moment to enable boosting. It sounds more reasonable
> to me to WARN when a core is missing from the mask that boosting cannot
> be enabled. I'll cook up something later today.
