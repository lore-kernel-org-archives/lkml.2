Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab1FWBbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:31:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43968 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab1FWBbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:31:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02975A.3000800@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 10:31:06 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: rientjes@google.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, hotplug: fix error handling in mem_online_node()
References: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106221810130.23120@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/23 10:13), David Rientjes wrote:
> The error handling in mem_online_node() is incorrect: hotadd_new_pgdat() 
> returns NULL if the new pgdat could not have been allocated and a pointer 
> to it otherwise.
> 
> mem_online_node() should fail if hotadd_new_pgdat() fails, not the 
> inverse.  This fixes an issue when memoryless nodes are not onlined and 
> their sysfs interface is not registered when their first cpu is brought 
> up.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Nice catch.

The fault was introduced by commit cf23422b9d76(cpu/mem hotplug: enable CPUs
online before local memory online) iow v2.6.35.

 Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/memory_hotplug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -521,7 +521,7 @@ int mem_online_node(int nid)
>  
>  	lock_memory_hotplug();
>  	pgdat = hotadd_new_pgdat(nid, 0);
> -	if (pgdat) {
> +	if (!pgdat) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 


