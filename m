Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2G1M1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 08:27:16 -0400
Received: from canardo.mork.no ([148.122.252.1]:53603 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2G1M1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 08:27:15 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarbojit Ganguly <unixman.linuxboy@gmail.com>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
Organization: m
References: <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org>
	<500D659E.5090207@gmail.com>
Date: Sat, 28 Jul 2012 14:27:02 +0200
In-Reply-To: <500D659E.5090207@gmail.com> (Daniel Mack's message of "Mon, 23
	Jul 2012 16:54:22 +0200")
Message-ID: <87r4rwvzop.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <zonque@gmail.com> writes:
> On 23.07.2012 16:47, Alan Stern wrote:
>> On Mon, 23 Jul 2012, Sarbojit Ganguly wrote:
>>> That is why I provided two stacks,
>>>
>>> 1st one is when I tried to remove the USB hub (which connects a webcam
>>> + microphone)
>>> 2nd one is when I tried to remove an USB powered external HDD.
>>>
>>> Just to make sure whether the problem is with USB sound or the USB subsystem.
>> 
>> Do you stop all the programs that are using the USB devices before 
>> unplugging the hub?  Do you unmount the USB HDD first?
>> 
>> The first crash shows a problem in the snd-usb-audio driver.
>> 
>> The second crash shows a problem in the VFS layer or in ext3, not in 
>> the USB stack.
>
> I dare to doubt there are two severe bugs of that kind that are 100%
> reproducible. I haven't had a  hotplug crash in any of the two drivers
> for a long time, and I use both of them extensively.

Actually, based on the recent usb_wwan experience, I'd say that two such
bugs isn't as unlikely as it may seem at first.  Even three if we add
the now fixed usb_wwan (or six, if we count the three drivers affected
by the usb_wwan bug).  There are probably even more.

The reason is this change:

 0998d0631 device-core: Ensure drvdata = NULL when no driver is bound


It will make bugs like this suddenly 100% reproducible.  But the bugs
*are* in the drivers, and may have been there for a long time.  The
drivers have been accessing drvdata after unbinding.  They just didn't
crash prior to that commit.

But the commit is correct, and a very much needed improvement if my
assumptions are correct.  The drivers need fixing and this just makes it
evident.

> I rather assume there's something else failing, probably some host
> controller issue that corrupts mempory? Can anyone else reproduce this
> maybe?

You could of course do like me and bisect, but if you end up with commit
0998d0631 then you haven't really learned more than confirming my guess.


Bjørn
