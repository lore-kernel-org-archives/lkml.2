Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2DKLic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:38:32 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:33090 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2DKLib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:38:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F856D32.8000009@cam.ac.uk>
Date: Wed, 11 Apr 2012 12:38:26 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk> <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <20120411112411.11825eec@pyramind.ukuu.org.uk>
In-Reply-To: <20120411112411.11825eec@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 11:24 AM, Alan Cox wrote:
>>> Non-staging code cannot depend upon staging code. That is the rule GregKH
>>> laid down. The Intel drivers involved are established non staging drivers
>>> and the gpadc layer is basically cleaning up the fact they all do this
>>> themselves in private right now without any central co-ordination or
>>> abstraction.
>> So, that's a bit different and not at all obvious from your e-mail - the
>> diffstat shows only the code you're adding, not the code you've factored
>> out of the existing mainline drivers.  The diffstat you posted was:
>>
>> | arch/x86/include/asm/intel_mid_gpadc.h   |   13 +
>> | arch/x86/platform/mrst/Makefile          |    1
>> | arch/x86/platform/mrst/intel_mid_gpadc.c |  645 ++++++++++++++++++++++++++++++
>> | arch/x86/platform/mrst/mrst.c            |    6
>> | 4 files changed, 665 insertions(+), 0 deletions(-)
>>
>> which is a pure addition of code and I'm not seeing anything in the
>> changelog about this either.
> True.. the code factoring out stuff is supposed to follow once this is
> sorted.
>
>> We do have to be careful about this sort of "this is a little bit of low
>> level code" thing - it (along with "our hardware is unique") comes up
>> rather a lot and it's often missing a good chunk of the picture.
> Yes. But it also helps - there is no user space API here so the only bit
> of IIO that needs importing is small, and if the API in kernel changes
> nothing userspace will break.
If only it separated that well.  There are numerous bits of iio that 
need to hack into
the core structures still. I wish there weren't but they are there.
>
> I don't btw think that layer should depend upon IIO though - IIO should
> depend upon that layer. There's no need to drag all the rest of IIO in
> for this, just as it can depend upon the gpio layer etc.
I have no problem with additional abstractions below. What I want to 
avoid is having
two equivalent interfaces.
>
> If that code gets pulled out of IIO dumped into drivers/adc and has a bit
> of a different API to the gpadc code then no problem, gpadc can follow it
> happily enough. IIO can use it from staging and IIO can migrate whenever.
Just to restate this. It doesn't go in drivers/adc. That would cover a 
tiny corner of the scope
of IIO and make the ripped out bit effectively useless for the rest.  We 
ended up with IIO because
we couldn't come up with a term that meant input / output devices that 
are analog (in some sense)
but not hwmon or human input related.  Other name suggestions welcome!

I'm not against this in principle but don't have the time and it will 
have to be carefully handled
to not end up with something so limited that it is useless for IIO's 
current drivers.
Now days there is actually relatively little bloat in the IIO core.

In the short term I'll look at making the sysfs interfaces a build time 
option for a driver or two.

As ever it comes down to man hours.
>
> It does make sense to think hard about userspace APIs for IIO but for
> kernel APIs its really being too conservative - we break kernel APIs
> every release. They are not set into stone.
No problem with that.   The recent core changes have all been about 
adding enough
support for the cases Mark raised (which are pretty much the same as here).
>
> Alan

