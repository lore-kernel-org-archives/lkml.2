Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1F3Rql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:46:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59203 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1F3Rqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
References: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Date: Thu, 30 Jun 2011 10:46:37 -0700
X-Google-Sender-Auth: zUoV1rvru5GIxl1AHnUjBWH2h_4
Message-ID: <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
Subject: Re: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
From: Dan Williams <dan.j.williams@intel.com>
To: yxlraid@gmail.com
Cc: JBottomley@parallels.com, James.Bottomley@suse.de, jack_wang@usish.com,
        lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuxiangl@marvell.com, jfeng@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 7:27 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> -- Add support for interrupt tasklet, which will improve performance.

Interesting, do you happen to have comparative performance numbers?
The other thing we are looking at with isci is performance impact of
task collector mode and trying to decide whether the potential for
injecting scheduling latency into command submission is worth it.  The
aic94xx driver seemed to have a specific coalescing behavior in mind
for this mode that I have not grokked yet.

> -- Correct spelling of "20011"
>
> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
> ---
>  drivers/scsi/mvsas/Kconfig   |    9 ++++++++-
>  drivers/scsi/mvsas/Makefile  |    1 +
>  drivers/scsi/mvsas/mv_64xx.c |    6 ++----
>  drivers/scsi/mvsas/mv_94xx.c |    5 +----
>  drivers/scsi/mvsas/mv_init.c |   32 ++++++++++++++++++++------------
>  drivers/scsi/mvsas/mv_sas.h  |    1 +
>  6 files changed, 33 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
> index c82b012..78f7e20 100644
> --- a/drivers/scsi/mvsas/Kconfig
> +++ b/drivers/scsi/mvsas/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  # Copyright 2007 Red Hat, Inc.
>  # Copyright 2008 Marvell. <kewei@marvell.com>
> -# Copyright 2009-20011 Marvell. <yuxiangl@marvell.com>
> +# Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
>  #
>  # This file is licensed under GPLv2.
>  #
> @@ -41,3 +41,10 @@ config SCSI_MVSAS_DEBUG
>        help
>                Compiles the 88SE64XX/88SE94XX driver in debug mode.  In debug mode,
>                the driver prints some messages to the console.
> +config SCSI_MVSAS_TASKLET
> +       bool "Support for interrupt tasklet"
> +       default n
> +       depends on SCSI_MVSAS
> +       help
> +               Compiles the 88SE64xx/88SE94xx driver in interrupt tasklet mode.In this mode,
> +               the interrupt will schedule a tasklet.
> diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
> index 87b231a..40aae8a 100644
> --- a/drivers/scsi/mvsas/Makefile
> +++ b/drivers/scsi/mvsas/Makefile
> @@ -23,6 +23,7 @@
>  # USA
>
>  ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
> +ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) := -DMVS_USE_TASKLET

Question, why not just use "#ifdef CONFIG_SCSI_MVSAS_TASKLET" and drop
these redefinitions?
