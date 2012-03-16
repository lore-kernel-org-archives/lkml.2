Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab2CPGss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:48:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41634 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab2CPGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:48:46 -0400
Date: Fri, 16 Mar 2012 15:55:11 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F62C9B4.7060804@linux.vnet.ibm.com>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62C9B4.7060804@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 13:03:48 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> For my quickly review, mmu_lock can not protect everything, if the guest page

Yes and ...

> is written out of the shadow page/ept table, dirty page will be lost.

No.

> 
> There is a example:
> 
>              CPU A                                   CPU  B
> guest page is written by write-emulation
> 
>                                                   hold mmu-lock and see dirty-bitmap
>                                                   is not be changed, then migration is
>                                                   completed.

We do not allow this break.

> 
> call mark_page_dirty() to set dirty_bit map
> 
> 
> Right?


As you pointed out, we cannot assume mutual exclusion by mmu_lock.
That is why we are using atomic bitmap operations: xchg and set_bit.

In this sense we are at least guaranteed to get the dirty page
information in dirty_bitmap - the current one or next one.

So what we should care about is to not miss the information written in
the next bitmap at the time we actually migrate the guest.

Actually the userspace stops the guest at the final stage and then send the
remaining pages found in the bitmap.  So the above break between write and
mark_page_dirty() cannot happen IIUC.


Thanks,
	Takuya
