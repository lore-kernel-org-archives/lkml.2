Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031086Ab1EXBE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:04:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45459 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030717Ab1EXBEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a71RHm+xWRpWgHagOJEIQ7ipv6YNjUq+qV3GKA0h20U+hMTq9gbqORJeTkc8XYXWsu
         8E0/XH9DvXoTk5uSBEhA9yVr1Dbc7VKdOTgpMJ+0ahAvEtRBQJxmEW28WnYtfX/UfW/d
         VDmOzSQWivIkwi4yX9Be7sntIlCrcgb5b4SYY=
MIME-Version: 1.0
In-Reply-To: <20110523121310.GA24439@htj.dyndns.org>
References: <201105120025.34531.rjw@sisk.pl>
	<20633.1305565337@localhost>
	<BANLkTin7NgUMXSVyKn6P0TCrFZ5uaaRL1w@mail.gmail.com>
	<201105182144.37713.rjw@sisk.pl>
	<BANLkTimZ9pe-FhkJYHTG1Jx8MUPrMHSFbA@mail.gmail.com>
	<BANLkTim9_1Xt8oE4awbCO1iKUW96YUOv_A@mail.gmail.com>
	<10124.1305906020@localhost>
	<20110520154341.GL31426@htj.dyndns.org>
	<BANLkTi=iNjWsaYCJqP057FkhAXtab5nS=Q@mail.gmail.com>
	<20110523121310.GA24439@htj.dyndns.org>
Date: Mon, 23 May 2011 18:04:23 -0700
Message-ID: <BANLkTinJxu9+kSgb3jYBEBMy9igg0vp1FQ@mail.gmail.com>
Subject: Re: [PATCH v2.6.38-rc7] Revert "libata: ahci_start_engine compliant
 to AHCI spec"
From: Jian Peng <jipeng2005@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>, linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

Defintely. I will clarify it as much as possible and meanwhile, wait
for it to be tested by reporters.

Thanks,
Jian

On Mon, May 23, 2011 at 5:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, May 20, 2011 at 10:02:56AM -0700, Jian Peng wrote:
>> Hi, Tejun/Valdis,
>>
>> Since this is an interoperability issue of SATA host controller, the first
>> step I want to try it to make sure the tweak that MAKE my controller WORK
>> does not break other controllers.
>> You are both right that adding this majic 5ms delay at this place should not
>> be the final solution.
>>
>> If this magic 5ms delay works on other affected systems, I plan to post a
>> new patch that inside ahci_start_engine(), still perform same check, and
>> show warning message if failed, but will set a flag, then still set START
>> bit, and if there is such failure flag, add 5ms delay.
>
> Yeah, sounds like a plan but please add ample comment explaining
> what's going on for which controller including link to the mailing
> list threads.  As we're basically adding a black magic, I would still
> like to enable it only for the affected controllers so that we don't
> have to worry whether there are controllers which are affected by this
> problem but we don't know about.
>
>> --- a/drivers/ata/libahci.c 2011-05-18 14:23:36.564665643 -0700
>> +++ c/drivers/ata/libahci.c 2011-05-20 09:48:06.194663506 -0700
>> @@ -540,6 +540,7 @@
>>   void __iomem *port_mmio = ahci_port_base(ap);
>>   u32 tmp;
>>   u8 status;
>> + int err = 0;
>
> I think
>
>  bool stat_failed = false;
>
> would be more in line with recent coding style.
>
>>   status = readl(port_mmio + PORT_TFDATA) & 0xFF;
>>
>> @@ -553,12 +554,12 @@
>>    * specific controller will fail under this condition
>>    */
>>   if (status & (ATA_BUSY | ATA_DRQ))
>> -  return;
>> +  err = 1;
>>   else {
>>    ahci_scr_read(&ap->link, SCR_STATUS, &tmp);
>>
>>    if ((tmp & 0xf) != 0x3)
>> -   return;
>> +   err = 1;
>>   }
>>
>>   /* start DMA */
>> @@ -566,6 +567,13 @@
>>   tmp |= PORT_CMD_START;
>>   writel(tmp, port_mmio + PORT_CMD);
>>   readl(port_mmio + PORT_CMD); /* flush */
>> +
>> + /* Some controllers need longer time to be ready */
>> + if(err) {
>> +  printk(KERN_WARNING
>> +   "Controller in wrong state when setting START bit\n");
>> +  msleep(5);
>
>  ata_port_printk()?
>
> Thanks.
>
> --
> tejun
>
