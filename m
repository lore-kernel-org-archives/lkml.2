Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2LUNgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:36:14 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50175 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LUNgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:36:06 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 08:36:06 EST
Date: Fri, 21 Dec 2012 15:30:41 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 05/11] remoteproc: Load firmware once.
Message-ID: <20121221133040.GA22252@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021616.GC28692@WorkStation.localnet>
 <81C3A93C17462B4BBD7E272753C1057924576E4FEF@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057924576E4FEF@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 21, 2012 at 01:02:02PM +0100, Sjur BRENDELAND wrote:
> Hi Ido and Ohad,
> 
> > In case the remote processor is added, booted and then rebooted, the
> > program sections wont be reinitialized. This can be a bit problematic,
> > since the firmware might assume values are initialized in its data
> > sections.
> > 
> > How about the following alternative approach - instead of loading the
> > firmware in advance, we could allocate just a small (private) buffer,
> > holding a copy of the resource table. Our copy will be updated with the
> > addresses of the vrings we allocate, along with the notification ids.
> > Each time the remote processor is booted, we could reload the firmware
> > and overwrite the resource table section with our own private copy.
> > virtio's configuration space and status will probably need to be updated
> > in both copies of the resource table, so it would be consistent across
> > boots.
> 
> Thank you for review comments Ido!
> 
> Hm, are you suggesting to load firmware once or twice?
> 
> We could keep loading firmware twice and copy
> the resource table. This solves the issue of initializing variables.
> We could then keep the original approach with loading firmware
> twice. But one question comes to mind:  is it safe to assume that
> the firmware's resource table is unchanged after a reboot?
> 
> [Ohad Aug 10, 2012 wrote.]
> >The general direction I have in mind is to put the resource table in
> >its final location while we do the first pass of fw parsing.
> ...
> >This will solve all sort of open issues we have (or going to have soon):
> ...
> >1. dynamically-allocated address of the vrings can be communicated
> >2. vdev statuses can be communicated
> >3. virtio config space will finally become bi-directional as it should
> >4. dynamically probed rproc-to-rproc IPC could then take place
> >
> >It's the real deal :)
> >
> >The only problem with this approach is that the resource table isn't
> >reloaded throughout cycles of power up/down, and that is insecure.
> >We'll have to manually reload it somewhere after the rproc is powered
> >down (or before it is powered up again).
> >
> >This change will break existing firmwares, but it looks required and inevitable.
> 
> This patch is a stab on implementing what Ohad suggested originally, and loads firmware
> once. We can probably make this work as well, but I missed handling reload properly.
> For this to work I need to add support for reloading firmware upon reboot.
> 
> I go on vacation for a while now, but please get back to me on what direction we
> should go in: loading once or twice :-)

If we need to reload the firmware on remote processor reboots, we either
need to load the firmware more than once, or save a whole copy of it.
Since firmwares can get quite large, it would be a waste to hold two
copies in memory, so I'm not sure we can avoid loading the firmware more
than once.

We could read the firmware's checksum either from the elf file or from
an entry in the resource table. When requesting the firmware again, we
could compare the read checksum with the stored one, and abort if they
don't match. Given that only root can modify the firmware file, it
should be good enough.

Thanks,
Ido.
