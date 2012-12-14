Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2LNMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 07:18:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:56712 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2LNMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 07:18:28 -0500
Message-ID: <50CB1910.70502@linutronix.de>
Date: Fri, 14 Dec 2012 13:18:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com> <50B5C821.4000406@linutronix.de> <xa1ta9u1naik.fsf@mina86.com> <50B61695.50207@linutronix.de> <20121207231828.GM22789@localhost>
In-Reply-To: <20121207231828.GM22789@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 12:18 AM, Joel Becker wrote:
> Hey Guys,

Hi Joel,

you took quite some time to write this down.

> 	Please remember that configfs is not a "user" interface, it's a
> userspace<->kernelspace interface.  Like sysfs, it's not required to be
> convenient for someone at a bash prompt.  My goal is that it is *usable*
> from a bash prompt.  So it must be that you can
> create/destroy/configure objects via mkdir/rmkdir/cat/echo, but you
> might have a lot of those mkdir/echo combos to configure something.
> When it comes to the "user" interface, a wrapper script or library
> should be converting a user intention into all that boilerplate.

It is good that you say such things so people that want this things know 
the reasons why it is not done.

>>>>> I think the question is of information flow direction.  If user gives
>>>>> some information to the kernel, she should be the one creating any
>>>>> necessary directories.  But if the information comes from kernel to the
>>>>> user, the kernel should create the structure.
>
> 	This last paragraph actually describes the distinction between
> configfs and sysfs.  More specifically, if userspace wants to create an
> object in the kernel, it should use configfs.  If the kernel has created
> an object on its own, it exposes it via sysfs.  It is a deliberate
> non-goal for configfs to replicate sysfs behavior.

So you are saying that I should expose my UDC hardware device via sysfs
after the hardware is available because the kernel created it.
How should I get then into configfs? mkdir a directory which is named
like the HW? This would be painful to do manually but as you said, we
should have a tool.

> [What About the Patch?]
>
> 	In general, attribute setting that turns into created configfs
> objects is against the theory of configfs.  In practice, it's a
> nightmare locking change.  Coming into this discussion, I though you
> were doing dymanic things at ->make_group() time, but that is already
> supported.
> 	But I want to hear your thoughts.  I've dumped a bunch of
> alternate approaches here.  Do any seem to fit?  What other challenges
> do you see?

I'm mostly fine with this. Part of the problem was/is that the user
could create lun1 without lun0. Now, after looking at target they don't
have this limitation so I don't think we should have it either. As nab
explained, lun0 is always handled implicit for certain requests and not
exposed as a lun if the user did not create it. So I think we can live
with this. After all we can still return with -EINVAL if the user
creates lun1 before lun0.

Now one little question remains: We plan to expose interface numbers
and endpoints. The current idea is to have one directory for each
endpoint something like endpointXX where XX is the endpoint number.
We create the gadget upfront and assign it later to the UDC via a
symlink. We learn the interface number after the gadget has been
assigned. I think you suggest that we create the directory via the tool
once we exposed its details via sysfs or so. This might be okay since we 
want it probably only for debugging. On the hand if we drop the
endpooint number we don't have this. Got to keep thinking about this.

Anyway, thank you for time and arguments pro / contra self-created
directories.

>
> Joel
>

Sebastian
