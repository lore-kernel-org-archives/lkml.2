Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2A1Kx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 05:53:57 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:37172
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173Ab2A1Kxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 05:53:55 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0SAraaj027505
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Slab corruption in floppy driver module
In-Reply-To: <20120127195455.GA18068@redhat.com> (Vivek Goyal's message of
	"Fri, 27 Jan 2012 14:54:55 -0500")
References: <4F1EAFE9.5000306@suse.com> <20120124223153.GG17291@redhat.com>
	<20120126150420.GD1891@redhat.com>
	<20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120126193735.GA11297@redhat.com> <giobtq5e46.fsf@mx10.gouders.net>
	<4F223F11.4050307@suse.com> <giaa59tmbr.fsf@mx10.gouders.net>
	<20120127195455.GA18068@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sat, 28 Jan 2012 11:53:34 +0100
Message-ID: <gity3g14k1.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sat, 28 Jan 2012 11:53:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Jan 27, 2012 at 12:30:00PM +0100, Dirk Gouders wrote:
>> Suresh Jayaraman <sjayaraman@suse.com> writes:
>> 
>> > On 01/27/2012 03:18 AM, Dirk Gouders wrote:
>> 
>> [snipped many lines]
>> 
>> >> Probably a rare and uncommon one but it seems that the reloading case on
>> >> a machine that has a floppy controller is a different problem.  To be
>> >> sure I tested the patch on a machine that has a floppy controller and
>> >> when unloading and reloading the floppy module the log messages that I
>> >> attached to a mail earlier in this thread are still generated.
>> >> 
>> >
>> > Yeah, this seems like a different problem. Could you please try enabling
>> > CONFIG_DEBUG_PAGEALLOC and see whether is it pointing to the problem
>> > code while loading/unloading the module?
>> 
>> I enabled the option and it produces just one message during boot but
>> nothing else while unloading/loading the floppy module.
>>
>
> Can you please try following patch and see if it fixes the issue. I could
> reproduce the issue with my virtual machine. The issue seems to be that
> we do not call add_disk() for all the drives/disks but we try to do
> put_disk() on all the disks. Hence running into the issue of putting
> extra reference during module removal.

I tested your patch and it works fine.

There is just a little typo:

floppy: Fix a crash during rmmod

Thanks,

Dirk

> floppy: Fix a crash during rmmmod
>
> floppy driver does not call add_disk() on all the drives hence we don't take
> gendisk reference on request queue for these drives. Don't call put_disk()
> with disk->queue set, otherwise we try to put the reference we never took.
>
> Reported-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> 
> Signed-off-by: Vivek Goyal<vgoyal@redhat.com>
> ---
>  drivers/block/floppy.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> Index: linux-2.6/drivers/block/floppy.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/floppy.c	2012-01-27 14:34:45.000000000 -0500
> +++ linux-2.6/drivers/block/floppy.c	2012-01-27 14:39:13.729861052 -0500
> @@ -4584,6 +4584,15 @@ static void __exit floppy_module_exit(vo
>  			platform_device_unregister(&floppy_device[drive]);
>  		}
>  		blk_cleanup_queue(disks[drive]->queue);
> +
> +		/*
> +		 * These disks have not called add_disk().  Don't put down
> +		 * queue reference in put_disk().
> +		 */
> +		if (!(allowed_drive_mask & (1 << drive)) ||
> +		    fdc_state[FDC(drive)].version == FDC_NONE)
> +			disks[drive]->queue = NULL;
> +
>  		put_disk(disks[drive]);
>  	}
>  
