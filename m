Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0ICVo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:44:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:35270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab0ICVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,315,1280732400"; 
   d="scan'208";a="834721060"
Date: Fri, 3 Sep 2010 14:34:56 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] therm_throt.c: Fix error handling in
	thermal_throttle_add_dev
Message-ID: <20100903213456.GA22124@fenghua-desk.sc.intel.com>
References: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com> <20100903093553.GA6821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903093553.GA6821@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 02:35:53AM -0700, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > 
> > Warn when sysfs_add_file_to_group fails.
> > 
> > Also add missing curly braces.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |   14 ++++++++++----
> >  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> > +               WARN_ON(err);
> 
> Hm, we tend to use WARN_ON_ONCE(), to avoid repeat spamming of the 
> syslog. Also, and perhaps more importantly, WARN_ON() is not a 
> particularly smart way to handle errors. How do other drivers handle 
> sysfs registration failures?

drivers/pci/pcie/aspm.c doesn't collect error from sysfs_add_file_to_group. This
driver is similar to our case because neither of sysfs_add_file_to_group error
is fatal and we can ignore the error and continue to add other files.

Other drivers exit function when sysfs_add_file_to_group fails. This assumes
there is dependency among each devices and an earlier failure prevents from
later sysfs_add_file_to_group. This is different from our case.

> 
> Also, that's not the only thing the patch does:
> 
> > @@ -211,20 +211,26 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
> 
> > -	return err;
> > +	return 0;
> 
> How is the ignoring of an error and turning it into a WARN_ON() a fix? 
> Either it makes no sense to return errors - in which case the whole 
> add_dev method needs to be fixed in all drivers - or it makes sense, in 
> which case the behavior here is inconsistent.
> 
> At minimum more explanation is needed in the changelog.

"return err" always returns the err value from the last sysfs_add_file_to_group
I.e. one earlier err value is not reflected by thermal_throttle_add_dev(). If
you think the original code is ok, I can keep the original error handling code
and just have the missing curly braces fix.

To log an error, the patch just warns on each error but returns 0 because
neither of the error is fatal. If you think this option is ok, I can change
WAR_ON to WARN_ON_ONCE.

Or other options could be:

1. Just calling sysfs_add_file_to_group() without collecting returned error and
return 0 at the end (driver/pci/pcie/aspm.c does like this). The drawback is
there is no error logged if an unlikely errorr occurs. But user can see some
files are missing in sysfs.
2. Or collect errors in err1, err2, etc for each sysfs_add_file_to_group. At
the end, return -ENODEV(??) if any err1, err2, etc is not 0. This option makes
code unreasonable complex to handle unlikely errors.

What do you think?

Thanks.

-Fenghua
