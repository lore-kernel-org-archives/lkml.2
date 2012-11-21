Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2KUSIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:08:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47584 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2KUSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121121174453.GD6406@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com> <20121121155104.726B83E0AE2@localhost>
 <20121121174453.GD6406@obsidianresearch.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Nov 2012 18:07:46 +0000
X-Google-Sender-Auth: ohRJpsqAPEypEYc26t-vJ3udafw
Message-ID: <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather
 than device_add
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 5:44 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Nov 21, 2012 at 03:51:04PM +0000, Grant Likely wrote:
>> On Wed, 21 Nov 2012 00:24:48 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>> > This allows platform_device_add a chance to call insert_resource
>> > on all of the resources from OF. At a minimum this fills in proc/iomem
>> > and presumably makes resource tracking and conflict detection work
>> > better.
>> >
>> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> >  drivers/of/device.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > Tested on PPC32 and ARM32 embedded kernels.
>> >
>> > diff --git a/drivers/of/device.c b/drivers/of/device.c
>> > index 4c74e4f..a5b67dc 100644
>> > +++ b/drivers/of/device.c
>> > @@ -62,7 +62,7 @@ int of_device_add(struct platform_device *ofdev)
>> >     if (!ofdev->dev.parent)
>> >             set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
>> >
>> > -   return device_add(&ofdev->dev);
>> > +   return platform_device_add(ofdev);
>> >  }
>> >
>> >  int of_device_register(struct platform_device *pdev)
>>
>> This has the side effect of moving all devices at the root of the tree
>> from /sys/devices/ to /sys/devices/platform. It also has the possibility
>> of breaking if any devices get registered with overlapping regions. I
>> think there are some powerpc 5200 boards that do this, and I'm not sure
>> about the larger Power boxen.
>
> Okay, I'll try to test your patch.
>
> I know sensible overlapping seems to work:
>
> e0000000-e7ffffff : PCIe 0 MEM
>   e0000000-e000ffff : 0000:00:01.0
>     e0000000-e0000fff : /pex@e0000000/chip@0/chip_control@0
>       e0000008-e000000b : dat
>         e0000008-e000000b : dat
>       e000000c-e000000f : set
>         e000000c-e000000f : set
>       e0000010-e0000013 : dirin
>         e0000010-e0000013 : dirin
>
> Which is nesting the generic gpio driver under a larger region..

Try two sibling nodes with overlapping addresses. There are powerpc
device trees doing that even though it isn't legal by the ofw and
epapr specs.

g.
