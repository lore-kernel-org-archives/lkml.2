Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248Ab2CFBFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:05:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:37285 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab2CFBFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:05:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115074891"
Subject: Re: [PATCH V3] cpuidle: Add a sysfs entry to disable specific C
 state for debug purpose.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
In-Reply-To: <20120305101827.GA19408@khazad-dum.debian.net>
References: <C6CB66606345BC4B80CBE69D22ABFBB1021C7F@SHSMSX101.ccr.corp.intel.com>
	 <1330647453.1916.7.camel@ymzhang>
	 <20120302142303.648285a7.akpm@linux-foundation.org>
	 <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
	 <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com>
	 <20120305101827.GA19408@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 06 Mar 2012 09:04:14 +0800
Message-ID: <1330995854.1916.39.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 07:18 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 05 Mar 2012, ShuoX Liu wrote:
> > @@ -45,6 +46,7 @@ total 0
> >  /sys/devices/system/cpu/cpu0/cpuidle/state1:
> >  total 0
> >  -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
> > +-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
> >  -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
> >  -r--r--r-- 1 root root 4096 Feb  8 10:42 name
> >  -r--r--r-- 1 root root 4096 Feb  8 10:42 power
> 
> ...
> 
> > diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> > index 3fe41fe..1eae29a 100644
> > --- a/drivers/cpuidle/sysfs.c
> > +++ b/drivers/cpuidle/sysfs.c
> > @@ -222,6 +222,9 @@ struct cpuidle_state_attr {
> >  #define define_one_state_ro(_name, show) \
> >  static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444,
> > show, NULL)
> > 
> > +#define define_one_state_rw(_name, show, store) \
> > +static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644,
> > show, store)
> > +
> >  #define define_show_state_function(_name) \
> >  static ssize_t show_state_##_name(struct cpuidle_state *state, \
> >  			 struct cpuidle_state_usage *state_usage, char *buf) \
> > @@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
> > cpuidle_state *state, \
> >  	return sprintf(buf, "%u\n", state->_name);\
> >  }
> > 
> > +#define define_store_state_function(_name) \
> > +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > +		const char *buf, size_t size) \
> > +{ \
> > +	int value; \
> > +	sscanf(buf, "%d", &value); \
> > +	if (value) \
> > +		state->disable = 1; \
> > +	else \
> > +		state->disable = 0; \
> > +	return size; \
> > +}
> 
> Isn't this missing a check for capabilities?  Disabling cpuidle states is
> not something random Joe (and IMHO that does mean random capability-
> restricted Joe root) should be doing...
Sorry. Could you elaborate it?

Basically, CPU initialization codes (ACPI on x86) checks the capabilities and
creates the C states in kernel. If we find there are such C states under
/sys/devices/system/cpu/cpuXXX/cpuidle/, we assume CPU supports them.
So here we wouldn't check them again.

> 
> Also, maybe it would be best to use one of the lib helpers to parse that
> value, so that it will be less annoying to userspace (trim blanks, complain
> if there is trailing junk after trimming, etc)?
We would use strict_strtol to parse the value in next version.

Thanks for your kind comments!


