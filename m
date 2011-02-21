Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1BUGJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:09:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53281 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1BUGJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:09:55 -0500
Message-ID: <4D6201A3.70301@cn.fujitsu.com>
Date: Mon, 21 Feb 2011 14:09:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Justin TerAvest <teravest@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Chad Talbott <ctalbott@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6 v5] cfq-iosched: Introduce CFQ group hierarchical scheduling
 and "use_hierarchy" interface
References: <4D61FE91.60705@cn.fujitsu.com>
In-Reply-To: <4D61FE91.60705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 14:08:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-21 14:08:53,
	Serialize complete at 2011-02-21 14:08:53
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

V4 -> V5 Changes:
- Change boosting base to a smaller value.
- Rename repostion_time to position_time
- Replace duplicated code by calling cfq_scale_slice()
- Remove redundant use_hierarchy in cfqd
- Fix grp_service_tree comment
- Rename init_cfqe() to init_group_cfqe()

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

 Documentation/cgroups/blkio-controller.txt |   81 +-
 block/blk-cgroup.c                         |   61 +
 block/blk-cgroup.h                         |    3
 block/cfq-iosched.c                        |  959 ++++++++++++++++++++---------
 4 files changed, 815 insertions(+), 289 deletions(-)

Thanks,
Gui
