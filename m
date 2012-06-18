Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2FRGlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:41:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:8744 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2FRGlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="158862831"
Message-ID: <1340001753.7225.5.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] cpuidle: move field disable from per-driver to per-cpu
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, lenb@kernel.org
Cc: shuox.liu@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Andrew J. Schorr" <aschorr@telemetry-investments.com>,
        linux-pm@lists.linux-foundation.org
Date: Mon, 18 Jun 2012 14:42:33 +0800
In-Reply-To: <4FDB25B6.2040909@linux.vnet.ibm.com>
References: <4FD95200.1090701@intel.com>
	 <4FDB25B6.2040909@linux.vnet.ibm.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 17:38 +0530, Deepthi Dharwar wrote:
> On 06/14/2012 08:22 AM, ShuoX Liu wrote:
> 
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > Andrew J.Schorr raises a question. When he changes the disable setting
> > on a single CPU, it affects all the other CPUs. Basically, currently,
> > the disable field is per-driver instead of per-cpu. All the C states of
> > the same driver are shared by all CPU in the same machine.
> > 
> > Below patch changes field disable to per-cpu, so we could set this
> > separately for each cpu.
> > 
> 
> 
> This would help us have asymmetric C-states on cpus.
> 
> > Reported-by: Andrew J.Schorr <aschorr@telemetry-investments.com>
> > Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
> > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> 
> 
> Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Len,

Would you like to accept the patch into your testing tree?
Both Deepthi Dharwar and Andrew J. Schorr  acked the patch is
useful.

> 
> > ---
> >  drivers/cpuidle/cpuidle.c        |    1 -
> >  drivers/cpuidle/governors/menu.c |    5 +++--
> >  drivers/cpuidle/sysfs.c          |   21 ++++++++++++---------
> >  include/linux/cpuidle.h          |    2 +-
> >  4 files changed, 16 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index d90519c..04e4b76 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -265,7 +265,6 @@ static void poll_idle_init(struct cpuidle_driver *drv)
> >  	state->power_usage = -1;
> >  	state->flags = 0;
> >  	state->enter = poll_idle;
> > -	state->disable = 0;
> >  }
> >  #else
> >  static void poll_idle_init(struct cpuidle_driver *drv) {}
> > diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> > index 0633575..8391d93 100644
> > --- a/drivers/cpuidle/governors/menu.c
> > +++ b/drivers/cpuidle/governors/menu.c
> > @@ -281,7 +281,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> >  	 * unless the timer is happening really really soon.
> >  	 */
> >  	if (data->expected_us > 5 &&
> > -		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
> > +		dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
> >  		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
> > 
> >  	/*
> > @@ -290,8 +290,9 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> >  	 */
> >  	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
> >  		struct cpuidle_state *s = &drv->states[i];
> > +		struct cpuidle_state_usage *su = &dev->states_usage[i];
> > 
> > -		if (s->disable)
> > +		if (su->disable)
> >  			continue;
> >  		if (s->target_residency > data->predicted_us)
> >  			continue;
> > diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> > index 88032b4..5f809e3 100644
> > --- a/drivers/cpuidle/sysfs.c
> > +++ b/drivers/cpuidle/sysfs.c
> > @@ -217,7 +217,8 @@ struct cpuidle_state_attr {
> >  	struct attribute attr;
> >  	ssize_t (*show)(struct cpuidle_state *, \
> >  					struct cpuidle_state_usage *, char *);
> > -	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
> > +	ssize_t (*store)(struct cpuidle_state *, \
> > +			struct cpuidle_state_usage *, const char *, size_t);
> >  };
> > 
> >  #define define_one_state_ro(_name, show) \
> > @@ -233,21 +234,22 @@ static ssize_t show_state_##_name(struct cpuidle_state *state, \
> >  	return sprintf(buf, "%u\n", state->_name);\
> >  }
> > 
> > -#define define_store_state_function(_name) \
> > +#define define_store_state_ull_function(_name) \
> >  static ssize_t store_state_##_name(struct cpuidle_state *state, \
> > +		struct cpuidle_state_usage *state_usage, \
> >  		const char *buf, size_t size) \
> >  { \
> > -	long value; \
> > +	unsigned long long value; \
> >  	int err; \
> >  	if (!capable(CAP_SYS_ADMIN)) \
> >  		return -EPERM; \
> > -	err = kstrtol(buf, 0, &value); \
> > +	err = kstrtoull(buf, 0, &value); \
> >  	if (err) \
> >  		return err; \
> >  	if (value) \
> > -		state->disable = 1; \
> > +		state_usage->_name = 1; \
> >  	else \
> > -		state->disable = 0; \
> > +		state_usage->_name = 0; \
> >  	return size; \
> >  }
> > 
> > @@ -273,8 +275,8 @@ define_show_state_ull_function(usage)
> >  define_show_state_ull_function(time)
> >  define_show_state_str_function(name)
> >  define_show_state_str_function(desc)
> > -define_show_state_function(disable)
> > -define_store_state_function(disable)
> > +define_show_state_ull_function(disable)
> > +define_store_state_ull_function(disable)
> > 
> >  define_one_state_ro(name, show_state_name);
> >  define_one_state_ro(desc, show_state_desc);
> > @@ -318,10 +320,11 @@ static ssize_t cpuidle_state_store(struct kobject *kobj,
> >  {
> >  	int ret = -EIO;
> >  	struct cpuidle_state *state = kobj_to_state(kobj);
> > +	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
> >  	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
> > 
> >  	if (cattr->store)
> > -		ret = cattr->store(state, buf, size);
> > +		ret = cattr->store(state, state_usage, buf, size);
> > 
> >  	return ret;
> >  }
> > diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> > index 6c26a3d..8570012 100644
> > --- a/include/linux/cpuidle.h
> > +++ b/include/linux/cpuidle.h
> > @@ -34,6 +34,7 @@ struct cpuidle_driver;
> >  struct cpuidle_state_usage {
> >  	void		*driver_data;
> > 
> > +	unsigned long long	disable;
> >  	unsigned long long	usage;
> >  	unsigned long long	time; /* in US */
> >  };
> > @@ -46,7 +47,6 @@ struct cpuidle_state {
> >  	unsigned int	exit_latency; /* in US */
> >  	int		power_usage; /* in mW */
> >  	unsigned int	target_residency; /* in US */
> > -	unsigned int    disable;
> > 
> >  	int (*enter)	(struct cpuidle_device *dev,
> >  			struct cpuidle_driver *drv,
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


