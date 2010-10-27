Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab0J0I6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:58:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47900 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab0J0I6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YbqYDByFFS8PWDGROWJvNsI475+DyVYhjdJf2EF0uxkcDlrqVfzineniECheMtHVoD
         qn5hCVKurC8Jar8dAEO8tfaEWqqNnpyhAuK96vBPFfMuMeXh1FNr1g/EfIVt4Bs/qyyd
         TbIp4JUXX4ZKMEbSpDf6k9BErGIhlLaVtppTo=
Date: Wed, 27 Oct 2010 01:58:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: ilkka.koskinen@nokia.com, linux-input@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: spi: Driver for SPI data stream driven vibrator
Message-ID: <20101027085844.GA7039@core.coreip.homeip.net>
References: <1288013463-21722-1-git-send-email-ilkka.koskinen@nokia.com>
 <20101026111344.GB24714@angua.secretlab.ca>
 <F80267346F10C541946CBE8909F1C39E35932598BB@NOK-EUMSG-02.mgdnok.nokia.com>
 <20101027084730.GC6797@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027084730.GC6797@angua.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:47:30AM +0100, Grant Likely wrote:
> On Tue, Oct 26, 2010 at 06:50:33PM +0200, ilkka.koskinen@nokia.com wrote:
> > Hi Grant and thanks for comments,
> [...]
> > >> +static int vibra_spi_playback(struct input_dev *input, int effect_id,
> > >int value)
> > >> +{
> > >> +    struct vibra_data *vibra = input_get_drvdata(input);
> > >> +    struct effect_info *einfo = &vibra->effects[effect_id];
> > >> +    struct ff_effect *ff_effect = &input->ff->effects[effect_id];
> > >> +
> > >> +    if (!vibra->workqueue)
> > >> +            return -ENODEV;
> > >> +
> > >> +    if (test_bit(FF_EFFECT_UPLOADING, &einfo->flags))
> > >> +            return -EBUSY;
> > >> +
> > >> +    if (value == 0) {
> > >> +            /* Abort the given effect */
> > >> +            if (test_bit(FF_EFFECT_PLAYING, &einfo->flags))
> > >> +                    __set_bit(FF_EFFECT_ABORTING, &einfo->flags);
> > >> +
> > >> +            __clear_bit(FF_EFFECT_QUEUED, &einfo->flags);
> > >> +    } else {
> > >> +            /* Move the given effect as the next one */
> > >> +            __clear_bit(FF_EFFECT_QUEUED,
> > >> +                    &vibra->effects[vibra->next_effect].flags);
> > >> +
> > >> +            vibra->next_effect = effect_id;
> > >> +            __set_bit(FF_EFFECT_QUEUED, &einfo->flags);
> > >> +            __clear_bit(FF_EFFECT_ABORTING, &einfo->flags);
> > >> +            einfo->stop_at = jiffies +
> > >> +                    msecs_to_jiffies(ff_effect->replay.length);
> > >> +
> > >> +            if (vibra->status == IDLE) {
> > >> +                    vibra->status = STARTED;
> > >> +                    queue_work(vibra->workqueue, &vibra->play_work);
> > >> +            }
> > >> +    }
> > >
> > >I can't speak anything about the input event handling because I'm not
> > >very familiar with it.  However, it looks like the shared effect data
> > >(vibra->effects) is getting modified outside of a critical region.  Is
> > >this safe?
> 
> Hmmm, I don't know why the force feedback layer is using a spin lock,
> but it looks like overkill.  Since you're already deferring work, I
> would look at queueing the request and pushing down the spin lock
> exposure as much as possible, but I'm really not the expert on the
> input layer.
> 

Events are often sent from IRQ context so input core has to use spinlocks to
protect its internal data structures. Since output events travel the
same data path the event handlers are also called in atomic context.

-- 
Dmitry
