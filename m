Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1BJHpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:45:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1BJHpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:45:51 -0500
Message-ID: <4D5397A9.6040404@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 15:45:45 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 0/6 v4] cfq-iosched: Introduce CFQ group hierarchical scheduling
 and "use_hierarchy" interface
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:44:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 15:44:58,
	Serialize complete at 2011-02-10 15:44:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
in the way that it puts all CFQ queues in a hidden group and schedules with other 
CFQ group under their parent. The patchset is available here,
http://lkml.org/lkml/2010/8/30/30

Vivek think this approach isn't so instinct that we should treat CFQ queues
and groups at the same level. Here is the new approach for hierarchical 
scheduling based on Vivek's suggestion. The most big change of CFQ is that
it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
queue scheduling just like CFQ group does. But I still give cfqq some jump 
in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
queue and CFQ group use the same scheduling algorithm. 

"use_hierarchy" interface is now added to switch between hierarchical mode
and flat mode. It works as memcg.

--
V3 -> V4 Changes:
- Take io class into account when calculating the boost value.
- Refine the vtime boosting logic as Vivek's Suggestion.
- Make the calculation of group slice cross all service trees under a group.
- Modify Documentation in terms of Vivek's comments.

--
V2 -> V3 Changes:
- Starting from cfqd->grp_service_tree for both hierarchical mode and flat mode
- Avoid recursion when allocating cfqg and force dispatch logic
- Fix a bug when boosting vdisktime
- Adjusting total_weight accordingly when changing weight
- Change group slice calculation into a hierarchical way
- Keep flat mode rather than deleting it first then adding it later
- kfree the parent cfqg if there nobody references to it
- Simplify select_queue logic by using some wrap function
- Make "use_hierarchy" interface work as memcg
- Make use of time_before() for vdisktime compare
- Update Document
- Fix some code style problems

--
V1 -> V2 Changes:
- Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
  queue_entity and group_entity, just use cfqe instead. 
- Give newly added cfqq a small vdisktime jump accord to its ioprio.
- Make flat mode as default CFQ group scheduling mode.
- Introduce "use_hierarchy" interface.
- Update blkio cgroup documents

Benchmarks:
I did some benchmarks by fio, I didn't see performance drop for throughtput or latency.
log is attached.

[PATCH 1/6 v4] cfq-iosched: Introduce cfq_entity for CFQ queue
[PATCH 2/6 v4] cfq-iosched: Introduce cfq_entity for CFQ group
[PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
[PATCH 4/6 v4] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
[PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling and use_hierarchy interface
[PATCH 6/6 v4] blkio-cgroup: Document for blkio.use_hierarchy interface

 Documentation/cgroups/blkio-controller.txt |   81 +-
 block/blk-cgroup.c                         |   61 +
 block/blk-cgroup.h                         |    3
 block/cfq-iosched.c                        |  968 ++++++++++++++++++++--------

Thanks,
Gui




