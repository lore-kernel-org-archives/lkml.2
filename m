Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0GINqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0GINqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:46:11 -0400
Date: Fri, 9 Jul 2010 09:45:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100709134546.GC3672@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:57:13PM -0400, Munehiro Ikeda wrote:
> These RFC patches are trial to add async (cached) write support on blkio
> controller.
> 
> Only test which has been done is to compile, boot, and that write bandwidth
> seems prioritized when pages which were dirtied by two different processes in
> different cgroups are written back to a device simultaneously.  I know this
> is the minimum (or less) test but I posted this as RFC because I would like
> to hear your opinions about the design direction in the early stage.
> 
> Patches are for 2.6.35-rc4.
> 
> This patch series consists of two chunks.
> 
> (1) iotrack (patch 01/11 -- 06/11)
> 
> This is a functionality to track who dirtied a page, in exact which cgroup a
> process which dirtied a page belongs to.  Blkio controller will read the info
> later and prioritize when the page is actually written to a block device.
> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
> proposals for IO controller.
> 
> 
> (2) blkio controller modification (07/11 -- 11/11)
> 
> The main part of blkio controller async write support.
> Currently async queues are device-wide and async write IOs are always treated
> as root group.
> These patches make async queues per a cfq_group per a device to control them.
> Async write is handled by flush kernel thread.  Because queue pointers are
> stored in cfq_io_context, io_context of the thread has to have multiple
> cfq_io_contexts per a device.  So these patches make cfq_io_context per an
> io_context per a cfq_group, which means per an io_context per a cgroup per a
> device.
> 
> 
> This might be a piece of puzzle for complete async write support of blkio
> controller.  One of other pieces in my head is page dirtying ratio control.
> I believe Andrea Righi was working on it...how about the situation?

Thanks Muuh. I will look into the patches in detail. 

In my initial patches I had implemented the support for ASYNC control
(also included Ryo's IO tracking patches) but it did not work well and
it was unpredictable. I realized that until and unless we implement
some kind of per group dirty ratio/page cache share at VM level and
create parallel paths for ASYNC IO, writes often get serialized.

So writes belonging to high priority group get stuck behind low priority
group and you don't get any service differentiation.

So IMHO, this piece should go into kernel after we have first fixed the
problem at VM (read memory controller) with per cgroup dirty ratio kind
of thing.

> 
> And also, I'm thinking that async write support is required by bandwidth
> capping policy of blkio controller.  Bandwidth capping can be done in upper
> layer than elevator.

I think capping facility we should implement in higher layers otherwise
it is not useful for higher level logical devices (dm/md).

It was ok to implement proportional bandwidth division at CFQ level
because one can do proportional BW division at each leaf node and still get
overall service differentation at higher level logical node. But same can
not be done for max BW control.
 
>  However I think it should be also done in elevator layer
> in my opinion.  Elevator buffers and sort requests.  If there is another
> buffering functionality in upper layer, it is doubled buffering and it can be
> harmful for elevator's prediction.

I don't mind doing it at elevator layer also because in that case of
somebody is not using dm/md, then one does not have to load max bw
control module and one can simply enable max bw control in CFQ. 

Thinking more about it, now we are suggesting implementing max BW
control at two places. I think it will be duplication of code and
increased complexity in CFQ. Probably implement max bw control with
the help of dm module and use same for CFQ also. There is pain 
associated with configuring dm device but I guess it is easier than
maintaining two max bw control schemes in kernel.

Thanks
Vivek
