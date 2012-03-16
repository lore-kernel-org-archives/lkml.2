Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab2CPJii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:38:38 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49092 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576Ab2CPJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:38:36 -0400
Date: Fri, 16 Mar 2012 18:44:59 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120316184459.3c64c8cf.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F62F9C8.6090803@linux.vnet.ibm.com>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62C9B4.7060804@linux.vnet.ibm.com>
	<20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62EC25.5060306@linux.vnet.ibm.com>
	<20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62F9C8.6090803@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 16:28:56 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Thanks for your explanation, maybe you are right, i do not know migration
> much.
> 
> What i worried about is, you have changed the behaviour of GET_DIRTY_LOG,
> in the current one, it can get all the dirty pages when it is called; after
> your change, GET_DIRTY_LOG can get a empty dirty bitmap but dirty page exists.

The current code also see the same situation because nothing prevents the
guest from writing to pages before GET_DIRTY_LOG returns and the userspace
checks the bitmap.  Everything is running.

> Migration may work correctly depends on the final GET_DIRTY_LOG, in that time,
> guest is stopped. But i am not sure whether other components using GET_DIRTY_LOG
> are happy, e.g. frame-buffer.

Ah, you are probably worrying about what I discussed with Avi before.

In the end we cannot get a complete snapshot without stopping the guest
like migration does.  So that cannot be guaranteed.

The only thing it can promise is to make it possible to get the log after
mark_page_dirty().  Even when the bit is not marked at Nth GET_DIRTY_LOG
time, we should be able to get it at (N+1)th call - maybe N+2.

For VGA, the display continues to update endlessly and each page will be
updated at some time: of course there may be a bit of time lag.

BTW marking framebuffer pages is through MMU and mmu_lock protected.


Thanks,
	Takuya
