Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2F2MTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:19:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47023 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2F2MTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120626221907.GC26614@kamineko.org>
References: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
	<1339572727-24744-2-git-send-email-corentin.chary@gmail.com>
	<20120626221907.GC26614@kamineko.org>
Date: Fri, 29 Jun 2012 14:19:04 +0200
Message-ID: <CAHR064i0J32kpOh3v2SMhVQ=wofkm5wyiPRwyJOzqwMq+y3LPA@mail.gmail.com>
Subject: Re: [PATCH 1/7] acpi: add a way to promote/demote vendor backlight drivers
From: Corentin Chary <corentin.chary@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:19 AM, Mattia Dongili <malattia@linux.it> wrote:
> Hi Corentin,
>
> On Wed, Jun 13, 2012 at 09:32:01AM +0200, Corentin Chary wrote:
> ...
>> +/* Promote the vendor interface instead of the generic video module.
>> + * This function allow DMI blacklists to be implemented by externals
>> + * platform drivers instead of putting a big blacklist in video_detect.c
>> + * After calling this function you will probably want to call
>> + * acpi_video_unregister() to make sure the video module is not loaded
>> + */
>> +void acpi_video_dmi_promote_vendor(void)
>> +{
>> +     acpi_video_caps_check();
>> +     acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>> +}
>> +EXPORT_SYMBOL(acpi_video_dmi_promote_vendor);
>
> I think having the promote_vendor() function do the sanity check on the
> acpi_backlight parameter and the unregistering of the acpi_video device
> may make the code cleaner and more acpi_video-agnostic in the drivers.
> I.e. (untested sample code):
>
> bool acpi_video_promote_vendor(void)
> {
>        if (acpi_video_backlight_support())
>                return false;
>
>        acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
>        pr_info("Disabling ACPI video driver\n");
>        acpi_video_unregister();
>        return true;
> }
> EXPORT_SYMBOL(acpi_video_promote_vendor);
>
> and in the drivers you do
>
>        if (my_drv->broken_acpi_video) {
>                if (acpi_video_promote_vendor())
>                        do_backlight_init();
>        } else if (!acpi_video_backlight_support())
>                do_backlight_init();
>
> or something along these lines.
> If you give a boolean parameter to acpi_video_promote_vendor to force
> vendor backlight we could make the drivers' code even simpler but that
> would change the semantics of the "promotion" to something more of a
> "take-over".
>
> PS: I will need to promote backlight control in sony-laptop.ko
> eventually as well but I don't have a DMI based list but rather I should
> look at a specific handle (or say Method) presence in the SNC Device.
> I guess I'm just bothered by the function naming here but not a big
> deal. :)
> --
> mattia
> :wq!

I had something like that in mind, but it makes acpi.ko use symbols
from video.ko, and video.ko already uses symbols from acpi.ko, and I
didn't want to mess with circular dependencies. But if you manage to
make it work, and if you want to remove dmi_, I'll hapilly Ack it !



-- 
Corentin Chary
http://xf.iksaif.net
