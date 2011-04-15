Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1DOS1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:27:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47684 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1DOS1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110414230955.GB32110@sortiz-mobl>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
	<loom.20110414T113238-377@post.gmane.org>
	<BANLkTi=T42zgY0hy4_u7YKboYuuUiRg_Yw@mail.gmail.com>
	<20110414230955.GB32110@sortiz-mobl>
Date: Fri, 15 Apr 2011 15:27:29 -0300
Message-ID: <BANLkTinRcRqPDXY-A6CF_qdU_gPprE981g@mail.gmail.com>
Subject: Re: [RFC] NFC subsystem prototype
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/14 Samuel Ortiz <sameo@linux.intel.com>:
> Hi Lauro,
>
> On Thu, Apr 14, 2011 at 07:57:57PM -0300, Lauro Ramos Venancio wrote:
>> 2011/4/14 Samuel Ortiz <sameo@linux.intel.com>:
>>
>> >> Subsystem Operations:
>> >>       - start poll - start polling for targets using the protocols given as
>> >> parameter
>> >>       - stop poll - stop polling
>> >>       - activate target - activate a target for communication using a
>> >> specific protocol
>> >>       - deactivate target - deactivate a target
>> >>       - reset device - put the adapter in idle mode
>> >>       - data exchange - low level data exchange (send and receive data)
>> > I suppose the data_exchange hook is sitting at the NFCIP level ? As I agree
>> > with your further comment that this one should not be part of the netlink
>> > API but should be done through sockets instead, I think this one should be
>> > defined as the netdev start_xmit hook.
>> > So this matches quite well the pn533 API, but I'm wondering how you're
>> > planning to support the HCI based devices (pn544, microread). We clearly
>> > have 2 kind of devices here, and it reminds me of the soft MAC vs full MAC
>> > problem in the 802.11 subsystem.
>> > I think we should have a kernel NFC HCI layer that would implement those
>> > hooks by following the HCP protocol. Then devices that only take HCI
>> > commands (kind of soft MAC NFC devices) would register against the NFC HCI
>> > layer and use those hooks. Other devices (e.g. pn533) would register at a
>> > higher level (The NFC core layer) and provide their own hooks. This would be
>> > similar to what 802.11 drivers do by registering against mac80211 (soft MACs)
>> > or directly against cfg80211 (full MACs).
>>
>> I fully agree. The prototype was designed with pn533 and pn544 in
>> mind. When the pn544 device driver is implemented, we will need
>> another layer for the HCI implementation.
> Are you guys planning to start working on the pn544 driver ? In theory the HCI
> layer should be implemented first but I suppose those 2 can be done in
> parallel, and I can start looking at the HCI parts. At least all the
> registration one and the netdev interaction as well.

We are not implementing the pn544 device driver. So, it would be very
nice if you can implement the HCI part.

Our short term plans are:
- Decide the best name for the subsystem (nfc or rfid).
- Improve the data exchange operation using sockets (2nd prototype)
- Send the patches


>> >> Further work:
>> >>       - Define subsystem operations for adapters in "target mode"
>> > I am not sure we need any specific additional hook for the target mode. In
>> > this mode, we mostly would be sending events (RF field ON, card activated
>> > or deactivated). After that, afaiu, the card would be expecting data
>> > reception, and then sending responses to it.
>>
>> I think the main part is the handling of timing constraints between
>> the data reception and the response using a socket interface.
> What are those constraints ?
The response must be sent before the timeout (about 5ms).


>> > We probably need to add a mode setting hook in the ops structure. And also,
>> > according to NFCIP-2, NFC devices should by default be in target mode.
>>
>> The selection between proximity and vicinity is partially covered by
>> the protocols selection in start_poll operation.
>>
>> Probably, the polling loop needs to have an initiator mode phase and a
>> target mode phase in a cycle (as the PN544 Polling management).
> That is something that is still not clear to me, to be honest with you. When
> in initiator mode, are we suppose to run regular polling cycles ?
It's not mandatory. The pn533 looks for targets only once using only
one protocol. The pn544 implements a polling cycle looking for targets
using many protocols.
In the subsystem, we decided to use a polling cycle (start poll/stop
poll) that receive as parameter the protocols to be used. For the
pn533, we implemented the polling cycle in the device driver as the
device does not support it.
When implementing the target mode in the subsystem, we may add a
target mode phase in the polling cycle.


Regards,

Lauro Ramos Venancio
INdT - Instituto Nokia de Tecnologia
