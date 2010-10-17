Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0JQBAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:00:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56285 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab0JQBAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tdtsz5aevfI2CAn/pHqToxz0Mu6v3Vvafh+XzjL/B9OrYHtUJhG4ohg3+5GiBKt7AF
         cGpsamdI80kqrRefHykC81c6ucE5sXk2ZtsOSbE35f4kCuHUkxgmfJE3ZONU1S3tM9Cg
         CmHDCwizt94iHVbHm4DgO6iy5aTHApoZ0p028=
MIME-Version: 1.0
In-Reply-To: <adad3r9hn1x.fsf@cisco.com>
References: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
	<adad3r9hn1x.fsf@cisco.com>
Date: Sat, 16 Oct 2010 21:00:35 -0400
Message-ID: <AANLkTinsmKABCCmS77MX4UH4NPG2UnQKtoGEcp6hooBJ@mail.gmail.com>
Subject: Re: 2.6.36-rc8 -- drivers/built-in.o: In function `nouveau_acpi_edid':
 (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
From: Miles Lane <miles.lane@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>,
        Maarten Maathuis <madman2003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 4:58 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  > drivers/built-in.o: In function `nouveau_acpi_edid':
>  > (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
>  > make: *** [.tmp_vmlinux1] Error 1
>
> The problem is:
>
>  > CONFIG_ACPI=y
>  > CONFIG_ACPI_VIDEO=m
>
> but
>
>  > CONFIG_DRM_NOUVEAU=y
>
> So the built-in nouveau code tries to reference the modular acpi video
> code.  I'm not sure what the correct fix is... does the following make
> things work?
>
>  drivers/gpu/drm/nouveau/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
> index e9b06e4..4e295b5 100644
> --- a/drivers/gpu/drm/nouveau/Makefile
> +++ b/drivers/gpu/drm/nouveau/Makefile
> @@ -28,6 +28,6 @@ nouveau-y := nouveau_drv.o nouveau_state.o nouveau_channel.o nouveau_mem.o \
>  nouveau-$(CONFIG_DRM_NOUVEAU_DEBUG) += nouveau_debugfs.o
>  nouveau-$(CONFIG_COMPAT) += nouveau_ioc32.o
>  nouveau-$(CONFIG_DRM_NOUVEAU_BACKLIGHT) += nouveau_backlight.o
> -nouveau-$(CONFIG_ACPI) += nouveau_acpi.o
> +nouveau-$(CONFIG_ACPI_VIDEO) += nouveau_acpi.o
>
>  obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o
>

Hi Roland,

I tried with your patch applied and got this:

drivers/built-in.o: In function `load_vbios_acpi':
nouveau_bios.c:(.text+0xa9cdf): undefined reference to
`nouveau_acpi_rom_supported'
nouveau_bios.c:(.text+0xa9cf4): undefined reference to
`nouveau_acpi_get_bios_chunk'
drivers/built-in.o: In function `nouveau_connector_detect_lvds':
nouveau_connector.c:(.text+0xb49d4): undefined reference to `nouveau_acpi_edid'
drivers/built-in.o: In function `nouveau_init':
nouveau_drv.c:(.init.text+0x653e): undefined reference to
`nouveau_register_dsm_handler'
drivers/built-in.o: In function `nouveau_exit':
nouveau_drv.c:(.exit.text+0x19b): undefined reference to
`nouveau_unregister_dsm_handler'
make: *** [.tmp_vmlinux1] Error 1

When I set CONFIG_DRM_NOUVEAU=m rather than =y, I got this:

ERROR: "nouveau_register_dsm_handler"
[drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "nouveau_acpi_rom_supported"
[drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "nouveau_unregister_dsm_handler"
[drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "nouveau_acpi_get_bios_chunk"
[drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "nouveau_acpi_edid" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
