Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2K1ILK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:11:10 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56984 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2K1ILI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:11:08 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
 <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
In-reply-to: <50B4E364.8030704@linutronix.de>
Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config groups
Date: Wed, 28 Nov 2012 09:10:59 +0100
Message-id: <002901cdcd3f$e7288ac0$b579a040$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: Ac3MuDbbsJDO/SuUTzCpBNGymg1CyAAgwOYg
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 27, 2012 5:00 PM Sebastian Andrzej Siewior wrote:
> On 11/27/2012 09:57 AM, Andrzej Pietrasiewicz wrote:
> >> |mkdir -p $FABRIC/naa.6001405c3214b06a/tpgt_1
> >> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_0
> >> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_1
> >>
> >> So you setup two luns without this patch. Would that work for you?
> >>
> > I think we _still_ need a way to programmatically create/remove
> > configfs directories. Without it, this: "After name is written it will
> > request the module and special configuration related files pop up."
> > (http://www.spinics.net/lists/linux-usb/msg75118.html)
> >
> > is only possible for a static, predefined number of configuration
> > subdirectories. Can you guarantee there will be only such a need?
> 
> No I can't but until now I don't such a need.
> 
> > Are you sure lun# directories will not be created programmatically?
> > https://lkml.org/lkml/2012/11/26/584
> 
> they are not by target and they are not complaining. We need it if we use
> the num_luns file which I don't think is useful.
> 
> > And there are problems to be addressed right now, not possibly in the
> > future: take the intrefaceXX (read-only) directory, which contains
> > information about altsetting, interface class, interface number,
> > endpoints etc. It can be created only after the gadget has actually
> > been bound. But before the gadget is bound it is being configured and
> > the configfs directories must already be there, so any default_groups
> > are already created.
> 
> Here I understand it. This is to some point a limitation of the gadget
> framework. We do know the number of interface that will be available
> before we bind. We simply don't know the endpoint number. There are two
> exceptions to what I just wrote:
> - g_zero drops the ISO endpoints if the UDC has no UDC support for it.
>    This should not happen on-the-fly.
> - UAC2 may want to make the number interfaces (and therefore configure
>    able) and function (play / record) configurable.
> 

So do we know everything before bind or we don't?

> > So the interfaceXX directory cannot be implemented as a default group,
> > but must be created programmatically.
> >
> > Also, there is an idea to unbind the gadget with just doing rmdir
> > /cfg/...../gadgetX:
> > http://www.spinics.net/lists/linux-usb/msg74893.html
> 
> Since we link the gadget to the function, we should unlink it.
> 
> > This implies doing a recursive rmdir first on its subdirectories - a
> > programmatic rmdir.
> 
> Hmm. On target I have to rmdir manually
> 
> |unlink naa.6001405c3214b06a/tpgt_1/lun/lun_2/virtual_scsi_port
> |unlink naa.6001405c3214b06a/tpgt_1/lun/lun_3/virtual_scsi_port
> |rmdir naa.6001405c3214b06a/tpgt_1/lun/lun_2
> |rmdir naa.6001405c3214b06a/tpgt_1/lun/lun_3
> |rmdir naa.6001405c3214b06a/tpgt_1/
> |rmdir naa.6001405c3214b06a/
> |cd ..
> |rmdir usb_gadget
> 
> to make it all go away. Couldn't we have a tool to manage all this?
> target has such a thing, you have just select a few things via a CLI tool
> and the tool creates the directories for you _and_ removes them later on.
> I don't want to push python on anyone but the removal magic is simply
> straight forward: unlink the disk ports, rmdir luns, tpgt,.
> 
> > Taken all this into account, I would like to have a way to
> > programmatically create and remove configfs directories.
> > Right now creating them is like scratching the left ear with the hand
> > under the right knee. And it leads to comments like: "Looking at this:
> > full_name_hash(), d_alloc(), d_add(), d_drop(), dput(). Do you write a
> > filesystem?"
> > http://www.spinics.net/lists/linux-usb/msg74841.html
> 
> That was wrong. Pushing it into configs is better but I am not sure we
> need it. I understand the need for things that pop later like interfaceXX
> but couldn't the user manually create them if he needs them?
> 

What name shall the user use? How to know which user-created directory
should correspond to which actual interface? If there are, say,
3 interfaces, what would:

$ mkdir interface873246

mean?

And in general, what would

$ mkdir rykcq1234

mean?

Let's go one directory deeper in the hierarchy and suppose there is
no programmatic directories creation. So we

$ cd interface<something>

so that we can create the endpoint directories.
And now what? What names shall the user use for the endpoint
directories? Oh, that's simple: just see what the endpoint
directories' names are. But wait, aren't we just creating them?

Please also see Micha³'s point about user interface.

Andrzej


