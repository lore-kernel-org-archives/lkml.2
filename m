Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab0HDGaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:30:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58549 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197Ab0HDG37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:29:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j2xD+Mou1XVzkCzg9w/yzNXSl8tziHvonP6pD+rQlP67NCQ6pIN1Suo7RrrKPaPUwP
         h4Ondm6NT4HFeKaR/2nPYYrrQ9L3Sc7onoDsPEALnd5w8GETVEPw7rfuXf03qkUFm5oq
         sqIfzB09uFKDzoX9PeM4YFngSrrTVaf0dLW5g=
Date: Tue, 3 Aug 2010 23:29:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Anisse Astier <anisse@astier.eu>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100804062954.GA28706@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100514145539.GA5598@srcf.ucam.org>
 <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
 <20100804062021.GA25742@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804062021.GA25742@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:20:22PM -0700, Dmitry Torokhov wrote:
> On Fri, May 14, 2010 at 08:16:34AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 14 May 2010, Matthew Garrett wrote:
> > >
> > > I've done some experimentation under qemu. On ACPI systems, Windows will 
> > > *only* touch the keyboard controller if there's a device with an 
> > > appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> > > Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> > > their keyboard probing is also somewhat different to ours, but that's 
> > > probably another story.
> > 
> > Well, I'd hate to lose the keyboard hotplug capability, but at the same 
> > time, it _is_ 2010, and while I have personally used it historically, I 
> > don't really foresee ever using it again.
> > 
> > So we _could_ decide to just try it, and see if anybody screams. If nobody 
> > does, that would be a very simple solution to the problem.
> > 
> 
> OK, time to ressurect the topic ;)
> 
> There is another report (from Anisse - CCed) - MSI AE2220 stops for 10
> seconds when we try to see if "AUX DISABLE" command took effect (it
> doesn't). While we should reduce the time we wait and retry to something
> more reasonable it woudl not fix this issue completely.
> 

Hm, I take it back.. We won't be able to reduce timeout because we don't
hit that code yet. Here is the excerpt from dmesg:

[    0.500931] drivers/input/serio/i8042.c: a7 -> i8042 (command) [9]
[    0.502950] drivers/input/serio/i8042.c: 20 -> i8042 (command) [10]
[    0.502950] drivers/input/serio/i8042.c:      -- i8042 (timeout) [10]
[   11.045100] Failed to disable AUX port, but continuing anyway... Is this a SiS?
[   11.049741] If AUX port is really absent please use the 'i8042.noaux' option.
[   11.055417] drivers/input/serio/i8042.c: a8 -> i8042 (command) [13]
[   11.057436] drivers/input/serio/i8042.c: 20 -> i8042 (command) [14]
[   11.057436] drivers/input/serio/i8042.c:      -- i8042 (timeout) [14]

We try do disable AUX and then read back the control register. We see
there isn't any data coming and then box goes away for 10 seconds.
And if we don't touch AUX port all is good...

> The box does not have any PS/2 ports but in this case BIOS writers _did_
> some crack and put PS/2 devices in DSDT. While the devices are most
> likely not active and thus Matthew's patch would help Anisse I do hate
> to loose the option of plugging PS/2 mouse/keyboard after boot and
> having chance of them working. I would still like to add a few blacklist
> entries instead.
> 

-- 
Dmitry
