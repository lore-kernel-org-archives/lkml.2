Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0CWWBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:01:15 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:53175 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754462Ab0CWWBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:01:14 -0400
Message-ID: <4BA93A43.2010807@bluewatersys.com>
Date: Wed, 24 Mar 2010 11:01:39 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] arm: add a /proc/cpuinfo platform extension
References: <BD79186B4FD85F4B8E60E381CAEE19090200F377@mi8nycmail19.Mi8.com> <4BA924CD.1010201@bluewatersys.com> <0D753D10438DA54287A00B02708426976368E58561@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B02708426976368E58561@AUSP01VMBX24.collaborationhost.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> On Tuesday, March 23, 2010 1:30 PM, Ryan Mallon wrote:
>> H Hartley Sweeten wrote:
>>> Add an optional platform specific extension to /proc/cpuinfo.
>>>
>>> Many platforms have custom cpu information that could be exposed
>>> to user space using /proc/cpuinfo.
>>>
>>> Patch 1/2 adds the necessary core support to allow a platform
>>> specific callback to dump this information.
>>>
>>> Patch 2/2 adds a callback to mach-ep93xx and hooks up all the
>>> edb93xx platforms.
>>>
>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>> I think this is unlikely to get merged in its current state. Russell has
>> mentioned issues with breaking userspace by changing /proc/cpuinfo. 
> 
> I don't agree with this point.
> 

[snip]

> 
> Even something as trivial as the BogoMIPS is in a different place in
> the two outputs and is spelled differently (due to caps).
> 
> The outputs are completely different.  Other architectures in
> mainline also have very different outputs.
> 
> I can't see any reason why adding additional fields will break
> user space, as long as an existing heading in the output is not
> duplicated.  Even that "really" shouldn't break anything since
> any application parsing this file has to do it sequentially and
> the new headings are located at the end of the file.

I'm really not sure. There may be some crappy userspace tools out there
which will break. I don't really mind either way if the info goes in
/proc/cpuinfo, or some new /proc/archinfo, just as long as it doesn't
break userspace in some way.

>> The other problem I see is that you have a single callback for registering
>> the arch specific information. In you ep93xx example, each of the ep93xx
>> boards must add:
>>
>>  .arch_cpuinfo = ep93xx_cpuinfo,
>>
>> If one of the boards has some additional information to make available,
>> it would need to reimplement the entire callback, which gets messy.
> 
> Not necessarily.
> 
> If a board, such as the ts72xx, wanted to add additional information
> it just has to register it's private callback then call the ep93xx core
> supplied callback at the desired point in it's private one.
> 
> The ts72xx currently does this exact thing with the .map_io callback.
> It supplies it's own private one to map the external FPGA.  It first calls
> the ep93xx core to map the ahb/apb space then it does an iotable_init to
> map the FPGA.

Okay, fair point. I still don't like having the seq_file callback being
in machine_desc. It means that all of the board files have to be edited
to add the callback. It should be something which happens automagically
in the platform core. Perhaps using a weak function for the callback, or
a #define check.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
