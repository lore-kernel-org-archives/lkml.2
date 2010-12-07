Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0LGJjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:39:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48485 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab0LGJjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EkpfhPskROf6EcrKxw3y643KVqTUNA+OlsXlDoW6wxdeIcXvusvKSUaodcIbq+wobz
         UpxN6c+mS2YQMaX1ynfrDCKshJWLLK5lK5aq5gTLTVsPONhtKwj7CFzglSD6u68eyXcm
         mneKxdPrpVqNOqeuB33WNidQ3VrYt77Phvl8s=
MIME-Version: 1.0
In-Reply-To: <20101207072919.GA8511@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	<20071024011712.GA3762@falooley.org>
	<1193208689.26096.48.camel@pmac.infradead.org>
	<20071227181524.GA19051@falooley.org>
	<20071228174853.GA4252@uranus.ravnborg.org>
	<20101207072919.GA8511@falooley.org>
Date: Tue, 7 Dec 2010 10:39:41 +0100
Message-ID: <AANLkTineLxHdcDKZEUGiqVNAauSX_xyQrs49kKaqhiWo@mail.gmail.com>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jason Lunz <lunz@acm.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 8:29 AM, Jason Lunz <lunz@acm.org> wrote:
>
> Allow parts of drivers/mtd to compile on uml by pushing the HAS_IOMEM
> dependencies down closer to the parts of mtd that actually need it.
> This allows enough of mtd to build to let jffs2 be used on uml.
>
> Signed-off-by: Jason Lunz <lunz@acm.org>
> ---
>  arch/um/Kconfig.rest        |    4 +---
>  drivers/mtd/Kconfig         |    1 -
>  drivers/mtd/Makefile        |    3 ++-
>  drivers/mtd/chips/Kconfig   |    4 ++++
>  drivers/mtd/devices/Kconfig |    8 ++++++++
>  drivers/mtd/maps/Kconfig    |    4 ++++
>  drivers/mtd/mtdchar.c       |    4 ++++
>  drivers/mtd/nand/Kconfig    |    3 +++
>  drivers/mtd/onenand/Kconfig |    3 +++
>  include/linux/mtd/map.h     |    2 ++
>  10 files changed, 31 insertions(+), 5 deletions(-)
>
> diff --git a/arch/um/Kconfig.rest b/arch/um/Kconfig.rest
> index 0ccad0f..e34f399 100644
> --- a/arch/um/Kconfig.rest
> +++ b/arch/um/Kconfig.rest
> @@ -28,9 +28,7 @@ source "drivers/scsi/Kconfig"
>
>  source "drivers/md/Kconfig"
>
> -if BROKEN
> -       source "drivers/mtd/Kconfig"
> -endif
> +source "drivers/mtd/Kconfig"

drivers/mtd was already marked as broken when we moved over to git (2.6.12-rc2).

Do you exactly know why it was marked and fixes this patch all issues?

