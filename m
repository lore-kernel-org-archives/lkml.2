Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2LUOE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:04:28 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:48692 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab2LUOEU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:04:20 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Fri, 21 Dec 2012 15:04:09 +0100
Subject: RE: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Topic: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Index: Ac3ff2PfaDFPgVMWT0+EIxJx9EDTbAAAuMiQ
Message-ID: <81C3A93C17462B4BBD7E272753C1057924576E509F@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021616.GC28692@WorkStation.localnet>
 <81C3A93C17462B4BBD7E272753C1057924576E4FEF@EXDCVYMBSTM005.EQ1STM.local>
 <20121221133040.GA22252@WorkStation.localnet>
In-Reply-To: <20121221133040.GA22252@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,
]
> > > In case the remote processor is added, booted and then rebooted, the
> > > program sections wont be reinitialized. This can be a bit problematic,
> > > since the firmware might assume values are initialized in its data
> > > sections.
> > >
> > > How about the following alternative approach - instead of loading the
> > > firmware in advance, we could allocate just a small (private) buffer,
> > > holding a copy of the resource table. Our copy will be updated with the
> > > addresses of the vrings we allocate, along with the notification ids.
> > > Each time the remote processor is booted, we could reload the firmware
> > > and overwrite the resource table section with our own private copy.
> > > virtio's configuration space and status will probably need to be updated
> > > in both copies of the resource table, so it would be consistent across
> > > boots.
> >
> > Thank you for review comments Ido!
> >
> > Hm, are you suggesting to load firmware once or twice?
> >
> > We could keep loading firmware twice and copy
> > the resource table. This solves the issue of initializing variables.
> > We could then keep the original approach with loading firmware
> > twice. But one question comes to mind:  is it safe to assume that
> > the firmware's resource table is unchanged after a reboot?
> >
> > [Ohad Aug 10, 2012 wrote.]
> > >The general direction I have in mind is to put the resource table in
> > >its final location while we do the first pass of fw parsing.
> > ...
> > >This will solve all sort of open issues we have (or going to have soon):
> > ...
> > >1. dynamically-allocated address of the vrings can be communicated
> > >2. vdev statuses can be communicated
> > >3. virtio config space will finally become bi-directional as it should
> > >4. dynamically probed rproc-to-rproc IPC could then take place
> > >
> > >It's the real deal :)
> > >
> > >The only problem with this approach is that the resource table isn't
> > >reloaded throughout cycles of power up/down, and that is insecure.
> > >We'll have to manually reload it somewhere after the rproc is powered
> > >down (or before it is powered up again).
> > >
> > >This change will break existing firmwares, but it looks required and
> inevitable.
> >
> > This patch is a stab on implementing what Ohad suggested originally, and
> loads firmware
> > once. We can probably make this work as well, but I missed handling reload
> properly.
> > For this to work I need to add support for reloading firmware upon reboot.
> >
> > I go on vacation for a while now, but please get back to me on what
> direction we
> > should go in: loading once or twice :-)
> 
> If we need to reload the firmware on remote processor reboots, we either
> need to load the firmware more than once, 

Yes, we're fully aligned here. I want to reload the firmware upon reboot.

...
>or save a whole copy of it.
> Since firmwares can get quite large, it would be a waste to hold two
> copies in memory, so I'm not sure we can avoid loading the firmware more
> than once.

I think you got me wrong. When I talk about loading firmware twice
I was referring to the current approach of calling request_firmware_nowait()
when rproc_add() is called and then calling request_firmware() again
when the virtio devices are probed (from rproc_boot).
The implementation I have done, avoids the second firmware loading by
storing the image into memory first time around.
So my question is: do you want to load firmware once or twice at the initial
boot?

> We could read the firmware's checksum either from the elf file or from
> an entry in the resource table. When requesting the firmware again, we
> could compare the read checksum with the stored one, and abort if they
> don't match. Given that only root can modify the firmware file, it
> should be good enough.

Yes, verifying the checksum sounds like a good idea.

Thanks,
Sjur
