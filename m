Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3AHTSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:18:07 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48704 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3AHTSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:18:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130108190657.GW5075@titan.lakedaemon.net>
References: <1357668987-3610-1-git-send-email-josh.coombs@gmail.com>
	<20130108190657.GW5075@titan.lakedaemon.net>
Date: Tue, 8 Jan 2013 14:18:04 -0500
Message-ID: <CAMW5UfY2vKEJ7K8tLJ1+JeKsr_hxtUTva9HGJxLan6k+KGdmvg@mail.gmail.com>
Subject: Re: [PATCH] Allow Marvell SATA driver to work with LEDS_TRIGGER_IDE_DISK
From: Josh Coombs <josh.coombs@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgarzik@pobox.com,
        linux-ide@vger.kernel.org,
        linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I only have access to Marvell's SATA controller for testing, so that
is why I only targeted it.  The Kconfig depends change makes perfect
sense.

Changing the name of the trigger might cause hardship for those
already using it, as they will have to update scripts/etc to account
for the name change.  Would it make more sense to add a second trigger
for SATA instead?

Josh C

On Tue, Jan 8, 2013 at 2:06 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Tue, Jan 08, 2013 at 01:16:27PM -0500, Joshua Coombs wrote:
>> Add a call to the IDE LED Trigger within the Marvell SATA driver to allow
>> Marvell SoC devices to show SATA activity via GPIO connected LEDs.
>>
>> Signed-off-by: Joshua Coombs <josh.coombs@gmail.com>
>> ---
>>  drivers/ata/sata_mv.c | 3 +++
>>  drivers/leds/Kconfig  | 3 +--
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index 68f4fb5..4aaf6f0 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -71,6 +71,7 @@
>>  #include <scsi/scsi_cmnd.h>
>>  #include <scsi/scsi_device.h>
>>  #include <linux/libata.h>
>> +#include <linux/leds.h>
>>
>>  #define DRV_NAME     "sata_mv"
>>  #define DRV_VERSION  "1.28"
>> @@ -1156,6 +1157,8 @@ static void mv_start_edma(struct ata_port *ap, void __iomem *port_mmio,
>>  {
>>       int want_ncq = (protocol == ATA_PROT_NCQ);
>>
>> +     ledtrig_ide_activity();
>> +
>>       if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
>>               int using_ncq = ((pp->pp_flags & MV_PP_FLAG_NCQ_EN) != 0);
>>               if (want_ncq != using_ncq)
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index b58bc8a..d2071d0 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -496,10 +496,9 @@ config LEDS_TRIGGER_ONESHOT
>>
>>  config LEDS_TRIGGER_IDE_DISK
>>       bool "LED IDE Disk Trigger"
>> -     depends on IDE_GD_ATA
>>       depends on LEDS_TRIGGERS
>>       help
>> -       This allows LEDs to be controlled by IDE disk activity.
>> +       This allows LEDs to be controlled by IDE or SATA disk activity.
>>         If unsure, say Y.
>>
>>  config LEDS_TRIGGER_HEARTBEAT
>
>
> Hmmm, I'm not sure about this.  Ideally, wouldn't all sata users want to
> have this option?  In which case, it should be changed to
> LEDS_TRIGGER_DISK_IO or similar.  However, this seems to be the first
> attempt at it:
>
> $ git grep ledtrig_ide_activity -- drivers/ata/*.c
> ...nada...
> $
>
> At any rate, I'd like to see this patch extended to facilitate other
> sata drivers using it.  eg adjusting the naming more appropriately, and
> 'depends on IDE_GD_ATA || ATA' or similar.  In it's current state, it
> should depend on IDE_GD_ATA || SATA_MV.
>
> thx,
>
> Jason.
