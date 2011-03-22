Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab1CVQE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:04:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60232 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1CVQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=NkBINe6eiRCt1F3R1xSnZcFGKJU5D0LUd0AKCuVjFX4v4vlvjLF1f9tawspro/2BSZ
         eNVhy0CLaQCpUKe250OleYo8r4iebHMS/k1IjwPZ53dQKXY2SOn07nfuq5CEyxSrpteO
         veizZMiaxbAutZ+4bgBhmxaktcqBhXY5zA45s=
Message-ID: <4D88C884.4020600@linaro.org>
Date: Tue, 22 Mar 2011 16:04:20 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jaswinder Singh <jaswinder.singh@linaro.org>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, benh@kernel.crashing.org, grant.likely@secretlab.ca,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>
In-Reply-To: <AANLkTikEtneWEu4iQgfKw-zkAT3Z=e7ohXgDq7oJAQvv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 03:05 PM, Somebody in the thread at some point said:

Hi -

>   Personally, I wouldn't have bothered thinking about some kernel-wide
> solution to the Panda SMSC9514 issue. I think defining Panda specific
>   udev rules to 'rename the SMSC9614 on USB1(?) to ETH0' is sufficient and
> legal to do. Bus enumeration algos change neither often nor enough.
> I believe there would be far riskier assumptions in filesystems already.

Not sure you got all the points there.  The interface index is not 
targeted at all, it's the interface class.  That is why I only talk 
about usb%d vs eth%d.

If you think about what userland has to do to correct that, it involves 
userland understanding that it is running on specifically a Panda board 
or other boards that need mangling, and it is looking at the device that 
is specifically the onboard one.  (You cannot do it from VID/PID because 
that same VID/PID can turn up in a second pluggable adapter case -- 
still an smsc95xx you see -- where you really would want it called 
usb%d.)  This is why elsewhere I refer to this as a "userland board 
quirk database" being needed to solve it in userland.  If it was 
simpler, sure, I wouldn't bother looking to guide the driver's choice in 
kernel because you can as pointed out meddle them from userland.  But if 
you look into what has to be done in Userland it's nothing like a normal 
udev handler based only on vid/pid.  Userland is actually super allergic 
to knowing directly what it is running on and making decisions based on 
that, for good reasons, and desperately wants to be generic leaving all 
board quirks for the kernel to hide.  And the machine definition file is 
designed to understand board-specific information.

In any event, the thread established that particular problem is unlikely 
to get solved in the mainline kernel.  So other than correct any 
misconception, there's no point going further into it as it stands.

> But I do agree it is nice to have system wide solutions whenever due.
> Like this attempted patchset. Which is based upon two questions :-
>
> Q(a) Can discoverable buses(USB, SDIO etc) legally need platform_data
> or similar?
>
> Q(b) If yes, what 'key' is most suitable for identifying the right device
>    to attach the data to ?
>
> (a) We already have a good example, of Panda's missing MAC. I am sure there
>   would be more to think of.

Having done the SDIO async platform_data support now, it turns out SDIO 
WLAN modules really do need platform_data already and at least in the 
(mainline) wl12xx case, go to some lengths to work around not having an 
api to deliver it.

>     Though it is illegal for a NIC to not have MAC address, no spec demands the
>   MAC be on some EEPROM or like. Theoretically, the NIC vendor could
> hand me a NIC
> and a note with it's unique MAC address scribbled :)
>   As Mark already noted, savings pile if we could save eeproms when a device is
> expected to ship in tens of thousands.
>   IIANM, Greg acknowledged passing MAC via board specific data
> structure(albeit via DT)
> It's a different matter that DT has many hearts to win(at least in ARM Linux)
> So, perhaps the answer to Q(a) is - Yes.
>
> (b) IMHO, though stable enough, the most obvious method of 'devpath association'
>   is indeed not future-proof.

What're you thinking it's not future-proof against?  As a 
path-structured string, it seems it should be ideal considering the same 
path elements are used in, eg, sysfs as string elements to describe 
device paths.  Since the strings are in the same tree as the things that 
generate them, it only means updating the strings if the generator for 
them changes.

>   Having parent pointers to compare sounds like a bit too intrusive.
>   People might want to suggest?

I spoke for half an hour with Grant Likely yesterday and showed him my 
patchset that now covers SDIO async platform_data and wl12xx WLAN 
particularly as found on Panda.  He asked for a couple of days to see if 
he could figure any different approach -- he made a point of saying non 
Device-Tree interestingly -- that he liked better.  I am not sure that 
he will find anything he likes better since after discussing it with 
him, his objection is platform_data itself, and that's what stuff like 
these WLAN modules on SDIO are already set up for.  Anyway I will study 
any suggestion.

What I saw from wl12xx though is there are already mainline drivers that 
can benefit from just delivering their existing platform_data via async 
platform_data api.  So I plan to wait for Grant's comments and release a 
new RFC patchset in the coming days.

-Andy
