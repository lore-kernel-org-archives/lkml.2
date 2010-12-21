Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0LUU5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:57:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61547 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0LUU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vnIQ6GnWe8XF4KCcPqVkkQhJ/yeAxQh1art5F5smSn/O9Ztm89eXr4Qqa+oF/rp4K1
         lx/KQVdGPxWL/dh1CokIBOnK6+cMQirJgb7nVZLCm9sIxnjZrAywgJKyRiPrmyJLS8hJ
         089zArrXuufwsQ+7oJIUJ61qUaA7Q42U0ONew=
MIME-Version: 1.0
In-Reply-To: <20101221075612.GA13626@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com> <20101221075612.GA13626@riccoc20.at.omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Wed, 22 Dec 2010 05:57:02 +0900
Message-ID: <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 4:56 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> Can you please elaborate?

The timex.constant is defined as equal to the binary logarithm of the
reciprocal of
the natural frequency minus SHIFT_PLL.  In other words, the following
equation holds:

	log2(natural frequency) + time_constant + SHIFT_PLL = 0,

which means that decreasing time_constant increases natural frequency
exponentially.
And since a larger natural frequency gives a smaller settling time, a
sufficiently
large negative time_constant results in immediate time step, at least in theory.

> I don't see any way to use timex.constant with ADJ_OFFSET in order to
> correct a time offset.

How about this?

if (txc->modes & ADJ_OFFSET) {
	if (txc->constant == INT32_MIN) {
		/* step time */
	} else {
		/* slew time */
	}
}

> The 'time_constant' in kernel/time/ntp.c is
> restricted to the interval [0..MAXTC], and MAXTC is 10 in timex.h.

Then let's just ignore the restriction.  (It's possible by setting the
timex.constant
without setting the ADJ_TIMECONST flag.)

That said, I'm somehow against the idea of using the adjtimex syscall
for that purpose.
