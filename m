Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0E0XJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:09:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50345 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab0E0XJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:09:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 28 May 2010 01:10:17 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <20100527181433.GG3543@srcf.ucam.org> <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280110.17075.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Alan Cox wrote:
> > No, it's not. Forced suspend may be in response to hitting a key, but it 
> 
> You are the only person here talking about 'forced' suspends. The rest of
> us are talking about idling down and ensuring we are always in a state we
> un-idle correctly.
> 
> > may also be in response to a 30 minute timeout expiring. If I get a WoL 
> > packet in the 0.5 of a second between userspace deciding to suspend and 
> > actually doing so, the system shouldn't suspend.
> 
> I don't think that argument holds water in the form you have it
> 
> What about 5 nanoseconds before you suspend. Now you can't do that (laws
> of physics and stuff).
> 
> So your position would seem to be "we have a race but can debate how big
> is permissible"
> 
> The usual model is
> 
> "At no point should we be in a position when entering a suspend style
>  deep sleep where we neither abort the suspend, nor commit to a
>  suspend/resume sequence if the events we care about occur"
> 
> and that is why the hardware model is
> 
> 	Set wake flags
> 	Check if idle
> 	If idle
> 		Suspend
> 	else
> 		Clear wake flags
> 		Unwind
> 
> and the wake flags guarantee that an event at any point after the wake
> flags are set until they are cleared will cause a suspend to be resumed,
> possibly immediately after the suspend.

That's correct, but to me the Arve's goal is simply to maximize battery life
and he found experimentally that the longest battery life is achieved if
system suspend is used whenever the system doesn't need to be active (from its
user's perspective).  This actually is different from "when the system is
idle", because the system isn't idle, for example, when updatedb is running.
However, from the user's perspective the updatedb process doesn't really need
to run at this particular time, it can very well do it's job in parallel with
the user typing or reading news.  So, the system may very well be suspended
when updatedb is running.

Now, "when the system doesn't need to be active" is not a very precise
statement, so the Android people attempted to develop a mechanism allowing
them to specify what that means more precisely.  It works for them, it need not
work for everyone, though.  Of course, we can dismiss it as "crap", "broken
design", whatever, but then we need to give them a clear advice what to do
to achieve the same goal (maximum battery life) in a different way that would
be more acceptable to us.

Since I think we've now rejected the feature, do we have a clear picture about
what the Android people should do _instead_ and yet keep the battery life they
want?  Because I don't think telling "let them do what they want, who cares"
is right.

Thanks,
Rafael
