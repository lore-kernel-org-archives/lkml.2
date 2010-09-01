Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0IAMZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab0IAMZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:25:41 -0400
Date: Wed, 1 Sep 2010 08:25:27 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100901122526.GA24922@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BD202.4040700@kernel.org>
 <4C7DFD8F.6070200@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7DFD8F.6070200@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01 2010 at  3:15am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Tejun,
> 
> On 08/31/2010 12:45 AM +0900, Tejun Heo wrote:
> > This patch converts request-based dm to support the new REQ_FLUSH/FUA.
> > 
> > The original request-based flush implementation depended on
> > request_queue blocking other requests while a barrier sequence is in
> > progress, which is no longer true for the new REQ_FLUSH/FUA.
> > 
> > In general, request-based dm doesn't have infrastructure for cloning
> > one source request to multiple targets, but the original flush
> > implementation had a special mostly independent path which can issue
> > flushes to multiple targets and sequence them.  However, the
> > capability isn't currently in use and adds a lot of complexity.
> > Moreoever, it's unlikely to be useful in its current form as it
> > doesn't make sense to be able to send out flushes to multiple targets
> > when write requests can't be.
> > 
> > This patch rips out special flush code path and deals handles
> > REQ_FLUSH/FUA requests the same way as other requests.  The only
> > special treatment is that REQ_FLUSH requests use the block address 0
> > when finding target, which is enough for now.
> > 
> > * added BUG_ON(!dm_target_is_valid(ti)) in dm_request_fn() as
> >   suggested by Mike Snitzer
> 
> Thank you for your work.
> 
> I don't see any obvious problem on this patch.
> However, I hit a NULL pointer dereference below when I use a mpath
> device with barrier option of ext3.  I'm investigating the cause now.
> (Also I'm not sure the cause of the hang which Mike is hitting yet.)
> 
> I tried on the commit 28dd53b26d362c16234249bad61db8cbd9222d0b of
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua.
> 
>     # mke2fs -j /dev/mapper/mpatha
>     # mount -o barrier=1 /dev/mapper/mpatha /mnt/0
>     # dd if=/dev/zero of=/mnt/0/a bs=512 count=1
>     # sync
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078

FYI, I can't reproduce this using all of Tejun's latest patches (not yet
in the flush-fua git tree).  But I haven't tried the specific flush-fua
commit that you referenced.

Mike
