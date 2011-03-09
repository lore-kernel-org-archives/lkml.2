Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab1CISEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:04:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24299 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1CISEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KRf5mHYGAn7ZJ5abYwz1Xv1wluFald4mTJn0iEreTBJOO021Yrp6v0gTMafQJhlndL
         eilED1d/nJcASBDPbt4Q==
MIME-Version: 1.0
In-Reply-To: <20110308225059.GL27455@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110308224325.GK27455@redhat.com> <20110308225059.GL27455@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 9 Mar 2011 10:04:11 -0800
Message-ID: <AANLkTinpLiFM2yoMONQYekSd4L1BgzHSUa6F+QGbW8Gr@mail.gmail.com>
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        ryov@valinux.co.jp, taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 2:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Mar 08, 2011 at 05:43:25PM -0500, Vivek Goyal wrote:
>> On Tue, Mar 08, 2011 at 01:20:50PM -0800, Justin TerAvest wrote:
>> > This patchset adds tracking to the page_cgroup structure for which cgroup has
>> > dirtied a page, and uses that information to provide isolation between
>> > cgroups performing writeback.
>> >
>>
>> Justin,
>>
>> So if somebody is trying to isolate a workload which does bunch of READS
>> and lots of buffered WRITES, this patchset should help in the sense that
>> all the heavy WRITES can be put into a separate cgroup of low weight?
>>
>> Other application which are primarily doing READS, direct WRITES or little
>> bit of buffered WRITES should still get good latencies if heavy writer
>> is isolated in a separate group?
>>
>> If yes, then this piece standalone can make sense. And once the other
>> piece/patches of memory cgroup dirty ratio and cgroup aware buffered
>> writeout come in, then one will be able to differentiate buffered writes
>> of different groups.
>
> Thinking more about it, currently anyway SYNC preempts the ASYNC. So the
> question would be will it help me enable get better isolation latencies
> of READS agains buffered WRITES?

Ah! Sorry, I left out a patch that disables cross-group preemption.
I'll add that to the patchset and email out v2 soon.

>
> Thanks
> Vivek
>
>>
>> Thanks
>> Vivek
>>
>> > I know that there is some discussion to remove request descriptor limits
>> > entirely, but I included a patch to introduce per-cgroup limits to enable
>> > this functionality. Without it, we didn't see much isolation improvement.
>> >
>> > I think most of this material has been discussed on lkml previously, this is
>> > just another attempt to make a patchset that handles buffered writes for CFQ.
>> >
>> > There was a lot of previous discussion at:
>> >   http://thread.gmane.org/gmane.linux.kernel/1007922
>> >
>> > Thanks to Andrea Righi, Kamezawa Hiroyuki, Munehiro Ikeda, Nauman Rafique,
>> > and Vivek Goyal for work on previous versions of these patches.
>> >
>> >
>> >  Documentation/block/biodoc.txt |   10 +
>> >  block/blk-cgroup.c             |  204 +++++++++++++++++++++-
>> >  block/blk-cgroup.h             |    9 +-
>> >  block/blk-core.c               |  216 +++++++++++++++--------
>> >  block/blk-settings.c           |    2 +-
>> >  block/blk-sysfs.c              |   60 ++++---
>> >  block/cfq-iosched.c            |  390 +++++++++++++++++++++++++++++++---------
>> >  block/cfq.h                    |    6 +-
>> >  block/elevator.c               |   11 +-
>> >  fs/buffer.c                    |    2 +
>> >  fs/direct-io.c                 |    2 +
>> >  include/linux/blk_types.h      |    2 +
>> >  include/linux/blkdev.h         |   81 ++++++++-
>> >  include/linux/blkio-track.h    |   89 +++++++++
>> >  include/linux/elevator.h       |   14 ++-
>> >  include/linux/iocontext.h      |    1 +
>> >  include/linux/memcontrol.h     |    6 +
>> >  include/linux/mmzone.h         |    4 +-
>> >  include/linux/page_cgroup.h    |   12 +-
>> >  init/Kconfig                   |   16 ++
>> >  mm/Makefile                    |    3 +-
>> >  mm/bounce.c                    |    2 +
>> >  mm/filemap.c                   |    2 +
>> >  mm/memcontrol.c                |    6 +
>> >  mm/memory.c                    |    6 +
>> >  mm/page-writeback.c            |   14 ++-
>> >  mm/page_cgroup.c               |   29 ++-
>> >  mm/swap_state.c                |    2 +
>> >  28 files changed, 985 insertions(+), 216 deletions(-)
>> >
>> > [PATCH 1/6] Add IO cgroup tracking for buffered writes.
>> > [PATCH 2/6] Make async queues per cgroup.
>> > [PATCH 3/6] Modify CFQ to use IO tracking information.
>> > [PATCH 4/6] With per-cgroup async, don't special case queues.
>> > [PATCH 5/6] Add stat for per cgroup writeout done by flusher.
>> > [PATCH 6/6] Per cgroup request descriptor counts
>
