Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2BFW3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:29:04 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:59893 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BFW3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:29:01 -0500
Subject: Re: FireWire/SBP2 Target mode
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <20120206212628.6880c506@stein>
Date: Mon, 6 Feb 2012 22:28:57 +0000
Cc: Clemens Ladisch <clemens@ladisch.de>, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        Boaz Harrosh <bharrosh@panasas.com>, Andy Grover <agrover@redhat.com>,
        linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5C167A1D-2203-4F1C-B538-E99DD87E7E42@bootc.net>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de> <4F2FD1F4.9050702@bootc.net> <4F2FE705.3070509@ladisch.de> <4F2FE8DA.70502@bootc.net> <20120206212628.6880c506@stein>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Feb 2012, at 20:26, Stefan Richter wrote:

> On Feb 06 Chris Boot wrote:
>> On 06/02/2012 14:43, Clemens Ladisch wrote:
>>> Chris Boot wrote:
>>>> You can pull the code from:
>>>> git://github.com/bootc/Linux-SBP-2-Target.git
>>> 
>>> The TODO file says:
>>>> * Update Juju so we can get the speed in the fw_address_handler callback
>>> 
>>> What is the speed needed for?
>> 
>> "The speed at which the block write request to the MANAGEMENT_AGENT 
>> register is received shall determine the speed used by the target for 
>> all subsequent requests to read the initiator’s configuration ROM, fetch 
>> ORB’s from initiator memory or store status at the initiator’s 
>> status_FIFO. Command block ORB’s separately specify the speed for 
>> requests addressed to the data buffer or page table."
>> 
>> (T10/1155D Revision 4 page 53/54)
> 
> I guess it is not too hard to add this to the AR-req handler.  On the
> other hand, I see little reason to follow the SBP-2 spec to the letter
> here.  The target driver could just use the maximum speed that the core
> figured out.  On the other hand, this requires of course
>  - the target to wait for core to finish scanning an initiator,
>  - the core to offer an API to look up an fw_device by a
>    card--generation--nodeID tuple.
> 
> The intention of the spec is IMO clearly to enable target implementations
> that do not need to implement topology scanning.  I have a hard time to
> think of a valid scenario where an initiator needs to be able to steer a
> target towards a lower wire speed than what the participating links and
> PHYs actually support.

The only thing stopping me from getting the speed is the fact that struct fw_request is opaque. The value is easily available from request->response.speed and I kind of do that already in a very hackish way. I've sent a separate patch which adds a function that can be used to access that one value.

Waiting until the bus scan is complete isn't actually that great as I see the first LOGIN requests often before the fw_node is seen at all. I'd have to turn away the requester and hope they try again. I'm fairly sure my little tweak in my patch is a simple enough solution.

>>> SBP-2 says:
>>> | The target shall issue data transfer requests with a speed equal to
>>> | that specified by the spd field in the ORB.
>>> 
>>> SBP-3 says:
>>> | The target shall issue data transfer requests with a speed equal to
>>> | that specified by the controlling spd field, whether in the ORB or in
>>> | a node selector in an associated page table.
> 
> Clemens, the speed used in data transfers can be different from the speed
> to be used to read the initiator's Config ROM/ fetch ORBs/ write status,
> because data buffers and page tables can reside on a third node.  (In
> practice they reside always on the initiator node, but per spec they
> don't have to.)
> 
> Again, IMO the target driver could ignore this other speed too and just
> use the speed which firewire-core figured out.  But on the other hand,
> this would require an fw_device lookup, given card--generation--nodeID; so
> using the speed code given in the ORB is much simpler.
> 
> Side note:  Like with the speed, the max_payload given in the ORB may be
> different from that in the initiator's bus information block, simply
> because the data buffers and page tables may reside on a third node with a
> different packet payload limit.  Again, just using the max_payload given
> in the ORB makes for the easiest implementation (and follows the spec to
> the letter).

Hmm yes so far I've ignored the fact that the data and page tables can be on a different node. I should add that to the TODO fairly low down :-)

>>>> Please note that you can't then disable a unit until all the targets
>>>> are logged-out. For Linux this usually means 'rmmod firewire_sbp2'.
>>> 
>>> That driver should not, by default, log into targets on its own node.
>> 
>> It still tries to and never appears to give up, so this needs 
>> blacklisting on the target system until firewire_sbp2 is changed. It's 
>> harmless other than filling up the kernel log with error messages.
>> 
>> What I meant, however, is if you connect to the target from a separate 
>> Linux system you will be unable to disable the unit on the target system 
>> until the _initiator_ logs out. You can do this on the initiator by 
>> unloading the module, which sends a logout request to the target.
> 
> Another way to log out is
> # echo "fw4.0" > /sys/bus/firewire/drivers/*sbp2/unbind
> 
> (I will post a patch soon which renames this directory from sbp2 to
> firewire_sbp2, as a side effect of a logging related change.)

Good to know, thanks!

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net

