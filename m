Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0CQWNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:13:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:54868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab0CQWNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:13:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,261,1267430400"; 
   d="scan'208";a="605358193"
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-wimax <linux-wimax@intel.com>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "Kao, Cindy H" <cindy.h.kao@intel.com>,
       "Brandewie, Dirk J" <dirk.j.brandewie@intel.com>,
       "wimax@linuxwimax.org" <wimax@linuxwimax.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1268829638.10618.28.camel@ICE-BOX>
References: <1268829638.10618.28.camel@ICE-BOX>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 15:10:41 -0700
Message-ID: <1268863841.2292.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 05:40 -0700, Darren Jenkins wrote: 
> On Wed, Mar 17, 2010 at 8:14 AM, David Miller <davem@davemloft.net>
> wrote:
> 
> > Therefore the krealloc() failure handling in this driver should NULL
> > out i2400m->fw_hdrs and that will fix the double kfree problem as well
> > as trap any stray references.
> 
> Yes that is a much better Idea. Thanks for the advice. 
> It also fixes the i2400m_barker_db problem that I didn't notice before.
> 
> 
> Fix double free on krealloc() failure by zeroing pointer

If krealloc() fails to aallocate a new pointer, the old block is
unmodified, so by doing this you are leaking a buffer allocation.

I think this should be solved at the site where i2400m_zrealloc_2x() is
called, with a 

if (result < 0) {
kfree(i2400m->fw_hdrs);
i2400m->fw_hdrs = NULL;
goto error_zrealloc;
}

or any other better fix. I am hesitant of having zrealloc_2x free the
original pointer because it breaks the traditional semantics that come
along being called 'realloc' (realloc if successful, keep the original
if not).

Am I missing anything?


> coverity CID: 13455
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> ---
>  drivers/net/wimax/i2400m/fw.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
> index 25c24f0..9f3b594 100644
> --- a/drivers/net/wimax/i2400m/fw.c
> +++ b/drivers/net/wimax/i2400m/fw.c
> @@ -232,8 +232,9 @@ int i2400m_zrealloc_2x(void **ptr, size_t *_count, size_t el_size,
>  		*_count = new_count;
>  		*ptr = nptr;
>  		return 0;
> -	} else
> -		return -ENOMEM;
> +	}
> +	*ptr = NULL;
> +	return -ENOMEM;
>  }
>  
> 



