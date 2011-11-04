Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1KDCvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:51:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:3383 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab1KDCu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:50:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,453,1315206000"; 
   d="scan'208";a="33179150"
Subject: Re: [PATCH][RFC] A readahead complete notify approach to implement
 buffer aio
From: Shaohua Li <shaohua.li@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "i@coly.li" <i@coly.li>, Zhu Yanhai <zhu.yanhai@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        Zhu Yanhai <gaoyang.zyh@taobao.com>
In-Reply-To: <x49y5vxytik.fsf@segfault.boston.devel.redhat.com>
References: <1320138024-10837-1-git-send-email-gaoyang.zyh@taobao.com>
	 <4EB2D8CF.2080108@coly.li>
	 <x49y5vxytik.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 10:59:19 +0800
Message-ID: <1320375559.22361.199.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 02:01 +0800, Jeff Moyer wrote:
> Coly Li <i@coly.li> writes:
> 
> > On 2011年11月01日 17:00, Zhu Yanhai Wrote:
> >> The current libaio/aio has to be Direct-IO, otherwise it falls back into sync IO.
> >> However, the aio core has already been asychronous naturally. This patch adds a complete
> >> notify mechanism to implement buffer aio, the main idea is to readahead()-like in
> >> io_submit(), counts the non-uptodated pages assocaiated with each iocb, then put each ref
> >> in the bio complete path just before unlock_page(), and hook them on to the aio ring buffer
> >> finally when the ref drops to zero. In io_getevents(), we call vfs_read() as a safe net
> >> since there is still little possibility that the pages had brought in were reclaimed
> >> between io_submit() and io_getevents().
> >> 
> >> I have tested this patch for a while, for the small size random io request, its
> >> performance is more or less the same with the traditional aio, for the big io request,
> >> the overhead of one extra memory copy arises.
> >> 
> >> I think so far it has at least below obvious drawbacks,
> >> 
> >> * mpage_readpage() is a really narrow interface, I have no way to pass down
> >> the new control struct baiocb, so I just put it into struct task_struct and
> >> refer it by current() as a workaround.
> >> 
> >> * the do_baio_read() routine is heavily similar with do_generic_file_read(), but
> >> the latter is really hard to modify. I think we may stuff these code down into the
> >> readahead path to reduce code reduplication.
> >> 
> >> Hopefully the explanations are clear enough and don't muddy the water any worse.
> >> I figure the code does need some better comments, and any suggestion are welcome.
> >> 
> >> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
> >> 
> >> ---
> >>  fs/aio.c                    |  319 ++++++++++++++++++++++++++++++++++++++++++-
> >>  fs/buffer.c                 |   26 ++++-
> >>  fs/mpage.c                  |   28 ++++-
> >>  include/linux/aio.h         |    9 ++
> >>  include/linux/aio_abi.h     |    1 +
> >>  include/linux/blk_types.h   |    2 +
> >>  include/linux/buffer_head.h |    3 +
> >>  include/linux/page-flags.h  |    2 +
> >>  include/linux/sched.h       |    1 +
> >>  9 files changed, 386 insertions(+), 5 deletions(-)
> >> 
> >
> > Hmm, I don't see the usage from user space. Is it possible to post a demo code in user space, so people are able to
> > understand how to use/test your patch.
> 
> He added a new IOCB_CMD_blah for buffered aio reads.  That is,
> unfortunately, a really poor way to go about doing things.  Please take
> a look at the work Jens did on implementing buffered aio.  It can be
> found in his linux-block git tree.
Interesting, I thought Jens's work is to make io_submit not blocking.
That's good to know it supports async buffer io too. Last time I look at
the code, it appears there still are threads to do the aio retry, so
what's the difference just letting user space thread do a sync buffer
io?

