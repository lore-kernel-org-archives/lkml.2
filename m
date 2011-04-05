Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1DEMDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:03:04 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:37993 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1DEMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:03:00 -0400
X-SENDER-IP: [85.230.173.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuNEAJ4Dm01V5q1yPGdsb2JhbACJFJxUCwEBAQE3Moh5ugkNhV4EkQs
X-IronPort-AV: E=Sophos;i="4.63,304,1299452400"; 
   d="scan'208";a="178492938"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Apr 2011 14:03:27 +0200
To: Jeffrey Brown <jeffbrown@android.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, djkurtz@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
Message-ID: <20110405120327.GA19300@polaris.bitmath.org>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com>
 <20110404213659.GC984@core.coreip.homeip.net>
 <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com>
 <20110404224611.GA2783@core.coreip.homeip.net>
 <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Should use client->head here so that the SYN_DROPPED is readable.
> >
> > It is readable, but we do not want to signal on it.
> 
> I think we do want to signal on it.  We should signal whenever the
> device becomes readable.
> 
> Signaling on dropped is useful in the case where a misbehaving device
> driver fails to ever call input_sync.  If that happens, we might
> enqueue a dropped event and then never wake up the client which makes
> the issue hard to diagnose.

A device that never wakes up the client seems like a detectable
symptom. I agree with Dmitry, the dropped event is more of a note in
passing, and as such can stay in the pipe until a real EV_SYN event
comes along.

> >> I don't think it's safe to modify last_syn outside of the spin lock.
> >> This should be done above.
> >
> > This is the only writer, plus we are running under event_lock with
> > interrupts off, so it is safe.
> 
> The value will be read concurrently by evdev_fetch_next_event.  So if
> this were safe, then we wouldn't need the spin lock at all.

The spinlock ensures atomic read/write of the event buffer. The
position into the buffer does not need the lock.

> At the very least for the sake of consistency, I think we should keep
> the buffer manipulations within the guarded region.

Sounds reasonable.

Thanks,
Henrik
