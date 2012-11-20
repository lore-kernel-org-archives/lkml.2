Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2KTLRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:17:03 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2KTLRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:17:00 -0500
Message-ID: <50AB669D.3060007@gmail.com>
Date: Tue, 20 Nov 2012 19:16:45 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        benh@kernel.crashing.org, paulus@samba.org,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: Re: [PATCH v3 06/12] memory-hotplug: unregister memory section on
 SPARSEMEM_VMEMMAP
References: <1351763083-7905-1-git-send-email-wency@cn.fujitsu.com> <1351763083-7905-7-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1351763083-7905-7-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 05:44 PM, Wen Congyang wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> Currently __remove_section for SPARSEMEM_VMEMMAP does nothing. But even if
> we use SPARSEMEM_VMEMMAP, we can unregister the memory_section.
>
> So the patch add unregister_memory_section() into __remove_section().

Hi Yasuaki,

I have a question about these sparse vmemmap memory related patches. Hot 
add memory need allocated vmemmap pages, but this time is allocated by 
buddy system. How can gurantee virtual address is continuous to the 
address allocated before? If not continuous, page_to_pfn and pfn_to_page 
can't work correctly.

Regards,
Jaegeuk

>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>   mm/memory_hotplug.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ca07433..66a79a7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -286,11 +286,14 @@ static int __meminit __add_section(int nid, struct zone *zone,
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
>   static int __remove_section(struct zone *zone, struct mem_section *ms)
>   {
> -	/*
> -	 * XXX: Freeing memmap with vmemmap is not implement yet.
> -	 *      This should be removed later.
> -	 */
> -	return -EBUSY;
> +	int ret = -EINVAL;
> +
> +	if (!valid_section(ms))
> +		return ret;
> +
> +	ret = unregister_memory_section(ms);
> +
> +	return ret;
>   }
>   #else
>   static int __remove_section(struct zone *zone, struct mem_section *ms)

