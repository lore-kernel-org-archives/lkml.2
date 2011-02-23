Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1BWB4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1BWB4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:56:23 -0500
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable
 memory slots using wbtree
From: Alex Williamson <alex.williamson@redhat.com>
To: avi@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
In-Reply-To: <20110222183822.22026.62832.stgit@s20.home>
References: <1298386481.5764.60.camel@x201>
	 <20110222183822.22026.62832.stgit@s20.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 18:56:19 -0700
Message-ID: <1298426179.1668.35.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 11:54 -0700, Alex Williamson wrote:
> This series introduces a new weight-balanced binary tree (wbtree) for
> general use.  It's largely leveraged from the rbtree, copying it's
> rotate functions, while introducing different rebalance and erase
> functions.  This tree is particularly useful for managing memory
> ranges, where it's desirable to have the most likely targets (the
> largest ranges) at the top of each subtree.
> 
> Patches 2 & 3 go on to convert the KVM memory slots to a growable
> array and make use of wbtree for efficient managment.  Trying to
> exercise the worst case for this data structure, I ran netperf
> TCP_RR on an emulated rtl8139 NIC connected directly to the host
> via a tap.  Both qemu-kvm and the netserver on the host were
> pinned to optimal CPUs with taskset.  This series resulted in
> a 3% improvement for this test.

Marcelo asked about kernbench with ept=0 on this series.  Using a 4-way,
10G guest with pinned vcpus, build in tmpfs, 10x optimal run, I got:

           before (stdev)    after (stdev)     %
--------+-----------------+----------------+-------
Elapsed |  42.809 (0.19)  |  42.305 (0.23) | -1.18
User    | 115.709 (0.22)  | 114.720 (0.31) | -0.85
System  |  41.605 (0.14)  |  40.924 (0.20) | -1.64
%cpu    |   366.9 (1.45)  |   367.6 (1.51) |  0.19
context |  7272.3 (68.6)  |  7249.5 (97.8) | -0.31
sleeps  | 14826.2 (110.6) | 14798.5 (63.0) | -0.19

So, a small but measurable gain.  Also, sorry for forgetting to address
Marcelo's comments from the original version of patch 2/3, I'll pick
them up in the next round.  Thanks,

Alex

