Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2K0P7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:59:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:35031 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2K0P7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:59:35 -0500
Message-ID: <50B4E364.8030704@linutronix.de>
Date: Tue, 27 Nov 2012 16:59:32 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
In-Reply-To: <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 09:57 AM, Andrzej Pietrasiewicz wrote:
>> |mkdir -p $FABRIC/naa.6001405c3214b06a/tpgt_1
>> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_0
>> |mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_1
>>
>> So you setup two luns without this patch. Would that work for you?
>>
> I think we _still_ need a way to programmatically create/remove configfs
> directories. Without it, this: "After name is written it will request
> the module and special configuration related files pop up."
> (http://www.spinics.net/lists/linux-usb/msg75118.html)
>
> is only possible for a static, predefined number of configuration
> subdirectories. Can you guarantee there will be only such a need?

No I can't but until now I don't such a need.

> Are you sure lun# directories will not be created programmatically?
> https://lkml.org/lkml/2012/11/26/584

they are not by target and they are not complaining. We need it if we
use the num_luns file which I don't think is useful.

> And there are problems to be addressed right now, not possibly in
> the future: take the intrefaceXX (read-only) directory, which
> contains information about altsetting, interface class,
> interface number, endpoints etc. It can be created only after
> the gadget has actually been bound. But before the gadget is
> bound it is being configured and the configfs directories
> must already be there, so any default_groups are already created.

Here I understand it. This is to some point a limitation of the gadget
framework. We do know the number of interface that will be available
before we bind. We simply don't know the endpoint number. There are two 
exceptions to what I just wrote:
- g_zero drops the ISO endpoints if the UDC has no UDC support for it.
   This should not happen on-the-fly.
- UAC2 may want to make the number interfaces (and therefore configure
   able) and function (play / record) configurable.

> So the interfaceXX directory cannot be implemented as a default
> group, but must be created programmatically.
>
> Also, there is an idea to unbind the gadget with just doing
> rmdir /cfg/...../gadgetX:
> http://www.spinics.net/lists/linux-usb/msg74893.html

Since we link the gadget to the function, we should unlink it.

> This implies doing a recursive rmdir first on its
> subdirectories - a programmatic rmdir.

Hmm. On target I have to rmdir manually

|unlink naa.6001405c3214b06a/tpgt_1/lun/lun_2/virtual_scsi_port
|unlink naa.6001405c3214b06a/tpgt_1/lun/lun_3/virtual_scsi_port
|rmdir naa.6001405c3214b06a/tpgt_1/lun/lun_2
|rmdir naa.6001405c3214b06a/tpgt_1/lun/lun_3
|rmdir naa.6001405c3214b06a/tpgt_1/
|rmdir naa.6001405c3214b06a/
|cd ..
|rmdir usb_gadget

to make it all go away. Couldn't we have a tool to manage all this?
target has such a thing, you have just select a few things via a CLI
tool and the tool creates the directories for you _and_ removes them
later on.
I don't want to push python on anyone but the removal magic is simply
straight forward: unlink the disk ports, rmdir luns, tpgt,…

> Taken all this into account, I would like to have a way
> to programmatically create and remove configfs directories.
> Right now creating them is like scratching the left ear
> with the hand under the right knee. And it leads to
> comments like: "Looking at this: full_name_hash(),
> d_alloc(), d_add(), d_drop(), dput(). Do you write a
> filesystem?"
> http://www.spinics.net/lists/linux-usb/msg74841.html

That was wrong. Pushing it into configs is better but I am not sure we
need it. I understand the need for things that pop later like
interfaceXX but couldn't the user manually create them if he needs them?

>
> Andrzej

Sebastian
