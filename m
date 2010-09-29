Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0I2Hyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:54:47 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52471 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0I2Hyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h7A5Fh0LnmC9wh0ei/gIgquUTPCRTyqSFpEX8tPGL+L90kFL0/Nb3N9VWD6YtvkdF9
         Ar8GpWWfqkjiMB61HLrcmsQXQL113T9XuGVduQLE/IgIlf5m6tghjnt6tyvwbt0REe7V
         W9BktP5z+bdHRH1geIbSwHMFpfYNpH9pP/q38=
MIME-Version: 1.0
In-Reply-To: <20100928145953.GC13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	<1285549026-5008-4-git-send-email-ying.huang@intel.com>
	<20100927094136.GB32222@erda.amd.com>
	<AANLkTimTg1uqXdAJ+GyZ3_B6n2xKWdqFL96jvv18JBM+@mail.gmail.com>
	<20100927132537.GO13563@erda.amd.com>
	<1285635832.20791.119.camel@yhuang-dev>
	<20100928145953.GC13563@erda.amd.com>
Date: Wed, 29 Sep 2010 15:54:45 +0800
Message-ID: <AANLkTikSF-jBkiwUUFwtnusnKFtHvX=WdDKq5WM1sfE3@mail.gmail.com>
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
From: huang ying <huang.ying.caritas@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Robert,

On Tue, Sep 28, 2010 at 10:59 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 27.09.10 21:03:52, Huang Ying wrote:
>> Use priority to enforce the order has some issues except what Don
>> pointed out (two registers for two call in chain):
>>
>> - Almost all direct call in default_do_nmi() must be turned into
>> notifier_block. I know this is what you want. But I am not a big fan of
>> notifier chain :)
>>
>> - This makes order of notifier call more implicitly. And I think the
>> order is important for NMI handler to work properly.
>>
>> - In your scheme, both die_val (DIE_NMI or DIE_NMI_UNKNOWN) and priority
>> are used to determine the order of call. This makes code more complex
>> and no additional benefit.
>>
>> So I think it is better to use different die_val to determine the order,
>> and insert some direct call between them.
>
> Huang,
>
> registering a notifier is the only clean way to add an NMI handler.
> Modifying the NMI control flow in traps.c with global flags is not the
> right approach.

If you mean my code in [PATCH 6/7], in that patch, I add another logic
into the general unknown NMI processing: treat all unknown NMI as
hardware error and go panic. The global flag is just used to implement
white list, it is not the point. I am not adding another NMI handler
there.

In general, I think it is better to call the NMI handler in
default_do_nmi() directly if possible. That is clearer, and the code
is much easier to be understood too.

> Currently, execution order depends on die_val, this is
> not obvious when reading the code

I think that is more obvious for reading than priority value. When you
look at the new default_do_nmi(), it is very clear that the order is
as follow:

DIE_NMI_IPI
DIE_NMI
port 0x61
watchdog
DIE_NMIUNKNOWN

Because the corresponding notifiers are called in this order.

With priority value, people may say: Oh, this is data-driven
programming, the execution order is based on data value. That is not
so obvious for me.

> and we all were wondering in the
> beginning why there was DIE_NMI, DIE_NMI_IPI and DIE_NMI_UNKNOWN, etc.

What I thought about this is described in my reply to Don in 3/7 thread.

> So, better we say instead, this is the notifier function with that
> priority, add it to the call chain. With priorities we are able to
> clearly specify the execution order even more fine grained than
> now.

Do we need fine grained order? Do you have some use cases. Fine
grained order is hard to managed too. Especially because some NMI
handler may be hardware independent.

> And, code in traps.c will become fairly easy. Also, we don't need
> two notifiers, because there is no need for different priorities
> then. Give me one use case, I don't know of any.

If my understanding is correct, in your previous mail, you said there
will be two notifier chain, DIE_NMI and DIE_NMI_UNKNOWN, so I said
that.

> And the setup of a notifier is not that much overhead or complex, sure
> we need to change the code, but actually this the work to be done to
> clean it up.

I just want to clean it up in different way as you :)

Best Regards,
Huang Ying
