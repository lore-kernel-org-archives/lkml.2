Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2K0TCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:02:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:43023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2K0TCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,328,1352102400"; 
   d="scan'208";a="253614691"
Date: Tue, 27 Nov 2012 11:01:32 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121127110132.20ea1338@chromoly>
In-Reply-To: <1353972445.2493.19.camel@joe-AO722>
References: <1353940633-20084-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1353940633-20084-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<1353972445.2493.19.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012 15:27:25 -0800
Joe Perches <joe@perches.com> wrote:

> On Mon, 2012-11-26 at 06:37 -0800, Jacob Pan wrote:
> > Intel PowerClamp driver performs synchronized idle injection across
> > all online CPUs. The goal is to maintain a given package level
> > C-state ratio.
> 
> trivial notes:
> 
> > diff --git a/drivers/thermal/intel_powerclamp.c
> > b/drivers/thermal/intel_powerclamp.c
> 
> You should still add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any include so that all messages are prefixed with powerclamp:
> 
I missed that. will fix in v4. thanks.
> > +
> > +/* #define DEBUG */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> []
> > +static void adjust_compensation(int target_ratio, unsigned int win)
> > +{
> > +	int delta;
> 
> It'd be shorter code to use a temporary like
> 
> 	struct powerclamp_calibration_data *d =
> &cal_data[target_ratio];
> 
> > +
> > +	/*
> > +	 * adjust compensations if confidence level has not been
> > reached or
> > +	 * there are too many wakeups during the last idle
> > injection period, we
> > +	 * cannot trust the data for compensation.
> > +	 */
> > +	if (cal_data[target_ratio].confidence >= CONFIDENCE_OK ||
> > +		atomic_read(&idle_wakeup_counter) >
> > +		win * num_online_cpus())
> > +		return;
> > +
> > +	delta = set_target_ratio - current_ratio;
> > +	/* filter out bad data */
> > +	if (delta >= 0 && delta <= (1+target_ratio/10)) {
> > +		if (cal_data[target_ratio].steady_comp)
> > +			cal_data[target_ratio].steady_comp =
> > +				roundup(delta+
> > +
> > cal_data[target_ratio].steady_comp,
> > +					2)/2;
> 
> so that this fits on a single line and becomes:
> 
> 		if (d->steady_comp)
> 			d->steady_comp = roundup(delta +
> d->steady_comp, 2) / 2; 
> 	etc.
> 
looks much better, will fix.
> What clamps target_ratio to the correct range?
> I briefly scanned the code but didn't spot it.
> 
target_ratio is a local variable for set_target_ratio, I did this to
avoid locking in case user wants to change it during computation.
set_target_ratio is clamped by:
        if (set_target_ratio > MAX_TARGET_RATIO)
                set_target_ratio = MAX_TARGET_RATIO;

I guess i could use clamp() macro.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

[Jacob Pan]

-- 
Thanks,

Jacob
