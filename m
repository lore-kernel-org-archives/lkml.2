Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab2CBPIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:08:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42260 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2CBPIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:08:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of aaron.lwe@gmail.com designates 10.52.24.40 as permitted sender) smtp.mail=aaron.lwe@gmail.com; dkim=pass header.i=aaron.lwe@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330671765.3412.7.camel@minggr>
References: <Pine.LNX.4.44L0.1203011059230.9392-100000@netrider.rowland.org>
	<1330671765.3412.7.camel@minggr>
Date: Fri, 2 Mar 2012 23:08:10 +0800
X-Google-Sender-Auth: n0STHewCXxDRKngfEyXNW8cm4oI
Message-ID: <CAOzJMDRTbq5o+jCyTtaAW_RPysfY3LhQ9gFC-tsvM8bsnh=rxQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 8/8] [SCSI] sr: check and enable Zero-power ODD support
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 2, 2012 at 3:02 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Thu, 2012-03-01 at 11:02 -0500, Alan Stern wrote:
>> On Thu, 1 Mar 2012, Lin Ming wrote:
>>
>> > ZPODD(Zero Power Optical Disk Drive) is a new feature in
>> > SATA 3.1 specification. It provides a way to power off unused ODD.
>> >
>> > ZPODD support is checked in in sr_probe().
>> > can_power_off flag is set during suspend if ZPODD is supported.
>> >
>> > ATA port's runtime suspend callback will actually power off the ODD
>> > and its runtime resume callback will actually power on the ODD.
>> >
>> > When ODD is powered off(D3Cold state), inserting disk will trigger a
>> > wakeup event(GPE). GPE AML handler notifies the associated device. Then
>> > ODD is resumed in the notify handler.
>>
>> I have one stylistic comment on this patch...
>>
>> > diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
>> > index 37c8f6b..39b3d8c 100644
>> > --- a/drivers/scsi/sr.h
>> > +++ b/drivers/scsi/sr.h
>> > @@ -42,6 +42,9 @@ typedef struct scsi_cd {
>> >     unsigned readcd_cdda:1; /* reading audio data using READ_CD */
>> >     unsigned media_present:1;       /* media is present */
>> >
>> > +   unsigned zpodd:1;       /* is ZPODD supported */
>> > +   unsigned zpodd_event:1;
>> > +
>>
>> You should not expect your readers to understand what "ZPODD" means.
>> drivers/scsi/sr.h is used by lots of different people, many of whom
>> will have no idea what it refers to, especially since it is part of
>> the SATA spec and not the SCSI spec.  You should provide a brief
>> explanation.
>
> I'll add some explanation.
>
> But I'm thinking maybe it's better to move this flag to ata layer, for

Agree.

> example, adding a flag to libata.h
>
> ATA_DFLAG_ZPODD
>

How about ATA_DFLAG_DA(device attention)?
It follows the name used in the sata spec and this feature might have
other uses in the future in addition to zero power odd(just my wild guess).

> sr runtime pm is only enabled when ZPODD(or more general, power off) is
> supported.
> So the problem is how will sr driver know this flag?
>

What about adding a new field to scsi_device to reflect this capability of
the underlying sata device? We can then set this field in ata_scsi_scan_host.

-Aaron
