Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0E0Qwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:52:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54641 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab0E0Qwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:52:39 -0400
Date: Thu, 27 May 2010 17:52:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527165210.GA1062@srcf.ucam.org>
References: <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <20100527160543.2228fc17@lxorguk.ukuu.org.uk> <20100527160714.GB31937@srcf.ucam.org> <20100527174131.18fd1c72@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527174131.18fd1c72@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:41:31PM +0100, Alan Cox wrote:
> On Thu, 27 May 2010 17:07:14 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Perhaps set after callbacks are made. But given that the approach 
> > doesn't work anyway...
> 
> Which approach doesn't work, and why ?

Sorry, using cgroups and scheduler tricks as a race-free replacement for 
opportunistic suspend.

> > It's still racy. Going back to my example without any of the suspend 
> > blocking code, but using a network socket rather than an input device:
> > 
> > int input = socket(AF_INET, SOCK_STREAM|SOCK_NONBLOCK, 0);
> > char foo;
> > struct sockaddr addr;
> > connect (input, &addr, sizeof(addr))
> > while (1) {
> >        if (read(input, &foo, 1) > 0) {
> >                (do something)
> >        } else {
> >                (draw bouncing cows and clouds and tractor beams briefly)
> >        }
> > }
> > 
> > A network packet arrives while we're drawing. Before we finish drawing, 
> > the policy timeout expires and the screen turns off.
> 
> Which is correct for a badly behaved application. You said you wanted to
> constrain it. You've done so. Now I am not sure why such a "timeout"
> would expire in the example as the task is clearly busy when drawing, or
> is talking to someone else who is in turn busy. Someone somewhere is
> actually drawing be it a driver or app code.

The timeout would be at the userspace platform level. If I haven't 
touched the app for 30 seconds (and if the app hasn't taken any form of 
suspend block), the screen should turn off. In the current Android 
implementation that will then (in the absence of any kernel-level 
suspend blockers) result in the system transitioning into a fully 
suspended state.

> For a well behaved application you are drawing so you are running
> drawing stuff so why would you suspend. The app has said it has a
> latency constraint that suspend cannot meet, or has a device open that
> cannot meet the constraints in suspend.

Not at all. The fact that the application hasn't taken any sort of 
suspend block means that the application has indicated that it's happy 
with no longer being scheduled when the screen is shut off, *providing 
there's no wakeup event to be processed*.

> You also have the socket open so you can meaningfully extract resource
> constraint information from that fact.
> 
> See it's not the read() that matters, it's the connect and the close. 
> 
> If your policy for a well behaved application is 'thou shalt not
> suspend in a way that breaks its networking' then for a well behaving app
> once I connect the socket we cannot suspend that app until such point as
> the app closes the socket. At any other point we will break the
> connection. Whether that is desirable is a policy question and you get to
> pick how much you choose to trust an app and how you interpret the
> information in your cpufreq and suspend drivers.

Again, that's not the desired outcome. The desired outcome is that when 
the screen shuts off, the application no longer gets scheduled until a 
network packet arrives. The difference between these scenarios is large.

> If you have wake-on-lan then the network stack might be smarter and
> choose to express itself as
> 
> 	'the constraint is C6 unless the input queue is empty in which
> 	 case suspend is ok as I have WoL and my network routing is such
> 	 that I can prove that interface will be used'

This is still racy. Going back to this:

int input = socket(AF_INET, SOCK_STREAM|SOCK_NONBLOCK, 0);
char foo;
struct sockaddr addr;
connect (input, &addr, sizeof(addr))
while (1) {
       if (read(input, &foo, 1) > 0) {
               (do something)
       } else {
		* SUSPEND OCCURS HERE *
               (draw bouncing cows and clouds and tractor beams briefly)
       }
}

A wakeup event now arrives. We use kernel level suspend blockers to 
prevent the system from going back to sleep until userspace has read the 
packet. The application finishes drawing its cows, reads the packet 
(thus releasing the kernel-level suspend block) and them immediately 
reaches the end of its timeslice. At this point the application has not 
had an opportunity to indicate in any way whether or not the packet has 
altered its constraints in any way. What stops us from immediately 
suspending again?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
