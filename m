Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2I0Kim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:38:42 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48706 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab2I0Kij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:39 -0400
Message-ID: <50642CA7.5070208@gmail.com>
Date: Thu, 27 Sep 2012 18:38:31 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:45 PM, wency@cn.fujitsu.com wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> When calling unregister_node(), the function shows following message at
> device_release().
>
> Device 'node2' does not have a release() function, it is broken and must be
> fixed.
>
> So the patch implements node_device_release()
looks reasonable to me.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>   drivers/base/node.c |   11 +++++++++++
>   1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index af1a177..07523fb 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -252,6 +252,16 @@ static inline void hugetlb_register_node(struct node *node) {}
>   static inline void hugetlb_unregister_node(struct node *node) {}
>   #endif
>   
> +static void node_device_release(struct device *dev)
> +{
> +	struct node *node_dev = to_node(dev);
> +
> +#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_HUGETLBFS)
> +	flush_work(&node_dev->node_work);
> +#endif
> +
> +	memset(node_dev, 0, sizeof(struct node));
> +}
>   
>   /*
>    * register_node - Setup a sysfs device for a node.
> @@ -265,6 +275,7 @@ int register_node(struct node *node, int num, struct node *parent)
>   
>   	node->dev.id = num;
>   	node->dev.bus = &node_subsys;
> +	node->dev.release = node_device_release;
>   	error = device_register(&node->dev);
>   
>   	if (!error){

