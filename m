Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab2CSKJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:09:20 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36474 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab2CSKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:09:18 -0400
Date: Mon, 19 Mar 2012 19:15:44 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120319191544.55f7e276.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F66FDB9.1000306@linux.vnet.ibm.com>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62C9B4.7060804@linux.vnet.ibm.com>
	<20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62EC25.5060306@linux.vnet.ibm.com>
	<20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62F9C8.6090803@linux.vnet.ibm.com>
	<20120316184459.3c64c8cf.yoshikawa.takuya@oss.ntt.co.jp>
	<4F66FDB9.1000306@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 17:34:49 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> The current code is under the protection of s-rcu:
> IIRC, it always holds s-rcu when write guest page and set dirty bit,
> that mean the dirty page is logged either in the old dirty_bitmap or in the
> current memslot->dirty_bitmap. Yes?


Yes.

I just wanted to explain that getting clear dirty bitmap by GET_DIRTY_LOG
does not mean there is no dirty page: it just means that there was nothing
logged when we updated the bitmap in get_dirty_log().

We cannot know if anything happend between the bitmap update and result
check in the userspace.

So even when we get a clear bitmap, we need to stop the VCPU threads and
then do GET_DIRTY_LOG once more for live migration.


The important thing is that every bit set by mark_page_dirty() can be
found at some time in the future, including the final GET_DIRTY_LOG.

	Takuya
