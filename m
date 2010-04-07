Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0DGU3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:29:45 -0400
Received: from legolas.restena.lu ([158.64.1.34]:42396 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0DGU3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:29:43 -0400
Date: Wed, 7 Apr 2010 22:29:37 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-ID: <20100407222937.73ed530b@neptune.home>
In-Reply-To: <20100407131204.10759584.randy.dunlap@oracle.com>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
	<20100406105635.5384a087@pluto.restena.lu>
	<20100406082614.79aaf1c5.randy.dunlap@oracle.com>
	<20100406183535.7de3c628@neptune.home>
	<20100406095633.49ec957a.randy.dunlap@oracle.com>
	<20100407204404.5233ba6b@neptune.home>
	<20100407131204.10759584.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 7 Apr 2010 20:44:04 +0200 Bruno Prémont wrote:
> 
> > On Tue, 06 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > > 
> > > > One of my attempts did end up with a circular loop with regard to FB
> > > > (some of the FB drivers did select INPUT)?  
> > > 
> > >   (not that I can find)
> > > 
> > > CONFIG_VT does select INPUT
> > > and CONFIG_DRM_I915 does
> > > 	select INPUT if ACPI
> > 
> > A newer attempt still produces the same result:
> > 
> > drivers/input/Kconfig:9:error: found recursive dependency: INPUT ->
> >        HID_SUPPORT -> HID_PICOLCD_FB -> FB -> FB_STI -> VT -> INPUT
> > 
> > (it's only FB which causes the loop, LEDS, LCD and BACKLIGHT are fine)
> 
>   (yes, so I see)
> 
> > This is with following patch on top of the improved deps patch I sent
> > a few minutes ago deeper in this thread.
> > 
> > Is there a way around this?
> > 
> 
> Well, lesson #1 is that select is evil^W^W should only be used to enable
> library-like code, or as Documentation/kbuild/kconfig-language.txt says:
> 
>   Note:
> 	select should be used with care. select will force
> 	a symbol to a value without visiting the dependencies.
> 	By abusing select you are able to select a symbol FOO even
> 	if FOO depends on BAR that is not set.
> 	In general use select only for non-visible symbols
> 	(no prompts anywhere) and for symbols with no dependencies.
> 	That will limit the usefulness but on the other hand avoid
> 	the illegal configurations all over.
> 	kconfig should one day warn about such things.

I've read that paragraph and I would definitely prefer not to have to
use select for what this patch should achieve!

It should really be a helper for the user going through menuconfig like
"please check all what is needed to satisfy this item's dependencies"
A "try-select-deep" or whatever it could be called.

A well-behaved "GUI" implementation of this would show what would get newly
checked and give the user the opportunity to not proceed or fine-tune
y/m choices.

> (more below)
> 
> > 
> > diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> > index 782a34e..711c091 100644
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -285,7 +285,7 @@ config HID_PICOLCD_FB
> >  	bool "Framebuffer support"
> >  	default !EMBEDDED
> >  	depends on HID_PICOLCD
> > -	depends on HID_PICOLCD=FB || FB=y
> > +	select FB
> 
> If you'll go back to the unpatched (by this patch) version here,
> it seems to work OK.

So best is probably to just forget about all of this non-leaf select
usage for now. (and not have one half doing one way and the other half
doing it the other way)

Thanks,
Bruno

