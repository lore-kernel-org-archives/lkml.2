Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2H0RQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:16:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60721 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2H0RQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:16:23 -0400
Message-ID: <503BAB00.1080708@linux.vnet.ibm.com>
Date: Mon, 27 Aug 2012 22:44:40 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
References: <20120827112503.10313.62594.stgit@localhost.localdomain> <20120827143619.GE27979@aftab.osrc.amd.com> <503B93D2.7090702@linux.vnet.ibm.com> <20120827154741.GI27979@aftab.osrc.amd.com> <503B99C7.3000503@linux.vnet.ibm.com> <20120827163408.GK27979@aftab.osrc.amd.com>
In-Reply-To: <20120827163408.GK27979@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082717-0260-0000-0000-000001C0EC59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 10:04 PM, Borislav Petkov wrote:
> On Mon, Aug 27, 2012 at 09:31:11PM +0530, Naveen N. Rao wrote:
>> On 08/27/2012 09:17 PM, Borislav Petkov wrote:
>>> On Mon, Aug 27, 2012 at 09:05:46PM +0530, Naveen N. Rao wrote:
>>>>>> +
>>>>>> +extern struct mce_boot_flags mce_boot_flags;
>>>>>
>>>>> Why do we need that extern thing?
>>>>
>>>> So that this is visible across mce.c and mce_intel.c?
>>>
>>> Ok. But if you move the struct to mce-internal.h and since both .c files
>>> include it, we shouldn't need that extern, right?
>>
>> I'm not sure I understand. I think we still need it. This is not
>> about the structure, but the variable itself. extern allows
>> mce_boot_flags _variable_ accessible from mce_intel.c.
>
> Ok, you're right. I actually was thinking of having athe extern at the
> place it is used, i.e. mce_intel.c but looking at mce-internal, it has a
> bunch of other externs so let keep it that way.
>
> But, I went and did change your patch a bit because I think
> mce_boot_flags is not such a fitting name if we want to move more of
> those items at the beginning of mce.c to it. Basically, I'd like to put
> all those MCE vendor-specific config settings into one struct which
> encapsulates them all together in a clean way instead of having a bunch
> of single variables all over the place.
>
> IOW, how about the following?

Looks good. Infact, I had actually added mce_ser and mce_disabled into 
the bitfield, but backed off not wanting to overdo.

We could pull in all the other configuration parameters into this 
structure as long as everyone is ok with this.

