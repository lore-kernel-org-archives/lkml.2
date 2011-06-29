Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1F2Pne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:43:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33521 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab1F2Pnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=16XEpvhWEAoUt_s5F41czeq2DVQ@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <20110627222121.GD20865@ponder.secretlab.ca>
 <BANLkTikt08CDJiKNxGF2mKmOhyxHfv21_g@mail.gmail.com> <BANLkTim+CemMz7A3J94e1UywCNd0r1SABQ@mail.gmail.com>
 <BANLkTi=16XEpvhWEAoUt_s5F41czeq2DVQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Jun 2011 09:43:10 -0600
X-Google-Sender-Auth: 55C4cL_B90co5lbjRGsOz2kjMYw
Message-ID: <BANLkTikJGHSwqMW2W2YA4EnvJ0yj+9C6ow@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 5:00 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Jun 29, 2011 at 1:51 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> It's not the device_for_each_child() that you're 'putting' back from
>> here.  Its the original kref initialization when the device was
>> created.
>
> device_unregister() is already calling put_device(), doesn't that deal
> with the original kref init for us ?

/me digs deeper:

device_register() has 2 parts; device_initialize() and device_add()
device_init() initialized the kref to 1 (via kobject_init()
device_add() calls get_device() to increment it to 2

Then similarly for device_unregister():
device_del() calls put_device() to decrement the kref to 1
a final put_device() call decrements the kref to 0 - which triggers a
call to the release method that kfrees the object.

So you are right that device_unregister drops the refcount to zero,
but the code still needs to be fixed to not call kfree() directly.

It also looks like rpmsg_destroy_channel() needs to be fixed to remove
the kfree call and an extra put_device() call.  This is important
because the last put_device() call above might /not/ decrement the
refcount to zero is for some reason something still holds a reference
to the device.  But the device will still get freed correctly when the
other holder finally calls device_put().

g.
