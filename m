Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1CWLNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:13:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46781 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Bfku+2DjjLjrCBH1HWPfszYUzet/rWtTr5MH5HfNvGT4VJQxycoKTimubNoRoYjX9c
         QBhQHs7OYeWEr4GOx9RZef6k30BoTCLeEjr4FqOLQiJUOYfMpADf8Vl5jjElnyiWKwBk
         tOj48KPr5MQto91SMcH52R3w2Jz8yVM/K6xYc=
Message-ID: <4D89D5EB.50803@linaro.org>
Date: Wed, 23 Mar 2011 11:13:47 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	<20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>	<4D89C618.1020608@linaro.org>	<201103231132.02690.arnd@arndb.de>	<4D89CDE4.3000504@linaro.org> <20110323105607.50697c65@lxorguk.ukuu.org.uk>
In-Reply-To: <20110323105607.50697c65@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 10:56 AM, Somebody in the thread at some point said:
>>> rules for the default device name that usbnet assigns. Simply letting
>>> a device driver flag "this is always an external ethernet, not
>>> a point-to-point connection" would be enough to solve this problem,
>>> and take some of the heat out of the discussion for how to solve
>>> the MAC address assignment.
>>
>> Completely agree, I have a happy feeling being able to say that too.
>> But I already see there's no path through Greg let alone Alan, so it'll
>> have to be dealt with a less good way.
>
> Having a USB net driver flag the fact it knows from its vid/did that it
> is probably P2P rather than net (or vice versa) isn't something I see a
> problem with, it's probably quite helpful for various network
> autoconfigurator guesses. What we don't want however is the kernel
> deciding the naming scheme should change. Name tweaks are really policy,
> knowing if an interface vid/did say its P2P or net is merely information
> that can guide a policy in user space.
>
> Now if your user space uses that flag to issue ifrenames fine, that's
> your choice. It's probably sufficient just to set IFF_POINTOPOINT
> appropriately on the net interface flags to make all that work ?

The problem is "[my] user space" in this case is generic Ubuntu 
basically.  It'd be a new thing to that, that it had to understand it 
woke up on specifically a Panda and do Panda quirks like clear 
IFF_POINTTOPOINT on a magic interface.  From a userland perspective, I 
would fairly I think term it "stinking it up" with board-specific 
quirks, so far generic distro userlands are AFAIK able to avoid that 
whole class of hack.  I mean there's nothing in Fedora that snoops 
/proc/cpuinfo to see what it is running on and then do some special 
scripts at init AFAIK, that is in fact what you are suggesting unless I 
badly misunderstand you.

The issue is Panda has smsc95xx USB <-> Ethernet bridge chip soldered on 
the board wired up to a fixed USB Host port.  This is indistinguishable 
from an smsc95xx you can buy in a pluggable USB / Ethernet dongle, and 
since there's no MAC address EEPROM on the board it could use, to the 
point they can report the same vid:pid; but you'd expect the dongle to 
come as usb%d as udev would already have it perfectly correctly.  So 
vid:pid alone is not a basis for distinguishing what to do here.

That is why I characterize the issue as being one of board-specific 
physical knowledge that should live in the kernel's board definition 
file (Arnd would characterize it similarly but involving Device Tree, 
but the same basic deal).  The board definition file knows, not that all 
device of that vid:pid should choose eth%d not usb%d which is not its 
business to know, but that the usb device on the specific wired-up USB 
port to the RJ45 soldered on the board should be guided a particular way 
when the interface name is registered.  That can only be done properly 
in-kernel by passing in a flag to usbnet specific to the device instance 
to guide its choice.

-Andy
