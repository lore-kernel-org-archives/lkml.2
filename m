Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0EEU4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:56:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab0EEU4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:56:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=jTEvpdUlnFfbZQ9rMTFXZXNrlT8Ybm3BiYAWVf3JacgIJh99FcwaI01Z1Q62LbMuB
	O2JcMCxvXsy5fnYSJ81Ug==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
Date: Wed, 5 May 2010 13:56:07 -0700
Message-ID: <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 12:13 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 5 May 2010, Matthew Garrett wrote:
>
>> > Clearly if there's a call in progress you don't want to shut the codec
>> > down.  Are there any other circumstances?  Would they vary according to
>> > whether the suspend was forced or opportunistic?
>>
>> Yeah, ok. We probably do need to figure this out.
>>
>> (Cc:ing Rebecca to see how this got handled on Droid)
>>
>> The current state of affairs is that a system suspend request is
>> expected to put the device in as low a power state as possible given the
>> required wakeup events. Runtime power management is expected to put the
>> device in as low a power state as possible given its usage constraints.
>> If opportunistic suspend does the former then it'll tear down devices
>> that may be in use, but we don't have any real way to indicate usage
>> constraints other than the phone app taking a wakelock - and that means
>> leaving userspace running during calls, which seems excessive.
>>
>> Mark's right in that the only case I can think of that's really relevant
>> right now is the audio hardware, so the inelegant solution is that this
>> is something that could be provided at the audio level. Is this
>> something we want a generic solution for? If so, what should it look
>> like?
>
> Should the audio driver be smart enough to know that the codec needs to
> remain powered up during every opportunistic suspend?
>
> Or only during opportunistic suspends while a call is in progress?
>
> Does it know when a call is in progress?

>From my point of view, the codec should be powered up while audio is
playing and powered down when it's not -- that's the approach I've
taken on MSM, regardless of suspend state.  I don't view suspend as
something that stops audio playback in progress.  Sort of similar to
how the modem doesn't power off down when the system is in suspend,
etc.

In effect, we have followed a sort of runtime pm model of
clocking/powering peripherals at the lowest possible level at all
times, which is why I've never viewed suspend_block as somehow
competing with runtime pm -- we always want all drivers/peripherals in
the lowers power state.  Sometimes the lowest power state possible is
higher than "full suspend" (for example when we can't meet latency
requirements on audio on 7201A) and suspend_blockers cover that case.

Brian
