Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab2IDDGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:06:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42192 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2IDDGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <CABgQ-ThYGdvhmpf+=GcLpE-qFAhrDUc1j07+XqohDNRa9bStiw@mail.gmail.com>
References: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
	<20120903130357.GA7403@pequod.mess.org>
	<CABgQ-ThYGdvhmpf+=GcLpE-qFAhrDUc1j07+XqohDNRa9bStiw@mail.gmail.com>
Date: Tue, 4 Sep 2012 11:06:07 +0800
Message-ID: <CABgQ-TjrXbqKaOd9fDptV2fUiyVTpzZ31K_iZ+HQ+3PGmWoHRw@mail.gmail.com>
Subject: Re: [RFC PATCH] [media] rc: filter out not allowed protocols when decoding
From: Changbin Du <changbin.du@gmail.com>
To: sean@mess.org
Cc: mchehab@infradead.org, paul.gortmaker@windriver.com, sfr@canb.auug.org.au,
        srinivas.kandagatla@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >               mutex_lock(&ir_raw_handler_lock);
> > -             list_for_each_entry(handler, &ir_raw_handler_list, list)
> > -                     handler->decode(raw->dev, ev);
> > +             list_for_each_entry(handler, &ir_raw_handler_list, list) {
> > +                     /* use all protocol by default */
> > +                     if (raw->dev->allowed_protos == RC_TYPE_UNKNOWN ||
> > +                         raw->dev->allowed_protos & handler->protocols)
> > +                             handler->decode(raw->dev, ev);
> > +             }
>
> Each IR protocol decoder already checks whether it is enabled or not;
> should it not be so that only allowed protocols can be enabled rather
> than checking both enabled_protocols and allowed_protocols?
>
> Just from reading store_protocols it looks like decoders which aren't
> in allowed_protocols can be enabled, which makes no sense. Also
> ir_raw_event_register all protocols are enabled rather than the
> allowed ones.
>
>
> Lastely I don't know why raw ir drivers should dictate which protocols
> can be enabled. Would it not be better to remove it entirely?


I agree with you. I just thought that the only thing a decoder should care
is its decoding logic, but not including decoder management. My idaea is:
     1) use enabled_protocols to select decoders in ir_raw.c, but not
placed in decoders to do the judgement.
     2) remove  allowed_protocols or just use it to set the default
decoder (also should rename allowed_protocols  to default_protocol).

I also have a question:
     Is there a requirement that one more decoders are enabled for a
IR device at the same time?
    And if that will lead to a issue that each decoder may decode a
same pulse sequence to different evnets since their protocol is
different?

[Du, Changbin]
>
>
> >               raw->prev_ev = ev;
> >               mutex_unlock(&ir_raw_handler_lock);
> >       }
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
