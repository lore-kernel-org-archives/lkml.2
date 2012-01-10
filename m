Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2AJRJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:09:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49427 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab2AJRJl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120110001447.GK30766@opensource.wolfsonmicro.com>
References: <1326111140.22107.9.camel@sw-eng-lt-dc-vm2>
	<20120109161456.GC2974@opensource.wolfsonmicro.com>
	<CAEqHmAte=rvhjGUEdMgNQKfvPxSVTFR5TfWy13VPEhZj0T53KQ@mail.gmail.com>
	<20120109200734.GB30766@opensource.wolfsonmicro.com>
	<CAEqHmAtmHjEJUdvkBPhF5PzP4V_xDc5owLJpp0DENsXLs_ynxQ@mail.gmail.com>
	<20120110001447.GK30766@opensource.wolfsonmicro.com>
Date: Tue, 10 Jan 2012 17:09:40 +0000
Message-ID: <CAEqHmAtrUNKTxt3Q8x7=nZNp09ajhyYQn3DmAKd3OUib9hLBUQ@mail.gmail.com>
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

On Tue, Jan 10, 2012 at 12:14 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jan 10, 2012 at 12:11:33AM +0000, dd diasemi wrote:
>
>> Making regulator_mode_to_status() returning an error allows to
>> simplify its usage:
>>       ret = regulator_mode_to_status(regulator_get_mode(rdev));
>>       if (ret < 0)
>>               ret = -EIO;
>
> That code would definitely be less than ideal - if we got an error back
> from the attempt to read the mode we ought to be returning that error
> not squashing it down to a single value.

Yes, indeed.

>> If that behaviour is deliberate, I would suggest to make it explicit:
>>       default:
>> -             return 0;
>> +             return REGULATOR_STATUS_OFF;
>
> That's not the deliberate behaviour, the deliberate behaviour is to
> return no mode if we didn't find one.

The behaviour is exactly the same in both cases, because
REGULATOR_STATUS_OFF == 0.

>From linux/regulator/driver.h:
enum regulator_status {
       REGULATOR_STATUS_OFF,
       REGULATOR_STATUS_ON,
       REGULATOR_STATUS_ERROR,
       /* fast/normal/idle/standby are flavors of "on" */
       REGULATOR_STATUS_FAST,
       REGULATOR_STATUS_NORMAL,
       REGULATOR_STATUS_IDLE,
       REGULATOR_STATUS_STANDBY,
};

So the only difference is that, the code:
       return 0;
is not obvious but still it will be interpreted as:
       return REGULATOR_STATUS_OFF;
by the caller of regulator_mode_to_status() when incorrect mode is passed.
Is it correct way to hide this behaviour rather than to make it explicit ?

And to set things up, should regulator_get_status() return negative
error code or REGULATOR_STATUS_OFF (0) on communication failure?
