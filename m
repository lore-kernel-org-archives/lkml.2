Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0ERM03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:26:29 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:34312 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0ERM0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Awn0RUb2WC/IbDldIAWI3/BGNASxlJxwZRXDid1tUyRKmQqWpVO045UNFDu0jTpxOT
         gqRmpyPGBwYB1ce1daTt7VahHx5IjfJdrvKHCuO/NlzLvJ68uP0vKv0waiJ/ZLV0FWD3
         nAnu9tBdMfhNmwgNc10r1RaS0QX8UpRi79bN8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1005172258360.27232@asgard.lang.hm>
References: <AANLkTil73ArhX2w6b_v1bmWjP1FA5zUTfPzK2N4waOu1@mail.gmail.com>
	 <87tyq63eux.fsf@basil.nowhere.org>
	 <AANLkTiktV26Xu_qXFPdTRMLe5UwWnjpqvEKitjRElF6R@mail.gmail.com>
	 <1274102511.4418.18.camel@mulgrave.site>
	 <AANLkTil9lmdG5LY2SFk3cMsPOK-gUm2diMFL_o5bT08u@mail.gmail.com>
	 <1274106526.4418.40.camel@mulgrave.site>
	 <alpine.DEB.2.01.1005172258360.27232@asgard.lang.hm>
Date: Tue, 18 May 2010 08:26:24 -0400
Message-ID: <AANLkTiltKYV6_usOnIhjg699vsnXVJ3vJlt63RfIfBJY@mail.gmail.com>
Subject: Re: [ANNOUNCE] GSoC project: Improving kconfig using a SAT solver
From: Jon Smirl <jonsmirl@gmail.com>
To: david@lang.hm
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Bart Massey <bart@cs.pdx.edu>,
       Michal Marek <mmarek@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 2:03 AM,  <david@lang.hm> wrote:
> On Mon, 17 May 2010, James Bottomley wrote:
>
>> On Mon, 2010-05-17 at 16:21 +0200, Vegard Nossum wrote:
>>>
>>> On 17 May 2010 15:21, James Bottomley
>>>
>>> Even if the problem is different from zypper's, it is also here
>>> possible to get an unsatisfiable instance. You are right that, yes,
>>> the kconfig files on their own should always be satisfiable. But
>>> that's before the user has made any choices at all. An example of an
>>> unsatisfiable instance would be one where the user demands that 1.
>>> some USB driver is enabled, while 2. USB support in general is
>>> disabled.
>>
>> Actually, these are two separate problems.  The first is basic
>> consistency within the Kconfig subsytstem (something that select
>> currently damages for us).  The second is what to present to the user,
>> which is where the inception of the select problem came from.  A user
>> doesn't really want to know that USB device X depends on usb storage,
>> SCSI and a raft of other things ... they just want it to configure a
>> kernel that supports their device.  In particular, we don't want to
>> present every possible option to users and then try to work out a
>> solution, we really need guided configuration (which, in some measure,
>> is what we have today: if you don't select general USB, you won't see
>> any USB drivers.  Or more importantly, if you select an Adaptec SCSI
>> card, we just enable whichever transport library it needs).
>
> There are two modes people can be in when configuring a kernel.
>
> 1. I want to configure a kernel to support my hardware, enable anything else
> needed to make it work.
>
> 2. I really care about having a small kernel, don't enable anything I have
> disabled (but help me figure out why something I want isn't available)
>
> I don't think that hiding hardware from the user is ever the best thing to
> do. for approach #1 you obviously don't want to hide anything, but even for
> approach #2, someone may not realize that by disabling one option they are
> making it impossible to support something, and as someone who spent a bunch
> of time hunting through config to find options that I ended up finding were
> not available without enabling something else, I much prefer to see the
> option, but see it disabled rather than not being sure if it should be
> there, or somewhere else in the config.

I have to agree with this. An example is audio drivers that disappear
because something like SPI is turned off. Sometimes I have to read the
Kconfig files to figure out what subsystems I need enabled in order to
make the driver appear as a choice.

Another way this could work...
Enable the platform
this causes all subsystems on the platform (usb, spi, pci, etc) to be
soft enabled
user selects device drivers or hard enables the subsystem
on save, if the subsystem wasn't hard enabled for some reason or
dependency, disable it.

---------------

I'd also find it useful if Kconfig had an option that analyzed the
system it is running on and then generated the minimal set of drivers
needed to support it. Assume that the system is running something like
the Ubuntu kernel with every driver enabled. Then figure out the
minimal build footprint for a custom kernel to support the same
hardware.  I do this by hand, but a button for doing it would be a lot
easier.

>
> David Lang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
