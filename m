Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2FLI7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:59:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55392 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2FLI7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
References: <CAH9NwWd1F3Vw2zrQJh8Jazm45C_BAH3H3-qupvm2XaLgDOM=QQ@mail.gmail.com>
 <CAMeQTsZfE8_t6DCr3UWVqnOLyxNuNh7_VxJmqiP+enBBqM0o_A@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 12 Jun 2012 10:59:32 +0200
Message-ID: <CAH9NwWc3W6zHCFf9rwKg5NMQaWnh4A=xVVysmG1Y=eUMzu=18Q@mail.gmail.com>
Subject: Re: gma500: Cannot find any crtc or sizes - going 1024x768
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrik

2012/6/12 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>:
> On Mon, Jun 11, 2012 at 4:16 PM, Christian Gmeiner
> <christian.gmeiner@gmail.com> wrote:
>> Hi,
>>
>> I am working with a custom/embedded device, which has the following device:
>>
> -- Snip ---
>>
>> At the moment (kernel 3.2.20) I am using this device with the vesa
>> driver, but I tested 3.5-rc2+ on the
>> device with the gma500 driver.
>>
>>
>> [    7.885054] gma500 0000:00:02.0: setting latency timer to 64
>> [    7.885395] [drm:psb_intel_opregion_setup], Public ACPI methods supported
>> [    7.885408] [drm:psb_intel_opregion_setup], ASLE supported
>> [    7.885435] gma500 0000:00:02.0: Enabling MSI failed!
>> [    7.885542] [drm] internal display is MIPI display
>> [    7.885658] ioremap error for 0x3ddbd000-0x3ddbe000, requested 0x10, got 0x0
>> [    7.885759] gma500 0000:00:02.0: Unable to read GCT!
> --- Snip ---
>> [    7.914951] gma500 0000:00:02.0: VBT signature missing
> --- Snip ---
>> [    8.063001] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>> [    8.063127] [drm] No driver support for vblank timestamp query.
>> [    8.063369] gma500 0000:00:02.0: DSI is not supported
> Indicates that oaktrail_lvds_init() is skipped
>
>> [    8.113473] No connectors reported connected with modes
>> [    8.113575] [drm:drm_setup_crtcs],
>> [    8.113591] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
>> [    8.113601] [drm] Cannot find any crtc or sizes - going 1024x768
>> [    8.125973] fbcon: psbfb (fb0) is primary device
>> [    8.127827] [drm:drm_crtc_helper_set_config],
>> [    8.127835] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
>> [    8.168231] [drm:drm_crtc_helper_set_config],
>> [    8.168238] [drm:drm_crtc_helper_set_config], [CRTC:4] [NOFB]
>> [    8.231312] Console: switching to colour frame buffer device 128x48
>> [    8.257610] fb0: psbfb frame buffer device
>> [    8.257807] drm: registered panic notifier
>> [    8.258049] [drm] Initialized gma500 1.0.0 2011-06-06 for
>> 0000:00:02.0 on minor 0
> --- Snip ---
>> An run into this problem - there may be some more:
>> Cannot find any crtc or sizes - going 1024x768
>>
>> Depending on the connected display, there are two ways the panel is connected.
>>
>> 1) up to WVGA - LVDS
>> 2) else SDVO
>>
>> There is no EDID available.. it is only possible to read out the
>> defined display resolution
>> via an at24 eeprom found on the i2c bus of the device.
> --- Snip ---
>> So... what options do I have to fix my problems?
>
> Your device seems to lack the pieces needed for auto-detection of the outputs.
>
> I'd start by forcing oaktrail_lvds_init to run. Look at the first function in
> oaktrail_device.c. You'll find that a fuse value is required and that you don't
> have it.
>


Got a little bit further:

diff --git a/drivers/gpu/drm/gma500/mid_bios.c
b/drivers/gpu/drm/gma500/mid_bios.c
index b2a790b..9ee3122 100644
--- a/drivers/gpu/drm/gma500/mid_bios.c
+++ b/drivers/gpu/drm/gma500/mid_bios.c
@@ -55,8 +55,12 @@ static void mid_get_fuse_settings(struct drm_device *dev)
        pci_read_config_dword(pci_root, 0xD4, &fuse_value);

        /* FB_MIPI_DISABLE doesn't mean LVDS on with Medfield */
