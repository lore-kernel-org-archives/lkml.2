Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0IEMdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 08:33:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43345 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0IEMdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 08:33:11 -0400
Date: Sun, 5 Sep 2010 14:32:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20100905123229.GA8254@elte.hu>
References: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com>
 <20100903093553.GA6821@elte.hu>
 <20100903213456.GA22124@fenghua-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903213456.GA22124@fenghua-desk.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> Or other options could be:
> 
> 1. Just calling sysfs_add_file_to_group() without collecting returned error and
> return 0 at the end (driver/pci/pcie/aspm.c does like this). The drawback is
> there is no error logged if an unlikely errorr occurs. But user can see some
> files are missing in sysfs.
>
> 2. Or collect errors in err1, err2, etc for each sysfs_add_file_to_group. At
> the end, return -ENODEV(??) if any err1, err2, etc is not 0. This option makes
> code unreasonable complex to handle unlikely errors.

Well, the usual way to handle errors is to abort the operation when it 
occurs, and return the error code that sysfs_add_file_to_group() gave.

The error is not 'fatal' but missing sysfs files sure are confusing, and 
might break user-land which depends on them. So we should either 
initialize a driver fully - or not intialize it at all.

Now, a sub-case is the question whether to emit something more than the 
return code from sysfs_add_file_to_group(). If it's exceedingly rare 
(and subsequently poorly tested) then adding a WARN_ON_ONCE(ret) is OK - 
but that error code should be returned.

Am i missing any detail?

Thanks,

	Ingo
