Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab1DEAev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:34:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54497 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1DEAet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:34:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110404224611.GA2783@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com> <20110404213659.GC984@core.coreip.homeip.net>
 <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com> <20110404224611.GA2783@core.coreip.homeip.net>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Mon, 4 Apr 2011 17:34:09 -0700
Message-ID: <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Mon, Apr 4, 2011 at 3:46 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, Apr 04, 2011 at 03:16:13PM -0700, Jeffrey Brown wrote:
>> bool full_sync = (type == EV_SYN && code == SYN_REPORT);
>
> I am not sure what is cheaper - 2 conditionals or stack manipulation
> needed to push another argument if we happed to be register-starved.

Not a question of the computational cost.  It was mostly done to avoid
repeating the same predicate in multiple places.  This was one of the
suggested improvements to my earlier patch.

>> This comment for last_syn is not quite right.  We need last_syn to
>> refer to the position just beyond the last sync.  Otherwise the device
>> will not become readable until another event is written there.  The
>> invariants for last_syn should be similar to those for head.
>
> Hm, yes, comment is incorrect. Given this fact I do not like the name
> anymore either (nor do I like 'end'). Need to think about something
> better.

Heh, I faced this very same dilemma.  I tried 'last_sync',
'readable_tail', 'read_end', and others before settling on 'end' and a
descriptive comment.

>> Should use client->head here so that the SYN_DROPPED is readable.
>
> It is readable, but we do not want to signal on it.

I think we do want to signal on it.  We should signal whenever the
device becomes readable.

Signaling on dropped is useful in the case where a misbehaving device
driver fails to ever call input_sync.  If that happens, we might
enqueue a dropped event and then never wake up the client which makes
the issue hard to diagnose.

>> I don't think it's safe to modify last_syn outside of the spin lock.
>> This should be done above.
>
> This is the only writer, plus we are running under event_lock with
> interrupts off, so it is safe.

The value will be read concurrently by evdev_fetch_next_event.  So if
this were safe, then we wouldn't need the spin lock at all.

At the very least for the sake of consistency, I think we should keep
the buffer manipulations within the guarded region.

Jeff.
