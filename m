Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1G1N4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:56:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61741 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab1G1N4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:56:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=KwMpqhzdjDAJEsM9ixaZ3r4mVETTUPbIIBKtcNeUA9WHmpPUpwTPzYFS2jHwnVQNe
	3i5gWsnEiCFwJ5rX34i5w==
MIME-Version: 1.0
In-Reply-To: <4E30C46F.2030903@canonical.com>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-8-git-send-email-djkurtz@chromium.org> <4E2A1ECD.3030302@canonical.com>
 <CAGS+omBCd=e0ACxxTwns8HVNitVOYF-xFrkVmhreOmHQTq_10A@mail.gmail.com>
 <4E2F4A66.1020207@canonical.com> <CAGS+omAwrXMC=U2Hx7EoJzUM+=PYyR4di0tDhq0oVnR_AAdEhQ@mail.gmail.com>
 <4E307F8A.6090707@canonical.com> <CAGS+omBr3adfENg5UDnbfPEFPg+0myKHFWb5qCSTt6wjVtvyeA@mail.gmail.com>
 <4E30C46F.2030903@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 28 Jul 2011 21:56:25 +0800
X-Google-Sender-Auth: -9g2LiZ20pfoLliaKiGAWAIdTig
Message-ID: <CAGS+omBOpzHERGuiNq+OfC3ubJsuyy0kp-5Vw49G=f4m6GTRxA@mail.gmail.com>
Subject: Re: [PATCH 7/9 v2] Input: synaptics - improved 2->3 finger transition handling
To: Chase Douglas <chase.douglas@canonical.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 10:07 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 07/27/2011 06:00 PM, Daniel Kurtz wrote:
>> On Thu, Jul 28, 2011 at 5:13 AM, Chase Douglas
>> <chase.douglas@canonical.com> wrote:
>> [...]
>>>>>
>>>>>> Would you prefer an implementation that continued to report count (via
>>>>>> BTN_TOUCH*) correctly, but dropped down to 0 or 1 MT-B slots when for
>>>>>> these cases where it could not determine the correct position or track_id
>>>>>> to report?
>>>>>
>>>>> That may be doable, but I would prefer to just assume that tracking ids
>>>>> are not valid when (tracked touches > reported touches).
>>>>
>>>> Userspace is free to make this assumption, of course, but, in fact,
>>>> the image sensor trackpad actually does a pretty good job of tracking
>>>> the fingers - it just has serious issues reporting them!
>>>> Since a track_id change is how userspace is told that the identity of
>>>> the reported finger is changing, if the track_id of a finger position
>>>> datum is unknowable, I'd rather just discard it in the kernel than
>>>> report it to userspace with the wrong track_id.
>>>> Otherwise, the heuristics used in the userspace finger tracking
>>>> algorithms would need to be overly aggressively tuned to handle this
>>>> known error cases:
>>>>   2->3 and 3->2 finger transitions look like 2nd finger motion,
>>>> instead of reported finger changes.
>>>>
>>>>>
>>>>>> It seems like it would be more work for userspace to handle this new way
>>>>>> than the simulated number-of-touch transitions, where the transient
>>>>>> states are all normal valid states.
>>>>>
>>>>> This harkens back to my earlier statements where I said this new
>>>>> Synaptics protocol is worse than the previous one :).
>>>>>
>>>>> I agree that the implementation you gave here might be trickier for
>>>>> userspace, so I'd rather table it unless you feel that the "tracking ids
>>>>> are meaningless!" solution won't work. If you think there are problems
>>>>> with that approach, we can re-evaluate.
>>>>>
>>>>> Thanks!
>>>>>
>>>>> -- Chase
>>>>
>>>> Yes, I feel there are problems with this approach, as I tried to explain above.
>>>> Can you explain why you 'continuation gestures' can't handle 1->2->3
>>>> finger transitions looking like 1->2->1->3, and 3->2->3 looking like
>>>> 3->2->0->3?
>>>>
>>>> I think the only real point left to decide is what BTN_* events should
>>>> signify during these rare transition states:
>>>>   (a) the actually number of fingers on the pad,
>>>>   (b) the number of fingers being reported via the slots
>>>>
>>>> The current patchset does (a).
>>>> We could do (b), if that would get these patches accepted sooner :)
>>>
>>> I was thinking that the current patchset does (b). I think (a) is
>>> better, and if it really works that way then I'm fine with it. It's hard
>>> for me to keep track of the flow of the logic across the patches :).
>>
>> Argh, my bad.  You are correct.  Current patchset does (b)!
>> It reports the number of active slots, not the number of touches.
>>
>> In any case, I really don't know why you need (a).  We are talking
>> about some degenerate transitions here.  Your userspace driver should
>> work just fine with the (b) driver, it just loses some really
>> complicated continued gestures for hardware that can't support them.
>
> To give userspace incorrect information about the number of touches on
> the device is always bad. Lets say the degenerate case is when you go
> from two touches to three (maybe Synaptics doesn't do this, but someone
> else might). When the user performs a three finger tap, we'd see two
> touches down, two lifted up, three touches down, three lifted up in
> short succession. Userspace is gonna get pretty confused about that :).
>
> (Please don't make me try to come up with a use case we already have in
> Unity that would be broken for Synaptics due to this. I could probably
> find one, but it would take quite a bit of thinking. :)

