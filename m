Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1L2KYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:24:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1L2KYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:24:04 -0500
Message-ID: <4EFC3FA8.6020401@gmail.com>
Date: Thu, 29 Dec 2011 11:23:36 +0100
From: Corentin Chary <corentin.chary@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@googlemail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrzej Prochyra <andrzej@prochyra.name>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [PATCH] Platform: samsung-laptop: add DMI information for Samsung
 N150 Plus
References: <87ty4ss0z4.fsf@prochyra.name> <CAHR064h7a=RQq=p1J+gKpC5_6ow8ChUFFkC39HwtmerHaMksjw@mail.gmail.com> <87ty4qdpna.fsf@prochyra.name> <20111224142028.GA32171@srcf.ucam.org> <CANq1E4S+Sa1BERtR6aNH-ypRo+oJ1fRXkuVa+tREy5qVodv2pw@mail.gmail.com> <CAHR064jyubYf5d_KekB8+wqmGXcm8v4Gg9jVt3W9Kx_Ljh++GA@mail.gmail.com> <CANq1E4T9LtrBgAxhZAcZZc_gN5yuBm0Yn1ukYiWFvH84hKavBA@mail.gmail.com>
In-Reply-To: <CANq1E4T9LtrBgAxhZAcZZc_gN5yuBm0Yn1ukYiWFvH84hKavBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 11:22 AM, David Herrmann wrote:
> On Mon, Dec 26, 2011 at 10:49 AM, Corentin Chary
> <corentin.chary@gmail.com>  wrote:
>> On Sat, Dec 24, 2011 at 3:28 PM, David Herrmann
>> <dh.herrmann@googlemail.com>  wrote:
>>> On Sat, Dec 24, 2011 at 3:20 PM, Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>>> On Sat, Dec 24, 2011 at 02:12:57PM +0000, Andrzej Prochyra wrote:
>>>>> 'acpi_video0' not functional.  Brightness can be controlled through
>>>>> intel_backlight interface.  There are 21 brightness levels and the
>>>>> backlight can be turned off.
>>>>
>>>> If acpi_video0 doesn't work then we either need to work out why it's not
>>>> working or make it vanish completely, so this patch isn't the correct
>>>> approach.
>>>
>>> Just to make clear, intel_backlight isn't working properly either. If
>>> my laptop boots with backlight at 50% then intel_backlight will only
>>> work in the range 0%-50% on my machine. If I use the samsung module to
>>> set it to 100% then  intel_backlight works correctly in the range
>>> 0-100% until next reboot/suspend.
>>>
>>> So I'd recommend staying with the samsung module and disabling the
>>> acpi_backlight entirely. The samsung module is the only backlight
>>> control which works properly.
>>
>> Can I take a look at the DSDT to see how it's broken ?
>> If it's really not functional, then it should be added to the
>> blacklist in video_detect.c
>
> Raw and disassembled dsdt is attached.

Took a quick look but didn't find anything obvious. What happens exactly 
with acpi_video0 ?

But if it's not possible to make it work, I'd propose that (not tested):

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 45d8097..5041924 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,26 @@ find_video(acpi_handle handle, u32 lvl, void 
*context, void **rv)
         return AE_OK;
  }

+/* Force to use vendor driver when the ACPI device is known to be
+ * buggy */
+static int video_detect_force_vendor(const struct dmi_system_id *d)
+{
+       acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+}
+
+static struct dmi_system_id video_detect_dmi_table[] __initdata = {
+       {
+        .callback = video_detect_force_vendor,
+        .ident = "N150P",
+        .matches = {
+               DMI_MATCH(DMI_SYS_VENDOR,
+                         "SAMSUNG ELECTRONICS CO., LTD."),
+               DMI_MATCH(DMI_PRODUCT_NAME, "N150P"),
+               DMI_MATCH(DMI_BOARD_NAME, "N150P"),
+               },
+       },
+};
+
  /*
   * Returns the video capabilities of a specific ACPI graphics device
   *
@@ -164,6 +184,8 @@ long acpi_video_get_capabilities(acpi_handle 
graphics_handle)
                  *              ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
                  *}
                  */
+
+               dmi_check_system(video_detect_dmi_table);
         } else {
                 status = acpi_bus_get_device(graphics_handle, &tmp_dev);
                 if (ACPI_FAILURE(status)) {


-- 
Corentin Chary
http://xf.iksaif.net/
