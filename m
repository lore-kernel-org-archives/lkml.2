Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0FGXRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:17:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0FGXRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v4amO9rlaq4+/vaDJ0nyAbvL4lEPMuLaVWccgnbIKHyxnEkBCNMiCVg0pb0rGOHW7/
         fnS/rcfTAtnr5frJKWVX/TFnDV6dOs3B/qN4D/kHNBg2QxcPwMxaF8vToPGroQF10UHU
         9rjorrLtzGio/mwXKVS4+cF5dl9r3gIn+PfIQ=
MIME-Version: 1.0
In-Reply-To: <1275916830.1645.566.camel@laptop>
References: <1275834706.7227.545.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	<1275844114.7227.552.camel@mulgrave.site>
	<20100606190525.GA20517@infradead.org>
	<AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
	<20100606192405.GA7559@infradead.org>
	<AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
	<1275916830.1645.566.camel@laptop>
Date: Tue, 8 Jun 2010 01:17:13 +0200
Message-ID: <AANLkTik-0JRJTEbVkr4LUsnELRuqpmGYrRsMxVZDpz8C@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Swetland <swetland@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, "Arve Hj?nnev?g" <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>, hackbod@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/7 Peter Zijlstra <peterz@infradead.org>:
> On Sun, 2010-06-06 at 12:58 -0700, Brian Swetland wrote:
>> Somebody will have to broker a deal with the frameworks/apps folks to
>> get rid of the binder.  They like it a lot.  Of course if somebody
>> built a drop-in replacement for the userspace side that didn't require
>> a kernel driver, had the same performance characteristics, solved the
>> same problems, etc, they could probably make an argument for it (or
>> just provide it as a drop-in replacement for people who want a more
>> "pure" linux underneath Android, even if we didn't pick it up).
>
> So what's up with this Binder stuff, from what I can see its just
> yet-another-CORBA. Why does it need a kernel part at all, can't you
> simply run with a user-space ORB instead?
>
> I really don't get why people keep re-inventing CORBA, there's some
> really nice (free) ORBs out there, like:
>
>  http://www.cs.wustl.edu/~schmidt/TAO.html

There was a mailthread on LKML a while back where binder was
discussed, where Dianne Hackborn explained in detail how Android
uses binder. At the time it was contrasted with D-Bus (the IPC
mechanism that has largely replaced DCOP (KDE) and Bonobo
(GNOME), the latter was actually CORBA-based).

I don't think there was any conclusion, but it was pretty clear that
binder is an Android key asset, actually the key component that
the Android people have brought with them from BeOS to
Palmsource to Android to Google, and they really really like to use
that thing.

It's built into the entire Android userspace for all IPC, except the
stuff that's handled by D-Bus instead (yes they have
both for some cases).

What sets binder aside from the others is that it's kernel-based;
things like low-latency and large buffer-passing have been mentioned
as key features of the kernel driver.

Solving binder one way is to just include it and say it's needed
to run Android, the other is to define the technical issue at hand,
which is: "can the kernel support high-speed, low-latency,
partly marshalled, large-buffer IPC?"

D-Bus (on a local machine, mind you, it can use TCP also) will use
a simple unix domain socket by:

socket(PF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0)
as can be seen here:
http://cgit.freedesktop.org/dbus/dbus/tree/dbus/dbus-sysdeps-unix.c

ACE/TAO as referenced seems to use only TCP sockets actually:
https://svn.dre.vanderbilt.edu/viewvc/Middleware/trunk/ACE/ace/Sock_Connect.cpp?view=co
Perhaps it simply uses 127.0.0.1 for local IPC. (The source is
voluminous and hard for me to navigate, perhaps someone
familiar with it can add something here.)

Then either D-Bus or TAO builds a complete marshalling stack on
top of these sockets, it's all fully abstract, fully userspace. Several
processes and dbus daemons push/pull bytes into these sockets.
I think DCOP and Bonobo basically do the same thing, by
the way.

Binder on the other hand is a large kernel module:
http://android.git.kernel.org/?p=kernel/experimental.git;a=blob;f=drivers/staging/android/binder.c;h=e13b4c4834076eb64680457049832af0b92d88b9;hb=android-2.6.34-test2

It will do some serious reference counting, handshaking back-and-forth
and so on. Basically a lot of the stuff that other IPC mechanisms
also does, but in kernelspace. (OK I'm oversimplifying, binder
is far more lightweight for one.)

The bigger question behind it all is this:

Does the kernel provide the proper support for local IPC
transport, or is there more it could do in terms of interface, latency,
throughput?

A domain socket bitsink should be enough for everybody?

So I would really like to know from the Android people why the
binder is in the kernel, after all. Could it *theoretically* be in
userspace, on top of some unix domain sockets, running as a
real-time scheduled daemon or whatever, still yielding the same
performance? Or is there some discovered limitation with current
interfaces, that everybody ought to know? Especially authors of
D-Bus and TAO etc would be very interested in this I believe.

It's not like I don't understand that it would be hard to move this
thing to userspace, it's more that I'd like to know how you think it
would be impacted by that.

Yours,
Linus Walleij
