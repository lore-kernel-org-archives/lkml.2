Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab1CCVn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:43:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58913 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab1CCVnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:43:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pukfXpvm6WpdPNNoqvJCSb2mLnw8eOcife8td21vTAyXmYNcWZihtnbe78NgeoHcP9
         rmpGN4u+V6XAzA8oLZoqaEAns4HPcbxKpItLe1z3Ydu4aYZsbNXYGxw5bqRWHInnX11U
         6sRACcHNVj9E1p6qlI5Uw2jFilqSHml2Y6HwY=
Message-ID: <4D700B93.2080807@gmail.com>
Date: Fri, 04 Mar 2011 00:43:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        yinghai@kernel.org, brgerst@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 12:15 AM, David Rientjes wrote:
> This patch cleans initmem_init() so that it is more readable and doesn't
> use an unnecessary array of function pointers to convolute the flow of
> the code.  It also makes it obvious that dummy_numa_init() will always
> succeed (and documents that requirement) so that the existing BUG() is
> never actually reached.
> 
> No functional change.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/mm/numa_64.c |   92 ++++++++++++++++++++++++++++---------------------
>  1 files changed, 53 insertions(+), 39 deletions(-)
> 
...
> +void __init initmem_init(void)
> +{
> +	int ret;
>  
> -			if (nid == NUMA_NO_NODE)
> -				continue;
> -			if (!node_online(nid))
> -				numa_clear_node(j);
> -		}
> -		numa_init_array();
> -		return;
> +	if (!numa_off) {
> +#ifdef CONFIG_ACPI_NUMA
> +		ret = numa_init(x86_acpi_numa_init);
> +		if (!ret)
> +			return;
> +#endif
> +#ifdef CONFIG_AMD_NUMA
> +		ret = numa_init(amd_numa_init);
> +		if (!ret)
> +			return;
> +#endif
>  	}
> -	BUG();
> +
> +	numa_init(dummy_numa_init);
>  }
>  
>  unsigned long __init numa_free_all_bootmem(void)

Divid, I suspect it's due to diff format and we still need "ret" here, right?

-- 
    Cyrill
