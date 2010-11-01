Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0KAACn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 20:02:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58535 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0KAACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 20:02:40 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCE03FA.5030504@np.css.fujitsu.com>
Date: Mon, 01 Nov 2010 09:04:10 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H.Peter Anvin" <hpa@zytor.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] [x86, next] Add mce_ser interface in /sys/kernel/debug/mce/
 for test
References: <4CCA50A1.8050609@np.css.fujitsu.com> <20101029080650.GA11149@basil.fritz.box>
In-Reply-To: <20101029080650.GA11149@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/29 17:06), Andi Kleen wrote:
> On Fri, Oct 29, 2010 at 01:42:09PM +0900, Jin Dongming wrote:
>> If we want to test the part of mce handler for SRAO and SRAR,  we need to
>> have a test machine whose CPU supports MCG_SER_P. If we don't have such
>> machine, we can not test the part of mce handler for SRAO and SRAR.
>>
>> With this interface we can test the part of mce handler for SRAO and SRAR
>> by setting mce_ser 1 on the machine which does not support MCG_SER_P.
>>
>> Usage:
>>         if val == 1 or val == 0
>>            Set val to mce_ser.
>>         else
>>            Ser the original value to mce_ser.
>>
>> Note:
>>     Please don't use mce_ser interface except mce test.
>>     Because when the real mce exception happened, the unsuitable set
>>     with this interface maybe change the real process of mce handler and
>>     lead to a different result.
> 
> Basic idea is good (I have been using a similar patch for quite some time).
> My patch was a little bit simpler though, not bothering with org_ser:
> 
Yes, it is.

But if you set mce_ser with mca_recovery_set(), 
the original value of mce_ser will be changed, is it right?

If a new guy try to test mce with the test machine, he/she may be
confused by the value of mce_ser. So I think how to tell him
the original value is also important.
> ---
> 
> MCE: Add an debugfs interface to force MCA recovery
> 
> This is useful to run the MCA recovery test cases using
> error injection on a non MCA recovery capable system.
> 
> On a system without MCA recovery this should be a nop.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2346,13 +2346,26 @@ static int fake_panic_set(void *data, u6
>  	fake_panic = val;
>  	return 0;
>  }
> +static int mca_recovery_get(void *data, u64 *val)
> +{
> +	*val = mce_ser;
> +	return 0;
> +}
> +
> +static int mca_recovery_set(void *data, u64 val)
> +{
> +	mce_ser = val;
> +	return 0;
> +}
>  
>  DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
>  			fake_panic_set, "%llu\n");
> +DEFINE_SIMPLE_ATTRIBUTE(mca_recovery_fops, mca_recovery_get,
> +			mca_recovery_set, "%llu\n");
>  
>  static int __init mcheck_debugfs_init(void)
>  {
> -	struct dentry *dmce, *ffake_panic;
> +	struct dentry *dmce, *ffake_panic, *fmca_recovery;
>  
>  	dmce = mce_get_debugfs_dir();
>  	if (!dmce)
> @@ -2361,7 +2374,10 @@ static int __init mcheck_debugfs_init(vo
>  					  &fake_panic_fops);
>  	if (!ffake_panic)
>  		return -ENOMEM;
> -
> +	fmca_recovery = debugfs_create_file("mca_recovery_force",0644,dmce,NULL,
> +					&mca_recovery_fops);
> +	if (!fmca_recovery)
> +		return -ENOMEM;
>  	return 0;
>  }
>  late_initcall(mcheck_debugfs_init);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


