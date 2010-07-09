Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0GIDAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0GIDAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:00:12 -0400
Message-ID: <4C369009.80503@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 22:57:13 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, Muuhh Ikeda <m-ikeda@ds.jp.nec.com>
Subject: [RFC][PATCH 00/11] blkiocg async support
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These RFC patches are trial to add async (cached) write support on blkio
controller.

Only test which has been done is to compile, boot, and that write bandwidth
seems prioritized when pages which were dirtied by two different processes in
different cgroups are written back to a device simultaneously.  I know this
is the minimum (or less) test but I posted this as RFC because I would like
to hear your opinions about the design direction in the early stage.

Patches are for 2.6.35-rc4.

This patch series consists of two chunks.

(1) iotrack (patch 01/11 -- 06/11)

This is a functionality to track who dirtied a page, in exact which cgroup a
process which dirtied a page belongs to.  Blkio controller will read the info
later and prioritize when the page is actually written to a block device.
This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
proposals for IO controller.


(2) blkio controller modification (07/11 -- 11/11)

The main part of blkio controller async write support.
Currently async queues are device-wide and async write IOs are always treated
as root group.
These patches make async queues per a cfq_group per a device to control them.
Async write is handled by flush kernel thread.  Because queue pointers are
stored in cfq_io_context, io_context of the thread has to have multiple
cfq_io_contexts per a device.  So these patches make cfq_io_context per an
io_context per a cfq_group, which means per an io_context per a cgroup per a
device.


This might be a piece of puzzle for complete async write support of blkio
controller.  One of other pieces in my head is page dirtying ratio control.
I believe Andrea Righi was working on it...how about the situation?

And also, I'm thinking that async write support is required by bandwidth
capping policy of blkio controller.  Bandwidth capping can be done in upper
layer than elevator.  However I think it should be also done in elevator layer
in my opinion.  Elevator buffers and sort requests.  If there is another
buffering functionality in upper layer, it is doubled buffering and it can be
harmful for elevator's prediction.

I appreciate any comments and suggestions.


Thanks,
Muuhh


-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com

