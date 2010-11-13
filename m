Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0KMDya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:54:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0KMDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:54:28 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=xFXFSQEJbasA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=60zBYf7NQLlsj5ocWeMA:9 a=l9poZfRVdKm_1NGOEZ0A:7 a=ZWarXlW8P9wpgIw7fQWTL5-MGKwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Failed build on randconfig for DVB_DIB modules
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <4CC6BD78.5040200@infradead.org>
References: <1288066536.18238.78.camel@gandalf.stny.rr.com>
	 <4CC6BD78.5040200@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 22:54:26 -0500
Message-ID: <1289620466.12418.583.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply, but KS and LPC got in the way.

Also added kbuild to the Cc.

On Tue, 2010-10-26 at 09:37 -0200, Mauro Carvalho Chehab wrote:
> Hi Steven,
> 
> Em 26-10-2010 02:15, Steven Rostedt escreveu:
> > I'm currently finishing up an automated test program (that I will be
> > publishing shortly). This program does various randconfig builds, boots
> > and tests (as well as bisecting and patch set testing). But enough about
> > it.
> > 
> > I hit this little build bug that is more annoying than anything else. If
> > I have the following configuration:
> > 
> > 
> > CONFIG_DVB_USB_DIBUSB_MB=y
> > CONFIG_DVB_USB_DIBUSB_MC=m
> > CONFIG_DVB_USB_NOVA_T_USB2=m
> > 
> > It fails to build with this error:
> > 
> > ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
> > ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/dvb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
> > ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> > ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> > 
> > Those undefined functions are defined in
> > drivers/media/dvb/dvb-usb/dibusb-common.c, but are surrounded by:
> > 
> > #if defined(CONFIG_DVB_DIB3000MC) || 					\
> > 	(defined(CONFIG_DVB_DIB3000MC_MODULE) && defined(MODULE))
> > 
> > Which Mauro updated in Dec 2007 with this commit:
> > 4a56087f3b7660c9824e9ec69b96ccf8d9b25d1c
> > due to just having CONFIG_DVB_DIB3000MC not enough.
> > 
> > Well, this is not enough either. Why?
> > 
> > On build the object dibusb-common.o is built first because of the
> > DVB_USB_DIBUSB_MB being builtin kernel core. Thus, it gets built with
> > the preprocessor condition false.
> > 
> > Then when the compile gets to the modules, the object dibusb-common.o
> > has already been built, and gets linked in as is.
> > 
> > We end up with the functions not defined and we get the above error.
> > 
> > My question: Why does that preprocessor condition exist? Can't we just
> > build those functions in regardless?
> 
> Not sure if I understood your question. Short answer is: No.

What about just changing it to:

#if defined(CONFIG_DVB_DIB3000MC) ||
		defined(CONFIG_DVB_DIB3000MC_MODULE)

Looking at the kbuild system scripts/Makefile.lib we have:

# When an object is listed to be built compiled-in and modular,
# only build the compiled-in version

obj-m := $(filter-out $(obj-y),$(obj-m))

So if this is defined as both a module and builtin, the module version
will never be built. Then we need that code in that #if block
regardless. No need for testing the define(MODULE).


> > 
> 
> A detailed explanation follows:
> 
> <detailed>
> 
> On DVB drivers, there are a few separate
> components:
> 	- Tuner - receives the signal from antenna, converting them into an
> 	intermediate frequency, tune to a station;
> 	- Demod - decodes the intermediate frame into a MPEG-TS;
> 	- Bridge - talks with the PCI/USB/.. bus and send/receive commands to Demod/Frontend.
> 
> The tuner + frontend + satellite controller are called frontend.
> 
> On a typical design, tuners are a separate chip, interconnected via an I2C bus, and 
> the demod may be separate or integrated with the bridge (or with the tuner).
> 
> Since the design is modular, the same frontend may be used by different bridges, and a
> given bridge may work with more than one frontend, depending on the specific device you may have.
> 
> So, we basically have one Kconfig option for each component, to allow building kernels with
> the minimum footprint.
> 
> For example, picking a random DVB bridge:
> 
> config DVB_DM1105
> 	tristate "SDMC DM1105 based PCI cards"
> 	depends on DVB_CORE && PCI && I2C
> 	depends on INPUT
> 	select DVB_PLL if !DVB_FE_CUSTOMISE
> 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
> 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
> 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
> 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
> 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
> 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
> 
> The components at the select are the frontend.
> 
> In this specific case, there's just one demod supported (stv0299),
> but it allows using 6 different types of tuners.
> 
> If you want to build a kernel with a minimal footprint, and if you have just one device type, 
> you'll need only one tuner driver.
> 
> </detailed>
> 
> In the specific case you're mentioning, we have the following bridge drivers:
> 
> config DVB_USB_NOVA_T_USB2
> 	tristate "Hauppauge WinTV-NOVA-T usb2 DVB-T USB2.0 support"
> 	depends on DVB_USB
> 	select DVB_DIB3000MC
> 	select DVB_PLL if !DVB_FE_CUSTOMISE
> 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
> 
> config DVB_USB_DIBUSB_MB
> 	tristate "DiBcom USB DVB-T devices (based on the DiB3000M-B) (see help for device list)"
> 	depends on DVB_USB
> 	select DVB_PLL if !DVB_FE_CUSTOMISE
> 	select DVB_DIB3000MB
> 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
> 
> config DVB_USB_DIBUSB_MC
> 	tristate "DiBcom USB DVB-T devices (based on the DiB3000M-C/P) (see help for device list)"
> 	depends on DVB_USB
> 	select DVB_DIB3000MC
> 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
> 
> 
> And the following frontends:
> 
> config DVB_DIB3000MC
> 	tristate "DiBcom 3000P/M-C"
> 	depends on DVB_CORE && I2C
> 	default m if DVB_FE_CUSTOMISE
> 	help
> 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
> 	  to support this frontend.
> 
> config DVB_DIB3000MB
> 	tristate "DiBcom 3000M-B"
> 	depends on DVB_CORE && I2C
> 	default m if DVB_FE_CUSTOMISE
> 	help
> 	  A DVB-T tuner module. Designed for mobile usage. Say Y when you want
> 	  to support this frontend.
> 
> The makefile for it is:
> 
> obj-$(CONFIG_DVB_DIB3000MB) += dib3000mb.o
> obj-$(CONFIG_DVB_DIB3000MC) += dib3000mc.o dibx000_common.o
> obj-$(CONFIG_DVB_DIB7000M) += dib7000m.o dibx000_common.o
> obj-$(CONFIG_DVB_DIB7000P) += dib7000p.o dibx000_common.o
> obj-$(CONFIG_DVB_DIB8000) += dib8000.o dibx000_common.o
> 
> For sure, the Makefile is not doing the right thing, for a random config on those drivers,
> as some of the frontends may be compiled builtin, while others may be compiled as module.
> 
> I can see two possible fixes:
> 
> 1) create a Kconfig option for dibx000_common, and let the other frontends
>    select/depend on it;
> 2) change the build system to not allow having some frontends builtin and others as modules.
> 
> Probably, (1) is easier than (2). Yet, (2) may also fix other hidden cases like that.

Or we just don't test for define(MODULE). If either CONFIG_DVB_DIB3000MC
or CONFIG_DVB_DIB3000MC_MODULE are defined, the code must be there,
because, if this code is built as both a module and builtin, only the
builtin will be created.

-- Steve


