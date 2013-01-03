Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3ACCgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 21:36:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64343 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3ACCgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 21:36:19 -0500
Message-ID: <50E4EE9A.1060406@gmail.com>
Date: Thu, 03 Jan 2013 10:36:10 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <50DAC678.5060601@gmail.com> <50E3FD17.80402@nvidia.com>
In-Reply-To: <50E3FD17.80402@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 05:25 PM, Terje Bergström wrote:
> On 26.12.2012 11:42, Mark Zhang wrote:
[...]
> 
>>
>>         if (!de)
>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
>> index 07e8813..01ed10d 100644
>> --- a/drivers/gpu/host1x/dev.c
>> +++ b/drivers/gpu/host1x/dev.c
>> @@ -38,6 +38,7 @@
>>
>>  struct host1x *host1x;
>>
>> +/* Called by drm unlocked ioctl function. So do we need a lock here? */
>>  void host1x_syncpt_incr_byid(u32 id)
> 
> No, host1x_syncpt_incr_byid is SMP safe.

Correct. Lock is unnecessary.

> 
>>  {
>>         struct host1x_syncpt *sp = host1x->syncpt + id;
>> @@ -52,6 +53,7 @@ u32 host1x_syncpt_read_byid(u32 id)
>>  }
>>  EXPORT_SYMBOL(host1x_syncpt_read_byid);
>>
>> +/* Called by drm unlocked ioctl function. So do we need a lock here? */
>>  int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value)
> 
> Same here, SMP safe.
> 
>>  {
>>         struct host1x_syncpt *sp = host1x->syncpt + id;
>> @@ -161,6 +163,8 @@ static int host1x_probe(struct platform_device *dev)
>>
>>         err = host1x_alloc_resources(host);
>>         if (err) {
>> +               /* We don't have chip_ops right now, so here the
>> +                  error message is somewhat improper */
>>                 dev_err(&dev->dev, "failed to init chip support\n");
>>                 goto fail;
>>         }
> 
> Actually, alloc_resources only allocates intr->syncpt, so I the code to
> host1x_intr_init().
> 
>> @@ -175,6 +179,14 @@ static int host1x_probe(struct platform_device *dev)
>>         if (!host->syncpt)
>>                 goto fail;
>>
>> +       /* I suggest create a dedicate function for initializing nop sp.
>> +          First this "_host1x_syncpt_alloc" looks like an internal/static
>> +          function.
>> +          Then actually "host1x_syncpt_alloc" & "_host1x_syncpt_alloc" all
>> +          serve host1x client(e.g: gr2d) so it's not suitable to use them
>> +          for nop sp.
>> +          Just create a wrapper function to call _host1x_syncpt_alloc is OK.
>> +          This will make the code more readable. */
>>         host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);
> 
> _host1x_syncpt_alloc is an internal function, not exported.
> host1x_syncpt_alloc is exported. I think it's even better if I just move
> allocation of nop_sp to happen in host1x_syncpt_init.
> 

Agree.

>>         if (!host->nop_sp)
>>                 goto fail;
[...]
> 
>> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
>> index efcb9be..e112001 100644
>> --- a/drivers/gpu/host1x/intr.c
>> +++ b/drivers/gpu/host1x/intr.c
>> @@ -329,8 +329,13 @@ void host1x_intr_deinit(struct host1x_intr *intr)
>>  void host1x_intr_start(struct host1x_intr *intr, u32 hz)
>>  {
>>         struct host1x *host1x = intr_to_host1x(intr);
>> +
>> +       /* Why we need to lock here? Seems like this function is
>> +          called by host1x's probe only. */
>>         mutex_lock(&intr->mutex);
>>
>> +       /* "init_host_sync" has already been called in function
>> +          host1x_intr_init. Remove this line. */
>>         host1x->intr_op.init_host_sync(intr);
>>         host1x->intr_op.set_host_clocks_per_usec(intr,
>>                         DIV_ROUND_UP(hz, 1000000));
> 
> In future, we'll call host1x_intr_start() whenever host1x is turned on.
> Thus we need locking.
>
> init_host_sync() should actually be called from host1x_intr_start(), not
> _init().
> 

Got it. Thanks for explanation.

>> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
>> index 07cbca5..9a234ad 100644
>> --- a/drivers/gpu/host1x/syncpt.c
>> +++ b/drivers/gpu/host1x/syncpt.c
>> @@ -309,6 +309,8 @@ struct host1x_syncpt *host1x_syncpt_init(struct
>> host1x *host)
>>         struct host1x_syncpt *syncpt, *sp;
>>         int i;
>>
>> +       /* Consider devm_kzalloc here. Then you can forget the release
>> +          stuffs about this "syncpt". */
>>         syncpt = sp = kzalloc(sizeof(struct host1x_syncpt) * host->info.nb_pts,
>>                 GFP_KERNEL);
>>         if (!syncpt)
> 
> Will do.
> 
> Thanks!
> 
> Terje
> 