Just to be clear:

Debouncing num-fingers at the start of a tap works just fine.
For a 3f-tap, you would see one of:
  0->1->2->3
  0->2->3
  0->3

Not:
  0->1->2->0->3
  0->2->0->3

You only see 2->0->3 if there had previously been 3 fingers down, and
some of those fingers are removed:
  0->3->0*->2*->0*->3*
  0->3->0*->1*

Where the "*" states are when mt_state_lost = true.
So, with method (b), you might see 3->0->2->0 if the release of the
other two fingers was really slow (longer than 37.5 ms), or, more
likely on a tap, just 3->0.

In any case, I don't think we are making progress arguing (a) vs. (b).
Let me implement method (a), and upload for review.
I agree that it makes some sense to always accurately report number of
touches with the BTN_*, independent of number of slots.

A true MT-B userspace app would always do the right thing with the
slots, legacy apps can always do the right thing in legacy mode, and a
hybrid app get do 2-touch multitouch & use BTN_* to determine total
number of touches.

Was there anything else I should add/change while I'm at it?

You mention documentation below, was there something in particular
that you'd like to see documented better?  Where?

-Dan

>
>>> That said, merging this patchset as is effectively means that the number
>>> of slots is completely decoupled from the number of touches on the
>>> device. Previously, one could say that the number of touches on the
>>> device was equal to the number of open slots or more if all slots were
>>> open. With this approach, we could have 0 slots open during a transition
>>> when there are still touches down.
>>>
>>> While the distinction makes sense for these synaptics devices, I don't
>>> want the semantics to hold for full multitouch devices. Otherwise, we
>>> would have to add many more BTN_*TAPs. If we go this route, we must have
>>> a way to tell userspace that this is a special device where the number
>>> of active touches can only be determined from BTN_*TAP. Thus, we would
>>> need a property for this exception to normal behavior.
>>
>> Henrik & Dmitry roughly suggested "do not define a new property; let
>> userspace detect max BTN_*TAP > ABS_MT_SLOT.max to indicate that
>> BTN_*TAP carries the total number of touches".  I wish they would
>> chime in on this patchset...
>
> I think it sets a really bad precedent to obey the stated protocol in
> most cases, but disregard it in others if specific conditions are met,
> which are not documented and are not presented in a clear manner to
> userspace. At the *very least*, this change would need documentation to
> go in at the same time, but I strongly believe a property is merited here.
>
> -- Chase
