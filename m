Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1B1NKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:10:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35376 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1B1NKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:10:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nvJO5jKnDNzJsekEasFZ/Yqlrg3aZoR/dPXQIEkh54fqF8WVYHEOmpSmRzyj5kQRLX
         ee3I826RrfaxfhsOZ2pYTimWpXuJbO1pNBVEESLFbIWIc5nIGdOHS5vM3piWnIMDMypT
         vDFm9rd08Ky0AMjTpIsrrkYsq8fQ9BdSh/6ug=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Albert Cahalan <acahalan@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20110228134338.1241484mkljbz4w0@hayate.sektori.org>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	 <1298793252.8726.45.camel@edumazet-laptop>
	 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	 <1298837273.8726.128.camel@edumazet-laptop>
	 <20110228134338.1241484mkljbz4w0@hayate.sektori.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 14:10:40 +0100
Message-ID: <1298898640.2941.256.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 février 2011 à 13:43 +0200, Jussi Kivilinna a écrit :
> Quoting Eric Dumazet <eric.dumazet@gmail.com>:
> 
> > Le dimanche 27 février 2011 à 12:55 +0200, Jussi Kivilinna a écrit :
> >> Quoting Albert Cahalan <acahalan@gmail.com>:
> >>
> >> > On Sun, Feb 27, 2011 at 2:54 AM, Eric Dumazet  
> >> <eric.dumazet@gmail.com> wrote:
> >> >> Le dimanche 27 février 2011 à 08:02 +0100, Mikael Abrahamsson a écrit :
> >> >>> On Sun, 27 Feb 2011, Albert Cahalan wrote:
> >> >>>
> >> >>> > Nanoseconds seems fine; it's unlikely you'd ever want
> >> >>> > more than 4.2 seconds (32-bit unsigned) of queue.
> >> > ...
> >> >> Problem is some machines have slow High Resolution timing services.
> >> >>
> >> >> _If_ we have a time limit, it will probably use the low resolution (aka
> >> >> jiffies), unless high resolution services are cheap.
> >> >
> >> > As long as that is totally internal to the kernel and never
> >> > getting exposed by some API for setting the amount, sure.
> >> >
> >> >> I was thinking not having an absolute hard limit, but an EWMA based one.
> >> >
> >> > The whole point is to prevent stale packets, especially to prevent
> >> > them from messing with TCP, so I really don't think so. I suppose
> >> > you do get this to some extent via early drop.
> >>
> >> I made simple hack on sch_fifo with per packet time limits
> >> (attachment) this weekend and have been doing limited testing on
> >> wireless link. I think hardlimit is fine, it's simple and does
> >> somewhat same as what packet(-hard)limited buffer does, drops packets
> >> when buffer is 'full'. My hack checks for timed out packets on
> >> enqueue, might be wrong approach (on other hand might allow some more
> >> burstiness).
> >>
> >
> >
> > Qdisc should return to caller a good indication packet is queued or
> > dropped at enqueue() time... not later (aka : never)
> >
> > Accepting a packet at t0, and dropping it later at t0+limit without
> > giving any indication to caller is a problem.
> >
> > This is why I suggested using an EWMA plus a probabilist drop or
> > congestion indication (NET_XMIT_CN) to caller at enqueue() time.
> >
> > The absolute time limit you are trying to implement should be checked at
> > dequeue time, to cope with enqueue bursts or pauses on wire.
> >
> 
> Would it be better to implement this as generic feature instead of  
> qdisc specific? Have qdisc_enqueue_root do ewma check:

Problem is you can have several virtual queues in a qdisc.

For example, pfifo_fast has 3 bands. You could have a global ewma with
high values, but you still want to let a high priority packet going
through...



