Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0KKVdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:33:44 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34392 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0KKVdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:33:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HnlQA0Cn2xY1RV1Wy0tfCplu6AqqoozeWBSq7/JKpjYiq0dT0n+yVrC+FXJNo4hp0Y
         dRPoeL6HOPZk+Ua4GXvUYRQKe1k5W8v4l0qJRXAAXwS9Gks1Ud9CT+dZEtOjKgsTH/SO
         ocVizXkBG0FflyEEiRjPH6zx2XsOpDMQAjJz8=
MIME-Version: 1.0
In-Reply-To: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
References: <1289466356-16697-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 11 Nov 2010 13:33:41 -0800
X-Google-Sender-Auth: lEBeql3DYYLR3g4t2oKb-HlyVhk
Message-ID: <AANLkTi=ysONhPQBTbVNRgTOx5PGEM=STaUYY6RnUpfES@mail.gmail.com>
Subject: Re: [PATCH] RFC: nomadik: expand timesource to 63 bits
From: john stultz <johnstul@us.ibm.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@google.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 1:05 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> After wraparound-problems in sched_clock() we expand the 32bit
> timer in the MTU from 32 to 63 bits so the scheduling and
> timeline is more stable. At current max operating frequency for
> the MTU, 133 MHz, this should be sufficient for rougly 2200
> years.
>
[snip]
> What we need to know is whether it's OK to simply blow up
> clocksource to 63 bits like this. In that case this
> simplification should also apply to Orion, meaning that it
> would base it's sched_clock() on the clocksource, using
> simply clocksource_cyc2ns() cutting down the code
> significantly.

I would advise against expanding the hardware counter to 63bits via
software at the clocksource layer. This breaks the
CLOCK_SOURCE_IS_CONTINUOUS flag rule (since the hardware will wrap
below the mask value if not updated in the software layer). And as
Thomas said, this will cause problems in the nohz idle limiting code
(which makes sure we wake up before the clocksource wraps).

Instead, I'd use this extension at the sched_clock level, where it
seems reasonable that it will be called frequently enough to not brake
the cnt32_to_63 magic.

thanks
-john
