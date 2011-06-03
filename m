Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1FCWvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:51:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab1FCWvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oDCe4Qk7IPV8AdmwEiFLb5i56lCFoS/SOZaz7C8mTjMscJYsxhKGOJeDqxW3RFKhCJ
         vshBATBl4Fg2tjGJK61Q==
MIME-Version: 1.0
In-Reply-To: <BANLkTikureiwJ=hSfnwo2y0wWoW3hGge9Q@mail.gmail.com>
References: <1307117538-14317-1-git-send-email-gthelen@google.com> <BANLkTikureiwJ=hSfnwo2y0wWoW3hGge9Q@mail.gmail.com>
From: Greg Thelen <gthelen@google.com>
Date: Fri, 3 Jun 2011 15:50:28 -0700
Message-ID: <BANLkTik50YQtoLVHFg7BP6KLz7GtvU1KzEjdCwx620oYWBH0qQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/12] memcg: per cgroup dirty page accounting
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 3:46 PM, Hiroyuki Kamezawa
<kamezawa.hiroyuki@gmail.com> wrote:
> 2011/6/4 Greg Thelen <gthelen@google.com>:
>> This patch series provides the ability for each cgroup to have independent dirty
>> page usage limits.  Limiting dirty memory fixes the max amount of dirty (hard to
>> reclaim) page cache used by a cgroup.  This allows for better per cgroup memory
>> isolation and fewer ooms within a single cgroup.
>>
>> Having per cgroup dirty memory limits is not very interesting unless writeback
>> is cgroup aware.  There is not much isolation if cgroups have to writeback data
>> from other cgroups to get below their dirty memory threshold.
>>
>> Per-memcg dirty limits are provided to support isolation and thus cross cgroup
>> inode sharing is not a priority.  This allows the code be simpler.
>>
>> To add cgroup awareness to writeback, this series adds a memcg field to the
>> inode to allow writeback to isolate inodes for a particular cgroup.  When an
>> inode is marked dirty, i_memcg is set to the current cgroup.  When inode pages
>> are marked dirty the i_memcg field compared against the page's cgroup.  If they
>> differ, then the inode is marked as shared by setting i_memcg to a special
>> shared value (zero).
>>
>> Previous discussions suggested that a per-bdi per-memcg b_dirty list was a good
>> way to assoicate inodes with a cgroup without having to add a field to struct
>> inode.  I prototyped this approach but found that it involved more complex
>> writeback changes and had at least one major shortcoming: detection of when an
>> inode becomes shared by multiple cgroups.  While such sharing is not expected to
>> be common, the system should gracefully handle it.
>>
>> balance_dirty_pages() calls mem_cgroup_balance_dirty_pages(), which checks the
>> dirty usage vs dirty thresholds for the current cgroup and its parents.  If any
>> over-limit cgroups are found, they are marked in a global over-limit bitmap
>> (indexed by cgroup id) and the bdi flusher is awoke.
>>
>> The bdi flusher uses wb_check_background_flush() to check for any memcg over
>> their dirty limit.  When performing per-memcg background writeback,
>> move_expired_inodes() walks per bdi b_dirty list using each inode's i_memcg and
>> the global over-limit memcg bitmap to determine if the inode should be written.
>>
>> If mem_cgroup_balance_dirty_pages() is unable to get below the dirty page
>> threshold writing per-memcg inodes, then downshifts to also writing shared
>> inodes (i_memcg=0).
>>
>> I know that there is some significant writeback changes associated with the
>> IO-less balance_dirty_pages() effort.  I am not trying to derail that, so this
>> patch series is merely an RFC to get feedback on the design.  There are probably
>> some subtle races in these patches.  I have done moderate functional testing of
>> the newly proposed features.
>>
>
> Thank you...hmm, is this set really "merely RFC ?". I'd like to merge
> this function
> before other new big hammer works because this makes behavior of memcg
> much better.

Oops.  I meant to remove the above RFC paragraph.   This -v8 patch
series is intended for merging into mmotm.

> I'd like to review and test this set (but maybe I can't do much in the
> weekend...)

Thank you.

> Anyway, thank you.
> -Kame



