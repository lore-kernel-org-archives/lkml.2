Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0HYRFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:05:44 -0400
Received: from legolas.restena.lu ([158.64.1.34]:43640 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0HYRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:05:41 -0400
Date: Wed, 25 Aug 2010 19:04:38 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Colin Watson <cjwatson@canonical.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Add new linearfb driver
Message-ID: <20100825190438.55ecb34d@neptune.home>
In-Reply-To: <20100825141111.GI21862@riva.ucam.org>
References: <20100825141111.GI21862@riva.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 August 2010 Colin Watson <cjwatson@canonical.com> wrote:
> Split out linearfb from efifb so that boot loaders can program it as a
> simple linear framebuffer on non-EFI systems.  This is useful for boot
> loaders with their own graphics drivers, e.g. GRUB 2, since in some
> cases on x86 they can set up non-VESA modes and thus can't program
> vesafb.
> 
> efifb is reworked on top of this common code, and it should be possible
> to do the same with some other framebuffer drivers in future.
> 
> Signed-off-by: Colin Watson <cjwatson@canonical.com>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> Cc: Peter Jones <pjones@redhat.com>
> ---
>  drivers/video/Kconfig       |   17 ++-
>  drivers/video/Makefile      |    1 +
>  drivers/video/efifb.c       |  222 +----------------------------
>  drivers/video/linearfb.c    |  332 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h          |    8 +
>  include/linux/screen_info.h |    2 +
>  6 files changed, 364 insertions(+), 218 deletions(-)
>  create mode 100644 drivers/video/linearfb.c
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 59c51d9..a7735ec 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -721,13 +721,24 @@ config FB_VESA
>  	  You will get a boot time penguin logo at no additional cost. Please
>  	  read <file:Documentation/fb/vesafb.txt>. If unsure, say Y.
>  
> -config FB_EFI
> -	bool "EFI-based Framebuffer Support"
> -	depends on (FB = y) && X86 && EFI
> +config FB_LINEAR
> +	bool "Simple linear framebuffer support"
> +	depends on FB
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
        ^^^^^^^^^^^^^^^^^^^^^^^

>  	help
> +	  This is a simple linear frame buffer device driver. It has no
> +	  hardware-specific programming capability, but must be programmed
> +	  by the boot loader or by another frame buffer driver.
> +
> +	  If unsure, say N.
> +
> +config FB_EFI
> +	bool "EFI-based Framebuffer Support"
> +	depends on (FB = y) && X86 && EFI
> +	select FB_LINEAR
        ^^^^^^^^^^^^^^^^
  Has kconfig been adjusted to process select recursively?
  If not the selects from FB_LINEAR will have to be copied here.

  Bruno


> +	help
>  	  This is the EFI frame buffer device driver. If the firmware on
>  	  your platform is EFI 1.10 or UEFI 2.0, select Y to add support for
>  	  using the EFI framebuffer as your console.
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index ddc2af2..ad74d3b 100644
