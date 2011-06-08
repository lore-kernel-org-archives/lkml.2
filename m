Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1FHQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1FHQ6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:58:37 -0400
Message-ID: <4DEFAA2F.1010100@redhat.com>
Date: Wed, 08 Jun 2011 13:58:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Igor M. Liplianin" <liplianin@netup.ru>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the staging.current
 tree
References: <20110608114130.444a7f99.sfr@canb.auug.org.au> <20110608161127.GD21645@kroah.com>
In-Reply-To: <20110608161127.GD21645@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Em 08-06-2011 13:11, Greg KH escreveu:
> On Wed, Jun 08, 2011 at 11:41:30AM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> After merging the staging.current tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/media/video/cx23885/cx23885-cards.c:28:28: fatal error: staging/altera.h: No such file or directory
>>
>> Caused by commit 85ab9ee946da ("Staging: altera: move .h file to proper
>> place").
>>
>> I have used the staging.current tree from next-20110607 for today.
> 
> Ok, sorry about that.
> 
> Mauro, Igor, why would another driver need to reference a .h file of a
> staging driver?  I'll patch it right now to point to the proper place
> (down in the staging tree), but it would be good to resolve this
> "properly" somehow.
> 
> Next time, please never include a staging driver that isn't
> self-contained, and don't create include/staging/ that's not acceptable.

The altera driver were discussed for about two kernel cycles. When it was
about to be merged upstrem, two people complained about having a FPGA firmware 
driver inside the Linux Kernel. However, this driver is essential in order to load
the firmware for a DVB device. So, to avoid postponing the merge for yet another
kernel cycle, I've moved the offending part to staging, and asked for those
two people to provide us a new solution up to the next merge window, otherwise, it
would be moved it to the proper place.

Basically, this driver is used to load the FPGA firmware for the CI module that 
de-scrambles DVB-C/DVB-T/DVB-S streams, used by some cx23885 devices.

Basically, cx23885 gets the firmware file via request_firmware() and uses the
altera module to load it. After loaded, the altera-ci driver implements the logic
to talk with the CI hardware.

There's no Coding Style or any other troubles on this driver that I'm aware,
except that the altera driver also allows loading FPGA firmwares via LPT port.

The main argue is that there are some userspace tools available to program a
FPGA hardware, but the problem is that the cx23885 needs to command the firmware
load, as it needs to occur when the device is booted (or resumed).

There were some discussions about that at LKML:
	https://lkml.org/lkml/2011/3/7/270

>From my side, I think that the driver is doing the right approach. Using a different
logic will make harder to sync userspace with kernelspace and will require an
specialized userspace application for just a few device types (just two of the
30 boards supported by cx23885 currently needs it).

Igor,

Could you please prepare a patch against linux-next moving it to the proper place?
It is probably better to apply such patch at Greg's tree, as he has two patches
touching at the altera include files. Also, please get rid of the parallel port
support, as you don't need it for cx23885.

Thanks,
Mauro.