>> Here is an example of the memcg-oom that is avoided with this patch series:
>>        # mkdir /dev/cgroup/memory/x
>>        # echo 100M > /dev/cgroup/memory/x/memory.limit_in_bytes
>>        # echo $$ > /dev/cgroup/memory/x/tasks
>>        # dd if=/dev/zero of=/data/f1 bs=1k count=1M &
>>        # dd if=/dev/zero of=/data/f2 bs=1k count=1M &
>>        # wait
>>        [1]-  Killed                  dd if=/dev/zero of=/data/f1 bs=1M count=1k
>>        [2]+  Killed                  dd if=/dev/zero of=/data/f1 bs=1M count=1k
>>
>> Known limitations:
>>        If a dirty limit is lowered a cgroup may be over its limit.
>>
>> Changes since -v7:
>> - Merged -v7 09/14 'cgroup: move CSS_ID_MAX to cgroup.h' into
>>  -v8 09/13 'memcg: create support routines for writeback'
>>
>> - Merged -v7 08/14 'writeback: add memcg fields to writeback_control'
>>  into -v8 09/13 'memcg: create support routines for writeback' and
>>  -v8 10/13 'memcg: create support routines for page-writeback'.  This
>>  moves the declaration of new fields with the first usage of the
>>  respective fields.
>>
>> - mem_cgroup_writeback_done() now clears corresponding bit for cgroup that
>>  cannot be referenced.  Such a bit would represent a cgroup previously over
>>  dirty limit, but that has been deleted before writeback cleaned all pages.  By
>>  clearing bit, writeback will not continually try to writeback the deleted
>>  cgroup.
>>
>> - Previously mem_cgroup_writeback_done() would only finish writeback when the
>>  cgroup's dirty memory usage dropped below the dirty limit.  This was the wrong
>>  limit to check.  This now correctly checks usage against the background dirty
>>  limit.
>>
>> - over_bground_thresh() now sets shared_inodes=1.  In -v7 per memcg
>>  background writeback did not, so it did not write pages of shared
>>  inodes in background writeback.  In the (potentially common) case
>>  where the system dirty memory usage is below the system background
>>  dirty threshold but at least one cgroup is over its background dirty
>>  limit, then per memcg background writeback is queued for any
>>  over-background-threshold cgroups.  Background writeback should be
>>  allowed to writeback shared inodes.  The hope is that writing such
>>  inodes has good chance of cleaning the inodes so they can transition
>>  from shared to non-shared.  Such a transition is good because then the
>>  inode will remain unshared until it is written by multiple cgroup.
>>  Non-shared inodes offer better isolation.
>>
>> Single patch that can be applied to mmotm-2011-05-12-15-52:
>>  http://www.kernel.org/pub/linux/kernel/people/gthelen/memcg/memcg-dirty-limits-v8-on-mmotm-2011-05-12-15-52.patch
>>
>> Patches are based on mmotm-2011-05-12-15-52.
>>
>> Greg Thelen (12):
>>  memcg: document cgroup dirty memory interfaces
>>  memcg: add page_cgroup flags for dirty page tracking
>>  memcg: add mem_cgroup_mark_inode_dirty()
>>  memcg: add dirty page accounting infrastructure
>>  memcg: add kernel calls for memcg dirty page stats
>>  memcg: add dirty limits to mem_cgroup
>>  memcg: add cgroupfs interface to memcg dirty limits
>>  memcg: dirty page accounting support routines
>>  memcg: create support routines for writeback
>>  memcg: create support routines for page-writeback
>>  writeback: make background writeback cgroup aware
>>  memcg: check memcg dirty limits in page writeback
>>
>>  Documentation/cgroups/memory.txt  |   70 ++++
>>  fs/fs-writeback.c                 |   34 ++-
>>  fs/inode.c                        |    3 +
>>  fs/nfs/write.c                    |    4 +
>>  include/linux/cgroup.h            |    1 +
>>  include/linux/fs.h                |    9 +
>>  include/linux/memcontrol.h        |   63 ++++-
>>  include/linux/page_cgroup.h       |   23 ++
>>  include/linux/writeback.h         |    5 +-
>>  include/trace/events/memcontrol.h |  198 +++++++++++
>>  kernel/cgroup.c                   |    1 -
>>  mm/filemap.c                      |    1 +
>>  mm/memcontrol.c                   |  708 ++++++++++++++++++++++++++++++++++++-
>>  mm/page-writeback.c               |   42 ++-
>>  mm/truncate.c                     |    1 +
>>  mm/vmscan.c                       |    2 +-
>>  16 files changed, 1138 insertions(+), 27 deletions(-)
>>  create mode 100644 include/trace/events/memcontrol.h
>>
>> --
>> 1.7.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
