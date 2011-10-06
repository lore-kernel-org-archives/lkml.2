Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab1JFKyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:54:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51918 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab1JFKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:54:12 -0400
Message-ID: <4E8D889F.7010401@mvista.com>
Date: Thu, 06 Oct 2011 14:53:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Garzik <jgarzik@pobox.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] libata: Convert LED disk trigger from IDE to libata
References: <38bd3a0590c6b069e2e6ff63d2bc4d039a703f02.1317657893.git.joerg@alea.gnuu.de>
In-Reply-To: <38bd3a0590c6b069e2e6ff63d2bc4d039a703f02.1317657893.git.joerg@alea.gnuu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-10-2011 20:07, Jörg Sommer wrote:

> This patch converts the trigger for the LED at the front of Apple's
> iBooks to libata. It's merely a replacement of the string ide by disk.

> The patch is taken from http://dev.gentoo.org/~josejx/ata.patch. I've
> asked Joseph Jezak if he intends to send this patch upstream, but as he
> did not reply I'll do so.

    The patch needs to be signed off, it cannot be applied otherwise.

> ---
>   arch/powerpc/configs/pmac32_defconfig |    2 +-
>   arch/powerpc/configs/ppc6xx_defconfig |    2 +-
>   drivers/ata/libata-core.c             |    4 ++
>   drivers/ide/ide-disk.c                |    2 +-
>   drivers/leds/Kconfig                  |   10 +++---
>   drivers/leds/Makefile                 |    2 +-
>   drivers/leds/ledtrig-disk.c           |   64 +++++++++++++++++++++++++++++++++
>   drivers/leds/ledtrig-ide-disk.c       |   64 ---------------------------------
>   drivers/macintosh/Kconfig             |   11 +++---
>   drivers/macintosh/via-pmu-led.c       |    4 +-
>   include/linux/leds.h                  |    6 ++--
>   11 files changed, 87 insertions(+), 84 deletions(-)
>   create mode 100644 drivers/leds/ledtrig-disk.c
>   delete mode 100644 drivers/leds/ledtrig-ide-disk.c

    You should use -C/-M git options to detect file renames.

> diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
> index f8b394a..cff5d4e 100644
> --- a/arch/powerpc/configs/pmac32_defconfig
> +++ b/arch/powerpc/configs/pmac32_defconfig
> @@ -180,7 +180,7 @@ CONFIG_ADB=y
>   CONFIG_ADB_CUDA=y
>   CONFIG_ADB_PMU=y
>   CONFIG_ADB_PMU_LED=y
> -CONFIG_ADB_PMU_LED_IDE=y
> +CONFIG_ADB_PMU_LED_DISK=y
>   CONFIG_PMAC_APM_EMU=m
>   CONFIG_PMAC_MEDIABAY=y
>   CONFIG_PMAC_BACKLIGHT=y
> diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
> index 04360f9..c56464d 100644
> --- a/arch/powerpc/configs/ppc6xx_defconfig
> +++ b/arch/powerpc/configs/ppc6xx_defconfig
> @@ -471,7 +471,7 @@ CONFIG_ADB=y
>   CONFIG_ADB_CUDA=y
>   CONFIG_ADB_PMU=y
>   CONFIG_ADB_PMU_LED=y
> -CONFIG_ADB_PMU_LED_IDE=y
> +CONFIG_ADB_PMU_LED_DISK=y
>   CONFIG_PMAC_APM_EMU=y
>   CONFIG_PMAC_MEDIABAY=y
>   CONFIG_PMAC_BACKLIGHT=y

    Defconfigs should be changed by a separate patch.

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 4a3a5ae..d37e3a2 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -66,6 +66,7 @@
>   #include<asm/byteorder.h>
>   #include<linux/cdrom.h>
>   #include<linux/ratelimit.h>
> +#include<linux/leds.h>
>
>   #include "libata.h"
>   #include "libata-transport.h"
> @@ -4823,6 +4824,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
>   {
>   	struct ata_port *ap = qc->ap;
>
> +	/* Trigger the LED (if available) */
> +	ledtrig_disk_activity();
> +
>   	/* XXX: New EH and old EH use different mechanisms to
>   	 * synchronize EH with regular execution path.
>   	 *

    This also seems a material for the separate patch. You should first do a 
file/function rename and then add support for libata, I think.

> diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> index 2747980..cb25bd6 100644
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -186,7 +186,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
>   	BUG_ON(drive->dev_flags&  IDE_DFLAG_BLOCKED);
>   	BUG_ON(rq->cmd_type != REQ_TYPE_FS);
>
> -	ledtrig_ide_activity();
> +	ledtrig_disk_activity();

    Hm, the trigger point seems asymmetric to that one you added to libata. 
Here you trigger before executing a request, and in libata after a command 
completes; also, in libata you also trigger on ATAPI devices, while here only 
on ATA devices...

WBR, Sergei
