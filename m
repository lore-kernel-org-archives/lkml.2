Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1C1IzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:55:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32833 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1C1IzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:55:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110328061214.GD31692@core.coreip.homeip.net>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com> <20110325074920.GF2590@core.coreip.homeip.net>
 <AANLkTikTOEimVER8eWT7yTUe7+4QS5epQWUAnoJD=B+=@mail.gmail.com> <20110328061214.GD31692@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 28 Mar 2011 01:54:37 -0700
Message-ID: <AANLkTikai5zePwGicXXKj1hpHt=4JLaKN3migfXe_8QE@mail.gmail.com>
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Sun, Mar 27, 2011 at 11:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>>     count = read(fd, buffer, sizeof(buffer) / sizeof(buffer[0]));
>
> I hope this is simply a typo in pseudo-code - read takes size in bytes,
> not in number of structures.

Definitely a typo.  :)

> Unfortunately your change fixes only first packet, like I mentioned.
> Consider the following scenario:
>
>  - input core delivers events, we postpone waking up waiters
>   till we get EV_SYN/SYN_REPORT;
>  - userspace is waken and consumes entire packet;
>  - in the meantime input core delivered 3 more events;
>  - userpsace executes poll;
>  - kernel adds the process to poll waiters list (poll_wait() call in
>   evdev_poll();
>  - evdev_poll() checks the condition, sees that there are events and
>   signals that the data is ready even though we did not accumulate
>   full event packet.
>
> Hence your fix did not reliably fix the issue you are seeing.

Ahh, I see what you mean.  As long as the buffer is non-empty, poll()
considers the stream to be readable therefore it does not block.
That's a good thing as otherwise clients that poll() / read() one
event at a time would be broken.

Delaying when we wake waiters is helpful in the common case but as you
point out there still exists a potential degenerate case if the writer
is busy and prevents the reader from ever catching up completely and
blocking when the buffer is empty.  I haven't seen that happen but
it's certainly possible.  In any case, it would be no worse than what
we have now.

> We might entertain notion of not considering device readable unless
> there is a sync event that has not been consumed, but this is
> significant change in semantics and we need much more consideration.

Indeed.  That's why I brought the idea here for discussion.  :)

For maximum compatibility we could define an ioctl to enable new
readability semantics.  Existing clients would retain the old behavior
(device is readable whenever it is non-empty).  I'm not sure this is
really necessary but it might be useful to help diagnose bad drivers
that never write sync packets.

Suppose we adopt the invariant that when new readability semantics are
enabled, clients are only allowed to read events that belong to
complete packets.  That is, they can read events one at a time or in
batches all they like but only up to and including the last sync
event.

Implementing this behavior is straightforward.

Keep track of the end index one past the last readable event in the
ring buffer.  The end index marks the end of the readable portion of
the buffer.  Initially the read index and end index are the same
(zero).  The read index is never allowed to advance past the end
index.  When the read index equals the end index, the device is not
readable.  (Equivalently, the device is only readable when the buffer
contains at least one sync event that has not yet been read.)  When a
sync event (other than SYN_MT_REPORT) is written, advance the end
index past the sync event so that the entire packet becomes readable,
then wake up the waiters because readability may have changed.

How's that sound?

Thanks,
Jeff.
