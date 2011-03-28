Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1C1GMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:12:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52434 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1C1GMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lmnZvaqzoP1q0jwARCWKDDBa1/RQ801kMFXQZ2jt5FvZnpZpLpkVBYrTm/Ne58u8Fu
         rtaxHYz/cQjfwVcNBE/F6BGYCgrgWAvtavrxoqHVu8o/p2lyGB4rryZfMv5MRagMR8H/
         y9OBifScd6Im5RyiQFdGE5gFP1ITB9rT2d5i4=
Date: Sun, 27 Mar 2011 23:12:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeffrey Brown <jeffbrown@android.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
Message-ID: <20110328061214.GD31692@core.coreip.homeip.net>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com>
 <20110325074920.GF2590@core.coreip.homeip.net>
 <AANLkTikTOEimVER8eWT7yTUe7+4QS5epQWUAnoJD=B+=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikTOEimVER8eWT7yTUe7+4QS5epQWUAnoJD=B+=@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all - please do not top post.

On Fri, Mar 25, 2011 at 04:03:18PM -0700, Jeffrey Brown wrote:
> It helps with every packet.  I have seen situations where user space
> somehow manages to read events faster than the driver enqueues them.
> 
> Pseudo-code basic processing loop:
> 
> struct input_event buffer[100];
> for (;;) {
>     poll(...);
>     count = read(fd, buffer, sizeof(buffer) / sizeof(buffer[0]));

I hope this is simply a typo in pseudo-code - read takes size in bytes,
not in number of structures.

>     process(buffer, count / sizeof(buffer[0]));
> }
> 
> I've seen cases on a dual-core ARM processor where instead of reading
> a block of 71 events all at once, it ends up reading 1 event after
> another 71 times.  CPU usage for the reading thread climbs to 35%
> whereas it should be less than 5%.
> 
> The problem is that poll() wakes up after the first event becomes
> available.  So the reader wakes up, promptly reads the event and goes
> back to sleep waiting for the next one.  Of course nothing useful
> happens until a SYN_REPORT arrives to complete the packet.

Unfortunately your change fixes only first packet, like I mentioned.
Consider the following scenario:

 - input core delivers events, we postpone waking up waiters
   till we get EV_SYN/SYN_REPORT;
 - userspace is waken and consumes entire packet;
 - in the meantime input core delivered 3 more events;
 - userpsace executes poll;
 - kernel adds the process to poll waiters list (poll_wait() call in
   evdev_poll();
 - evdev_poll() checks the condition, sees that there are events and
   signals that the data is ready even though we did not accumulate
   full event packet.

Hence your fix did not reliably fix the issue you are seeing.

> 
> Adding a usleep(100) after the poll() is enough to allow the driver
> time to finish writing the packet into the evdev ring buffer before
> the reader tries to read it.  In that case, we mostly read complete 71
> event packets although sometimes the 100us sleep isn't enough so we
> end up reading half a packet instead of the whole thing, eg. 28 events
> + 43 events.
> 
> Instead it would be better if the poll() didn't wake up until a
> complete packet is available for reading all at once.

Unfortunately poll() does not know the intent of userspace program -
will it try to consume the whole event or will it work in poll/read one
event/poll again mode. In this case you really do not want to delay
reading till next EV_SYN comes along.

We might entertain notion of not considering device readable unless
there is a sync event that has not been consumed, but this is
significant change in semantics and we need much more consideration.

> 
> Jeff.
> 
> On Fri, Mar 25, 2011 at 12:49 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tue, Mar 22, 2011 at 06:04:04PM -0700, Jeff Brown wrote:
> >> On SMP systems, it is possible for an evdev client blocked on poll()
> >> to wake up and read events from the evdev ring buffer at the same
> >> rate as they are enqueued.  This can result in high CPU usage,
> >> particularly for MT devices, because the client ends up reading
> >> events one at a time instead of reading complete packets.  This patch
> >> ensures that the client only wakes from poll() when a complete packet
> >> is ready to be read.
> >
> > Doesn't this only help with very first packet after a pause in event
> > stream?
> >
> > --
> > Dmitry
> >

-- 
Dmitry
