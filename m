Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1DEQcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:32:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48797 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1DEQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:32:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nOQr9YsGjP3/krFuRJq4TlaZ+zYuGrArp7oeiH2sBqaGFJQ7zcFCjFrZRBYqKBv2r2
         bRYxzM3iPTDXdZtafN66Ni6b0xC3WGt/V2q4gB0A3eNWykhj06c4oD+uTPDohTD40azB
         Zati5Y8TroSMOAbkEfkDCzoA47J/aQlceDQhU=
Date: Tue, 5 Apr 2011 09:32:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jeffrey Brown <jeffbrown@android.com>, djkurtz@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
Message-ID: <20110405163239.GB4183@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com>
 <20110404213659.GC984@core.coreip.homeip.net>
 <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com>
 <20110404224611.GA2783@core.coreip.homeip.net>
 <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
 <20110405120327.GA19300@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405120327.GA19300@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 02:03:27PM +0200, Henrik Rydberg wrote:
> > >> Should use client->head here so that the SYN_DROPPED is readable.
> > >
> > > It is readable, but we do not want to signal on it.
> > 
> > I think we do want to signal on it.  We should signal whenever the
> > device becomes readable.
> > 
> > Signaling on dropped is useful in the case where a misbehaving device
> > driver fails to ever call input_sync.  If that happens, we might
> > enqueue a dropped event and then never wake up the client which makes
> > the issue hard to diagnose.
> 
> A device that never wakes up the client seems like a detectable
> symptom. I agree with Dmitry, the dropped event is more of a note in
> passing, and as such can stay in the pipe until a real EV_SYN event
> comes along.

Also we have evbug module to report raw event stream from theinput core
without evdev involvement. It should show missing SYN_REPORT should such
a driver appear.

> 
> > >> I don't think it's safe to modify last_syn outside of the spin lock.
> > >> This should be done above.
> > >
> > > This is the only writer, plus we are running under event_lock with
> > > interrupts off, so it is safe.
> > 
> > The value will be read concurrently by evdev_fetch_next_event.  So if
> > this were safe, then we wouldn't need the spin lock at all.
> 
> The spinlock ensures atomic read/write of the event buffer. The
> position into the buffer does not need the lock.
> 
> > At the very least for the sake of consistency, I think we should keep
> > the buffer manipulations within the guarded region.
> 
> Sounds reasonable.

OK, we can pull kill_fasync inside spin_lock/unlock pair, it should
change nothing.

-- 
Dmitry
