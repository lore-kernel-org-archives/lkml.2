Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0HSJzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:55:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:34379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0HSJzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:55:49 -0400
Message-ID: <4C6CFEAA.1060004@kernel.org>
Date: Thu, 19 Aug 2010 11:51:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net> <4C6546E0.7070208@kernel.org> <4C6C34E0.3050601@vlnb.net>
In-Reply-To: <4C6C34E0.3050601@vlnb.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 09:55:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/18/2010 09:30 PM, Vladislav Bolkhovitin wrote:
> Basically, I measured how iSCSI link utilization depends from amount
> of queued commands and queued data size. This is why I made it as a
> table. From it you can see which improvement you will have removing
> queue draining after 1, 2, 4, etc. commands depending of commands
> sizes.
>
> For instance, on my previous XFS rm example, where rm of 4 files
> took 3.5 minutes with nobarrier option, I could see that XFS was
> sending 1-3 32K commands in a row. From my table you can see that if
> it sent all them at once without draining, it would have about
> 150-200% speed increase.

You compared barrier off/on.  Of course, it will make a big
difference.  I think good part of that gain should be realized by the
currently proposed patchset which removes draining.  What's needed to
be demonstrated is the difference between ordered-by-waiting and
ordered-by-tag.  We've never had code to do that properly.

The original ordered-by-tag we had only applied tag ordering to two or
three command sequences inside a barrier, which doesn't amount to much
(and could even be harmful as it imposes draining of all simple
commands inside the device only to reduce issue latencies for a few
commands).  You'll need to hook into filesystem and somehow export the
ordering information down to the driver so that whatever needs
ordering is sent out as ordered commands.

As I've wrote multiple times, I'm pretty skeptical it will bring much.
Ordered tag mandates draining inside the device just like the original
barrier implementation.  Sure, it's done at a lower layer and command
issue latencies will be reduced thanks to that but ordered-by-waiting
doesn't require _any_ draining at all.  The whole pipeline can be kept
full all the time.  I'm often wrong tho, so please feel free to go
ahead and prove me wrong.  :-)

Thanks.

-- 
tejun
