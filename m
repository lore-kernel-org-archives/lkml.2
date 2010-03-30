Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0C3KCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:02:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0C3KCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:02:20 -0400
Message-ID: <4BB15B1A.7090901@cn.fujitsu.com>
Date: Tue, 30 Mar 2010 09:59:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] KVM MMU: thinking of shadow page cache
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we cached shadow page tables, one guest page table may have
many shadow pages, take below case for example:

 (RO+U) ---> |------| __     |------|
 (W+U ) ---> |  GP1 |   |    |  GP2 |
 (W+P ) ---> |------|   |--> |------|

There have 3 kinds of permission mapping to GP1, so we should
allocate 3 shadow pages for GP1 and 3 shadow pages for GP2.
And it has 3 class permissions(R/W, U/S, X/NX) in x86's architecture,
for the worst case, we should allocate 2^3 pages for every paging
mapping level.

This waste is caused by that we only set the permission bits in PTE,
not in the middle mapping level.

So, i think we can mapping guest page table's permission into cache
shadow page table, then it can be shared between many shadow page tables
if their map to the same gust physics address. For above case, we only need 2
pages.

Any comments?
