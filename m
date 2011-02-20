Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1BTKi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 05:38:28 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48466 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1BTKiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 05:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TlngDTYodmrmTbNBNSftYkf2uQN2Vv2+soB7ivwQRnK3i0htOIdjlxdirTS4w5i6Xf
         f6x5ATgHYNhwgPmSp9nvP6sMwOLzeCOP3Bcki7XdX0AIzL+iV+obvKSsAwW877CB0P3k
         YJowvEsDYLH62hlT2cTPpHlCRUb8mJi64u+po=
MIME-Version: 1.0
In-Reply-To: <20110219164811.2e90de88@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<4D514754.30203@ru.mvista.com>
	<AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
	<20110219164811.2e90de88@lxorguk.ukuu.org.uk>
Date: Sun, 20 Feb 2011 11:38:23 +0100
Message-ID: <AANLkTi=Lj54hRfkn7qLwoQ7aGSchnzBwy4m2Uok764qD@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 5:48 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >   SLC90E66 datasheet only says that SIDETIM register has no effect without
>> > SITRE bit set.
>
> Which means the current setup is fine yes ?

That's the problem, the current setup is buggy in slave-only setups:

                slave_data |= ((timings[pio][0] << 2) |
timings[pio][1]) << shift;
                pci_write_config_byte(dev, 0x44, slave_data);
        }

        idetm_data |= 0x4000;   /* Ensure SITRE is set */
        pci_write_config_word(dev, idetm_port, idetm_data);

idetm_port needs to be programmed _before_ slave_data to "ensure SITRE is set".

IOW We currently depend on the BIOS here to set SITRE bit for us..

>> Alan, is this explanation sufficient to ACK this patch?  (Thanks
>> Sergei for digging it out.)
>>
>> Jeff, would it be possible to queue patches #01-15 for 2.6.39
>
> Have they been tested on the relevant hardware yet - I don't believe the
> changes should be made for the untested stuff and you indicated you
> agreed with that.

Unless they are obvious or risk is higher than benefit (bugfixes based
on code review).  I don't think that ATA code has became recently
special in this regard compared to the rest of the kernel.

> The tidyups for the easily tested cases (PIIX4 etc) look sensible

Please take look at the changes #01-15 then:

     ata_piix: SITRE handling fix
     ata_piix: unify code for programming PIO and MWDMA timings
     pata_efar: fix register naming used in efar_set_piomode()
     pata_efar: unify code for programming PIO and MWDMA timings
     pata_efar: always program master_data before slave_data
     pata_it8213: fix register naming used in it8213_set_piomode()
     pata_it8213: unify code for programming PIO and MWDMA timings
     pata_it8213: add UDMA100 and UDMA133 support
     pata_oldpiix: unify code for programming PIO and MWDMA timings
     pata_radisys: unify code for programming PIO and MWDMA timings
     pata_rdc: unify code for programming PIO and MWDMA timings
     pata_rdc: parallel scanning needs an extra locking
     pata_rdc: add Power Management support
     pata_oldpiix: add locking for parallel scanning
     pata_oldpiix: enable parallel scan

Most patches has been posted months ago in the past as the part of
atang tree.  They don't contain risky stuff (it was intentionally
pushed at the end of the patch queue).  We have here obvious register
naming unification, PIO/DMA folding (it was tested with ata_piix and
only later ported to other PIIX-like drivers) and:

* para_rdc: locking bug-fix and Power Management support

* pata_it8213: IDE -> libata regression fix (UDMA100/133 support based
on vendor / old IDE driver)

* pata_oldpiix: locking bug-fix (ACK-ed by you in the past) and
parallel scanning support

I see a lot of magnitude more risky stuff going elsewhere in the
kernel, including ATA itself and if there are any concerns left those
patches (#01-15) I'll be happy to address them.

Thanks,
Bartlomiej