>  source "drivers/leds/Kconfig"
>
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 1e2cbf5..a0e2a28 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -1,6 +1,5 @@
>  menuconfig MTD
>        tristate "Memory Technology Device (MTD) support"
> -       depends on HAS_IOMEM
>        help
>          Memory Technology Devices are flash, RAM and similar chips, often
>          used for solid state file systems on embedded devices. This option
> diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
> index 760abc5..ffa2e15 100644
> --- a/drivers/mtd/Makefile
> +++ b/drivers/mtd/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_MTD_OOPS)                += mtdoops.o
>  nftl-objs              := nftlcore.o nftlmount.o
>  inftl-objs             := inftlcore.o inftlmount.o
>
> -obj-y          += chips/ lpddr/ maps/ devices/ nand/ onenand/ tests/
> +obj-y                  += maps/ devices/ nand/ onenand/ tests/
> +obj-$(CONFIG_HAS_IOMEM)        += chips/ lpddr/
>
>  obj-$(CONFIG_MTD_UBI)          += ubi/
> diff --git a/drivers/mtd/chips/Kconfig b/drivers/mtd/chips/Kconfig
> index 35c6a23..27382c9 100644
> --- a/drivers/mtd/chips/Kconfig
> +++ b/drivers/mtd/chips/Kconfig
> @@ -1,3 +1,5 @@
> +if HAS_IOMEM
> +
>  menu "RAM/ROM/Flash chip drivers"
>        depends on MTD!=n
>
> @@ -240,3 +242,5 @@ config MTD_XIP
>          then say N.
>
>  endmenu
> +
> +endif # HAS_IOMEM
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 35081ce..8f6d85d 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -112,6 +112,8 @@ config MTD_SST25L
>          Set up your spi devices with the right board-specific platform data,
>          if you want to specify device partitioning.
>
> +if HAS_IOMEM
> +
>  config MTD_SLRAM
>        tristate "Uncached system RAM"
>        help
> @@ -128,6 +130,8 @@ config MTD_PHRAM
>          doesn't have access to, memory beyond the mem=xxx limit, nvram,
>          memory on the video card, etc...
>
> +endif # HAS_IOMEM
> +
>  config MTD_LART
>        tristate "28F160xx flash driver for LART"
>        depends on SA1100_LART
> @@ -187,6 +191,8 @@ config MTD_BLOCK2MTD
>          Testing MTD users (eg JFFS2) on large media and media that might
>          be removed during a write (using the floppy drive).
>
> +if HAS_IOMEM
> +
>  comment "Disk-On-Chip Device Drivers"
>
>  config MTD_DOC2000
> @@ -249,6 +255,8 @@ config MTD_DOC2001PLUS
>          under "NAND Flash Device Drivers" (currently that driver does not
>          support all Millennium Plus devices).
>
> +endif # HAS_IOMEM
> +
>  config MTD_DOCPROBE
>        tristate
>        select MTD_DOCECC
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index a0dd7bb..e793b29 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -1,3 +1,5 @@
> +if HAS_IOMEM
> +
>  menu "Mapping drivers for chip access"
>        depends on MTD!=n
>
> @@ -553,3 +555,5 @@ config MTD_PISMO
>          When built as a module, it will be called pismo.ko
>
>  endmenu
> +
> +endif # HAS_IOMEM
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 4759d82..a434354 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -1075,6 +1075,7 @@ static unsigned long mtd_get_unmapped_area(struct file *file,
>  /*
>  * set up a mapping for shared memory segments
>  */
> +#ifdef CONFIG_HAS_IOMEM
>  static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  #ifdef CONFIG_MMU
> @@ -1113,6 +1114,7 @@ static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
>        return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
>  #endif
>  }
> +#endif
>
>  static const struct file_operations mtd_fops = {
>        .owner          = THIS_MODULE,
> @@ -1125,7 +1127,9 @@ static const struct file_operations mtd_fops = {
>  #endif
>        .open           = mtd_open,
>        .release        = mtd_close,
> +#ifdef CONFIG_HAS_IOMEM
>        .mmap           = mtd_mmap,
> +#endif
>  #ifndef CONFIG_MMU
>        .get_unmapped_area = mtd_get_unmapped_area,
>  #endif
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 8229802..8bdd465 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -10,6 +10,8 @@ config MTD_NAND_ECC_SMC
>          The original Linux implementation had byte 0 and 1 swapped.
>
>
> +if HAS_IOMEM
> +
>  menuconfig MTD_NAND
>        tristate "NAND Device Support"
>        depends on MTD
> @@ -533,3 +535,4 @@ config MTD_NAND_FSMC
>          Flexible Static Memory Controller (FSMC)
>
>  endif # MTD_NAND
> +endif # HAS_IOMEM
> diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
> index 4dbd0f5..166aa18 100644
> --- a/drivers/mtd/onenand/Kconfig
> +++ b/drivers/mtd/onenand/Kconfig
> @@ -1,3 +1,5 @@
> +if HAS_IOMEM
> +
>  menuconfig MTD_ONENAND
>        tristate "OneNAND Device Support"
>        depends on MTD
> @@ -75,3 +77,4 @@ config MTD_ONENAND_SIM
>          OneNAND MTD layer.
>
>  endif # MTD_ONENAND
> +endif # HAS_IOMEM
> diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
> index a9e6ba4..c7233ba 100644
> --- a/include/linux/mtd/map.h
> +++ b/include/linux/mtd/map.h
> @@ -388,6 +388,7 @@ static inline map_word map_word_ff(struct map_info *map)
>        return r;
>  }
>
> +#ifdef CONFIG_HAS_IOMEM
>  static inline map_word inline_map_read(struct map_info *map, unsigned long ofs)
>  {
>        map_word r;
> @@ -439,6 +440,7 @@ static inline void inline_map_copy_to(struct map_info *map, unsigned long to, co
>  {
>        memcpy_toio(map->virt + to, from, len);
>  }
> +#endif /* CONFIG_HAS_IOMEM */
>
>  #ifdef CONFIG_MTD_COMPLEX_MAPPINGS
>  #define map_read(map, ofs) (map)->read(map, ofs)
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Thanks,
//richard
