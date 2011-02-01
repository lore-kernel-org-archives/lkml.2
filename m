Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1BARqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:46:50 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43101 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755784Ab1BARqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:46:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mKK3ulOAHn1qsgTluflVaGDZRb2Dm+Y+OppYfoF5Hhxnvv/MdT8+X6OLwmVKk+2RT5cW1OqCzXfj/H17j0zH1F4oZlAMRuZylYD1QIKC76b8cPgKgbi/Jtb3Aj6d8rGo;
Date: Tue, 1 Feb 2011 09:46:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Message-ID: <20110201094643.366bc073@jbarnes-desktop>
In-Reply-To: <alpine.LSU.2.00.1102010909270.1586@sister.anvils>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 09:34:12 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Mon, 31 Jan 2011, Chris Wilson wrote:
> 
> > Hugh Dickins found that characters in xterm were going missing and oft
> > delayed. Being the curious type, he managed to associate this with the
> > new high-precision vblank patches; disabling these he found, restored
> > the orderliness of his characters.
> > 
> > The oddness begins when one realised that Hugh was not using vblanks at
> > all on his system (fvwm and some xterms). Instead, all he had to go on
> > were warning of a pipe underrun, curiously enough at around 60Hz. He
> > poked and found that in addition to the underrun warning, the hardware
> > was flagging the start of a new frame, a vblank, which in turn was
> > kicking off the pending vblank processing code.
> > 
> > There is little we can do for the underruns on Hugh's machine, a
> > Crestline [965GM], which must have its FIFO watermarks set to 8.
> > However, we do not need to process the vblank if we know that they are
> > disabled...
> > 
> > Reported-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> Thanks a lot for devising this, Chris, I really appreciate it.
> 
> But so far I can't be more enthusiastic than "seems to be a good
> improvement most of the time" - though I've not spent long on this
> laptop since putting it on to -rc3.
> 
> I've not seen it go wrong on x86_64, but my first boot with it on
> i386 behaved just as badly as before; thereafter it's not gone wrong
> yet (and I had to double-check boot.omsg to make sure I'd really been
> running what I thought I was running the first time).  I'm relying
> upon it to type this mail, which I wouldn't have managed before.
> 
> As you know (I went off-list to send more info at the weekend), this
> behaviour is very elusive, probably depends on more than one issue,
> comes and goes with irrelevant patches and config changes and reboots.

Are you still seeing underruns during normal activity?  I wonder if the
ones you were seeing before were only reported at 60Hz due to vblank
interrupt processing.  If we failed to clear the underrun status, we'd
report one every time we got a vblank interrupt (since the underruns
don't report interrupts by themselves).

If so, that may just be a red herring in this case.

-- 
Jesse Barnes, Intel Open Source Technology Center
