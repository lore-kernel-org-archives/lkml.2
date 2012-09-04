Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2IDMVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:21:36 -0400
Received: from pequod.mess.org ([93.97.41.153]:59684 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab2IDMVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:21:23 -0400
Date: Tue, 4 Sep 2012 13:21:21 +0100
From: Sean Young <sean@mess.org>
To: Changbin Du <changbin.du@gmail.com>
Cc: mchehab@infradead.org, paul.gortmaker@windriver.com, sfr@canb.auug.org.au,
        srinivas.kandagatla@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] [media] rc: filter out not allowed protocols when
 decoding
Message-ID: <20120904122121.GA13018@pequod.mess.org>
References: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
 <20120903130357.GA7403@pequod.mess.org>
 <CABgQ-ThYGdvhmpf+=GcLpE-qFAhrDUc1j07+XqohDNRa9bStiw@mail.gmail.com>
 <CABgQ-TjrXbqKaOd9fDptV2fUiyVTpzZ31K_iZ+HQ+3PGmWoHRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgQ-TjrXbqKaOd9fDptV2fUiyVTpzZ31K_iZ+HQ+3PGmWoHRw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 11:06:07AM +0800, Changbin Du wrote:
> > >               mutex_lock(&ir_raw_handler_lock);
> > > -             list_for_each_entry(handler, &ir_raw_handler_list, list)
> > > -                     handler->decode(raw->dev, ev);
> > > +             list_for_each_entry(handler, &ir_raw_handler_list, list) {
> > > +                     /* use all protocol by default */
> > > +                     if (raw->dev->allowed_protos == RC_TYPE_UNKNOWN ||
> > > +                         raw->dev->allowed_protos & handler->protocols)
> > > +                             handler->decode(raw->dev, ev);
> > > +             }
> >
> > Each IR protocol decoder already checks whether it is enabled or not;
> > should it not be so that only allowed protocols can be enabled rather
> > than checking both enabled_protocols and allowed_protocols?
> >
> > Just from reading store_protocols it looks like decoders which aren't
> > in allowed_protocols can be enabled, which makes no sense. Also
> > ir_raw_event_register all protocols are enabled rather than the
> > allowed ones.
> >
> >
> > Lastely I don't know why raw ir drivers should dictate which protocols
> > can be enabled. Would it not be better to remove it entirely?
> 
> 
> I agree with you. I just thought that the only thing a decoder should care
> is its decoding logic, but not including decoder management. My idaea is:
>      1) use enabled_protocols to select decoders in ir_raw.c, but not
> placed in decoders to do the judgement.
>      2) remove  allowed_protocols or just use it to set the default
> decoder (also should rename allowed_protocols  to default_protocol).

The default decoder should be the one set by the rc keymap.

> I also have a question:
>      Is there a requirement that one more decoders are enabled for a
> IR device at the same time?

Yes, you want to be able to multiple remotes on the IR device (which
you can do as long as the scancodes don't overlap, I think), and the 
lirc device is implemented as a decoder, so you might want to see the
raw IR as well as have it decoded.

>     And if that will lead to a issue that each decoder may decode a
> same pulse sequence to different evnets since their protocol is
> different?

At the moment, no. David Hardeman has sent a patch for this:

http://patchwork.linuxtv.org/patch/11388/


Sean
