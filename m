Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1FJIJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:09:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54816 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1FJIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:09:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF1D136.4050903@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 17:09:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 09/10] MCE: run through processors with more severe problems
 first
References: <4df13d2627304cd979@agluck-desktop.sc.intel.com>
In-Reply-To: <4df13d2627304cd979@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 6:37), Luck, Tony wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Instead of letting cpus run through the MC bank scanning code
> in the order that they turned up in the handler, we arrange to
> deal with those that have more severe problems (mcgstatus.ripv=0)
> first. This will make life simpler in the case that banks are
> shared between processors, since the cpu with the problem will
> see it and clear it, leaving the other cpu(s) that share the
> bank with nothing to do.

Well, I agree about the point that reordering is required to handle
shared banks. 

I think it is better to put this change in early of the series. 

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
(snip)
> +/*
> + * next cpu choosing first from cant_return, and then from can_return
> + */
> +int mce_nextcpu(int this)
> +{
> +	int next;
> +
> +	if (this == -1 || cpumask_test_cpu(this, &cant_return)) {
> +		next = cpumask_next(this, &cant_return);
> +		if (next >= nr_cpu_ids)
> +			next = cpumask_next(-1, &can_return);
> +		return next;
> +	}
> +
> +	return cpumask_next(this, &can_return);
> +}

I don't like to have multiple cpumasks here, notably one is just an
inversion of another... 

How about using severity-leveling?
Pick cpus with PANIC level first, then AR, AO ...

Or how about checking rip in each mces_seen?


Thanks,
H.Seto

