Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1CKBqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:46:25 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:65474 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743Ab1CKBqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:46:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAIsLeU15LK5JgWdsb2JhbACmNBUBARYmJcFaDYVVBA
Date: Fri, 11 Mar 2011 12:46:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Justin TerAvest <teravest@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        m-ikeda <m-ikeda@ds.jp.nec.com>, jaxboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ryov <ryov@valinux.co.jp>,
        taka <taka@valinux.co.jp>, "righi.andrea" <righi.andrea@gmail.com>,
        guijianfeng <guijianfeng@cn.fujitsu.com>,
        balbir <balbir@linux.vnet.ibm.com>, ctalbott <ctalbott@google.com>,
        nauman <nauman@google.com>, mrubin <mrubin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Storing cgroup id in page->private (Was: Re: [RFC]
 [PATCH 0/6] Provide cgroup isolation for buffered writes.)
Message-ID: <20110311014618.GC15097@dastard>
References: <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
 <20110310181529.GF29464@redhat.com>
 <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
 <20110310191115.GG29464@redhat.com>
 <20110310194106.GH29464@redhat.com>
 <1299791640-sup-1874@think>
 <3EC7D30A-B8F7-416B-8B1D-A19350C57D82@dilger.ca>
 <20110310213832.GK29464@redhat.com>
 <1299793340-sup-9066@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299793340-sup-9066@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:43:31PM -0500, Chris Mason wrote:
> Excerpts from Vivek Goyal's message of 2011-03-10 16:38:32 -0500:
> > On Thu, Mar 10, 2011 at 02:24:07PM -0700, Andreas Dilger wrote:
> > > On 2011-03-10, at 2:15 PM, Chris Mason wrote:
> > > > Excerpts from Vivek Goyal's message of 2011-03-10 14:41:06 -0500:
> > > >> On Thu, Mar 10, 2011 at 02:11:15PM -0500, Vivek Goyal wrote:
> > > >>>>> I think the person who dirtied the page can store the information in
> > > >>>>> page->private (assuming buffer heads were not generated) and if flusher
> > > >>>>> thread later ends up generating buffer heads and ends up modifying
> > > >>>>> page->private, this can be copied in buffer heads?
> > > >>>> 
> > > >>>> This scares me a bit.
> > > >>>> 
> > > >>>> As I understand it, fs/ code expects total ownership of page->private.
> > > >>>> This adds a responsibility for every user to copy the data through and
> > > >>>> store it in the buffer head (or anything else). btrfs seems to do
> > > >>>> something entirely different in some cases and store a different kind
> > > >>>> of value.
> > > >>> 
> > > >>> If filesystems are using page->private for some other purpose also, then
> > > >>> I guess we have issues. 
> > > >>> 
> > > >>> I am ccing linux-fsdevel to have some feedback on the idea of trying
> > > >>> to store cgroup id of page dirtying thread in page->private and/or buffer
> > > >>> head for tracking which group originally dirtied the page in IO controller
> > > >>> during writeback.
> > > >> 
> > > >> A quick "grep" showed that btrfs, ceph and logfs are using page->private
> > > >> for other purposes also.
> > > >> 
> > > >> I was under the impression that either page->private is null or it 
> > > >> points to buffer heads for the writeback case. So storing the info
> > > >> directly in either buffer head directly or first in page->private and
> > > >> then transferring it to buffer heads would have helped. 
> > > > 
> > > > Right, btrfs has its own uses for page->private, and we expect to own
> > > > it.  With a proper callback, the FS could store the extra information you
> > > > need in out own structs.
> > > 
> > > There is no requirement that page->private ever points to a
> > > buffer_head, and Lustre clients use it for its own tracking
> > > structure (never touching buffer_heads at all).  Any
> > > assumption about what a filesystem is storing in page->private
> > > in other parts of the code is just broken.
> > 
> > Andreas,
> > 
> > As Chris mentioned, will providing callbacks so that filesystem
> > can save/restore page->private be reasonable?
> 
> Just to clarify, I think saving/restoring page->private is going
> to be hard.  I'd rather just have a call back that says here's a
> page, storage this for the block io controller please, and another
> one that returns any previously stored info.

Agreed - there is absolutely no guarantee that some other thread
doesn't grab the page while it is under writeback and dereference
page->private expecting there to be buffer heads or some filesystem
specific structure to be there. Hence swapping out the expected
structure with something different is problematic.

However, I think there's bigger issues. e.g.  page->private might
point to multiple bufferheads that map to non-contiguous disk blocks
that were written by different threads - what happens if we get two
concurrent IOs to the one page, perhaps with different cgroup IDs?

Further, page->private might not even point to a per-page specific
structure - it might point to a structure shared by multiple pages
(e.g. an extent map). Adding a callback like this requires
filesystems to be able to store per-page or per-block information
for external users. Indeed, one of the areas of development in XFS
right now is to move away from storing internal per-block/per-page
information because of the memory overhead it causes.

IMO, if you really need some per-page information, then just put it
in the struct page - you can't hide the memory overhead just by
having the filesystem to store it for you. That just adds
unnecessary complexity...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
