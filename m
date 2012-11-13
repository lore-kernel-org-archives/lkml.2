Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2KMJ6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:58:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12535 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2KMJ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:58:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 01:58:06 -0800
Message-ID: <50A219A8.7090605@nvidia.com>
Date: Tue, 13 Nov 2012 17:58:00 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de> <50A1F3A3.40905@nvidia.com> <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de> <50A20994.9000305@nvidia.com> <20121113093725.GB8122@avionic-0098.mockup.avionic-design.de> <50A217A8.2000600@nvidia.com> <20121113095424.GA982@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113095424.GA982@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 05:54 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Nov 13, 2012 at 05:49:28PM +0800, Mark Zhang wrote:
>> On 11/13/2012 05:37 PM, Thierry Reding wrote:
>>>> Old Signed by an unknown key
>>>
>>> On Tue, Nov 13, 2012 at 04:49:24PM +0800, Mark Zhang wrote:
>>>> On 11/13/2012 03:48 PM, Thierry Reding wrote:
>>>>>> Old Signed by an unknown key
>>>>>
>>>>> On Tue, Nov 13, 2012 at 03:15:47PM +0800, Mark Zhang wrote:
>>>>>> On 11/13/2012 05:55 AM, Thierry Reding wrote:
>>>>>>> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
>>>>>>> support for host1x and the two display controllers found on the Tegra20
>>>>>>> SoC. Each display controller can drive a separate RGB/LVDS output.
>>>>>>>
>>>>>>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>>>>>> ---
>>>>>>> Changes in v2:
>>>>>>> - drop Linux-specific drm subdirectory for DT bindings documentation
>>>>>>> - remove display helper leftovers that belong in a later patch
>>>>>>> - reuse debugfs infrastructure provided by the DRM core
>>>>>>> - move vblank syncpoint defines to dc.h
>>>>>>> - use drm_compat_ioctl()
>>>>>>>
>>>>>> [...]
>>>>>>> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
>>>>>>> new file mode 100644
>>>>>>> index 0000000..be1daf7
>>>>>>> --- /dev/null
>>>>>>> +++ b/drivers/gpu/drm/tegra/Kconfig
>>>>>>> @@ -0,0 +1,23 @@
>>>>>>> +config DRM_TEGRA
>>>>>>> +       tristate "NVIDIA Tegra DRM"
>>>>>>> +       depends on DRM && OF && ARCH_TEGRA
>>>>>>> +       select DRM_KMS_HELPER
>>>>>>> +       select DRM_GEM_CMA_HELPER
>>>>>>> +       select DRM_KMS_CMA_HELPER
>>>>>>
>>>>>> Just for curious, according to my testing, why the "CONFIG_CMA" is not
>>>>>> enabled while DRM_GEM_CMA_HELPER & DRM_KMS_CMA_HELPER are enabled here?
>>>>>
>>>>> The reason is that CMA doesn't actually provide any API for drivers to
>>>>> use and in fact unless you use very large buffers you could indeed run
>>>>> this code on top of a non-CMA kernel and it will likely even work.
>>>>>
>>>>
>>>> Okay. But I think it's better to turn on CMA defaultly. During my
>>>> testing, it's hard to allocate more 2MB without CMA...
>>>
>>> CMA is enabled by default in one of the Tegra default configuration
>>> patches in my tegra/next branch. I will submit that patch to Stephen
>>> when the 3.8 cycle starts, so that it'll be automatically enabled along
>>> with the DRM driver.
>>>
>>> But I don't think it makes sense to couple it to the DRM_TEGRA symbol as
>>> it isn't strictly required.
>>>
>>
>> Yes. We don't need to touch CMA in our Kconfig. In my opinion, right now
>> we're relying on the DRM_GEM_CMA_HELPER which should turn on CMA when
>> it's been selected.
> 
> Again, I don't think CMA should be selected by those either as the
> helpers will work fine if CMA is disabled (their name is a bit
> unfortunate). It's just that they won't be able to allocate very large
> buffers.
> 
> So I think the correct way is to select CMA in the Tegra default
> configuration to make it explicit that Tegra wants to use the CMA for
> large contiguous buffer allocations.
> 

Agree.

>>>>>>> +static struct of_device_id tegra_dc_of_match[] = {
>>>>>>> +       { .compatible = "nvidia,tegra20-dc", },
>>>>>>> +       { .compatible = "nvidia,tegra30-dc", },
>>>>>>
>>>>>> If you don't want add Tegra 3 support in this patch set, remove
>>>>>> { .compatible = "nvidia,tegra30-dc", } here.
>>>>>
>>>>> Good catch! I'll move that into the Tegra30 support patch.
>>>>>
>>>>>>> +static int host1x_activate_drm_client(struct host1x *host1x,
>>>>>>> +                                     struct host1x_drm_client *drm,
>>>>>>> +                                     struct host1x_client *client)
>>>>>>> +{
>>>>>>> +       mutex_lock(&host1x->drm_clients_lock);
>>>>>>> +       list_del_init(&drm->list);
>>>>>>> +       list_add_tail(&drm->list, &host1x->drm_active);
>>>>>>
>>>>>> Why we need this "drm_active" list? We can combine this function and
>>>>>> function "host1x_remove_drm_client" and free the drm client just here.
>>>>>> It's useless after host1x clients registered themselves.
>>>>>
>>>>> The list is used to properly remove all clients and resources when the
>>>>> module is unloaded. Granted, this code isn't executed if you don't build
>>>>> the driver as a loadable module, but it should still be a supported use-
>>>>> case.
>>>>>
>>>>
>>>> My opinion is, after registration is completed, host1x_drm_client is
>>>> useless, host1x_client is enough for follow-up operations.
>>>> I still don't get how this is related with building the driver into the
>>>> kernel or as a kernel module, so if something I misunderstood, please
>>>> let me know it. Thanks.
>>>
>>> I can take another look at this and see if it can be further simplified.
>>> This was actually a rather tricky part to get right, so I'm naturally a
>>> bit hesitant to touch it.
>>>
>>
>> Okay. I recall I did some changes on this part about 3 month ago in a
>> patch named "drm: Add T30 support - host1x". So maybe you can know what
>> I mean by reading that patch.
> 
> Yes, I remember the patch. Unfortunately the result of applying that
> patch was that unloading the module no longer worked properly.
> 

Okay. I'll take a look at this part as well when I'm free.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
