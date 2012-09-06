Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2IFJgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:36:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34455 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab2IFJgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120904122121.GA13018@pequod.mess.org>
References: <1346464629-22458-1-git-send-email-changbin.du@gmail.com>
	<20120903130357.GA7403@pequod.mess.org>
	<CABgQ-ThYGdvhmpf+=GcLpE-qFAhrDUc1j07+XqohDNRa9bStiw@mail.gmail.com>
	<CABgQ-TjrXbqKaOd9fDptV2fUiyVTpzZ31K_iZ+HQ+3PGmWoHRw@mail.gmail.com>
	<20120904122121.GA13018@pequod.mess.org>
Date: Thu, 6 Sep 2012 17:36:14 +0800
Message-ID: <CABgQ-TigHVka=iW-dzXebEDK-Hxjh8OrvhtfELMgoh6MN4s1Zw@mail.gmail.com>
Subject: Re: [RFC PATCH] [media] rc: filter out not allowed protocols when decoding
From: Changbin Du <changbin.du@gmail.com>
To: Sean Young <sean@mess.org>
Cc: mchehab@infradead.org, paul.gortmaker@windriver.com, sfr@canb.auug.org.au,
        srinivas.kandagatla@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean , many thanks for your help. I know much more about IR framwork
now. I'll try to
work out a patch to remove "allowed_protocols".

Thanks again!
[Du, Changbin]

2012/9/4 Sean Young <sean@mess.org>:
> On Tue, Sep 04, 2012 at 11:06:07AM +0800, Changbin Du wrote:
>> > >               mutex_lock(&ir_raw_handler_lock);
>> > > -             list_for_each_entry(handler, &ir_raw_handler_list, list)
>> > > -                     handler->decode(raw->dev, ev);
>> > > +             list_for_each_entry(handler, &ir_raw_handler_list, list) {
>> > > +                     /* use all protocol by default */
>> > > +                     if (raw->dev->allowed_protos == RC_TYPE_UNKNOWN ||
>> > > +                         raw->dev->allowed_protos & handler->protocols)
>> > > +                             handler->decode(raw->dev, ev);
>> > > +             }
>> >
>> > Each IR protocol decoder already checks whether it is enabled or not;
>> > should it not be so that only allowed protocols can be enabled rather
>> > than checking both enabled_protocols and allowed_protocols?
>> >
>> > Just from reading store_protocols it looks like decoders which aren't
>> > in allowed_protocols can be enabled, which makes no sense. Also
>> > ir_raw_event_register all protocols are enabled rather than the
>> > allowed ones.
>> >
>> >
>> > Lastely I don't know why raw ir drivers should dictate which protocols
>> > can be enabled. Would it not be better to remove it entirely?
>>
>>
>> I agree with you. I just thought that the only thing a decoder should care
>> is its decoding logic, but not including decoder management. My idaea is:
>>      1) use enabled_protocols to select decoders in ir_raw.c, but not
>> placed in decoders to do the judgement.
>>      2) remove  allowed_protocols or just use it to set the default
>> decoder (also should rename allowed_protocols  to default_protocol).
>
> The default decoder should be the one set by the rc keymap.
>
>> I also have a question:
>>      Is there a requirement that one more decoders are enabled for a
>> IR device at the same time?
>
> Yes, you want to be able to multiple remotes on the IR device (which
> you can do as long as the scancodes don't overlap, I think), and the
> lirc device is implemented as a decoder, so you might want to see the
> raw IR as well as have it decoded.
>
>>     And if that will lead to a issue that each decoder may decode a
>> same pulse sequence to different evnets since their protocol is
>> different?
>
> At the moment, no. David Hardeman has sent a patch for this:
>
> http://patchwork.linuxtv.org/patch/11388/
>
>
> Sean
