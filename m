Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1GYKMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYKMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:12:17 -0400
Message-ID: <4E2D4177.9000402@redhat.com>
Date: Mon, 25 Jul 2011 12:12:07 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Thunderbird/5.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH] Reduce number of KOBJ_REMOVE events
References: <4E2987AE.2070707@redhat.com> <1311553130.1671.21.camel@mop>
In-Reply-To: <1311553130.1671.21.camel@mop>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 25.7.2011 02:18, Kay Sievers napsal(a):
> On Fri, 2011-07-22 at 16:22 +0200, Zdenek Kabelac wrote:
> 
>> For now udev recieves 3 event for removal of DM logical volumes. (1 for
>> bdi and 2 for same block kobject). Reason is dm device generates its
>> own kobject event with approriate env parameter and block layer sends
>> another KOBJ_REMOVE event on its own unconditionaly for the same
>> kobject. As for now only the kobject cleanup checks that the REMOVE
>> event has been already sent and avoids duplicate REMOVE event.
> 
>> The patch for kobject_uevent_env() which has been testing for duplicate
>> REMOVE event did not passed into the mainline (yet?):
> 
> No, it's wasn't merged. Subsystems should really not send their own
> 'add' or 'remove' events. These are properties of the driver core.
> 
>> I'm proposing alternative way around to always use kobject cleanup
>> routine for sending REMOVE event if it was not send by the module - so
>> it makes the code few lines shorter.
> 
> The events the core creates are only sent out at release() not at del(),
> so we would delay 'remove' events when we keep the device pinned but
> it's not valid anymore. We can not do that today, we would need to move
> the core-created 'remove' events to del().
> 
> 
> For device-mapper, I would prefer to add a '.dev_uevent' callback to the
> 'block' class let this callback check 'struct block_device_operations'
> for a possibly specified '.uevent' callback and call it.
> 
> Then have 'dm_blk_dops' add '.uevent' and let the core call into the dm
> code to the needed properties to the 'remove' event, instead of sending
> its own, and see the duplication.

Sounds like complex solution - maybe it would be easier to just register some
environment variable on dm code side - like kobject_add_env() - so it would
take envs from this internal kobject list and after sending uevent it would
implicitly clear this list.

So in dm case  dm-uevent would just register  env(cookie) for KOBJ_REMOVE and
would left kobject_uevent() on block layer ?

Also I'm aware that remove event would be delayed by leaving it on
kobject_cleanup(), but since you mentioned 'del()' as a better place - why not
move this implicit uvent call there - since most kernel driver writers
probably do not want to be bothered with uvents?

Zdenek
