Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0HHSC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 14:02:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0HHSC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 14:02:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=grYawMf7FZ/fv5NVv/6oHVTkd44OAORLDg+gkqVKpV/nHsYN5VcvipZE4DkQfb6BQ
	7ohIZjYv+9VH4lGOUa29Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
Date: Sun, 8 Aug 2010 11:02:21 -0700
Message-ID: <AANLkTim4dH2p3KXB1wUi793y7darf1xzfXV0bm34gFQu@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 10:40 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>> This goes back to your first assertion that there are *many*
>> applications that need to run in the background.  I just don't think
>> that's true.  There will be a few, and probably more than just the
>> restricted set allowed (and programmed) by Apple.  But not *many*.
>
> The argument in favor of suspend blockers is that you could take
> applications that are not designed for embedded, and make them run on
> an embedded device without draining excessive battery life; those
> applications would have to be background services not conflicting with
> Android's design.
>
> I agree there probably would not be that many background apps, and
> probably even less ported background apps, but that is actually an
> argument against suspend blockers.
>
> The rest of the apps (UI apps), cannot be ported, but have to be
> written specifically for Android, and therefore should have PM in
> mind, and not require suspend blockers to have good power usage.

I think there's some confusion here.

The default operating mode for Android is to aggressively reach the
lowest possible power state (typically full suspend).  suspend
blockers are used by applications to inform the system that they are
currently doing work which requires immediate processing, so the
system will avoid fully suspending until that work is done.  You could
think of it as setting your laptop power management settings to be
"blank screen after 60 seconds, power down 5 seconds after blanking",
except that there's also a mechanism for apps to hold off on that
power down if they're doing important work, and a lot more ways to
wakeup beyond opening the lid or pushing the power button.

Straight-forward UI apps don't actually require much special handling
-- it's preferable that they do busy-wait on things, but even when
power is not an issue, wasting cpu spinning needlessly is frowned
upon, so this isn't a special request.  There's nothing stopping
somebody from writing an Android app that acts as a bridge to X11 apps
(embedding an X server, etc) and making it possible for native X11
apps to coexist with the Android composition model.  I'm a little
surprised nobody has done so, actually.  I figured *somebody* would
decide that they like their phone but absolutely need to run xclock or
something locally as a first class app.

The Android app model does say that if you're not in the foreground
(from a UI standpoint) you should save your state, as you may be
terminated if the system runs low on resources.  The system only does
this when it has to -- generally when we bottom out on memory.  On
devices with sufficient memory, it's quite common for many apps to
remain resident for days-weeks -- I've seen as many as 45-50 apps
running on my nexus one.

I am a little puzzled by the assertion that Android lasks "true
multitasking", but that's another discussion entirely.  We certainly
don't lack for many concurrent processes and threads...

Brian
