Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1JNRqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:46:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63081 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1JNRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:46:33 -0400
Message-ID: <4E987575.5080509@pobox.com>
Date: Fri, 14 Oct 2011 13:46:29 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ata: add CONFIG_SATA_HOST config option
References: <201110131658.08732.bzolnier@gmail.com>
In-Reply-To: <201110131658.08732.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 10:58 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH v3] ata: add CONFIG_SATA_HOST config option
>
> Add CONFIG_SATA_HOST config option (for selecting SATA Host
> support) to make setup easier on PATA-only systems.
>
> Additionally move SATA-specific code to libata-sata.c which
> allows us to save ~11.5k of the output code size (x86-64) on
> PATA-only systems for CONFIG_SATA_HOST=n:
>
> CONFIG_SATA_HOST=y:
>     text    data     bss     dec     hex filename
>    44283    6576      57   50916    c6e4 drivers/ata/libata-core.o
>    29054      16       2   29072    7190 drivers/ata/libata-eh.o
>    20085       0      19   20104    4e88 drivers/ata/libata-sff.o
>     8699       0       0    8699    21fb drivers/ata/libata-sata.o
>
> CONFIG_SATA_HOST=n:
>     text    data     bss     dec     hex filename
>    43754    6576      57   50387    c4d3 drivers/ata/libata-core.o
>    26775      16       2   26793    68a9 drivers/ata/libata-eh.o
>    20144       0      19   20163    4ec3 drivers/ata/libata-sff.o
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> v2:
> - Kconfig fixups per Sergei's comments
> - add non-SATA version of ata_std_postreset()
> - drop non-SATA versions of sata_link_[debounce,hardreset,resume](),
>    sata_set_spd(), sata_print_link_status() and ata_tf_from_fis()
> - move SATA-specific code to libata-sata.c
> v3:
> - require SATA_HOST for ata_piix for now
>
> earlier references:
> https://lkml.org/lkml/2011/2/9/149
> https://lkml.org/lkml/2011/2/11/103
>
>   drivers/ata/Kconfig       |   19
>   drivers/ata/Makefile      |    1
>   drivers/ata/libata-core.c |  814 ------------------------------
>   drivers/ata/libata-eh.c   |  412 ---------------
>   drivers/ata/libata-sata.c | 1243 ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/ata/libata-sff.c  |   32 -
>   drivers/ata/libata.h      |   52 +
>   include/linux/libata.h    |   32 -
>   8 files changed, 1365 insertions(+), 1240 deletions(-)

You did a good job of avoiding the "#ifdef ugliness" problem that often 
plagues patches like this.

However, let's not mix code movement in with the rest of the separation. 
  Code movement into drivers/ata/libata-sata.c should be a separate, 
first patch.  Patch #1 should link and behave as before (excepting the 
addition of libata-sata.c to the build of course).

Creating no-op stubs and CONFIG_SATA_HOST is a separate change after 
code movement.

	Jeff



