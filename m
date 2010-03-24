Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab0CXOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:01:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:35507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0CXOBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:01:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=p4bqABgbpzgYXQ3wSdbGEEWpt/RTvd1VkxzHy83JqGVKUP8cdM2hwxT2GlAXlubji
	aQvOpkd6Ckkp/VUWiaqYw==
MIME-Version: 1.0
In-Reply-To: <20100324054531.GA30416@drongo>
References: <4ba8f988.9804cc0a.4b1f.5d77@mx.google.com>
	 <20100324054531.GA30416@drongo>
Date: Wed, 24 Mar 2010 15:01:14 +0100
Message-ID: <bd4cb8901003240701y63198cc5hd380bbe754e57915@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix remapped count support
From: Stephane Eranian <eranian@google.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 6:45 AM, Paul Mackerras <paulus@samba.org> wrote:
> On Tue, Mar 23, 2010 at 06:25:01PM +0200, Stephane Eranian wrote:
>
>> The patch adds a new field to the perf_mmap_page buffer header (delta_base).
>> It is necessary to correctly scale the count. This new value represents the
>> counter value when the event was last scheduled in. It cannot be substracted
>> by the kernel from the total count because of scaling. The correct formula is:
>>
>>        count = offset * time_enabled/time_running + (raw_count - prev_count)
>
> Interesting.  On powerpc I took the view that what was needed from a
> user-space direct_counter_read() function was to return the same value
> as a read() on the event counter fd would give, that is, the unscaled
> count.  The stuff that's in the mmapped page is sufficient to compute
> the unscaled count, and I already have userspace code on powerpc that
> does that.
>
We agree on that. When you combined mmapped data + direct_counter_read()
you should get the unscaled count.

As for the scaling, you are right, my formula is not quite correct. You also
need to scale the delta you obtain for the direct_read_counter(). But for
that, you would need the timebase relative to when prev_count was last
touched. Then, you would need to collect time at the user level (TSC)
and compute the time delta t. In that case, I think the correct formula
would become:

            (offset + (raw_count - prev_count)) * (time_enabled + t)
count = --------------------------------------------------------------------------------
             time_running + t


>
> We don't currently have a way to work out up-to-the-nanosecond values
> of time_enabled and time_running in userspace, though it could be
> done.  Userspace would have to read the timebase or TSC (or
> equivalent), subtract a base value, multiply by a scale factor, and
> add that on to the time_enabled/time_running values stored in the
> mmapped page.  Although this is all quite doable on powerpc where the
> timebase counts at constant frequency and is synchronized across cpus,
> it seemed like it could get complicated on x86 where the TSC might
> change speed and might not be synchronized (though I suppose we only
> need to supply the values relevant to the cpu where the monitored
> thread is running).

Recent X86 processors do have constant TSC, i.e., not subject to frequency
scaling.

You don't need to have TSC synchronized as long as you guarantee that
prev_count and the kernel TSC snapshot is updated each time the event
is scheduled.

>
>> For other architectures, e.g., PPC, SPARC, assuming they do offer the ability
>> to read counts directly from user space, all that is needed is a couple of new
>> arch specific functions:
>>       - hw_perf_event_counter_width(): actual counter width
>>       - hw_perf_event_index(): register index to pass to the user instruction
>>       - hw_perf_update_user_read_perm(): toggle permission to read from userspace
>
> I'm puzzled why powerpc now needs to supply more stuff when we already
> have userspace reading of (unscaled) counts working just fine.
>
Going back to the formula above, and if I revert the change I made to
userpage->offset. Then the code would look as follows:

                userpg->offset -= atomic64_read(&event->hw.prev_count);

Prev_count is a 64-bit negative value on X86. Whereas direct_read_counter()
on X86, returns only the N-bits of the counter, where N is the width
of the counter.
For instance, with a 40-bit counter:

direct_read_counter() = 0xffce91a62a
prev_count                = 0xffffffffce91a600

Thus, offset + (raw_count - prev_count)) would not be correct. That is why
in my patch, there is this small adjust to mask off bits 63-N. You may
not have to do this on PPC. The alternative would be expose the width
to user and fix the direct_read_counter() count.

>
> I don't mind if you add fields to make it possible to compute a scaled
> count more easily, but please don't change the meaning of the existing
> fields.

I can revert the change. I just did not know this was already working on PPC.
I guess I was not part of that discussion.
