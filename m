Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab2K0I5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:57:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40686 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2K0I5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:57:12 -0500
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
In-reply-to: <50B39921.6090308@linutronix.de>
Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config groups
Date: Tue, 27 Nov 2012 09:57:05 +0100
Message-id: <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3L81/l146z0hsmTOqHBCg7cWPYvAAhc1zQ
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 5:30 PM Sebastian Andrzej Siewior wrote:
> On 11/26/2012 09:35 AM, Andrzej Pietrasiewicz wrote:
> > In some parts of the kernel (e.g. planned configfs integration into
> > usb
> > gadget) there is a need to programmatically create config groups
> > (directories) but it would be preferable to disallow creating them by
> > the user. This is more or less what default_groups used to be for.
> > But e.g. in the mass storage gadget, after storing the number of luns
> > (logical units) into some configfs attribute, the corresponding lun#
> > directories should be created, their number is not known up front so
> > default_groups are no good for this.
> >

<snip>

> 
> |mkdir -p $FABRIC/naa.6001405c3214b06a/tpgt_1
> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_0
> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_1
> 
> So you setup two luns without this patch. Would that work for you?
> 

I think we _still_ need a way to programmatically create/remove configfs
directories. Without it, this: "After name is written it will request
the module and special configuration related files pop up."
(http://www.spinics.net/lists/linux-usb/msg75118.html)

is only possible for a static, predefined number of configuration
subdirectories. Can you guarantee there will be only such a need?
Are you sure lun# directories will not be created programmatically?
https://lkml.org/lkml/2012/11/26/584

And there are problems to be addressed right now, not possibly in
the future: take the intrefaceXX (read-only) directory, which
contains information about altsetting, interface class,
interface number, endpoints etc. It can be created only after
the gadget has actually been bound. But before the gadget is
bound it is being configured and the configfs directories
must already be there, so any default_groups are already created.
So the interfaceXX directory cannot be implemented as a default
group, but must be created programmatically.

Also, there is an idea to unbind the gadget with just doing
rmdir /cfg/...../gadgetX:
http://www.spinics.net/lists/linux-usb/msg74893.html

This implies doing a recursive rmdir first on its
subdirectories - a programmatic rmdir.

Taken all this into account, I would like to have a way
to programmatically create and remove configfs directories.
Right now creating them is like scratching the left ear
with the hand under the right knee. And it leads to
comments like: "Looking at this: full_name_hash(),
d_alloc(), d_add(), d_drop(), dput(). Do you write a
filesystem?"
http://www.spinics.net/lists/linux-usb/msg74841.html

Andrzej


