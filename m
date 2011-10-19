Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1JSVDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:03:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1JSVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:03:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=YFK+MSFd/aOIgyQrPhA8GJ8rns4Hp4mXoxVGpGhIUowCDPecKoOWXkalszb+im95a
	04ZWiX2mrZsYUepgiL1lw==
Date: Wed, 19 Oct 2011 14:03:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@amd64.org>
cc: EDAC devel <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 8/9] x86, RAS: Add attributes needed for HW injection
In-Reply-To: <1319035866-29570-9-git-send-email-bp@amd64.org>
Message-ID: <alpine.DEB.2.00.1110191402490.5687@chino.kir.corp.google.com>
References: <1319035866-29570-1-git-send-email-bp@amd64.org> <1319035866-29570-9-git-send-email-bp@amd64.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Borislav Petkov wrote:

> diff --git a/arch/x86/kernel/cpu/ras/amd/mce-inject.c b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
> index 1b797bd..8646080 100644
> --- a/arch/x86/kernel/cpu/ras/amd/mce-inject.c
> +++ b/arch/x86/kernel/cpu/ras/amd/mce-inject.c
> @@ -77,6 +77,59 @@ static int toggle_hw_mce_inject(unsigned int cpu, bool enable)
>  }
>  
>  /*
> + * HW or SW injection
> + */
> +static int hw_inj_get(void *data, u64 *val)
> +{
> +	struct mce *m = (struct mce *)data;
> +
> +	*val = !!(m->inject_flags & MCJ_HW_MSR_INJECT);
> +
> +	return 0;
> +}
> +
> +static int hw_inj_set(void *data, u64 val)
> +{
> +	struct mce *m = (struct mce *)data;
> +
> +	switch (val) {
> +	case 0:
> +		m->inject_flags &= (u8)~MCJ_HW_MSR_INJECT;
> +		break;
> +
> +	case 1:
> +		m->inject_flags |= MCJ_HW_MSR_INJECT;
> +		break;
> +
> +	default:
> +		printk(KERN_ERR "%s: Only 0 or 1 allowed!\n", __func__);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(hw_inj_fops, hw_inj_get, hw_inj_set, "%llu\n");
> +
> +/*
> + * On which CPU to inject?
> + */
> +MCE_INJECT_GET(extcpu);
> +
> +static int inj_extcpu_set(void *data, u64 val)
> +{
> +	struct mce *m = (struct mce *)data;
> +
> +	if (val >= num_online_cpus()) {

That wouldn't catch an offline cpuid, you probably want cpu_online(val)?

> +		printk(KERN_ERR "%s: Non-existent CPU: %llu\n", __func__, val);
> +		return -EINVAL;
> +	}
> +	m->extcpu = val;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(extcpu_fops, inj_extcpu_get, inj_extcpu_set, "%llu\n");
> +
> +/*
>   * This denotes into which bank we're injecting and triggers
>   * the injection, at the same time.
>   */
> @@ -116,6 +169,8 @@ struct dfs_node {
>  	{ .name = "misc",	.fops = &misc_fops },
>  	{ .name = "addr",	.fops = &addr_fops },
>  	{ .name = "bank",	.fops = &bank_fops },
> +	{ .name = "hw_inject",	.fops = &hw_inj_fops },
> +	{ .name = "cpu",	.fops = &extcpu_fops },
>  };
>  
>  static int __init init_mce_inject(void)
