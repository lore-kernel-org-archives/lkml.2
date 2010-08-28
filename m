Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0H1QK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:10:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34634 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0H1QK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cPM3cpOsnoQrg62knosnXuMCcM3azF2dpfF8FtiMpmrp4qBVYj0NnX+BfvRm0LDU2F
         DEjguGVZlshj9ew21w7wROEqxNLEq87ngB3Gl+y8sKQl9dS2Q0KO/rg4DsgwxJNmb8XO
         NFmcWUaNKLh6Fwv9cCGT75DjZlS9o48/LJiOk=
MIME-Version: 1.0
In-Reply-To: <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
	<1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
Date: Sat, 28 Aug 2010 21:40:55 +0530
Message-ID: <AANLkTim=Zq7Pxixdwe_H-659cLZ2yybediDURGwvoO3=@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
From: Sundar <sunder.svit@gmail.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samu,

few minor comments,

On Fri, Aug 27, 2010 at 5:24 PM, Samu Onkalo <samu.p.onkalo@nokia.com> wrote:
> +
> +struct ak8974_chip {
> +       struct miscdevice       miscdev;
> +       struct mutex            lock;   /* Serialize access to chip */
> +       struct mutex            users_lock;
> +       struct i2c_client       *client;
> +       struct regulator_bulk_data regs[2];
> +       struct work_struct      work;
> +       wait_queue_head_t       misc_wait;
> +       loff_t                  offset;
> +
> +       int                     max_range;
> +       int                     users;
> +
> +       const char              *id;
> +       u8                      info[2];
> +
> +       s16                     x, y, z; /* Latest measurements */
> +       s8                      axis_x;
> +       s8                      axis_y;
> +       s8                      axis_z;
> +       bool                    valid;
> +
> +       char                    name[20];
> +};

This can be static ?

> +
> +       ak8974_regulators_off(chip);
> +

[..]

> +       if (err < 0) {
> +               dev_err(&chip->client->dev, "Device registration failed\n");
> +               goto fail3;
> +       }

[..]

> +       return 0;
> +fail4:
> +       misc_deregister(&chip->miscdev);
> +fail3:
> +       ak8974_regulators_off(chip);

in case of fail3, regulators get disabled twice. i think we will have
unbalanced calls to the supplies then.

> +
> +
> +#ifdef CONFIG_PM
> +static int ak8974_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +       struct ak8974_chip *chip = i2c_get_clientdata(client);
> +       mutex_lock(&chip->users_lock);
> +       if (chip->users > 0)
> +               ak8974_enable(chip, AK8974_PWR_OFF);
> +       mutex_unlock(&chip->users_lock);
> +       return 0;
> +}

Can we disable the regulators here too?

Regards,
Sundar
