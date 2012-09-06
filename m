Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2IFHHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 03:07:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57405 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2IFHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 03:07:01 -0400
Message-ID: <50484B8A.4090009@gmail.com>
Date: Thu, 06 Sep 2012 15:06:50 +0800
From: wujianguo <wujianguo106@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC PATCH V6 10/19] memory-hotplug: add memory_block_release
References: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com> <1343980161-14254-11-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1343980161-14254-11-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-3 15:49, wency@cn.fujitsu.com wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> When calling remove_memory_block(), the function shows following message at
> device_release().
> 
> Device 'memory528' does not have a release() function, it is broken and must
> be fixed.
> 

I found this warning too when doing memory-hotplug,
why not send as a bug fix patch?
The same as [RFC PATCH V6 18/19] memory-hotplug: add node_device_release

> remove_memory_block() calls kfree(mem). I think it shouled be called from
> device_release(). So the patch implements memory_block_release()
> 
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  drivers/base/memory.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 038be73..1cd3ef3 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -109,6 +109,15 @@ bool is_memblk_offline(unsigned long start, unsigned long size)
>  }
>  EXPORT_SYMBOL(is_memblk_offline);
>  
> +#define to_memory_block(device) container_of(device, struct memory_block, dev)
> +
> +static void release_memory_block(struct device *dev)
> +{
> +	struct memory_block *mem = to_memory_block(dev);
> +
> +	kfree(mem);
> +}
> +
>  /*
>   * register_memory - Setup a sysfs device for a memory block
>   */
> @@ -119,6 +128,7 @@ int register_memory(struct memory_block *memory)
>  
>  	memory->dev.bus = &memory_subsys;
>  	memory->dev.id = memory->start_section_nr / sections_per_block;
> +	memory->dev.release = release_memory_block;
>  
>  	error = device_register(&memory->dev);
>  	return error;
> @@ -674,7 +684,6 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
>  		mem_remove_simple_file(mem, phys_device);
>  		mem_remove_simple_file(mem, removable);
>  		unregister_memory(mem);
> -		kfree(mem);
>  	} else
>  		kobject_put(&mem->dev.kobj);
>  
> 

