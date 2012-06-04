Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2FDMIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2FDMIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:08:39 -0400
Message-ID: <4FCCA543.3030603@redhat.com>
Date: Mon, 04 Jun 2012 14:08:35 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Moser <john.r.moser@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is this code right in zram?
References: <4FC7E610.5060207@gmail.com>
In-Reply-To: <4FC7E610.5060207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 11:43 PM, John Moser wrote:
> before I go stomping all over other peoples' work and sending idiotic 
> patches, I think I'll ask.  Since I have no clue what I'm doing.
> 
> in drivers/staging/zram.c out of 3.4 (I just grabbed the source hours 
> ago), I see this on lines 810-822:

I assume that's drivers/staging/zram_drv.c.

> 
>         /* Allocate the device array and initialize each one */
>          pr_info("Creating %u devices ...\n", num_devices);
>          zram_devices = kzalloc(num_devices * sizeof(struct zram), 
> GFP_KERNEL);
>          if (!zram_devices) {
>                  ret = -ENOMEM;
>                  goto unregister;
>          }
> 
>          for (dev_id = 0; dev_id < num_devices; dev_id++) {
>                  ret = create_device(&zram_devices[dev_id], dev_id);
>                  if (ret)
>                          goto free_devices;
>          }
> 
> Curiosity got me to here:
> 
> http://lwn.net/Articles/147014/
> 
> So assuming this, what I see here is:
> 
>   - kmalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
>   - memset() that to 0
>   - immediately fill in this RAM without reading it
> 
> I'm wondering what the immediate need is to fill the area with zeros?

It's to avoid to have undefined values between the time the device is
created and initialized. In that case, it may be superfluous since the
locking mechanism should avoid to access an uninitialized device.
  
> Also curious as to whether the kzalloc() thing should better be 
> kcalloc(num_devices, sizeof(struct zram), GFP_KERNEL) as a matter of 
> convention.

It probably doesn't matter much. Apparently kcalloc() never got  a lot
of success and kzalloc(sizeof(foo) * num_foos) type of allocation are
more popular.

Jerome

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

