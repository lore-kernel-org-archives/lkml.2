Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1AaTVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1AaTVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:21:04 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group() for root group
References: <20110117215606.GI5624@redhat.com>
	<20110126185729.GD6713@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 31 Jan 2011 14:20:57 -0500
In-Reply-To: <20110126185729.GD6713@redhat.com> (Vivek Goyal's message of
	"Wed, 26 Jan 2011 13:57:29 -0500")
Message-ID: <x49ei7sq3qe.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jan 17, 2011 at 04:56:06PM -0500, Vivek Goyal wrote:
>> o Jeff Moyer was doing some testing on a RAM backed disk and
>>   blkiocg_lookup_group() showed up high overhead after memcpy(). Similarly
>>   somebody else reported that blkiocg_lookup_group() is eating 6% extra
>>   cpu. Though looking at the code I can't think why the overhead of
>>   this function is so high. One thing is that it is called with very high
>>   frequency (once for every IO).
>> 
>> o For lot of folks blkio controller will be compiled in but they might
>>   not have actually created cgroups. Hence optimize the case of root
>>   cgroup where we can avoid calling blkiocg_lookup_group() if IO is happening
>>   in root group (common case).
>> 
>> Reported-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Hi Jens,
>
> Do you have any concerns regarding this patch?

Acked-by: Jeff Moyer <jmoyer@redhat.com>

Jens, this is a pretty easy performance regression fixup.  I think it
should be pulled in sooner rather than later.  We've also witnessed this
slowdown on big performance testing rigs, so it's not just a ramdisk
issue.

Cheers,
Jeff

>> ---
>>  block/blk-throttle.c |   10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>> 
>> Index: linux-2.6/block/blk-throttle.c
>> ===================================================================
>> --- linux-2.6.orig/block/blk-throttle.c	2011-01-17 16:23:37.041280712 -0500
>> +++ linux-2.6/block/blk-throttle.c	2011-01-17 16:36:09.362940975 -0500
>> @@ -168,7 +168,15 @@ static struct throtl_grp * throtl_find_a
>>  	 * tree of blkg (instead of traversing through hash list all
>>  	 * the time.
>>  	 */
>> -	tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
>> +
>> +	/*
>> +	 * This is the common case when there are no blkio cgroups.
>> + 	 * Avoid lookup in this case
>> + 	 */
>> +	if (blkcg == &blkio_root_cgroup)
>> +		tg = &td->root_tg;
>> +	else
>> +		tg = tg_of_blkg(blkiocg_lookup_group(blkcg, key));
>>  
>>  	/* Fill in device details for root group */
>>  	if (tg && !tg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
>> 
