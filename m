Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1CIHZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 02:25:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1CIHZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 02:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dZj2145ItCn8BW8nIav+ofeBCj1jWFL6Z9jgCafY9YcomC1tp4ULu3wHvxrFxBE5ah
         ftelR+BsJFKDBe4XkJJwy4iG0OYjbPzbipuoPh+5Ho05Gnyz7KkRYDEzCJh4ZyOOzqbw
         iTPa8JHw5XfvNSuhxTTT4KIKtE26xWvg+tjew=
MIME-Version: 1.0
In-Reply-To: <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
	<20110307114142.GB13471@opensource.wolfsonmicro.com>
	<AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
	<20110307121502.GG13471@opensource.wolfsonmicro.com>
	<AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
Date: Wed, 9 Mar 2011 15:25:05 +0800
Message-ID: <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for Analog
 Devices ADAU1701 SigmaDSP
From: Cliff Cai <cliffcai.sh@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, cliff.cai@analog.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 8:29 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Mar 7, 2011 at 07:15, Mark Brown wrote:
>> On Mon, Mar 07, 2011 at 06:50:15AM -0500, Mike Frysinger wrote:
>>> On Mon, Mar 7, 2011 at 06:41, Mark Brown wrote:
>>> > I can't apply this driver until it's merged into ASoC via some means
>>>
>>> and andrew has been holding off on merging the firmware driver until
>>> something in mainline needs it.  once a driver gets to the point where
>>> you're fine with merging it, we can bug akpm to push the sigma
>>> firmware loader to linus.
>>
>> It'd seem easier to just merge the two patches together rather than
>> trying to deal with cross-tree issues.
>
> that sounds like a terrible idea.  they're logically different
> changesets and we shouldnt be squashing them together simply to work
> around problems with process workflows.
>
>>> > More generally this doesn't seem like a great interface - apparently the
>>> > device requries that firmware be loaded but the whole firmware load
>>> > process isn't at all joined up with the driver code meaning that the
>>> > application layer has to figure out when firmware needs to be reloaded,
>>> > there's no understanding on the part of the driver of what the firmware
>>> > on the device is doing or how it's glued into the audio subsystem.
>>
>>> the API should allow for userspace to specify the firmware name, but
>>> that's about it.  it is up to the userspace application to arbitrarily
>>> load different firmware files on the fly into the codec without the
>>> codec caring what's going into it.  often times the firmware is DSP
>>> code to do different post processing on the audio stream (cleanup or
>>> whatever).
>>
>> Right, and this isn't a particularly unusual requirement especially if
>> the driver isn't going to have any ability to interact with the DSP (at
>> which point it's just coefficient data, the fact that it's a DSP program
>> is uninteresting).  The problem is that this isn't a great interface for
>> doing that.
>
> i dont see suggestions of a better interface anywhere ...
>
>> At a really basic level the code is not at all integrated with either
>> power management or stream handling in ASoC meaning that the user could
>> try to download firmware in the middle of an active audio stream (which
>> isn't going to be ideal).  Obviously the driver doesn't really support
>> any kind of power management at the minute but if it were improved in
>> this area you'd also have issues with trying to download firmware while
>> the device is off which probably isn't going to work either.
>
> wrt pm, that's a trivial programming issue that would be resolved in
> the driver.  userspace need not care.
>
> wrt stream flows, all the customers we've talked to are fine with this
> -- having stream control be an application issue.  their application
> is driving the codec directly and knows when it needs to change the
> firmware, so it pauses its alsa flow, loads the new firmware, and
> moves on.
>
> that said, i dont see anything in asoc today to address this, so if
> we're simply missing it, please highlight it for us.
>
>> It's also not an interface which offers any kind of discoverability or
>> enumerability, meaning that it's not suitable for integration into
>> application layer code such as the use case manager.  Applications need
>> to be hard coded to know that a particular magic sysfs file needs to be
>> poked.  This would be a big step backwards in terms of the ability to
>> run off the shelf application software.
>
> i dont see the issue here.  the firmware is *optional* and does not
> impair basic audio output.  further, the firmware is fully
> written/compiled/maintained by the end customer, just like the
> application.  which means there is no "magic" here -- the end customer
> is the wizard.

it's a DSP,so firmware is not optional,actually there is default
internal program can be used
if no external firmware is downloaded,of cause, the internal program
is only used to test analog audio pass-through.

> there is no "stock" firmware that ADI or anyone provides for any of
> these SigmaDSP audio codecs.
> -mike
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>
