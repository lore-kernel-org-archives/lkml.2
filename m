Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0FUTHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:07:00 -0400
Received: from emroute2.ornl.gov ([160.91.86.17]:60324 "EHLO emroute2.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab0FUTG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:06:59 -0400
Date: Mon, 21 Jun 2010 15:06:57 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
In-reply-to: <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-id: <1277147217.2501.52.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
 <1276972298.22889.16.camel@obelisk.thedillows.org>
 <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
 <1277043970.22889.45.camel@obelisk.thedillows.org>
 <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com>
 <1277129180.22889.64.camel@obelisk.thedillows.org>
 <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
 <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 20:49 +0200, Hans Schou wrote:
> 2010/6/21 Hans Schou <linux@schou.dk>:
> > 2010/6/21 David Dillow <dave@thedillows.org>:
> >> An overrun means that arecord didn't run for 500ms, and the load average
> >> won't really tell you much about that -- latency can happen with low
> >
> > Well, I did not see that with sox. It was running fine for 42 min.

My thought is that you may have been somewhat fortunate and did not see
an overrun for 42 minutes. I am trying to narrow down if this is an
issue with sox's overrun handling, if there is a big with handing
anything other than two periods per buffer, or some other generic bug in
the driver.

> >> I don't know the options available on sox, but if you can use arecord to
> >> reproduce, then that is probably the best tool for the job. Can you set
> >> it up to use two periods per buffer and see if you still can reproduce?
> >> Options would look like -B 250000 -F 125000. A second test with -B
> >> 1000000 -F 500000 would be interesting, if the hw can handle buffers of
> >> that size -- I don't recall offhand.
> >
> > I have just started it with  -B 250000 -F 125000 and get a lot of overrun.
> > I skipped using strace to make less stress.
> >
> > cmdline is now:
> > arecord -B 250000 -F 125000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> 
> This gave a 191069598 bytes long file. What does this test actually
> show regarding the original problem with stopping after 42 min?

I'm trying to have you reproduce the original problem using 2 periods
per buffer so that I can localize the likely location of a driver bug.
If it only happens when there is not 2 periods per buffer, then that
points to one set of timing code. If it also happens with 2 periods per
buffer, then that points to a more generic bug.

> I have just started:
>  arecord -B 1000000 -F 500000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> and I only got one overrun. What I did was that logged in on another
> ssh console and executed "ls".

That sounds like a scheduling latency issue, yes.

> Here is a complete screen dump after running 2 minutes:
> + arecord -B 1000000 -F 500000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> Recording WAVE 'arec.wav' : Signed 16 bit Little Endian, Rate 44100 Hz, Mono
> Hardware PCM card 0 'SiS7019' device 0 subdevice 0
> Its setup is:

>   buffer_size  : 32768
>   period_size  : 22050

Ok, please play with the options until you can get buffer_size = 2 *
period_size. That will eliminate the alternate timing code from the
path. I expected that options you gave to do that, but apparently there
is something else keeping that from happening.

Dave

