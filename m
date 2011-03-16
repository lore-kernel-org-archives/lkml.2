Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1CPThj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:37:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1CPThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:37:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: scameron@beardog.cce.hp.com
Subject: Re: Question about driver ioctl, big kernel lock, mutexes
Date: Wed, 16 Mar 2011 20:36:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dab@hp.com,
        mike.miller@hp.com
References: <20110316155033.GQ12760@beardog.cce.hp.com>
In-Reply-To: <20110316155033.GQ12760@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103162036.56474.arnd@arndb.de>
X-Provags-ID: V02:K0:wWArXsfF7IFyvHK5Du+/aZB+tGi4TjyuY4YGuu1ZD0F
 qLH+V3ei27oR43DMlsiV89L5UUJ+MJcihAG6yy1RW9eSjahMgt
 rhICLXsFutpZgph+KqK/vDrw3fweAeu0OkjNajRb4fle0pP9yP
 bTxnF1TSmEUSKNxHtwaANdSXquzBHSWd2E84snQSpibZJXQlMX
 KXCf+YK+0IEo8LPpWestQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 March 2011 16:50:33 scameron@beardog.cce.hp.com wrote:
> That's a pretty big change in behavior.  Some commands sent through
> the passthrough ioctls may take awhile, and they're going to block
> any other ioctls from getting started while they're going.  Previously,
> it was possible to saturate the controller using multiple threads or
> processes hammering on the ioctl path.  This would appear to no longer
> be the case.

I just looked a bit closer at the driver, this is what I noticed:

* The mutex currently protects CCISS_GETNODENAME against CCISS_SETNODENAME
and CCISS_GETINTINFO against CCISS_SETINTINFO. You can easily change
that by taking &h->lock in the CCISS_GET* functions.

* The scsi ioctls don't need the mutex, we've checked that elsewhere.

* I can see no reason why any of the CCISS specific ioctls would
require a lock. There is no global data they touch, and very little
host specific data, most of which is accessed under a host spinlock.

* When you clean up the ioctl handling to remove the mutex, it would
be a good idea to clean up the compat_ioctl handling at the same
time, which is another artifact of a legacy implementation. Just
change cciss_ioctl_big_passthru to take a BIG_IOCTL_Command_struct
kernel pointer argument, and then it directly from
cciss_ioctl32_big_passthru without the extra compat_alloc_user_space
and copy_in_user. Same for cciss_ioctl32_passthru. This will
simplify the compat code path and make it faster.

* Allocating consistent memory on behalf of the user indeed looks
like a potential DoS attack, but it's only possible if you have
read permissions on the block device. To improve this, you should
track the total amount of memory allocated to the device, since
even a single ioctl apparently could be used to pin down all memory
otherwise, independent of the number of commands.

	Arnd
