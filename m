Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1CICfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:35:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1CICfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CnFNPX8gkdeOlrBggBbvinO5yCbuS6g7n9aPdgVw7p02e9BVztQINzMSFExox/ZhsJ
         faagsRIW6vf/AKrv7frbR+Yr54M3vkH0RLQw4a+EDmRFlrcbSizqvL7ieogvBcSFEMtD
         mjgiIV7Y5mTIhuUfOxSDPGxf1EHJFCpBr5z3E=
MIME-Version: 1.0
In-Reply-To: <20110308133817.GE20944@opensource.wolfsonmicro.com>
References: <1299549838-9821-1-git-send-email-myungjoo.ham@samsung.com>
	<20110308133817.GE20944@opensource.wolfsonmicro.com>
Date: Wed, 9 Mar 2011 11:35:09 +0900
X-Google-Sender-Auth: -UVuX4Qh8icxie5Pp74rAsJvd4U
Message-ID: <AANLkTi=iXSMU4yH2xV_dYO5nf4E_zTRww1Y+32U7GQbs@mail.gmail.com>
Subject: Re: [PATCH] Regulator: add suspend-finish API for regulator core.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 10:38 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Mar 08, 2011 at 11:03:58AM +0900, MyungJoo Ham wrote:
>> The regulator core had suspend-prepare that turns off the regulators
>> when entering a system-wide suspend. However, it did not have
>> suspend-finish that recovers the change made by suspend-prepare and
>> depends on machine pm code or the regulator device or driver
>> doing so.
>
> This is a good idea, thanks for working on it.

Welcome.

>
> Your commit message is sligtly inaccurate as this isn't what
> suspend_prepare() is for, suspend_prepare() is for matching the suspend
> mode configuration of regulators that support that with the suspend mode
> Linux is using (RAM, disk and so on).  There is no need for this to
> recover the pre-suspend state as hardware implementing suspend mode
> configuration should be able to do so autonomously.
>
> Of course not all hardware supports a distinct suspend mode and for
> hardware that doesn't we should be doing pretty much this - it's a
> bit of a hole in our regulator support at the minute.  It should really
> be coupled with a soft suspend mode implementation which can put the
> regulators into an appropriate state for suspend on the way down.

Yes. It'd be more accurate to describe that the patch is to set states
of the regulators according to their state-related regulator values
(use_count, always_on) at resume.

>
>> +               if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
>> +                               rdev->desc->ops->enable) {
>> +                       error = rdev->desc->ops->enable(rdev);
>> +                       if (error)
>> +                               ret = error;
>
> We should probably also be turning off regulators that shouldn't be on -
> a regulator may default to being enabled when we don't want it.
> Thinking about it we can probably share most if not all of the code with
> regulator_init_complete()...
>
> Ideally we'd also restore voltages but that can always be added later.

Agreed. I'll add rdev->desc->ops->disable(rdev) for the else statement
of that if statement.

>
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(regulator_suspend_finish);
>
> Hrm, I'd really expect the core to be arranging for this to happen
> rather than exporting the function?  Though the sequencing so it gets
> called at the right time might be a bit tricky and I've not actually
> looked at the isues here.
>

Currently, it depends on machine's pm code calling
regulator_suspend_prepare. And, that's why I made
regulator_suspend_finish to be called by someone else. This appears to
be odd to me as well; however, probably, like
regulator_init_complete() is optional, some systems cannot allow
regulators to be controlled by regulator_suspend_prepare by default or
the executed position (after suspend_ops->prepare, right before
suspend_ops->enter, or ...) may vary. If we are to let the core
arrange regulator_suspend_prepare/finish, do you think putting it
right after "suspend_ops->prepare" and right before
"suspend_ops->enter"?


Version-2 Patch is incoming. (with disable feature at suspend_finish)

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
