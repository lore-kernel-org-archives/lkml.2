Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1DEQjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:39:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50925 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab1DEQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gd/PW8R888uO1dXHmiT3klKYeydFPjhoEkkZ2k/FC6+PDOi1UwKvmRewgFKh6c3Xr3
         8qFyMr9V4h9E/CMdSNDsLgrx6KnrsIGtB10I2vh0FpiI5Q6lV/JoexKQf76i2lkxQl62
         AGx8br60z5DwFrtnEuFbFfhrUohIKUa0HnAkM=
Date: Tue, 5 Apr 2011 09:38:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeffrey Brown <jeffbrown@android.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
Message-ID: <20110405163855.GC4183@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com>
 <20110404213659.GC984@core.coreip.homeip.net>
 <BANLkTi=0q6DbXki5RhE8eakermnVixN67g@mail.gmail.com>
 <20110404224611.GA2783@core.coreip.homeip.net>
 <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinLcXsZpHm3_uzRUEdrJQsbozgghA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 05:34:09PM -0700, Jeffrey Brown wrote:
> Dmitry,
> 
> On Mon, Apr 4, 2011 at 3:46 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Mon, Apr 04, 2011 at 03:16:13PM -0700, Jeffrey Brown wrote:
> >> bool full_sync = (type == EV_SYN && code == SYN_REPORT);
> >
> > I am not sure what is cheaper - 2 conditionals or stack manipulation
> > needed to push another argument if we happed to be register-starved.
> 
> Not a question of the computational cost.  It was mostly done to avoid
> repeating the same predicate in multiple places.  This was one of the
> suggested improvements to my earlier patch.
> 
> >> This comment for last_syn is not quite right.  We need last_syn to
> >> refer to the position just beyond the last sync.  Otherwise the device
> >> will not become readable until another event is written there.  The
> >> invariants for last_syn should be similar to those for head.
> >
> > Hm, yes, comment is incorrect. Given this fact I do not like the name
> > anymore either (nor do I like 'end'). Need to think about something
> > better.
> 
> Heh, I faced this very same dilemma.  I tried 'last_sync',
> 'readable_tail', 'read_end', and others before settling on 'end' and a
> descriptive comment.

'packet_head' maybe? Similar to the head but for whole event packet?

> 
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
> 
> >> I don't think it's safe to modify last_syn outside of the spin lock.
> >> This should be done above.
> >
> > This is the only writer, plus we are running under event_lock with
> > interrupts off, so it is safe.
> 
> The value will be read concurrently by evdev_fetch_next_event.  So if
> this were safe, then we wouldn't need the spin lock at all.

Before we started changing tail to advance to SYN_DROPPED position we
could probably drop the buffer lock and sprinkle memory barriers (to
ensure, for example, that buffer is written before advancing head).

Now we do need to protect buffer and head/tail but the new field can be
updated outside the lock.

> 
> At the very least for the sake of consistency, I think we should keep
> the buffer manipulations within the guarded region.
> 

OK, we can do that too. As I said, we are running with interrupts off
and with even_lock acquired so we can pull update to the new field along
with kill_fasync inside the buffer lock.

Thanks.

-- 
Dmitry
