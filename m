Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab1JaT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:59:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37115 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab1JaT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:59:39 -0400
Message-ID: <1320090688.8964.52.camel@js-netbook>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
From: John Stultz <johnstul@us.ibm.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, zhangfx <zhangfx@lemote.com>,
        Chen Jie <chenj@lemote.com>, Yong Zhang <yong.zhang0@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>, yanhua <yanh@lemote.com>,
        =?UTF-8?Q?=E9=A1=B9=E5=AE=87?= <xiangy@lemote.com>,
        =?UTF-8?Q?=E5=AD=99=E6=B5=B7=E5=8B=87?= <sunhy@lemote.com>
Date: Mon, 31 Oct 2011 15:51:28 -0400
In-Reply-To: <4EAEE92D.4080402@gmail.com>
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>
	 <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>
	 <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com>
	 <1320066197.2266.11.camel@js-netbook> <4EAEA9AF.1060904@lemote.com>
	 <1320084763.8964.22.camel@js-netbook> <4EAEE92D.4080402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11103119-5112-0000-0000-0000017733A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 11:30 -0700, David Daney wrote:
> On 10/31/2011 11:12 AM, John Stultz wrote:
> > +	/*
> > +	 * Since mult may be adjusted by ntp, add an extra saftey margin
> > +	 * for clocksources that have large mults, to avoid overflow.
> > +	 *
> > +	 * Assume we won't try to correct for more then 5% adjustments
> 
> Can we do any better than making assumptions about this?
> 
> The current assumption appears to be that only very small adjustments 
> will be made, and that didn't workout so well.

s/only very small/no/

The calc_mult_shift function doesn't take any adjustments into account.

> Is it possible to put hard constraints on these things, so that it will 
> always work?

Fair enough. The patch was a bit off the cuff, and you're right that the
assumption is broken: ntp limits the freq adjustment to 500ppm, but the
kernel limits tick adjustments to 10%. Thus 11% adjustments (easier to
remember then 10.05%) would be the hard limit of adjustments from
external interfaces. So I'll need to rework the patch to adapt for that.

The harder part, once we put a hard constraint on the adjustment, is to
enforce that the timekeeping_bigadjust() doesn't push it beyond that,
since its logic uses relative adjustments and doesn't consider the
original mult value. Further, since its fairly opaque code, proving the
constraint itself won't break in edge cases is also needed, and will
take some time.

So yea, you're point is fair. Its just going to take a bit of thoughtful
review before implementing such a hard constraint universally.

So making a good adversary constraint first (11%), and then iteratively
hardening the code it impacts might be a good approach to get there.

thanks
-john


