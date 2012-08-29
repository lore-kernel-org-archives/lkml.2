Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2H2RIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2H2RIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:08:06 -0400
Date: Wed, 29 Aug 2012 13:07:53 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, Bruno Wolff III <bruno@wolff.to>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Logitech USB headset not working in 3.6-rc3
Message-ID: <20120829170753.GA1895@zod.bos.redhat.com>
References: <5038007E.5060505@gmail.com>
 <20120825111749.GA17048@wolff.to>
 <20120825115423.GA14327@wolff.to>
 <5038BEEB.6090303@gmail.com>
 <20120825120740.GA19539@wolff.to>
 <5038C186.7000107@gmail.com>
 <20120825121758.GF20043@zod.bos.redhat.com>
 <503DFC61.3000104@gmail.com>
 <s5hsjb56d40.wl%tiwai@suse.de>
 <503E19F2.3080302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503E19F2.3080302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 03:32:34PM +0200, Daniel Mack wrote:
> On 29.08.2012 15:29, Takashi Iwai wrote:
> > At Wed, 29 Aug 2012 13:26:25 +0200,
> > Daniel Mack wrote:
> >>
> >> [1  <text/plain; ISO-8859-1 (7bit)>]
> >> On 25.08.2012 14:17, Josh Boyer wrote:
> >>> On Sat, Aug 25, 2012 at 02:13:58PM +0200, Daniel Mack wrote:
> >>>> On 25.08.2012 14:07, Bruno Wolff III wrote:
> >>>>> On Sat, Aug 25, 2012 at 14:02:51 +0200,
> >>>>>    Daniel Mack <zonque@gmail.com> wrote:
> >>>>>>
> >>>>>> Can you revert commit e9ba389c5 ("ALSA: usb-audio: Fix
> >>>>>> scheduling-while-atomic bug in PCM capture stream") and see if that
> >>>>>
> >>>>> I can try that, but it takes a long time to build a new kernel on my 
> >>>>> old hardware.
> >>>>>
> >>>>>> helps? If not, can you summarize again which kernels still work for you
> >>>>>> and which don't?
> >>>>>
> >>>>> The latest kernel that works is 3.6.0-0.rc2.git1.2.fc18. The earliest that 
> >>>>> doesn't work is 3.6.0-0.rc2.git2.1.fc18.
> >>>>>
> >>>>
> >>>> The report you sent doesn't look like it could be caused by e9ba389c5.
> >>>> It fixes a kernel Ooops. But as it is the only relevant patch in that
> >>>> area, it would be interesting if reverting it fixes anything.
> >>>
> >>> Yep, agreed.  If this revert kernel doesn't work, we're likely down to a
> >>> git bisect, Bruno.
> >>>
> >>>> Btw - thanks a lot for testing -rc kernels, much appreciated!
> >>>
> >>> Indeed!
> >>
> >> Could you please try this patch on top of Takashi's? Thanks again!
> >>
> >>
> >> Daniel
> >>
> >> [2 0001-ALSA-snd-usb-Fix-URB-cancellation-at-stream-start.patch <text/x-patch (7bit)>]
> >> >From 6617bb2463ae3fad21390b59cc2a71f96b9e9ca8 Mon Sep 17 00:00:00 2001
> >> From: Daniel Mack <zonque@gmail.com>
> >> Date: Wed, 29 Aug 2012 13:17:05 +0200
> >> Subject: [PATCH] ALSA: snd-usb: Fix URB cancellation at stream start
> >>
> >> Commit e9ba389c5 ("ALSA: usb-audio: Fix scheduling-while-atomic bug in
> >> PCM capture stream") fixed a scheduling-while-atomic bug that happened
> >> when snd_usb_endpoint_start was called from the trigger callback, which
> >> is an atmic context. However, the patch breaks the idea of the endpoints
> >> reference counting, which is the reason why the driver has been
> >> refactored lately.
> >>
> >> Revert that commit and let snd_usb_endpoint_start() take care of the URB
> >> cancellation again. As this function is called from both atomic and
> >> non-atomic context, add a flag to denote whether the function may sleep.
> >>
> >> Signed-off-by: Daniel Mack <zonque@gmail.com>
> >> Cc: stable@kernel.org [3.5+]
> >> ---
> >>  sound/usb/endpoint.c | 10 ++++++++--
> >>  sound/usb/endpoint.h |  2 +-
> >>  sound/usb/pcm.c      | 13 +++++--------
> >>  3 files changed, 14 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
> >> index c411812..678456c 100644
> >> --- a/sound/usb/endpoint.c
> >> +++ b/sound/usb/endpoint.c
> >> @@ -799,7 +799,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
> >>  /**
> >>   * snd_usb_endpoint_start: start an snd_usb_endpoint
> >>   *
> >> - * @ep: the endpoint to start
> >> + * @ep:		the endpoint to start
> >> + * @can_sleep:	flag indicating whether the operation is executed in
> >> + * 		non-atomic context
> >>   *
> >>   * A call to this function will increment the use count of the endpoint.
> >>   * In case it is not already running, the URBs for this endpoint will be
> >> @@ -809,7 +811,7 @@ int snd_usb_endpoint_set_params(struct snd_usb_endpoint *ep,
> >>   *
> >>   * Returns an error if the URB submission failed, 0 in all other cases.
> >>   */
> >> -int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
> >> +int snd_usb_endpoint_start(struct snd_usb_endpoint *ep, int can_sleep)
> >>  {
> >>  	int err;
> >>  	unsigned int i;
> >> @@ -821,6 +823,10 @@ int snd_usb_endpoint_start(struct snd_usb_endpoint *ep)
> >>  	if (++ep->use_count != 1)
> >>  		return 0;
> >>  
> >> +	/* just to be sure */
> >> +	deactivate_urbs(ep, 0, can_sleep);
> >> +	wait_clear_urbs(ep);
> > 
> > It'd be safer to protect the call of wait_clear_urbs() when
> > can_sleep=0.
> 
> Right. New patch attached.

I'll try and get another kernel built with this later today.  I'm at
Plumbers so it might have to wait a bit.

Bruno, if you're comfortable adding the patch to the Fedora 18 kernel
via a spec file, you should be able to do a scratch build by passing an
SRPM.  If you get tired of waiting for me, give it a shot.

josh
