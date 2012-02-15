Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2BOGG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:06:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34627 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2BOGGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:06:24 -0500
MIME-Version: 1.0
In-Reply-To: <1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
	<1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
Date: Wed, 15 Feb 2012 14:06:23 +0800
X-Google-Sender-Auth: PEBlhLA4igjKV0vRPq58hZq-Tqk
Message-ID: <CAOzJMDQHbM9Hyx_W=0nhzK+FTk5i5Hvvn00TerYH54-yH1so2A@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] libata: add ZPODD support
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Good work, I'm also working on ZPODD for AMD platforms, some comments below.

On Mon, Feb 13, 2012 at 5:11 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> ZPODD(Zero Power Optical Disk Drive) is a new feature in
> SATA 3.1 specification. It provides a way to power off unused CDROM.

I don't see anywhere in the sata 3.1 spec mentioned how to power off the
cdrom, the only relevant content is the newly defined device attention pin,
which is used to notify the host that this powered off device needs attention.
Or do I miss something?

>
> CDROM is powered off by executing ACPI power resource's _OFF method.
>

AMD has a different implementation to power off the CDROM, I'll need to
prepare another patch based on yours.

> When CDROM is powered off(D3Cold state), inserting disk will trigger a
> wakeup event(GPE). GPE AML handler notifies the associated device. Then
> CDROM is resumed in the notify handler.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/libata-acpi.c |   64 +++++++++++++++++++++++++++++++++++++-------
>  drivers/scsi/sr.c         |   39 +++++++++++++++++++++++++++
>  drivers/scsi/sr.h         |    3 ++
>  3 files changed, 95 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..bf4eace 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -716,6 +752,9 @@ static int sr_probe(struct device *dev)
>        disk->flags |= GENHD_FL_REMOVABLE;
>        add_disk(disk);
>
> +       if (device_run_wake(dev))
> +               cd->zpodd = 1;
> +

For a cd to support zero power, it has to support device attention pin.
If it does not support that, once it is powered off, it can't be power up
back. So I don't think device_run_wake is enough to set the zpodd flag,
unless your firmware has done the check and created the acpi table
according to the result. Is it the case?

Thanks,
Aaron
