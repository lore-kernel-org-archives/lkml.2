Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0H3JyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:54:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:57862 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0H3JyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:54:16 -0400
Message-ID: <4C7B7FC3.1050701@suse.de>
Date: Mon, 30 Aug 2010 11:54:11 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de,
        tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz,
        rwheeler@redhat.com
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org> <4C6C34E0.3050601@vlnb.net> <4C6CFEAA.1060004@kernel.org>
In-Reply-To: <4C6CFEAA.1060004@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On 08/18/2010 09:30 PM, Vladislav Bolkhovitin wrote:
>> Basically, I measured how iSCSI link utilization depends from amount
>> of queued commands and queued data size. This is why I made it as a
>> table. From it you can see which improvement you will have removing
>> queue draining after 1, 2, 4, etc. commands depending of commands
>> sizes.
>>
>> For instance, on my previous XFS rm example, where rm of 4 files
>> took 3.5 minutes with nobarrier option, I could see that XFS was
>> sending 1-3 32K commands in a row. From my table you can see that if
>> it sent all them at once without draining, it would have about
>> 150-200% speed increase.
> 
> You compared barrier off/on.  Of course, it will make a big
> difference.  I think good part of that gain should be realized by the
> currently proposed patchset which removes draining.  What's needed to
> be demonstrated is the difference between ordered-by-waiting and
> ordered-by-tag.  We've never had code to do that properly.
> 
> The original ordered-by-tag we had only applied tag ordering to two or
> three command sequences inside a barrier, which doesn't amount to much
> (and could even be harmful as it imposes draining of all simple
> commands inside the device only to reduce issue latencies for a few
> commands).  You'll need to hook into filesystem and somehow export the
> ordering information down to the driver so that whatever needs
> ordering is sent out as ordered commands.
> 
> As I've wrote multiple times, I'm pretty skeptical it will bring much.
> Ordered tag mandates draining inside the device just like the original
> barrier implementation.  Sure, it's done at a lower layer and command
> issue latencies will be reduced thanks to that but ordered-by-waiting
> doesn't require _any_ draining at all.  The whole pipeline can be kept
> full all the time.  I'm often wrong tho, so please feel free to go
> ahead and prove me wrong.  :-)
> 
Actually, I thought about ordered tag writes, too.
But eventually I had to give up on this for a simple reason:
Ordered tag controls the ordering on the SCSI _TARGET_. But for a
meaningful implementation we need to control the ordering all the way
down from ->queuecommand(). Which means we have three areas we need
to cover here:
- driver (ie between ->queuecommand() and passing it off to the firmware)
- firmware
- fabric

Sadly, the latter two are really hard to influence. And, what's more,
with the new/modern CNAs with multiple queues and possible multiple
routes to the target it becomes impossible to guarantee ordering.
So using ordered tags for FibreChannel is not going to work, which
makes implementing it a bit of a pointless exercise for me.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
