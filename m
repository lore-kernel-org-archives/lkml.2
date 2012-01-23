Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2AWWf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:35:59 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59120 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:35:57 -0500
Date: Mon, 23 Jan 2012 17:35:51 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: khali@linux-fr.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] x86/platform: (TS-5500) revised ADC driver
Message-ID: <20120123173551.309af2eb@v0nbox>
In-Reply-To: <20120123155408.7d52e4da@v0nbox>
References: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20120121044631.GA4143@ericsson.com>
	<20120122203619.22fabe79@lenov0n>
	<20120123043645.GA14660@ericsson.com>
	<20120123155408.7d52e4da@v0nbox>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 15:54:08 -0500,
Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:

> On Sun, 22 Jan 2012 20:36:46 -0800,
> Guenter Roeck <guenter.roeck@ericsson.com> wrote: 
> > > > Regarding the location, I'd really like to know from the
> > > > powers-that-be if arch/x86/platform/ts5500/
> > > > or
> > > > 	drivers/platform/x86
> > > > or
> > > > 	drivers/hwmon
> > > > 
> > > > would be the appropriate location for a driver like this. As
> > > > mentioned before, my strong preference is drivers/hwmon, but I
> > > > would like to hear from others.
> > > 
> > > We should either split every driver into corresponding
> > > subdirectories, or put everything in a common platform directory.
> > > My first RFC patches set has every driver separated. As they are
> > > really specific to the platform, people seem to agree with
> > > grouping them, mainly because they won't be shared. I changed
> > > that in the following patches sets, and X86 maintainers seemed to
> > > be ok with that.
> > > 
> > > I'm ok with both solutions, but we should all agree on one.
> > > Maybe we should have other maintainers view on this?
> > > 
> > That is what I had asked for. I thought the whole point of
> > per-module directories was to have all drivers there. If that is no
> > longer true, fine with me; who am I to argue about something like
> > that. I'd just like to know.
> > 
> > > > Also, I am not sure if the current approach is appropriate to
> > > > start with. Looking at the datasheet as well as into existing
> > > > kernel code, it appears quite likely that some kind of more or
> > > > less generic MAX197 driver exists somewhere. The existence of
> > > > is_max197_installed() - without any calling code - is a strong
> > > > indication that this is the case, as well as the "static"
> > > > platform data in your original patch. It might be more
> > > > appropriate to take this more or less generic driver, move it to
> > > > drivers/hwmon, and provide - for example through platform data -
> > > > a means to read from and write to the chip on a per-platform
> > > > basis, ie with per-platform access functions.
> > > 
> > > You're right, it should be possible to create a generic max197
> > > driver and provide read/write functions through platform data. But
> > > we don't have a max197 right now... So it can stay as a compact
> > > TS-5500 ADC driver for the moment, and maybe we will split later.
> > > What do you think?
> > > 
> > I am lost. If you don't have a TS-5500 with max197, how do you test
> > the driver ?
> 
> Sorry, I wasn't clear. I meant the only max197 I have is the one
> behind the TS-5500 CPLD, I don't have any others to test
> independently.
> 
> > I had another look into the MAX197 and TS-5500 data sheets. In my
> > opinion, a generic MAX197 driver in drivers/hwmon combined with a
> > platform driver in the current location would be the way to go. That
> > driver would then also work for the other TS-5x00 systems. All you
> > need is a single chip access function in the platform code, since
> > the chip is always accessed with a write followed by a read.
> 
> I took a deeper look at the datasheets, and you're right, a MAX197
> driver seems to be a good choice. However, there are a number of
> differences between a direct usage of a MAX197 and the TS-5500 mapped
> MAX197.
> 
> To start a conversion of a channel for a given range and polarity, it
> consists on both sides of a u8 outb() call on pins 7-14 (i.e. bits
> D7-D0). To be notified when the result is ready, we can either set an
> IRQ on INT pin (falling edge), or poll it.
> Then on the MAX197, you read the pins 7-14, set pin HBEN to 1, and
> read the same pins again to get the 4 remaining bits. On the TS-5500,
> only polling is available, and the 12 bits are mapped on 2 registers.
> 
> I propose to write a max197 driver with default read and write
> functions. A platform_data will be used to specify the base address
> (pins 7-14), and eventually a custom read function pointer, which will
> be used instead of the default one if it is different of NULL.
> 
> What do you think?
> 
> I will write a max197 driver with default read and write functions. A
> platform_data will be used to specify the base address (pins 7-14),
> and eventually a custom read function pointer, which will be used
> instead of the default, if it is not NULL.
> 
> What do you think? 

Sorry for the duplicate :)

BTW, I've added Jean Delvare and the lm-sensors mailing list in Cc, in
case they have an opinion on this.

Thanks,


-- 
Vivien Didelot
Savoir-faire Linux Inc.
Tel: (514) 276-5468 #149
