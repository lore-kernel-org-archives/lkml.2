Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab0LPUm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:42:59 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:41906 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0LPUm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:42:58 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.87.10]
In-Reply-To: <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com> <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Dec 2010 22:42:37 +0200
Message-ID: <AANLkTi=JUxc+eOTAkFFjEXoqQEaXgyT7n6qtxW-7MzRv@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: Greg KH <greg@kroah.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 8:40 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Dec 14, 2010 at 7:06 PM, Greg KH <greg@kroah.com> wrote:
>>  Like the most important one, why is this generic code if
>>  it's only for one specific platform?
>
> We started out with an omap-specific driver, but Tony preferred that we
> make this a platform-agnostic framework, in order to keep the IPC drivers that
> will use it generic, and assuming that more users will show up for
> such framework.

I was just told about additional users for this (thanks Mugdha):

1) There are several platforms (such as omap3530 and omapl1xx) that
have no such hardware support, but would still need to use the same
IPC drivers (to communicate with their DSP).

The only way to achieve mutual exclusion on those platforms is by
using a shared-memory synchronization algorithm called Peterson's
Algorithm [1]. We would still need the same hwspinlock framework for
that - the busy looping, the timeout, the various locking schemes, the
resource allocation - are all still valid. The only difference is the
actual lock implementation.

2) The C6474, which is a multi-core DSP device [2], have Linux running
on one of its cores, and would be using the same IPC drivers, too.
C6474 has hardware support for synchronization, which would also
benefit from such hwspinlock module (btw the C6474 has a richer
hardware module that would need more than the hwspinlock framework
offer today - it also supports queuing, owner semantics and interrupt
notification to let a processor know when it acquires a lock, so it
wouldn't have to spin..)

Thanks,
Ohad.

[1] http://en.wikipedia.org/wiki/Peterson's_algorithm
[2] http://focus.ti.com/docs/prod/folders/print/tms320c6474.html

> To me it sounds reasonable, but both ways (framework / omap-specific
> driver) will work for us just fine, and I can switch back to a misc
> driver if this is preferred.
>
> The complete discussion of v1 is at:
> http://comments.gmane.org/gmane.linux.kernel/1049802
>
> We also discussed this at v2 of the patches with David, see the
> complete discussion at:
> http://comments.gmane.org/gmane.linux.kernel/1067016
>
> Thanks,
> Ohad.
>
>>
>> thanks,
>>
>> greg k-h
>>
>