>
> --
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index a3ac52b29cbf..e5cfd241e508 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -126,7 +126,6 @@ struct mce_log {
>   #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
>   #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
>
> -
>   #ifdef __KERNEL__
>
>   extern void mce_register_decode_chain(struct notifier_block *nb);
> @@ -169,8 +168,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
>   #define MAX_NR_BANKS 32
>
>   #ifdef CONFIG_X86_MCE_INTEL
> -extern int mce_cmci_disabled;
> -extern int mce_ignore_ce;
>   void mce_intel_feature_init(struct cpuinfo_x86 *c);
>   void cmci_clear(void);
>   void cmci_reenable(void);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> index 6a05c1d327a9..3b25bcf452d9 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> @@ -28,6 +28,15 @@ extern int mce_ser;
>
>   extern struct mce_bank *mce_banks;
>
> +struct mce_cfg {
> +	__u32	cmci_disabled		: 1,
> +		ignore_ce		: 1,
> +		dont_log_ce		: 1,
> +		__pad			: 29;
> +};
> +
> +extern struct mce_cfg cfg;
> +

I'd prefer mce_cfg, rather than just cfg. I think it looks clearer to 
say, for instance, mce_ser.ignore_ce rather than just cfg.ignore_ce 
where the latter looks more like a global thing. But, of course, the 
former is more concise...

Thanks,
Naveen

>   #ifdef CONFIG_X86_MCE_INTEL
>   unsigned long mce_intel_adjust_timer(unsigned long interval);
>   void mce_intel_cmci_poll(void);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index c311122ea838..db3c5eaa16da 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -79,11 +79,10 @@ static int			rip_msr			__read_mostly;
>   static int			mce_bootlog		__read_mostly = -1;
>   static int			monarch_timeout		__read_mostly = -1;
>   static int			mce_panic_timeout	__read_mostly;
> -static int			mce_dont_log_ce		__read_mostly;
> -int				mce_cmci_disabled	__read_mostly;
> -int				mce_ignore_ce		__read_mostly;
>   int				mce_ser			__read_mostly;
>
> +struct mce_cfg			cfg			__read_mostly;
> +
>   struct mce_bank                *mce_banks		__read_mostly;
>
>   /* User mode helper program triggered by machine check event */
> @@ -630,7 +629,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>   		 * Don't get the IP here because it's unlikely to
>   		 * have anything to do with the actual error location.
>   		 */
> -		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
> +		if (!(flags & MCP_DONTLOG) && !cfg.dont_log_ce)
>   			mce_log(&m);
>
>   		/*
> @@ -1634,7 +1633,7 @@ static void mce_start_timer(unsigned int cpu, struct timer_list *t)
>
>   	__this_cpu_write(mce_next_interval, iv);
>
> -	if (mce_ignore_ce || !iv)
> +	if (cfg.ignore_ce || !iv)
>   		return;
>
>   	t->expires = round_jiffies(jiffies + iv);
> @@ -1958,11 +1957,11 @@ static int __init mcheck_enable(char *str)
>   	if (!strcmp(str, "off"))
>   		mce_disabled = 1;
>   	else if (!strcmp(str, "no_cmci"))
> -		mce_cmci_disabled = 1;
> +		cfg.cmci_disabled = 1;
>   	else if (!strcmp(str, "dont_log_ce"))
> -		mce_dont_log_ce = 1;
> +		cfg.dont_log_ce = 1;
>   	else if (!strcmp(str, "ignore_ce"))
> -		mce_ignore_ce = 1;
> +		cfg.ignore_ce = 1;
>   	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
>   		mce_bootlog = (str[0] == 'b');
>   	else if (isdigit(str[0])) {
> @@ -2115,7 +2114,7 @@ show_trigger(struct device *s, struct device_attribute *attr, char *buf)
>   }
>
>   static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
> -				const char *buf, size_t siz)
> +			   const char *buf, size_t size)
>   {
>   	char *p;
>
> @@ -2129,6 +2128,34 @@ static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
>   	return strlen(mce_helper) + !!p;
>   }
>
> +static ssize_t get_dont_log_ce(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg.dont_log_ce);
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
> +	cfg.dont_log_ce = !!new;
> +
> +	return size;
> +}
> +
> +static ssize_t get_ignore_ce(struct device *dev,
> +			     struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg.ignore_ce);
> +}
> +
>   static ssize_t set_ignore_ce(struct device *s,
>   			     struct device_attribute *attr,
>   			     const char *buf, size_t size)
> @@ -2138,21 +2165,28 @@ static ssize_t set_ignore_ce(struct device *s,
>   	if (strict_strtoull(buf, 0, &new) < 0)
>   		return -EINVAL;
>
> -	if (mce_ignore_ce ^ !!new) {
> +	if (cfg.ignore_ce ^ !!new) {
>   		if (new) {
>   			/* disable ce features */
>   			mce_timer_delete_all();
>   			on_each_cpu(mce_disable_cmci, NULL, 1);
> -			mce_ignore_ce = 1;
> +			cfg.ignore_ce = 1;
>   		} else {
>   			/* enable ce features */
> -			mce_ignore_ce = 0;
> +			cfg.ignore_ce = 0;
>   			on_each_cpu(mce_enable_ce, (void *)1, 1);
>   		}
>   	}
>   	return size;
>   }
>
> +static ssize_t get_cmci_disabled(struct device *dev,
> +				 struct device_attribute *attr,
> +				 char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", cfg.cmci_disabled);
> +}
> +
>   static ssize_t set_cmci_disabled(struct device *s,
>   				 struct device_attribute *attr,
>   				 const char *buf, size_t size)
> @@ -2162,14 +2196,14 @@ static ssize_t set_cmci_disabled(struct device *s,
>   	if (strict_strtoull(buf, 0, &new) < 0)
>   		return -EINVAL;
>
> -	if (mce_cmci_disabled ^ !!new) {
> +	if (cfg.cmci_disabled ^ !!new) {
>   		if (new) {
>   			/* disable cmci */
>   			on_each_cpu(mce_disable_cmci, NULL, 1);
> -			mce_cmci_disabled = 1;
> +			cfg.cmci_disabled = 1;
>   		} else {
>   			/* enable cmci */
> -			mce_cmci_disabled = 0;
> +			cfg.cmci_disabled = 0;
>   			on_each_cpu(mce_enable_ce, NULL, 1);
>   		}
>   	}
> @@ -2188,31 +2222,23 @@ static ssize_t store_int_with_restart(struct device *s,
>   static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
>   static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
>   static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
> -static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
> +static DEVICE_ATTR(dont_log_ce, 0644, get_dont_log_ce, set_dont_log_ce);
> +static DEVICE_ATTR(ignore_ce, 0644, get_ignore_ce, set_ignore_ce);
> +static DEVICE_ATTR(cmci_disabled, 0644, get_cmci_disabled, set_cmci_disabled);
>
>   static struct dev_ext_attribute dev_attr_check_interval = {
>   	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
>   	&check_interval
>   };
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
>   static struct device_attribute *mce_device_attrs[] = {
>   	&dev_attr_tolerant.attr,
>   	&dev_attr_check_interval.attr,
>   	&dev_attr_trigger,
>   	&dev_attr_monarch_timeout.attr,
> -	&dev_attr_dont_log_ce.attr,
> -	&dev_attr_ignore_ce.attr,
> -	&dev_attr_cmci_disabled.attr,
> +	&dev_attr_dont_log_ce,
> +	&dev_attr_ignore_ce,
> +	&dev_attr_cmci_disabled,
>   	NULL
>   };
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 098386fed48e..f0cf857ba389 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -53,7 +53,7 @@ static int cmci_supported(int *banks)
>   {
>   	u64 cap;
>
> -	if (mce_cmci_disabled || mce_ignore_ce)
> +	if (cfg.cmci_disabled || cfg.ignore_ce)
>   		return 0;
>
>   	/*
>

