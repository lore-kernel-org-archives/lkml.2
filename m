Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0CaGNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:13:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41333 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab0CaGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:13:07 -0400
Date: Wed, 31 Mar 2010 08:13:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-ID: <20100331061343.GA28659@aftab>
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
 <1269610800-23847-3-git-send-email-bp@amd64.org>
 <20100330154229.dc8ebd24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330154229.dc8ebd24.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, Mar 30, 2010 at 03:42:29PM -0700

Hi Andrew,

> On Fri, 26 Mar 2010 14:39:56 +0100
> Borislav Petkov <bp@amd64.org> wrote:
> 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Starting with F10h, revE, AMD processors add support for a dynamic
> > core boosting feature called Core Performance Boost. When a specific
> > condition is present, a subset of the cores on a system are boosted
> > beyond their P0 operating frequency to speed up the performance of
> > single-threaded applications.
> > 
> > In the normal case, the system comes out of reset with core boosting
> > enabled. This patch adds a sysfs knob with which core boosting can be
> > switched on or off for benchmarking purposes.
> > 
> > While at it, cleanup the driver init codepath and update copyrights.
> > 
> > ...
> >
> > +static void _cpb_toggle_msrs(bool t)
> > +{
> > +	int cpu;
> > +
> > +	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > +
> > +	for_each_cpu(cpu, cpu_online_mask) {
> > +		struct msr *reg = per_cpu_ptr(msrs, cpu);
> > +		if (t)
> > +			reg->l &= ~BIT(25);
> > +		else
> > +			reg->l |= BIT(25);
> > +	}
> > +	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
> > +}
> 
> What prevents cpu_online_mask from changing while this is happening?

Frankly, nothing. And yes, we talked a lot about this internally, since,
you need this bit cleared on _all_ cores for the processor to boost.
Now, if you've offlined some of the cores, you won't be able to execute
any code on them and thus clear this bit.

However, this interface is there only for benchmarking purposes and
stuff, i.e. normally, you shouldn't need to touch it _at_ _all_ and
boosting will work out of the box and without user interaction.

So, IMHO, hotplug notifiers won't work since you need all cores online
at that particular moment to enable boosting. It sounds more reasonable
to me to WARN when a core is missing from the mask that boosting cannot
be enabled. I'll cook up something later today.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
