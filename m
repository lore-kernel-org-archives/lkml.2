Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2K1NuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:50:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:40768 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2K1NuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:50:17 -0500
Message-ID: <50B61695.50207@linutronix.de>
Date: Wed, 28 Nov 2012 14:50:13 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com> <50B5C821.4000406@linutronix.de> <xa1ta9u1naik.fsf@mina86.com>
In-Reply-To: <xa1ta9u1naik.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 02:05 PM, Michal Nazarewicz wrote:
>> On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
>>> How should a generic tool know what kind of actions are needed for given
>>> function to be removed?  If you ask me, there should be a way to unbind
>>> gadget and unload all modules without any specific knowledge of the
>>> functions.  If there is no such mechanism, then it's a bad user
>>> interface.
>
> On Wed, Nov 28 2012, Sebastian Andrzej Siewior wrote:
>> Well. You need only to remove the directories you created.
>
> My point is that there should be a way to write a script that is unaware
> of the way function is configured, ie. which directories were created
> and which were not.

I get this. If you recursively rmdir each directory then you clean it
up.

> Besides, if you rmdir lun0, is the function still supposed to work with
> all LUNs present?  In my opinion, while gadget is bound, it should not
> be possible to modify such things.

That is correct. The configuration should remain frozen as long as the
gadget is active because in most cases you can't propagate the change.

>> An unbind would be  simply an unlink of the gadget  which is linked to
>> the udc.   All configurations  remain so  you can link  it at  a later
>> point without touching the configuration because it is as it was.
>
> Yes, but that's not my concern.  My concern is that I should be able to
> put a relatively simple code in my shutdown script (or whatever) which
> unbinds all gadgets, without knowing what kind of functions are used.
>
> And I'm proposing that this could be done by allowing user to just do:
>
> 	cd /cfs/...
> 	rmdir gadgets/*		# unbind and remove all gadgets
> 	rmdir functions/*/*	# unbind and remove all function instances
> 	rmdir functions/*	# unload all functions

Yes, you push for simple rmdir API. That would avoid the need for an
user land tool at some point and you end up in shell scripts.
I'm not against it but others do have user tools to handle such things.
Anyway, for this to work we have to go through Joel.

> 	rmdir udcs/*		# unload all UDCs

No, for this you still have to rmmod :)


>>> I think the question is of information flow direction.  If user gives
>>> some information to the kernel, she should be the one creating any
>>> necessary directories.  But if the information comes from kernel to the
>>> user, the kernel should create the structure.
>
>> Yes that is a point. But the "name" can go away if we use it in the
>> directory name. That is what other configfs user do. The same is true
>> for luns for instance. I just want to avoid adding features because we
>> do something different compared to every other configfs user.
>
> You've lost me here.  What are we talking about again?  What “name” are
> you referring to?

            <function_name>-<common_name>
/functions/acm-function/

instead of
            <common_name>
/functions/function1/
                      +name
with attribute file named "name" which contains the name of the
function (i.e. acm). My point is to keep "name" in the directory name
instead having an extra attribute.

Sebastian
