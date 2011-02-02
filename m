Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1BBCb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:31:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35129 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1BBCbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=obW8vUcfrNu8HoSXWiN7AwZJp/dXHIjfk94KzqTFx20IUG96THOnVLtRYvznsjoqhg
         57UFfT1xWm0dB3CNiQpctUyMAjMzi/OkPen4qwZ/Wlz0tKyI7JQu5zwrS5D0ZE22iJBd
         qxhpsXJHsHUpd6nBIyrWyoMeRGCU9/0QQDG1o=
MIME-Version: 1.0
In-Reply-To: <20110201152820.GQ31216@n2100.arm.linux.org.uk>
References: <201102011711.31258.jeremy.kerr@canonical.com>
	<20110201105449.GY1147@pengutronix.de>
	<AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com>
	<20110201140024.GZ1147@pengutronix.de>
	<20110201151418.GN31216@n2100.arm.linux.org.uk>
	<20110201152203.GE1147@pengutronix.de>
	<20110201152820.GQ31216@n2100.arm.linux.org.uk>
Date: Wed, 2 Feb 2011 11:31:53 +0900
Message-ID: <AANLkTik_QFqas7yTWDpWhMfxfdOvKNh--DDFxY8x8v51@mail.gmail.com>
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/2 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Feb 01, 2011 at 04:22:03PM +0100, Uwe Kleine-König wrote:
>> Full ack.  (I wonder if you misunderstood me or wanted to put my
>> statement into more words.  Jassi didn't like that a clk_enable without
>> a previous clk_prepare worked on some platforms and on others it
>> doesn't.  With BUG_ON(clk->ops->prepare && !clk->prepare_count) in
>> clk_enable we have exactly this situation.)
>
> Even with a NULL clk->ops->prepare function, we still want drivers to
> have called clk_prepare().  So we can do something like:
>
>        if (WARN_ON(clk->prepare_count == 0))
>                return -EINVAL;
>
> in clk_enable() should be sufficient and noisy enough not to be missed.
>
> I'd avoid BUG_ON() here as that will take the system down, which may
> increase the chances of getting useful bug reports.

Having thought about it, I think it's not necessary to immediately catch
drivers that work on some platforms and not on others -- a mere comment
'please add clk_prepare' during code review or a patch adding 'clk_prepare'
later upon stumbling across a platform on which the driver doesn't work,
should be OK. Let us not fret about it.

That leaves us with only having to ensure that :-
a) No two calls to clk_prepare/unprepare _hooks_ are consecutive.
b) clk_prepare is done on the clock (not necessarily by the driver
    under consideration) before calls to clk_enable.

I think (a) is already easily managed by having the prepare_count,
and (b) can be reasonably managed by what Russell suggests above.

So, FWIW, I am for the idea.

Njoi!
