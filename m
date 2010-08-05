Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab0HEJth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:49:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50151 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0HEJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:49:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 18:44:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5 -mm][memcg] towards I/O aware memory cgroup v4
Message-Id: <20100805184434.3a29c0f9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v4.

Major changes from v3 is 
 - dropped spinlock per page_cgroup (then, 4byte free space.)
 - added more comments
 - clean up.


This set has 2 purposes.
 1. re-desgin struct page_cgroup and makes room for blocckio-cgroup ID.
 2. implement quick updating method for memcg's file stat.

 1. check influence of Mel's new writeback method.
    I think we'll see OOM easier. IIUC, memory cgroup needs a thread like kswapd
    to do background writeback or low-high watermark.
    (By this, we can control priority of background writeout thread priority
     by CFS. This is very good.)

 2. implementing dirty_ratio.
    Now, Greg Thelen is working on. One of biggest problems of previous trial was
    update cost of status. I think this patch set can reduce it.

About reducing size of struct page_cgroup:
We have several choices. So, plz wait.
I don't think packing memcgid, blockio-id to pc->flags is a good choice.
(I'm afraid of races and new limitations added by that.)

One idea:  free spaces in pc->flags can be used...but it's better to store some
           very stable/staic value.
	   One idea is store pfn or section-ID or node-id there. Then, we can remove
	   pc->page pointer. Considering page_cgroup's usage, page->page_cgroup is
	   a usual operation but page_cgroup->page is not. (only used at memory recalim)
	   Then, we can implement a function page_cgroup_to_page() and remove
	   page_cgroup->page pointer. For this, free space in pc->flags can be used.

After MM-Summit, I have another event until Aug16, and will be busy for a while.
(And cannot read e-mail box on my office) If you want to contact me, please
 e-mail kahi at mte biglobe ne jp.

Thanks,
-Kame




