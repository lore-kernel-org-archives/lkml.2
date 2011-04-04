Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1DDSNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:13:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60574 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab1DDSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1104041441530.28516@pobox.suse.cz>
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com>
 <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com> <alpine.LNX.2.00.1104041441530.28516@pobox.suse.cz>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 4 Apr 2011 11:13:12 -0700
Message-ID: <BANLkTikG-ku9mDebcaPKTwv3X0N+OKiyYQ@mail.gmail.com>
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Simon Budig <simon@budig.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I originally sent a reply to the list from my phone but it was
HTML formatted for some reason and the list server rejected it.  Meh.

On Mon, Apr 4, 2011 at 5:43 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> Could you just briefly describe what your solution is?

I have sent a series of 4 patches to linux-input:

* [PATCH v2 1/4] input: Set default events per packet.

This patch modifies input_register_device to calculate the number of
events per packet if the driver did not already supply a hint.
Roughly speaking, it examines the number of MT_SLOTs or
ABS_MT_TRACKING_IDs and multiplies that by the total number of MT
axes, then adds in a bit for non-MT axes, REL axes and SYN events.

The intent is to systematically solve the problem of determining the
number of events per packet so that most drivers won't need to set
hints themselves.  This fixes the magic mouse issue and related
problems in other drivers.

* [PATCH v2 2/4] hid: hid-input: Remove obsolete default events per
packet setting.

Given the first patch, the HID driver no longer needs to hardcode a
default events per packet value.

* [PATCH v2 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.

I first discovered that the evdev buffer was too small because of the
Apple Magic Trackpad.  With more than 3 fingers, some points would
regularly get dropped and would interrupt the gestures I was trying to
detect.  User space code got really confused since there was no
indication that anything unusual had happened and the event streams
effectively appeared to be truncated and concatenated arbitrarily.

So this patch introduces a new type of SYN event code, SYN_DROPPED, to
mark the point in the event stream where events were dropped.  The
most recent version of this patch also takes care to drop the entire
last packet, so the next event received by user-space will be the
first event of the following compete packet.

* [PATCH v2 4/4] input: evdev: Make device readable only when it
contains a complete packet.

There is a significant performance issue on SMP systems where the
driver and user-space code can race against one another to fill and
drain the evdev buffer in parallel.  It is possible for a client
waiting on poll() to wake up and read each event published by the
driver immediately as it becomes available.  That could mean 60 or
more calls to poll() and read() to read an entire packet.  It would be
preferable if the client were only awoken when the entire packet were
available so it could just make 1 call to poll() and read() everything
all at once.

No changes are required on the part of the client.  This patch changes
when evdev considers itself readable.  Essentially evdev is made to be
readable only up to the last non-MT SYN event it contains.  That way
the client can only read events that belong to packets which have been
completely buffered.  The client can still read events one at a time
if it likes.  The client will only wake from poll() when the buffer
contains a non-MT SYN.

This patch works well in combination with the SYN_DROPPED change above.

> I'd happuly take Chase's patch, but want to make sure that we don't cause
> any changes that would make backwards compatilibity an issue later.

There should be no compatibility issues.  However, we might be better
off in the long term taking (some variation of) these patches instead.

Jeff.
