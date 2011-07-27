Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1G0VN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:13:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52907 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab1G0VNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:13:54 -0400
Message-ID: <4E307F8A.6090707@canonical.com>
Date: Wed, 27 Jul 2011 14:13:46 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 7/9 v2] Input: synaptics - improved 2->3 finger transition
 handling
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-8-git-send-email-djkurtz@chromium.org> <4E2A1ECD.3030302@canonical.com> <CAGS+omBCd=e0ACxxTwns8HVNitVOYF-xFrkVmhreOmHQTq_10A@mail.gmail.com> <4E2F4A66.1020207@canonical.com> <CAGS+omAwrXMC=U2Hx7EoJzUM+=PYyR4di0tDhq0oVnR_AAdEhQ@mail.gmail.com>
In-Reply-To: <CAGS+omAwrXMC=U2Hx7EoJzUM+=PYyR4di0tDhq0oVnR_AAdEhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 09:48 PM, Daniel Kurtz wrote:
> On Wed, Jul 27, 2011 at 7:14 AM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>> On 07/22/2011 09:36 PM, Daniel Kurtz wrote:
>>> On Sat, Jul 23, 2011 at 9:07 AM, Chase Douglas
>>> <chase.douglas@canonical.com> wrote:
>>>> On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
>>>>> From: Daniel Kurtz <djkurtz@chromium.org>
>>>>> @@ -800,14 +803,32 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
>>>>>               break;
>>>>>       case 2:
>>>>>               /*
>>>>> -              * On 2->3 transitions, we are given no indication which finger
>>>>> -              * was added.
>>>>> -              * We don't even know what finger the current AGM packet
>>>>> -              * contained.
>>>>> +              * After some 3->1 and all 3->2 transitions, we lose track
>>>>> +              * of which slot is reported by sgm and agm.
>>>>>                *
>>>>> -              * So, empty all slots. They get filled on a subsequent 3->3
>>>>> +              * For 2->3 in this state, empty all slots, and we will guess
>>>>> +              * (0,1) on a subsequent 0->3.
>>>>> +              *
>>>>> +              * To userspace, the resulting transition will look like:
>>>>> +              *    2:[0,1] -> 0:[-1,-1] -> 3:[0,2]
>>>>
>>>> I don't think this should be allowed. We shouldn't be giving userspace
>>>> wrong information. One could argue that userspace could watch for these
>>>> transitions, but then I would argue that the driver should be handling
>>>> this :).
>>>>
>>>> I don't know what the best resolution to this issue is, but any
>>>> transition in the number of fingers must be accurate. In uTouch, we
>>>> watch for touch count transitions for "continuation" gestures.
>>>
>>> So, you want the count to be accurate.
>>> But, during these transitions, there is not enough information to
>>> guarantee all of the following at the same time:
>>>  (1) finger count
>>>  (2) track_id
>>>  (3) finger position
>>
>> If I had to pick one to give up, it would be the tracking id. It carries
>> the least useful information for a device that you may not get the whole
>> touch stream. Semi-mt devices already forsake the tracking id value,
>> IIRC. The id is always incremented when you create a new slot, but when
>> you go from 2->3 fingers the ids in the slots stay the same even if the
>> third finger expands the bounding box.
> 
> For synaptics profile sensors, adding additional fingers does not
> change which fingers are reported.
> You always get the first two fingers.
> AFAICT, you cannot "expand the bounding box" by adding new fingers.
> Thus, throwing away the track_id is irrelevant, since once the semi-mt
> driver starts reporting 2+ fingers, the track_ids are fixed.

Hmmm... you're right. I was completely mistaken here. This changes some
of my thinking about how to handle these devices.

> The image sensor does not work that way.
> As you add new fingers, the trackpad will, under certain conditions,
> switch to reporting the locations of these new fingers.
> Changing track_id is how we report this to userspace.
> 
>>
>>> Would you prefer an implementation that continued to report count (via
>>> BTN_TOUCH*) correctly, but dropped down to 0 or 1 MT-B slots when for
>>> these cases where it could not determine the correct position or track_id
>>> to report?
>>
>> That may be doable, but I would prefer to just assume that tracking ids
>> are not valid when (tracked touches > reported touches).
> 
> Userspace is free to make this assumption, of course, but, in fact,
> the image sensor trackpad actually does a pretty good job of tracking
> the fingers - it just has serious issues reporting them!
> Since a track_id change is how userspace is told that the identity of
> the reported finger is changing, if the track_id of a finger position
> datum is unknowable, I'd rather just discard it in the kernel than
> report it to userspace with the wrong track_id.
> Otherwise, the heuristics used in the userspace finger tracking
> algorithms would need to be overly aggressively tuned to handle this
> known error cases:
>   2->3 and 3->2 finger transitions look like 2nd finger motion,
> instead of reported finger changes.
> 
>>
>>> It seems like it would be more work for userspace to handle this new way
>>> than the simulated number-of-touch transitions, where the transient
>>> states are all normal valid states.
>>
>> This harkens back to my earlier statements where I said this new
>> Synaptics protocol is worse than the previous one :).
>>
>> I agree that the implementation you gave here might be trickier for
>> userspace, so I'd rather table it unless you feel that the "tracking ids
>> are meaningless!" solution won't work. If you think there are problems
>> with that approach, we can re-evaluate.
>>
>> Thanks!
>>
>> -- Chase
> 
> Yes, I feel there are problems with this approach, as I tried to explain above.
> Can you explain why you 'continuation gestures' can't handle 1->2->3
> finger transitions looking like 1->2->1->3, and 3->2->3 looking like
> 3->2->0->3?
> 
> I think the only real point left to decide is what BTN_* events should
> signify during these rare transition states:
>   (a) the actually number of fingers on the pad,
>   (b) the number of fingers being reported via the slots
> 
> The current patchset does (a).
> We could do (b), if that would get these patches accepted sooner :)

I was thinking that the current patchset does (b). I think (a) is
better, and if it really works that way then I'm fine with it. It's hard
for me to keep track of the flow of the logic across the patches :).

That said, merging this patchset as is effectively means that the number
of slots is completely decoupled from the number of touches on the
device. Previously, one could say that the number of touches on the
device was equal to the number of open slots or more if all slots were
open. With this approach, we could have 0 slots open during a transition
when there are still touches down.

While the distinction makes sense for these synaptics devices, I don't
want the semantics to hold for full multitouch devices. Otherwise, we
would have to add many more BTN_*TAPs. If we go this route, we must have
a way to tell userspace that this is a special device where the number
of active touches can only be determined from BTN_*TAP. Thus, we would
need a property for this exception to normal behavior.

(PS: As I've thought more about it, I don't think we need the property I
was advocating for before. That property was for denoting that the
device tracks more than it reports. If we're going to get this complex
in the protocol, there's not much you can do with bitmask properties to
denote every specific special case.)

-- Chase
