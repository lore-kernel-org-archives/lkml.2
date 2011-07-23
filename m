Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab1GWEg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 00:36:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1GWEgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 00:36:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PUqeggnWtCiO7HifEYW4mAyZy176/G/NrnvaSXlyry36PzCpO4mo7RxZ2RKm+WCu3
	m6mGC4RTpbB70jl+zVG+w==
MIME-Version: 1.0
In-Reply-To: <4E2A1ECD.3030302@canonical.com>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-8-git-send-email-djkurtz@chromium.org> <4E2A1ECD.3030302@canonical.com>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sat, 23 Jul 2011 12:36:28 +0800
X-Google-Sender-Auth: GvIdNURKkOHQv7xtynBGhzLrZm4
Message-ID: <CAGS+omBCd=e0ACxxTwns8HVNitVOYF-xFrkVmhreOmHQTq_10A@mail.gmail.com>
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

Hi Chase,

On Sat, Jul 23, 2011 at 9:07 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
>> From: Daniel Kurtz <djkurtz@chromium.org>
>>
>> As long as we know which slots are currently contained in SGM and AGM
>> packets, it is possible to track the slot 0 finger when transitioning from
>> 2->3 fingers.  This is the case when fingers are being added one at a
>> time, 1->2->3.
>>
>> However, when fingers are removed, we sometimes lose track of which slots
>> are contained in SGM and AGM. In particular, when transitioning from 3->2
>> and sometimes 3->1.  In both of these cases, we can no longer track slot 0
>> during 2->3 transitions.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/input/mouse/synaptics.c |   33 +++++++++++++++++++++++++++------
>>  drivers/input/mouse/synaptics.h |    1 +
>>  2 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
>> index b626b98..893e567 100644
>> --- a/drivers/input/mouse/synaptics.c
>> +++ b/drivers/input/mouse/synaptics.c
>> @@ -659,6 +659,7 @@ static void synaptics_image_sensor_0f(struct synaptics_data *priv,
>>                                     struct synaptics_mt_state *mt_state)
>>  {
>>       synaptics_mt_state_set(mt_state, 0, -1, -1);
>> +     priv->mt_state_lost = false;
>>  }
>>
>>  /* Handle case where mt_state->count = 1 */
>> @@ -726,6 +727,7 @@ static void synaptics_image_sensor_1f(struct synaptics_data *priv,
>>                * So, empty all slots. We will guess slot 0 on subsequent 1->1
>>                */
>>               synaptics_mt_state_set(mt_state, 0, -1, -1);
>> +             priv->mt_state_lost = true;
>>               break;
>>       }
>>  }
>> @@ -771,6 +773,7 @@ static void synaptics_image_sensor_2f(struct synaptics_data *priv,
>>                * subsequent 2->2
>>                */
>>               synaptics_mt_state_set(mt_state, 0, -1, -1);
>> +             priv->mt_state_lost = true;
>>               break;
>>       }
>>  }
>> @@ -800,14 +803,32 @@ static void synaptics_image_sensor_3f(struct synaptics_data *priv,
>>               break;
>>       case 2:
>>               /*
>> -              * On 2->3 transitions, we are given no indication which finger
>> -              * was added.
>> -              * We don't even know what finger the current AGM packet
>> -              * contained.
>> +              * After some 3->1 and all 3->2 transitions, we lose track
>> +              * of which slot is reported by sgm and agm.
>>                *
>> -              * So, empty all slots. They get filled on a subsequent 3->3
>> +              * For 2->3 in this state, empty all slots, and we will guess
>> +              * (0,1) on a subsequent 0->3.
>> +              *
>> +              * To userspace, the resulting transition will look like:
>> +              *    2:[0,1] -> 0:[-1,-1] -> 3:[0,2]
>
> I don't think this should be allowed. We shouldn't be giving userspace
> wrong information. One could argue that userspace could watch for these
> transitions, but then I would argue that the driver should be handling
> this :).
>
> I don't know what the best resolution to this issue is, but any
> transition in the number of fingers must be accurate. In uTouch, we
> watch for touch count transitions for "continuation" gestures.

So, you want the count to be accurate.
But, during these transitions, there is not enough information to
guarantee all of the following at the same time:
 (1) finger count
 (2) track_id
 (3) finger position

Would you prefer an implementation that continued to report count (via
BTN_TOUCH*) correctly, but dropped down to 0 or 1 MT-B slots when for
these cases where it could not determine the correct position or track_id
to report?

It seems like it would be more work for userspace to handle this new way
than the simulated number-of-touch transitions, where the transient
states are all normal valid states.

-Daniel

>
>>                */
>> -             synaptics_mt_state_set(mt_state, 0, -1, -1);
>> +             if (priv->mt_state_lost) {
>> +                     synaptics_mt_state_set(mt_state, 0, -1, -1);
>> +                     break;
>> +             }
>> +
>> +             /*
>> +              * If the (SGM,AGM) really previously contained slots (0, 1),
>> +              * then we cannot know what slot was just reported by the AGM,
>> +              * because the 2->3 transition can occur either before or after
>> +              * the AGM packet. Thus, this most recent AGM could contain
>> +              * either the same old slot 1 or the new slot 2.
>> +              * Subsequent AGMs will be reporting slot 2.
>> +              *
>> +              * To userspace, the resulting transition will look like:
>> +              *    2:[0,1] -> 1:[0,-1] -> 3:[0,2]
>> +              */
>> +             synaptics_mt_state_set(mt_state, 1, 0, -1);
>>               break;
>>       case 3:
>>               /*
>> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
>> index 87be1fe..e3edfea 100644
>> --- a/drivers/input/mouse/synaptics.h
>> +++ b/drivers/input/mouse/synaptics.h
>> @@ -162,6 +162,7 @@ struct synaptics_data {
>>       struct serio *pt_port;                  /* Pass-through serio port */
>>
>>       struct synaptics_mt_state mt_state;     /* Current mt finger state */
>> +     bool mt_state_lost;                     /* mt_state may be incorrect */
>>
>>       /*
>>        * Last received Advanced Gesture Mode (AGM) packet. An AGM packet
>
>
