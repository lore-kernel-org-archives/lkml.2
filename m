Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1BUVXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:23:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61639 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1BUVXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Be8UTP6W9VI2US50waenc9XcS9y6EbyBp7TCDwihcsoB9RClPTtPNX/CTXZDSEGoc2
         qGxKoRdwOKAgMCGECw9e/tkWCjPEuXejpeSTO9P45HOMLLF8AsfZ1CSFMFhMH8FCzAN8
         IIiW4YImydS9FKQof9VVBrN1RawKeFCkmAUq4=
MIME-Version: 1.0
In-Reply-To: <4D627B7F.7000409@metafoo.de>
References: <1297539554-13957-8-git-send-email-lars@metafoo.de>
	<1297652493-7207-1-git-send-email-lars@metafoo.de>
	<AANLkTimn2JYtUSUrJBQKzXrw+URD5n0Y2h7QMaFzKFdY@mail.gmail.com>
	<4D59A93A.7090800@metafoo.de>
	<AANLkTi=RJfYEoiCPgesmZUoeOy+MehZQWeWDCWoW7vnh@mail.gmail.com>
	<AANLkTik6df6X2Jw8m6SYCFi9aN2LZc=C72WCw=gDevOr@mail.gmail.com>
	<4D622243.8030507@metafoo.de>
	<AANLkTinB8i+UK2gb88Fy0zf8EO0nYksTOmZVfDOWRRro@mail.gmail.com>
	<4D627B7F.7000409@metafoo.de>
Date: Mon, 21 Feb 2011 23:23:07 +0200
Message-ID: <AANLkTi=ka8vSnXwsP7cV-fQ-kJFWWWqO6cHoHo7MO2MT@mail.gmail.com>
Subject: Re: [PATCH 07/14 v3] bq27x00: Cache battery registers
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 4:49 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/21/2011 03:00 PM, Grazvydas Ignotas wrote:
>> It comes from power_supply_changed, probably omitted because
>> queue_work is a tail function of power_supply_changed. It's probably
>> something i2c specific, I could try bisecting it for you if you like,
>> I know it doesn't happen before this series.
>
> Hi
>
> The following patch should hopefully fix the issue.

Indeed it does, everything is working nicely now.
For the whole series:
Tested-by: Grazvydas Ignotas <notasas@gmail.com>

>
> From 860fc31cef00bd87085100825ddbff82ad601c33 Mon Sep 17 00:00:00 2001
> From: Lars-Peter Clausen <lars@metafoo.de>
> Date: Mon, 21 Feb 2011 15:34:19 +0100
> Subject: [PATCH] Initialize power_supply changed_work before calling device_add
>
> Calling device_add causes a uevent for that device to be generated.
> The power_supply uevent function calls the drivers get_property function,
> which might causes the driver to update its state, which again might causes
> the driver to call power_supply_changed(). Since the power_supplys
> changed_work has not been initialized at this point the behavior is
> undefined and might result in a OOPS.
>
> This patch fixes the issue by initializing the power_supplys changed_work
> prior to adding the power_supplys device to the device tree.
>
> Reported-by: Grazvydas Ignotas <notasas@gmail.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/power_supply_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
> index 970f733..329b46b 100644
> --- a/drivers/power/power_supply_core.c
> +++ b/drivers/power/power_supply_core.c
> @@ -171,6 +171,8 @@ int power_supply_register(struct device *parent, struct
> power_supply *psy)
>        dev_set_drvdata(dev, psy);
>        psy->dev = dev;
>
> +       INIT_WORK(&psy->changed_work, power_supply_changed_work);
> +
>        rc = kobject_set_name(&dev->kobj, "%s", psy->name);
>        if (rc)
>                goto kobject_set_name_failed;
> @@ -179,8 +181,6 @@ int power_supply_register(struct device *parent, struct
> power_supply *psy)
>        if (rc)
>                goto device_add_failed;
>
> -       INIT_WORK(&psy->changed_work, power_supply_changed_work);
> -
>        rc = power_supply_create_triggers(psy);
>        if (rc)
>                goto create_triggers_failed;
> --
> 1.7.2.3
>
>
