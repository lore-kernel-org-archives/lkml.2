Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2IGSkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:40:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33435 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab2IGSkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:40:52 -0400
Message-ID: <504A3FA9.1050502@zytor.com>
Date: Fri, 07 Sep 2012 11:40:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
References: <1347039854.6288.8.camel@thor>
In-Reply-To: <1347039854.6288.8.camel@thor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 10:44 AM, Peter Hurley wrote:
\>
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index bdda2e6..ee399c3 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -714,6 +714,16 @@ int __init mtrr_cleanup(unsigned address_bits)
>   	if (mtrr_tom2)
>   		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
>
> +	/* Constrain a WB entry that maps entire phys addr space to max mem */
> +	for (i = 0; i < num_var_ranges; i++) {
> +		if (range_state[i].type == MTRR_TYPE_WRBACK &&
> +		    range_state[i].base_pfn == 0 &&
> +		    range_state[i].size_pfn > max_pfn) {
> +			range_state[i].size_pfn = roundup_pow_of_two(max_pfn);
> +			break;
> +		}
> +	}
> +

I really don't like it as it introduces yet another user of max_pfn, 
which should be going away.  Furthermore, the better question is what 
remaining needs there are for MTRR cleanup; historically the reason was 
that it prevented the display from being mapped WC via MTRR due to the 
MTRR conflict resolution rules favoring UC.

However, the right way to fix that is to use the PAT interfaces, which 
doesn't have this drawback -- then MTRR cleanup becomes entirely 
superfluous and the problem goes away.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

