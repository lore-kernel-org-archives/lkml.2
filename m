Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0FFJ7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:59:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:38715 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0FFJ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:59:06 -0400
Date: Sun, 6 Jun 2010 02:56:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: Vitaly Wool <vitalywool@gmail.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1006060235130.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com> <20100604071354.GA14451@elte.hu> <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
 <20100604083423.GD15181@elte.hu> <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com> <1275653210.27810.39762.camel@twins> <AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com> <1275731653.27810.41078.camel@twins> <20100605092851.6ee15f13@infradead.org>
 <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com> <AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com> <AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com> <AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
 <AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Brian Swetland wrote:

> The savings in airplane mode (apart from preventing data connections,
> which saves power by preventing data-hungry background apps from doing
> much) is the difference between standby with radio (3-5mA) and without
> (1-2mA).  I'm not suggesting that airplane mode is a typical case,
> just using it as in illustration of the more extreme standby case.

for the sake of discussion, let's say that standby is 5ma and full 
operation is 500ma and a minimal wakeup is 0.1 sec. these are probably 
fairly pessimistic numbers.

waking up every second would be awake 10% of the time, so in an hour you 
would use .9*5mA + .1*500mA = 4.5mA +45mA = 49.5mAH

waking up every 10 seconds would be awake 1% of the time, so in an hour 
you would use .99*5mA + 0.01*500mA = 4.95mA + 5mA = 9.95mAH

waking up every 100 seconds would be awake 0.1% of the time, so in an hour 
you would use .999*5mA + 0.001*500mA =4.995mA + 0.5mA = 5.495mAH

waking up every 1000 seconds would be awake 0.01% of the time so in an 
hour you would use .9999*5mA + 0.0001*500mA = 4.9995mA + 0.05mAH = 
5.0495mAH

now if you have a 1000mAH battery (small, but reasonable for a smartphone) 
your standby life would be

.1 second wakeup (on continuously) = 2 hours
1 second wakup = 20 hours
10 second wakeup = 100 hours
100 second wakeup = 182 hours
1000 second wakeup = 198 hours

if you could shrink the time awake to 0.01 second per wakeup you would 
shift this all up a category (and avoiding the need to wake everything up 
to service a timer would help do this)

this effort very definantly has diminishing returns as you go to larger 
sleep periods as the constant standby power draw becomes more and more 
dominating. someone mentioned that they were getting the sleep time of 
normal systems up past the 1 second mark with the 10 second mark looking 
very attainable. that is where you get the most benifit for whatever 
changes are needed. getting up to a 2 min sleep time really gives you 
about all the benifit that you can get, going from there to 15 min makes 
very little difference.

don't let chasing the best possible sleep time prevent you from 
considering options that would be good enough in time, but would 
drastically reduce the maintinance effort (as things could be upstreamed 
more easily), and would be usable on far more systems.

David Lang
