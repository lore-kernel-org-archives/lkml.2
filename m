Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab1DNOpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:45:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:41318 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918Ab1DNOpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:45:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC] NFC subsystem prototype
Date: Thu, 14 Apr 2011 14:17:42 +0000 (UTC)
Message-ID: <loom.20110414T113238-377@post.gmane.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 90.9.23.9 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101028 Iceweasel/3.5.15 (like Firefox/3.5.15))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lauro,

Lauro Ramos Venancio <lauro.venancio <at> openbossa.org> writes:
> The prototype implementation can be found at:
> 	git://186.215.206.130/linux-nfc.git
> 
> The userspace test application (list targets and read/write MIFARE
> tags) can be found at:
> 	git://186.215.206.130/nfc-example.git
Really nice. What about putting those in e.g. gitorious ?

 
> Prototype Scope:
> 	- Tag Reader/Writer
> 	- Protocols: MIFARE, ISO14443, FELICA, JEWEL
> 
> Subsystem Operations:
> 	- start poll - start polling for targets using the protocols given as
> parameter
> 	- stop poll - stop polling
> 	- activate target - activate a target for communication using a
> specific protocol
> 	- deactivate target - deactivate a target
> 	- reset device - put the adapter in idle mode
> 	- data exchange - low level data exchange (send and receive data)
I suppose the data_exchange hook is sitting at the NFCIP level ? As I agree
with your further comment that this one should not be part of the netlink
API but should be done through sockets instead, I think this one should be
defined as the netdev start_xmit hook.
So this matches quite well the pn533 API, but I'm wondering how you're
planning to support the HCI based devices (pn544, microread). We clearly
have 2 kind of devices here, and it reminds me of the soft MAC vs full MAC
problem in the 802.11 subsystem.
I think we should have a kernel NFC HCI layer that would implement those
hooks by following the HCP protocol. Then devices that only take HCI
commands (kind of soft MAC NFC devices) would register against the NFC HCI
layer and use those hooks. Other devices (e.g. pn533) would register at a
higher level (The NFC core layer) and provide their own hooks. This would be
similar to what 802.11 drivers do by registering against mac80211 (soft MACs)
or directly against cfg80211 (full MACs).



> Subsystem Event:
> 	- targets found - report all targets found by the polling
I would like to see a target lost event here as well, but as far as I know,
none of the various NFC specs specify such event. So I guess we get to know
that e.g. a tag is not there anymore when failing to read from it.

> However, the netlink choice has not proven to be the best solution for
> the data exchange operation. So we plan to have a new prototype
> version using another solution. The options are:
> 	- sockets for all operations as in bluez implementation;
> 	- sockets for data exchange and keep netlink for the other operations.
I would personally prefer to have a netlink layer for basically anything
except data I/O, and go with a socket for the rest.


> 
> Further work:
> 	- Define subsystem operations for adapters in "target mode"
I am not sure we need any specific additional hook for the target mode. In
this mode, we mostly would be sending events (RF field ON, card activated
or deactivated). After that, afaiu, the card would be expecting data
reception, and then sending responses to it.
We probably need to add a mode setting hook in the ops structure. And also,
according to NFCIP-2, NFC devices should by default be in target mode.


> 	- Implement LLCP
> 	- Add support to the "secure elements"
I'm also wondering how we're going to support the various CCID USB NFC
readers currently available ? At the moment this is all done through libusb
and pcsc-lite in userspace, but it would be nice to see that integrated
with this subsystem.

Cheers,
Samuel.

