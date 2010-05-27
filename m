Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0E0Qej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:34:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37593 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754206Ab0E0Qeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:34:37 -0400
Date: Thu, 27 May 2010 17:41:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527174131.18fd1c72@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527160714.GB31937@srcf.ucam.org>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<20100527160543.2228fc17@lxorguk.ukuu.org.uk>
	<20100527160714.GB31937@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 17:07:14 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 04:05:43PM +0100, Alan Cox wrote:
> > > Now, if the user is playing this game, you want it to be scheduled. If 
> > > the user has put down their phone and the screen lock has kicked in, you 
> > > don't want it to be scheduled. So we could imagine some sort of cgroup 
> > > that contains untrusted tasks - when the session is active we set a flag 
> > 
> > I would hope not, because I'd rather prefer my app that used the screen
> > to get the chance to save important data on what it was doing
> > irrespective of the screen blank:  "I have an elegant proof for this
> > problem but my battery has gone flat"
> 
> Perhaps set after callbacks are made. But given that the approach 
> doesn't work anyway...

Which approach doesn't work, and why ?

> > What is the problem here - your device driver for the display can block
> > tasks it doesn't want to use the display.
> 
> It's still racy. Going back to my example without any of the suspend 
> blocking code, but using a network socket rather than an input device:
> 
> int input = socket(AF_INET, SOCK_STREAM|SOCK_NONBLOCK, 0);
> char foo;
> struct sockaddr addr;
> connect (input, &addr, sizeof(addr))
> while (1) {
>        if (read(input, &foo, 1) > 0) {
>                (do something)
>        } else {
>                (draw bouncing cows and clouds and tractor beams briefly)
>        }
> }
> 
> A network packet arrives while we're drawing. Before we finish drawing, 
> the policy timeout expires and the screen turns off.

Which is correct for a badly behaved application. You said you wanted to
constrain it. You've done so. Now I am not sure why such a "timeout"
would expire in the example as the task is clearly busy when drawing, or
is talking to someone else who is in turn busy. Someone somewhere is
actually drawing be it a driver or app code.

For a well behaved application you are drawing so you are running
drawing stuff so why would you suspend. The app has said it has a
latency constraint that suspend cannot meet, or has a device open that
cannot meet the constraints in suspend.

You also have the socket open so you can meaningfully extract resource
constraint information from that fact.

See it's not the read() that matters, it's the connect and the close. 

If your policy for a well behaved application is 'thou shalt not
suspend in a way that breaks its networking' then for a well behaving app
once I connect the socket we cannot suspend that app until such point as
the app closes the socket. At any other point we will break the
connection. Whether that is desirable is a policy question and you get to
pick how much you choose to trust an app and how you interpret the
information in your cpufreq and suspend drivers.

If you have wake-on-lan then the network stack might be smarter and
choose to express itself as

	'the constraint is C6 unless the input queue is empty in which
	 case suspend is ok as I have WoL and my network routing is such
	 that I can prove that interface will be used'

In truth I doubt much hardware can make such an inference but some phones
probably can. On the other hand for /dev/input/foo you can make the
inference very nicely thank you.

Again wake on lan information does not belong in the application !



