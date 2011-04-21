Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1DUPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:23:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34914 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1DUPXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OTD1TBTDg+enqOfrx9CodNPy/38EqzuG4hQWaBo9OPJxBNQuhOu952/mzYcCoXjL1n
         h8/lNjlInr+IQ2UdVR29UCKh9Fd0wqvcXRHRxwFk5G9+eYVZnTOuegvwYS9magzyLmwf
         39PLE2+fpPI/ISMLA+6tzU8ILwTI6NBffVn1c=
MIME-Version: 1.0
In-Reply-To: <20110421120327.GD11788@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
	<1303300539-2941-1-git-send-email-haojian.zhuang@marvell.com>
	<20110421104204.GB11788@opensource.wolfsonmicro.com>
	<25B60CDC2F704E4E9D88FFD52780CB4C05CF0EF027@SC-VEXCH1.marvell.com>
	<20110421120327.GD11788@opensource.wolfsonmicro.com>
Date: Thu, 21 Apr 2011 23:23:19 +0800
Message-ID: <BANLkTik3w-uv95jHdBt7Q7qU54zc1=gCFA@mail.gmail.com>
Subject: Re: [PATCH 13/14] regulator: max8925: fix not add device if missing
 init data
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 8:03 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Apr 21, 2011 at 04:13:28AM -0700, Haojian Zhuang wrote:
>
>> >> +static struct regulator_init_data
>> >regulator_pdata[ARRAY_SIZE(regulator_devs)];
>
>> >That looks really suspicious, what happens if there's two of these
>> >devices in the system?
>
>> It's impossible to use two PMIC in one system. At least, I didn't hear.
>
> I don't believe that.  It's not going to be a common case but it will be
> possible.
>
OK, I can allocate memory to handle this.

>> >It's really unclear why the array is needed at all if you're registering
>> >the devices one at a time.
>
>> Although there're a lot of regulators, maybe only parts of them are used.
>> So only add the necessary one. Others will be passed. The number is got
>> from platform data.
>
> You're missing the point here.  You're registering a device at a time
> but for some reason the platform data is being stored in an array in
> order to pass it in, even though only a single element in the array is
> in use.
>
I can allocate memory for platform data.

>> >> -  if (pdata && pdata->regulator[0]) {
>> >> -          ret = mfd_add_devices(chip->dev, 0, &regulator_devs[0],
>> >> -                                ARRAY_SIZE(regulator_devs),
>> >> -                                &regulator_resources[0], 0);
>> >> -          if (ret < 0) {
>> >> -                  dev_err(chip->dev, "Failed to add regulator subdev\n");
>> >> -                  goto out_dev;
>> >> -          }
>
>> >Surely the only change that's needed here is to remove the check to see
>> >if pdata->regulator[0] is non-null?
>
>> All above changes are necessary to me.
>
> What makes you say this?  If you remove the check for the first entry
> being null then the driver will go and register all the regulators which
> seems fine.  That seems like it fixes the problem with skipping all the
> regulators if the first one has no platform data.
>
If I keep original method and only fix the null issue on regulator[0], I can
also register regulators. But it'll display error messages since
regulator_init_data is null while it's registers.

After switching to the current method, I only register the ones that I really
need. So I can avoid some error messages in boot time.

An array seems not good, and I can switch to allocate memory.

> You're really not explaining the changes you're trying to make here
> terribly well, the changes you're making seem very substantial relative
> to what you say you're trying to do.
>
Yes, I'll list all changes in log.
