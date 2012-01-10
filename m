Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2AJALg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:11:36 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47735 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933440Ab2AJALf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:11:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120109200734.GB30766@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
	<20120109161456.GC2974@opensource.wolfsonmicro.com>
	<CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com>
	<20120109200734.GB30766@opensource.wolfsonmicro.com>
Date: Tue, 10 Jan 2012 00:11:33 +0000
Message-ID: <CAEqHmAtmHjEJUdvkBPhF5PzP4V_xDc5owLJpp0DENsXLs_ynxQ@mail.gmail.com>
Subject: Re: drivers/regulator/core.c: Fixes mapping inside
 regulator_mode_to_status() and makes it returning -EINVAL on invalid input.
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 8:07 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 09, 2012 at 07:20:50PM +0000, dd diasemi wrote:
>> On Mon, Jan 9, 2012 at 4:14 PM, Mark Brown
>
>> >>       default:
>> >> -             return 0;
>> >> +             return -EINVAL;
>
>> > This behaviour is deliberate.
>
>> For this moment, the only usage is in one file in
>> wm831x_aldo_get_status() and wm831x_gp_ldo_get_status():
>>       ret = wm831x_aldo_get_mode(rdev);
>>       if (ret < 0)
>>               return ret;
>>       else
>>               return regulator_mode_to_status(ret);
>
>> The usage mistreats the signed value 'ret' as wm831x_aldo_get_mode()
>> always returns 0 on communication error. It effects in response as if
>> the regulator was off.
>
>> If that behaviour is deliberate, I would suggest to make it explicit:
>>       default:
>> -             return 0;
>> +             return REGULATOR_STATUS_OFF;
>
> That's not the deliberate behaviour, the deliberate behaviour is to
> return no mode if we didn't find one.

I am focusing now on regulator_mode_to_status(). It returns regulator
status inside int value. If driver passes 0 to the function (eg. in
case of communication failure), which is not a valid mode, either it
may return REGULATOR_STATUS_OFF (0) as a valid status or it may return
an error code.

I am aware, that dealing with communication problem is rather in
driver responsibility, than the framework itself, but keeping things
clear is also important, especially for framework.

Making regulator_mode_to_status() returning an error allows to
simplify its usage:
	ret = regulator_mode_to_status(regulator_get_mode(rdev));
	if (ret < 0)
		ret = -EIO;
