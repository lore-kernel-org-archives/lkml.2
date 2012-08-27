Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2H0Ogg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:36:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:59877 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2H0Oge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:36:34 -0400
Date: Mon, 27 Aug 2012 16:36:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
Message-ID: <20120827143619.GE27979@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827112503.10313.62594.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:55:03PM +0530, Naveen N. Rao wrote:
> Many MCE boot flags are boolean in nature, but are declared as integers
> currently. We can pack these into a bitfield to save some space.
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Ok,

looks good.

A couple of issues though:

You need to prepare your patches against tip/master (which contains
tip/x86/mce) because there are MCE changes in tip and they conflict with
your changes.

> ---
>  arch/x86/include/asm/mce.h             |   11 +++-
>  arch/x86/kernel/cpu/mcheck/mce.c       |   86 +++++++++++++++++++++-----------
>  arch/x86/kernel/cpu/mcheck/mce_intel.c |    2 -
>  3 files changed, 66 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index a3ac52b..78caeb2 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -129,6 +129,15 @@ struct mce_log {
>  
>  #ifdef __KERNEL__
>  
> +struct mce_boot_flags {
> +	__u32	cmci_disabled		: 1,
> +		ignore_ce		: 1,
> +		dont_log_ce		: 1,
> +		__pad			: 29;
> +};

This looks ok but I think it would be even better if it went into
mce-internal.h where all the mce-only stuff can be collected in a
private struct so that we don't pollute the global MCE namespace.

Then you can call the struct simply

struct boot_flags

since it is private to mce code.

> +
> +extern struct mce_boot_flags mce_boot_flags;

Why do we need that extern thing?

> +
>  extern void mce_register_decode_chain(struct notifier_block *nb);
>  extern void mce_unregister_decode_chain(struct notifier_block *nb);
>  
> @@ -169,8 +178,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
>  #define MAX_NR_BANKS 32
>  
>  #ifdef CONFIG_X86_MCE_INTEL
> -extern int mce_cmci_disabled;
> -extern int mce_ignore_ce;
>  void mce_intel_feature_init(struct cpuinfo_x86 *c);
>  void cmci_clear(void);
>  void cmci_reenable(void);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 292d025..5a0d399 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -79,11 +79,10 @@ static int			rip_msr			__read_mostly;
>  static int			mce_bootlog		__read_mostly = -1;
>  static int			monarch_timeout		__read_mostly = -1;
>  static int			mce_panic_timeout	__read_mostly;
> -static int			mce_dont_log_ce		__read_mostly;
> -int				mce_cmci_disabled	__read_mostly;
> -int				mce_ignore_ce		__read_mostly;
>  int				mce_ser			__read_mostly;
>  
> +struct mce_boot_flags		mce_boot_flags		__read_mostly;
> +
>  struct mce_bank                *mce_banks		__read_mostly;
>  
>  /* User mode helper program triggered by machine check event */
> @@ -630,7 +629,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  		 * Don't get the IP here because it's unlikely to
>  		 * have anything to do with the actual error location.
>  		 */
> -		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
> +		if (!(flags & MCP_DONTLOG) && !mce_boot_flags.dont_log_ce)
>  			mce_log(&m);
>  
>  		/*
> @@ -1601,7 +1600,7 @@ static void __mcheck_cpu_init_timer(void)
>  
>  	setup_timer(t, mce_timer_fn, smp_processor_id());
>  
> -	if (mce_ignore_ce)
> +	if (mce_boot_flags.ignore_ce)
>  		return;
>  
>  	__this_cpu_write(mce_next_interval, iv);
> @@ -1919,11 +1918,11 @@ static int __init mcheck_enable(char *str)
>  	if (!strcmp(str, "off"))
>  		mce_disabled = 1;
>  	else if (!strcmp(str, "no_cmci"))
> -		mce_cmci_disabled = 1;
> +		mce_boot_flags.cmci_disabled = 1;
>  	else if (!strcmp(str, "dont_log_ce"))
> -		mce_dont_log_ce = 1;
> +		mce_boot_flags.dont_log_ce = 1;
>  	else if (!strcmp(str, "ignore_ce"))
> -		mce_ignore_ce = 1;
> +		mce_boot_flags.ignore_ce = 1;
>  	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
>  		mce_bootlog = (str[0] == 'b');
>  	else if (isdigit(str[0])) {
> @@ -2076,7 +2075,7 @@ show_trigger(struct device *s, struct device_attribute *attr, char *buf)
>  }
>  
>  static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
> -				const char *buf, size_t siz)
> +			   const char *buf, size_t size)
>  {
>  	char *p;
>  

This is an unrelated change, pls drop it.

> @@ -2090,6 +2089,34 @@ static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
>  	return strlen(mce_helper) + !!p;
>  }
>  
> +static ssize_t get_dont_log_ce(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mce_boot_flags.dont_log_ce);
> +}
> +
> +static ssize_t set_dont_log_ce(struct device *s,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t size)
> +{
> +	u64 new;
> +
> +	if (strict_strtoull(buf, 0, &new) < 0)
> +		return -EINVAL;
> +
> +	mce_boot_flags.dont_log_ce = !!new;
> +
> +	return size;
> +}
> +
> +static ssize_t get_ignore_ce(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mce_boot_flags.ignore_ce);
> +}
> +

Those could be combined into a function similar to device_show/store_int
pairs but working on a bitfield.

Maybe later.

>  static ssize_t set_ignore_ce(struct device *s,
>  			     struct device_attribute *attr,
>  			     const char *buf, size_t size)
> @@ -2099,21 +2126,28 @@ static ssize_t set_ignore_ce(struct device *s,
>  	if (strict_strtoull(buf, 0, &new) < 0)
>  		return -EINVAL;
>  
> -	if (mce_ignore_ce ^ !!new) {
> +	if (mce_boot_flags.ignore_ce ^ !!new) {
>  		if (new) {
>  			/* disable ce features */
>  			mce_timer_delete_all();
>  			on_each_cpu(mce_disable_cmci, NULL, 1);
> -			mce_ignore_ce = 1;
> +			mce_boot_flags.ignore_ce = 1;
>  		} else {
>  			/* enable ce features */
> -			mce_ignore_ce = 0;
> +			mce_boot_flags.ignore_ce = 0;
>  			on_each_cpu(mce_enable_ce, (void *)1, 1);
>  		}
>  	}
>  	return size;
>  }
>  
> +static ssize_t get_cmci_disabled(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", mce_boot_flags.cmci_disabled);
> +}
> +
>  static ssize_t set_cmci_disabled(struct device *s,
>  				 struct device_attribute *attr,
>  				 const char *buf, size_t size)
> @@ -2123,14 +2157,14 @@ static ssize_t set_cmci_disabled(struct device *s,
>  	if (strict_strtoull(buf, 0, &new) < 0)
>  		return -EINVAL;
>  
> -	if (mce_cmci_disabled ^ !!new) {
> +	if (mce_boot_flags.cmci_disabled ^ !!new) {
>  		if (new) {
>  			/* disable cmci */
>  			on_each_cpu(mce_disable_cmci, NULL, 1);
> -			mce_cmci_disabled = 1;
> +			mce_boot_flags.cmci_disabled = 1;
>  		} else {
>  			/* enable cmci */
> -			mce_cmci_disabled = 0;
> +			mce_boot_flags.cmci_disabled = 0;
>  			on_each_cpu(mce_enable_ce, NULL, 1);
>  		}
>  	}
> @@ -2149,31 +2183,23 @@ static ssize_t store_int_with_restart(struct device *s,
>  static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
>  static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
>  static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
> -static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
> +static DEVICE_ATTR(dont_log_ce, 0644, get_dont_log_ce, set_dont_log_ce);
> +static DEVICE_ATTR(ignore_ce, 0644, get_ignore_ce, set_ignore_ce);
> +static DEVICE_ATTR(cmci_disabled, 0644, get_cmci_disabled, set_cmci_disabled);
>  
>  static struct dev_ext_attribute dev_attr_check_interval = {
>  	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
>  	&check_interval
>  };
>  
> -static struct dev_ext_attribute dev_attr_ignore_ce = {
> -	__ATTR(ignore_ce, 0644, device_show_int, set_ignore_ce),
> -	&mce_ignore_ce
> -};
> -
> -static struct dev_ext_attribute dev_attr_cmci_disabled = {
> -	__ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
> -	&mce_cmci_disabled
> -};
> -
>  static struct device_attribute *mce_device_attrs[] = {
>  	&dev_attr_tolerant.attr,
>  	&dev_attr_check_interval.attr,
>  	&dev_attr_trigger,
>  	&dev_attr_monarch_timeout.attr,
> -	&dev_attr_dont_log_ce.attr,
> -	&dev_attr_ignore_ce.attr,
> -	&dev_attr_cmci_disabled.attr,
> +	&dev_attr_dont_log_ce,
> +	&dev_attr_ignore_ce,
> +	&dev_attr_cmci_disabled,
>  	NULL
>  };
>  
> @@ -2314,7 +2340,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> -		if (!mce_ignore_ce && check_interval) {
> +		if (!mce_boot_flags.ignore_ce && check_interval) {
>  			t->expires = round_jiffies(jiffies +
>  					per_cpu(mce_next_interval, cpu));
>  			add_timer_on(t, cpu);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 38e49bc..aaf5c51 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -36,7 +36,7 @@ static int cmci_supported(int *banks)
>  {
>  	u64 cap;
>  
> -	if (mce_cmci_disabled || mce_ignore_ce)
> +	if (mce_boot_flags.cmci_disabled || mce_boot_flags.ignore_ce)
>  		return 0;

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