+#if 0
        if (IS_MRST(dev))
                dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
+#else
+       dev_priv->iLVDS_enable = 1;
+#endif

        DRM_INFO("internal display is %s\n",
                 dev_priv->iLVDS_enable ? "LVDS display" : "MIPI display");
diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c
b/drivers/gpu/drm/gma500/psb_intel_lvds.c
index c83f5b5..5b49522 100644
--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -530,11 +530,14 @@ static int psb_intel_lvds_get_modes(struct
drm_connector *connector)
        struct psb_intel_lvds_priv *lvds_priv = psb_intel_encoder->dev_priv;
        int ret = 0;

+       printk(KERN_INFO "test 1\n");
+#if 0
        if (!IS_MRST(dev))
                ret = psb_intel_ddc_get_modes(connector,
&lvds_priv->i2c_bus->adapter);

        if (ret)
                return ret;
+#endif

        /* Didn't get an EDID, so
         * Set wide sync ranges so we get all modes


[    8.233858] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:7:LVDS-1]
[    8.233869] test 1
[    8.233967] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:7:LVDS-1] probed modes :
[    8.233993] [drm:drm_mode_debug_printmodeline], Modeline
10:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[    8.234038] [drm:drm_setup_crtcs],
[    8.234053] [drm:drm_enable_connectors], connector 7 enabled? yes
[    8.234066] [drm:drm_target_preferred], looking for cmdline mode on
connector 7
[    8.234077] [drm:drm_target_preferred], looking for preferred mode
on connector 7
[    8.234088] [drm:drm_target_preferred], found mode 1024x600
[    8.234101] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    8.234116] [drm:drm_setup_crtcs], desired mode 1024x600 set on crtc 3
[    8.242199] fbcon: psbfb (fb0) is primary device
[    8.244065] [drm:drm_crtc_helper_set_config],
[    8.244076] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:12]
#connectors=1 (x y) (0 0)
[    8.244099] [drm:drm_crtc_helper_set_config], crtc has no fb, full mode set
[    8.244106] [drm:drm_crtc_helper_set_config], modes are different,
full mode set
[    8.244120] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0
0 0 0 0 0 0 0 0x0 0x0
[    8.244138] [drm:drm_mode_debug_printmodeline], Modeline
11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[    8.244145] [drm:drm_crtc_helper_set_config], encoder changed, full
mode switch
[    8.244151] [drm:drm_crtc_helper_set_config], crtc changed, full mode switch
[    8.244161] [drm:drm_crtc_helper_set_config], [CONNECTOR:7:LVDS-1]
to [CRTC:3]
[    8.244168] [drm:drm_crtc_helper_set_config], attempting to set
mode from userspace
[    8.244184] [drm:drm_mode_debug_printmodeline], Modeline
11:"1024x600" 75 53990 1024 1072 1104 1184 600 603 604 608 0x48 0x0
[    8.244195] Can't support LVDS on pipe A
[    8.244201] [drm:drm_crtc_helper_set_mode], Encoder fixup failed
[    8.244211] [drm:drm_crtc_helper_set_config] *ERROR* failed to set
mode on [CRTC:3]
[    8.244222] fbcon_init: detected unhandled fb_set_par error, error code -22
[    8.262085] Console: switching to colour frame buffer device 128x37
[    8.293680] fb0: psbfb frame buffer device
[    8.294817] drm: registered panic notifier
[    8.295173] [drm] Initialized gma500 1.0.0 2011-06-06 for
0000:00:02.0 on minor 0



> We have no SDVO support for Oaktrail and I've never seen any hardware
> that does LVDS over SDVO (though there is support for that on Poulsbo).
>

Don't ask... my hardware guy has some ominous reasons that its done this way :)

---
Christian Gmeiner, MSc
