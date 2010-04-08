Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab0DHU0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:26:14 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:35875 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333Ab0DHU0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:26:12 -0400
Message-ID: <4BBE3BC4.2030503@euromail.se>
Date: Thu, 08 Apr 2010 22:25:40 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Michael Poole <mdpoole@troilus.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se> <4BBE2B4D.9040808@seas.upenn.edu>
In-Reply-To: <4BBE2B4D.9040808@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1NzyIH-0006lj-67.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1NzyIH-0006lj-67 d685d8818872f16c38258716a15b8bfc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafi Rubin wrote:
> On 04/08/2010 05:43 AM, Henrik Rydberg wrote:
>> Michael Poole wrote:
>> [...]
>>>
>>> How would the slot number for a contact be chosen?
>>
>> The device driver determines how to use the slots. The driver calls
>> input_mt_slot(dev, slot), sends the data for the slot, picks another
>> slot, and
>> repeats.
>>
> 
> Is there any particular downside to defaulting to implicit slot ids?

Yes. The device driver should not have to update every slot between
synchronizations, or the point would be lost.

> For drivers/hardware that don't handle tracking, SYN_MT_REPORT could
> just result in dev->slot++ and a SYN_REPORT resets dev->slot to 0;

Drivers that do not handle tracking should not use the slots at all. The slot
concept requires that whatever gets communicated over it is identifiable, or
else it would not be possible to send changes. Drivers without tracking
capabilities should stick to the current MT protocol, for which it was designed.

> For tracking hardware do you envision waiting for TRACKING_ID before
> selecting a slot?  If so then either with explicit or implicit slot ids,
> we would need to cache event until the tracking id is read, and either
> use SYN_MT_SLOT or some other mechanism to denote known slot id.

The slot protocol propagates changes, which implies that the full state of each
initiated contact has to reside in the receiving end. Upon receiving an MT
event, one simply updates the appropriate attribute of the active slot. Done.
The TRACKING_ID is also an attribute of the slot, and gets updated the same way.
 Keeping track of fingers should thus be trivial. All in all, the SYN_MT_SLOT
method is probably more intuitive to use in the consumer end than the more
low-level SYN_MT_REPORT method.

> I like the idea and am just wondering if we can simplify the burden for
> the drivers (and reduce the potential for mistakes).

There will be more updates of the documentation following this, of course.
Hopefully that will help.

>>> If the kernel makes
>>> that assignment, what should a "slot" correspond to from a computer
>>> user's perspective? "Set[s] of identified sources" is a little vague:
>>> Does it mean contacts from one hand, contacts in one displayed window
>>> (assuming the touch surface is a screen), or something else?  (I assume
>>> it would not duplicate the blob or tracking IDs already defined for MT
>>> events.)
>>
>> The slot is only used for data communication. Think of the slot as a
>> combined,
>> unique identifier. For example, imagine a device driver dealing with
>> contacts
>> labeled with both a USER_ID and a TRACKING_ID. The driver assigns
>> every active
>> (USER_ID, TRACKING_ID) contact to a specific slot, and uses it to
>> communicate
>> all changes to that contact. When the contact is destroyed (for
>> instance by
>> sending a zero ABS_MT_PRESSURE on that slot), the slot is free to be
>> used for
>> another contact.
>>
>>> It seems like those would be important aspects of the protocol
>>> to document in Documentation/input/multi-touch-protocol.txt --
>>> otherwise, driver implementers or application developers might get it
>>> wrong.
>>
>> Certainly.
>>
>> Cheers,
>> Henrik
> 
> Please clarify which slots are emitted to userspace.

Picture an array of slots in the driver and an array of slots in the receiver.
For each slot, the driver keeps everything it can report, and the receiver keeps
everything if can use. The receiver may also keep an array of active tracking
ids. Each MT event updates an attribute of a slot in the receiver. Once the
synchronization event arrives, the receiver just reads off whatever the state
is. Every slot with a valid tracking id (nonzero pressure or nonzero touch_major
or the like) is an existing contact. Compare to the array of active tracking
ids, and you can figure out all new, modified and deleted ones.

> At some point you
> mentioned that if any are changed all will be emitted, is that still
> your intent?  Have you reconsidered using an explicit event to signify
> the end of a contact/slot?

No. The current MT protocol, using the SYN_MT_REPORT event, is well-defined in
that respect, will always send all data for all fingers, and requires no further
changes. For the slot extension, which uses SYN_MT_SLOT instead of
SYN_MT_REPORT, the issue with contact destruction arises in the drivers that
currently only report ABS_MT_POSITION_X and ABS_MT_POSITION_Y. Adding either
ABS_MT_PRESSURE or ABS_MT_TOUCH_MAJOR to those drivers, as intended in the MT
protocol, resolves the problem. The explicit contact destruction then comes
naturally as a zero touch event.

Cheers,
Henrik
