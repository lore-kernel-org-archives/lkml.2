Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2I1NxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:53:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab2I1NxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:53:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	<CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
Date: Fri, 28 Sep 2012 21:53:19 +0800
Message-ID: <CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: Ming Lei <ming.lei@canonical.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:31 AM, anish singh
<anish198519851985@gmail.com> wrote:
> Hello Ming,
> Though I am not an expert in this driver core area but
> I have been following this fix.So have some queries below:
>
> On Fri, Sep 28, 2012 at 6:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
>> Inside bus_add_driver(), one device might be added into
> should it not be "driver might be added into"?
>> the bus or probed which is triggered by deferred probe
>> just after completing of driver_attach() and before
>> 'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
>> so the device won't be probed by this driver.
> So the corresponding device will not be probed.
>>
>> This patch moves the below line
>>
>>         'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'
>>
>> before driver_attach() inside bus_add_driver().
>>
>> So fixes the problem since the below way can guarantee that
>> no probe(dev) may be lost.
>>
> As I understand CPU0 is just calling bus_add_driver and driver_attach
> is called and after that it was pre-empted and cpu1 came into picture.
> Deferred probe started running on cpu1 and it didn't find the driver present
> int the knode_bus and unloaded the driver(why it unloaded is already
> explained by russell in his first post).

If the driver is unloaded, it is not a problem because the device will be
probed after the driver is loaded again, so it is nothing to do with driver
unloading. I don't know it was mentioned before.

The  problem is that the bus_probe_device or device_add context
may not see the driver added in driver_register context, in which
the device is not being seen by driver_attach too. Only when the
device is not probed in both the two contexts, the problem is
triggered.

If the device can be guaranteed to be probed always in one of the
two contexts, the problem will be solved. That is the idea in the patch.

> Hope my understanding is correct.

Hope I clarify the problem.


Thanks,
--
Ming Lei
