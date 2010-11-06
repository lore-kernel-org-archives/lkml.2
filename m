Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0KFMWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 08:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0KFMWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 08:22:45 -0400
Date: Sat, 6 Nov 2010 08:16:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <jaxboe@fusionio.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
Message-ID: <20101106121605.GA6736@redhat.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103161638.ddc75ace.randy.dunlap@oracle.com>
 <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
 <4CD48D5E.10309@oracle.com>
 <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 04:36:59PM -0700, Linus Torvalds wrote:
> On Fri, Nov 5, 2010 at 4:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On 11/05/10 15:10, Linus Torvalds wrote:
> >>
> >> Randy, is this one also related to that ipv6 percpu list corruption?
> >> IOW, does it go away with
> >>
> >>   http://patchwork.ozlabs.org/patch/69939/
> >>
> >> like one of your other reports did?
> >
> > The list_debug.c message goes away, but it still gets the GP fault.
> 
> Ok. I think there's a separate floppy.c bug introduced in commit
> 488211844e0c ("floppy: switch to one queue per drive instead of
> sharing a queue").
> 
> We do "put_disk()" on the disk device _before_ we then clean up the
> queue associated with that disk.
> 
> So maybe this trivial patch is in order?
> 
> Again - UNTESTED. Jens, Vivek?

This one looks good to me.

While scanning the floopy code, I found one more instance of trying to
access disk->queue pointer after doing put_disk() on gendisk. For some
reason, floppy moule still loads/unloads fine. May be object is still
around with right pointer values.


o There seems to be one more instance of trying to cleanup the request queue
  after we have called put_disk() on associated gendisk.

o This fix is more out of code inspection. Even without this fix for some
  reason I am able to load/unload floppy module without any issues.

o Floppy module loads/unloads fine after the fix.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/floppy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/block/floppy.c
===================================================================
--- linux-2.6.orig/drivers/block/floppy.c	2010-11-06 07:49:29.000000000 -0400
+++ linux-2.6/drivers/block/floppy.c	2010-11-06 08:03:37.646062993 -0400
@@ -4573,8 +4573,8 @@ static void __exit floppy_module_exit(vo
 			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
 		}
-		put_disk(disks[drive]);
 		blk_cleanup_queue(disks[drive]->queue);
+		put_disk(disks[drive]);
 	}
 
 	del_timer_sync(&fd_timeout);
