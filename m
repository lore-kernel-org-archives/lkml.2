Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2BLPN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 10:13:29 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:55453 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2BLPN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 10:13:28 -0500
Message-ID: <4F37D714.3010006@bootc.net>
Date: Sun, 12 Feb 2012 15:13:24 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [RFC][PATCH 00/13] firewire-sbp-target: FireWire SBP-2 SCSI target
References: <4E4BD560.4010806@bootc.net> <1328989452-20921-1-git-send-email-bootc@bootc.net> <20120212151247.3d33d45b@stein>
In-Reply-To: <20120212151247.3d33d45b@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2012 14:12, Stefan Richter wrote:
> On Feb 11 Chris Boot wrote:
>> Well after lots of work I have a working and generally (at least I think)
>> sensible starting point for the FireWire target. It appears to work fine in all
>> the configurations I've tested it against, including Linux and Mac OS X
>> initiators.
>
> I only very quickly scrolled through your patches yet.  Looks all very
> readable and well laid out.  Some random thoughts:

Thanks for taking a look!

> Some of the smaller source files could certainly be merged with other
> ones without loss of readability.

Yes, definitely.

> Some comments about what the code is doing can be removed since the
> function names are very well readable on their own.  Example:
> +	/* read the peer's GUID */
> +	ret = read_peer_guid(&guid, req);

Guilty as charged. I'll go through and clean this up.

> The APIs which you include from "../../firewire/core.h" should eventually
> be moved to<linux/firewire.h>.  I think it does not matter whether this
> is done before or after mainline merge.  When we do so we should check
> whether the affected APIs can be improved for usage in drivers.

I'm not even sure I use that much from there at all. Possibly only 
fw_card_{get,put,release}(), so that could quite easily be moved into 
<linux/firewire.h>.

> Many of the printks should surely be demoted to debug messages with
> runtime on-and-off switch.

I've moved a lot of them to pr_debug() which doesn't emit anything 
unless you ask it to. Are there others you think should be pr_debug() 
that aren't?

> There are list traversals and list manipulations that make an impression
> as if they wanted to be mutex- or lock-protected, but I haven't looked yet
> in which contexts these accesses happen.

Yes this is what I'm most concerned about but it's an area I know very 
little about. Some hand-holding would be appreciated.

> sbp_proto.c:
> +/*
> + * Handlers for Serial Attached SCSI (SBP)
> + */
>                   ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ Serial Bus Protocol
> Though this is also readily apparent from the top comment in the file.

Hah. Can you tell where I copied and pasted from? :-) Fixed.

> The four EXPORT_SYMBOLs in sbp_proto.c can be removed, it seems.

Another copy & paste leftover. Also fixed.

> sbp_login.c:
> +			pr_notice("initiator already logged-in\n");
> +
> +			/*
> +			 * SBP-2 R4 says we should return access denied, but
> +			 * that can confuse initiators. Instead we need to
> +			 * treat this like a reconnect, but send the login
> +			 * response block like a fresh login.
> +			 */
> Are there initiators which don't bother with reconnect but send relogin
> straight away?

I found my PowerBook did. It looks like when OpenFirmware hands over to 
Darwin, the latter just does a login. I changed this before I had the 
code to expire sessions once the reconnect timeout expires though so 
it's probably unnecessary now but it would slow down the boot by several 
seconds.

> Kconfig:
> "default n" is redundant.
> "*older* Apple computers":  They are still manufactured with this feature.

I thought all the newer ones only did this over Thunderbolt and not 
FireWire? I'm more than happy to change this though.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
