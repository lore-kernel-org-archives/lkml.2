Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1CGPdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:33:46 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:54275 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1CGPdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:33:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XaKz70m8dagUZCkHusDPHLyW2M1fBJ6nXUBtWEjUtAn/R5sBDZRAmF6BtgPwvBvcPP
         0JW3frrfQB9BpgRCHn73LGkspOR42+omilnTG68YuJaMe8otDz6gVqCydou7ZVcC/pVZ
         8VARceR8jZN68CNN2Up79tA4fE2DpInXOPt3g=
MIME-Version: 1.0
In-Reply-To: <20110307145931.GK13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com> <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com> <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <20110307145931.GK13471@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 7 Mar 2011 10:33:25 -0500
Message-ID: <AANLkTi=e1xDz6fhBU7NL32DXL1J9Y1CDD2bHQVL6oASw@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 09:59, Mark Brown wrote:
> On Mon, Mar 07, 2011 at 07:29:12AM -0500, Mike Frysinger wrote:
>> On Mon, Mar 7, 2011 at 07:15, Mark Brown wrote:
>> > It'd seem easier to just merge the two patches together rather than
>> > trying to deal with cross-tree issues.
>>
>> that sounds like a terrible idea.  they're logically different
>> changesets and we shouldnt be squashing them together simply to work
>> around problems with process workflows.
>
> I'm not saying squash the changes, I'm saying apply them both via the
> same tree.

merging trees != merging patches ;)

>> > Right, and this isn't a particularly unusual requirement especially if
>> > the driver isn't going to have any ability to interact with the DSP (at
>> > which point it's just coefficient data, the fact that it's a DSP program
>> > is uninteresting).  The problem is that this isn't a great interface for
>> > doing that.
>
>> i dont see suggestions of a better interface anywhere ...
>
> It currently isn't and I'd encourage you to contribute to the discussion
> that's been going on on this, or even better help out with code.  There
> was some discussion on the list recently (in the past month IIRC).

i'd be looking at Cliff/Michael for this.  the ADI linux team has been
restructured and audio parts are handled by Michael's new group now.

>> wrt stream flows, all the customers we've talked to are fine with this
>> -- having stream control be an application issue.  their application
>> is driving the codec directly and knows when it needs to change the
>> firmware, so it pauses its alsa flow, loads the new firmware, and
>> moves on.
>
> I'd expect that the driver would at least error out if the user tried to
> do the wrong thing here, like I say currently the firmware code is just
> not joined up with anything else at all.

i dont see how the driver can detect a "wrong" thing.  the driver has
no idea what arbitrary code the user is going to load and what that
code is going to do, or validate the code in any way.  this is why the
firmware has a small crc header on it -- we only make sure that what
the user compiled at build time matches what is loaded into the
hardware.

>> that said, i dont see anything in asoc today to address this, so if
>> we're simply missing it, please highlight it for us.
>
> There's handling of this in a bunch of drivers for things like EQ
> coefficients - the missing bit is a way of telling the driver that there
> are new coefficient sets available at runtime, at the minute everything
> that supports this enumerates the available coefficient sets in platform
> data and presents the user with an enumeration.

i'm not sure that example is applicable ... or if it is, it's a pretty
rough fit to the point of not being worthwhile

>> > It's also not an interface which offers any kind of discoverability or
>> > enumerability, meaning that it's not suitable for integration into
>> > application layer code such as the use case manager.  Applications need
>> > to be hard coded to know that a particular magic sysfs file needs to be
>> > poked.  This would be a big step backwards in terms of the ability to
>> > run off the shelf application software.
>
>> i dont see the issue here.  the firmware is *optional* and does not
>> impair basic audio output.  further, the firmware is fully
>
> If the firmware is totally optional the driver needs updating -
> currently at startup it does:
>
> | +       /* Load default program */
> | +       ret = adau1701_setprogram(codec);
> | +       if (ret < 0) {
> | +               printk(KERN_ERR "Loading program data failed\n");
> | +               goto error;
> | +       }
>
> which will make the firmware mandatory.  In any case, the interface
> issues are there if the firmware is optional or not.

i believe that is an error in the driver.  Cliff can obviously correct
me here since he's actually working on the codec.

>> written/compiled/maintained by the end customer, just like the
>> application.  which means there is no "magic" here -- the end customer
>> is the wizard.
>>
>> there is no "stock" firmware that ADI or anyone provides for any of
>> these SigmaDSP audio codecs.
>
> The question of where the DSP firmware (or coefficient data) comes from
> is orthogonal to the issue of runtime management of the data.  The issue
> is how the application layer can tell if there are multiple coefficient
> sets and change between them, either directly or via something like UCM.
> Even if the system is using a custom application rather than an off the
> shelf distribution (which are becoming more and more common in embedded
> systems) there's no reason they shouldn't be able to rely on standard
> tools for managing their audio configurations.

if the standard tools existed today, i'd of course agree.  but as you
indicated there's nothing right now for us to bug off of.  so how
userspace "probes" for existing data would be however the end user
chooses to manage things.  it's not like the standard tools could
really provide anything other than a simple string that indicates
"some blob exists with name xxx".  the meaning/metadata that surrounds
xxx isnt really relevant from the kernel's pov.

> At present userspace can enumerate and change the runtime configuration
> the system offers via the ALSA APIs (and this will get even better once
> the media controller API starts being used).  This means that you can
> fairly easily write a userspace that'll run on pretty much any Linux
> audio hardware, adapting with pure configuration for which you can
> provide point and click tuning (realistically by allowing the user to
> configure via standard ALSA tools and offering a "save as use case" type
> interface).  If we start adding backdoors to drivers we're taking a step
> back from where we are currently by requiring that the application layer
> know magic stuff about individual systems in order to work with them.

from how we've seen people using these codecs, this scenario doesnt
make much sense.  the different algorithms would be loaded on the fly
by the application and its current operating needs, not a single
algorithm selected by the ender user that wouldnt change for the life
of the app.  not saying the scenario would never come up, just that it
isnt the one we'd be focused on.
-mike
