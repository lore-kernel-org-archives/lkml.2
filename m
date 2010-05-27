Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab0E0SNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:13:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54523 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0E0SNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:13:07 -0400
Date: Thu, 27 May 2010 19:12:39 +0100
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
Message-ID: <20100527181239.GF3543@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <20100527160543.2228fc17@lxorguk.ukuu.org.uk> <20100527160714.GB31937@srcf.ucam.org> <20100527174131.18fd1c72@lxorguk.ukuu.org.uk> <20100527165210.GA1062@srcf.ucam.org> <20100527190204.14546caa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527190204.14546caa@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:02:04PM +0100, Alan Cox wrote:
> > This is still racy. Going back to this:
> > 
> > int input = socket(AF_INET, SOCK_STREAM|SOCK_NONBLOCK, 0);
> > char foo;
> > struct sockaddr addr;
> > connect (input, &addr, sizeof(addr))
> > while (1) {
> >        if (read(input, &foo, 1) > 0) {
> >                (do something)
> >        } else {
> > 		* SUSPEND OCCURS HERE *
> 
> Fine but then the packet will arrive and we will wake back up process the
> packet and wake the task. See suspend is just like a deep sleep. If we
> went to sleep there and the packet arrival doesn't rewake the box the
> driver was buggy.

Yes, there's no problem so far. The question is how you guarantee that 
the application has had the opportunity to handle the packet.

> > reaches the end of its timeslice. At this point the application has not 
> > had an opportunity to indicate in any way whether or not the packet has 
> > altered its constraints in any way. What stops us from immediately 
> > suspending again?
> 
> If my app level constraint before the packet is 'don't suspend' then my
> constraint on receipt is 'don't suspend' so I won't suspend. If my
> constraint is then lowered and I suspend I will suspend *after* the
> lowering.

If the app level constraint before the packet was "don't suspend", we 
wouldn't have suspended. Here's a description of the desired behaviour 
of the application as you requested:

The application is a network monitoring app that renders server state 
via animated bouncing cows. The desired behaviour is that the 
application will cease to be scheduled if the session becomes idle 
(where idle is defined as the system having received no user input for 
30 seconds) but that push notifications from the server still be 
received in order to allow the application to present the user with 
critical alerts.

Under Android:

User puts down phone. 30 seconds later the screen turns off and releases 
the last user-level suspend block. The phone enters suspend and the 
application is suspended. A network packet is received, causing the 
network driver to take a suspend block. The application finishes the 
frame it was drawing, takes its own suspend block and reads the network 
packet. In doing so the network driver releases its suspend block, but 
since userspace is holding one the phone stays awake. The application 
then handles the event as necessary, releases its suspend block and the 
phone goes to sleep again.

I don't see how this behaviour can be emulated in your model.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
