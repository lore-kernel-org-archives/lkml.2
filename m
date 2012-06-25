Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2FYKyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 06:54:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46634 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab2FYKyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 06:54:05 -0400
X-IronPort-AV: E=Sophos;i="4.77,471,1336320000"; 
   d="scan'208";a="5258536"
Message-ID: <4FE84352.8090303@cn.fujitsu.com>
Date: Mon, 25 Jun 2012 18:54:10 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH SLUB 1/2] duplicate the cache name in saved_alias list
References: <1340617984.13778.37.camel@ThinkPad-T420>
In-Reply-To: <1340617984.13778.37.camel@ThinkPad-T420>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/25 18:54:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/25 18:54:18,
	Serialize complete at 2012/06/25 18:54:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 05:53 PM, Li Zhong wrote:
> SLUB duplicates the cache name in kmem_cache_create(). However if the
> cache could be merged to others during early booting, the name pointer
> is saved in saved_alias list, and the string needs to be kept valid
> before slab_sysfs_init() is called. 
> 
> This patch tries to duplicate the cache name in saved_alias list, so
> that the cache name could be safely kfreed after calling
> kmem_cache_create(), if that name is kmalloced. 
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  mm/slub.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 8c691fa..3dc8ed5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5373,6 +5373,11 @@ static int sysfs_slab_alias(struct kmem_cache *s,
> const char *name)
>  
>  	al->s = s;
>  	al->name = name;
> +	al->name = kstrdup(name, GFP_KERNEL);

dup assigned the al->name ?


Thanks,
Wanlong Gao

> +	if (!al->name) {
> +		kfree(al);
> +		return -ENOMEM;
> +	}
>  	al->next = alias_list;
>  	alias_list = al;
>  	return 0;
> @@ -5409,6 +5414,7 @@ static int __init slab_sysfs_init(void)
>  		if (err)
>  			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
>  					" %s to sysfs\n", s->name);
> +		kfree(al->name);
>  		kfree(al);
>  	}
>  
> 


