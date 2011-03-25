Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1CYXEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:04:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50538 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab1CYXD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110325074920.GF2590@core.coreip.homeip.net>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com> <20110325074920.GF2590@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 25 Mar 2011 16:03:18 -0700
Message-ID: <AANLkTikTOEimVER8eWT7yTUe7+4QS5epQWUAnoJD=B+=@mail.gmail.com>
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps with every packet.  I have seen situations where user space
somehow manages to read events faster than the driver enqueues them.

Pseudo-code basic processing loop:

struct input_event buffer[100];
for (;;) {
    poll(...);
    count = read(fd, buffer, sizeof(buffer) / sizeof(buffer[0]));
    process(buffer, count / sizeof(buffer[0]));
}

I've seen cases on a dual-core ARM processor where instead of reading
a block of 71 events all at once, it ends up reading 1 event after
another 71 times.  CPU usage for the reading thread climbs to 35%
whereas it should be less than 5%.

The problem is that poll() wakes up after the first event becomes
available.  So the reader wakes up, promptly reads the event and goes
back to sleep waiting for the next one.  Of course nothing useful
happens until a SYN_REPORT arrives to complete the packet.

Adding a usleep(100) after the poll() is enough to allow the driver
time to finish writing the packet into the evdev ring buffer before
the reader tries to read it.  In that case, we mostly read complete 71
event packets although sometimes the 100us sleep isn't enough so we
end up reading half a packet instead of the whole thing, eg. 28 events
+ 43 events.

Instead it would be better if the poll() didn't wake up until a
complete packet is available for reading all at once.

Jeff.

On Fri, Mar 25, 2011 at 12:49 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Mar 22, 2011 at 06:04:04PM -0700, Jeff Brown wrote:
>> On SMP systems, it is possible for an evdev client blocked on poll()
>> to wake up and read events from the evdev ring buffer at the same
>> rate as they are enqueued.  This can result in high CPU usage,
>> particularly for MT devices, because the client ends up reading
>> events one at a time instead of reading complete packets.  This patch
>> ensures that the client only wakes from poll() when a complete packet
>> is ready to be read.
>
> Doesn't this only help with very first packet after a pause in event
> stream?
>
> --
> Dmitry
>
