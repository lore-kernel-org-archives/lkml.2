Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2KMItq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:49:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18980 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2KMItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:49:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 00:49:32 -0800
Message-ID: <50A20994.9000305@nvidia.com>
Date: Tue, 13 Nov 2012 16:49:24 +0800
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
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de> <50A1F3A3.40905@nvidia.com> <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 03:48 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Nov 13, 2012 at 03:15:47PM +0800, Mark Zhang wrote:
>> On 11/13/2012 05:55 AM, Thierry Reding wrote:
>>> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
>>> support for host1x and the two display controllers found on the Tegra20
>>> SoC. Each display controller can drive a separate RGB/LVDS output.
>>>
>>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>>> ---
>>> Changes in v2:
>>> - drop Linux-specific drm subdirectory for DT bindings documentation
>>> - remove display helper leftovers that belong in a later patch
>>> - reuse debugfs infrastructure provided by the DRM core
>>> - move vblank syncpoint defines to dc.h
>>> - use drm_compat_ioctl()
>>>
>> [...]
>>> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
>>> new file mode 100644
>>> index 0000000..be1daf7
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/tegra/Kconfig
>>> @@ -0,0 +1,23 @@
>>> +config DRM_TEGRA
>>> +       tristate "NVIDIA Tegra DRM"
>>> +       depends on DRM && OF && ARCH_TEGRA
>>> +       select DRM_KMS_HELPER
>>> +       select DRM_GEM_CMA_HELPER
>>> +       select DRM_KMS_CMA_HELPER
>>
>> Just for curious, according to my testing, why the "CONFIG_CMA" is not
>> enabled while DRM_GEM_CMA_HELPER & DRM_KMS_CMA_HELPER are enabled here?
> 
> The reason is that CMA doesn't actually provide any API for drivers to
> use and in fact unless you use very large buffers you could indeed run
> this code on top of a non-CMA kernel and it will likely even work.
> 

Okay. But I think it's better to turn on CMA defaultly. During my
testing, it's hard to allocate more 2MB without CMA...

>>> +static struct of_device_id tegra_dc_of_match[] = {
>>> +       { .compatible = "nvidia,tegra20-dc", },
>>> +       { .compatible = "nvidia,tegra30-dc", },
>>
>> If you don't want add Tegra 3 support in this patch set, remove
>> { .compatible = "nvidia,tegra30-dc", } here.
> 
> Good catch! I'll move that into the Tegra30 support patch.
> 
>>> +static int host1x_activate_drm_client(struct host1x *host1x,
>>> +                                     struct host1x_drm_client *drm,
>>> +                                     struct host1x_client *client)
>>> +{
>>> +       mutex_lock(&host1x->drm_clients_lock);
>>> +       list_del_init(&drm->list);
>>> +       list_add_tail(&drm->list, &host1x->drm_active);
>>
>> Why we need this "drm_active" list? We can combine this function and
>> function "host1x_remove_drm_client" and free the drm client just here.
>> It's useless after host1x clients registered themselves.
> 
> The list is used to properly remove all clients and resources when the
> module is unloaded. Granted, this code isn't executed if you don't build
> the driver as a loadable module, but it should still be a supported use-
> case.
> 

My opinion is, after registration is completed, host1x_drm_client is
useless, host1x_client is enough for follow-up operations.
I still don't get how this is related with building the driver into the
kernel or as a kernel module, so if something I misunderstood, please
let me know it. Thanks.

>>> +int host1x_unregister_client(struct host1x *host1x,
>>> +                            struct host1x_client *client)
>>> +{
>>> +       struct host1x_drm_client *drm, *tmp;
>>> +       int err;
>>> +
>>> +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
>>> +               if (drm->client == client) {
>>> +                       err = host1x_drm_exit(host1x);
>>
>> Although this code works but I think it looks confusing.
>> "host1x_drm_exit" calls every client's "drm_exit" callback then free all
>> the host1x clients, but this function is placed inside a loop.
>>
>> I think the better way is, free this host1x_client first, then remove it
>> from host1x's "clients" list, finally free the host1x(call
>> host1x_drm_exit) when the "clients" list get empty.
> 
> But that would be the same thing, only slightly more explicit. I find
> that the above reads quite well as: look through the list of active
> clients and if the client to be removed is in that list, teardown the
> DRM part.
> 

All right, this is just coding style problem and I think your words make
sense as well.

> I suppose I could add a comment to explain this and avoid confusion.
> 
>>> +int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
>>> +{
>>> +       int connector, encoder, err;
>>> +       enum of_gpio_flags flags;
>>> +       struct device_node *ddc;
>>> +       size_t size;
>>> +
>>> +       if (!output->of_node)
>>> +               output->of_node = output->dev->of_node;
>>> +
>>> +       output->edid = of_get_property(output->of_node, "nvidia,edid", &size);
>>> +
>>> +       ddc = of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus", 0);
>>> +       if (ddc) {
>>> +               output->ddc = of_find_i2c_adapter_by_node(ddc);
>>
>> The i2c adapter may not be ready at this time. For Tegra 2, the I2C bus
>> for HDMI is not dedicated and we need the i2cmux driver loaded before
>> this i2c can be used. It proved that sometimes i2cmux driver loads after
>> drm driver.
>>
>> So we need to add some logics to support driver probe deferral here.
>> Anyway, I'm just want you know about this and we can improve this later.
> 
> Good point. Unfortunately tegra_output_init() isn't always used from
> within .probe(), so it isn't quite easy to handle deferred probe here.
> I'll have to take a look at how to solve this properly.
> 
>>> +int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
>>> +{
>>> +       struct device_node *np;
>>> +       struct tegra_rgb *rgb;
>>> +       int err;
>>> +
>>> +       np = of_get_child_by_name(dc->dev->of_node, "rgb");
>>> +       if (!np || !of_device_is_available(np))
>>> +               return -ENODEV;
>>> +
>>> +       rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
>>> +       if (!rgb)
>>> +               return -ENOMEM;
>>> +
>>> +       rgb->clk = devm_clk_get(dc->dev, NULL);
>>> +       if (IS_ERR_OR_NULL(rgb->clk))
>>> +               return PTR_ERR(rgb->clk);
>>> +
>>> +       rgb->clk_parent = devm_clk_get(dc->dev, "parent");
>>> +       if (IS_ERR_OR_NULL(rgb->clk_parent))
>>> +               return PTR_ERR(rgb->clk_parent);
>>> +
>>> +       err = clk_set_parent(rgb->clk, rgb->clk_parent);
>>> +       if (err < 0) {
>>> +               dev_err(dc->dev, "failed to set parent clock: %d\n", err);
>>> +               return err;
>>> +       }
>>
>> Okay, seems this works with the "CLK_DUPLICATE" in tegra20_clocks_data.c.
>> I think the purpose of all these is to make sure the dc has a correct
>> parent clock. Hm... But I feel this may bring confusing to do dc clock
>> settings in a drm output component.
> 
> How do you think this would be confusing?
> 

I just feel that all dc related works should be handled in crtc while
not in output. Anyway, this is not a big deal and I think the current
implementation also makes sense.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
