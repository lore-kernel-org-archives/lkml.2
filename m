Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1FGXDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:03:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932640Ab1FGXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:03:30 -0400
Date: Tue, 7 Jun 2011 16:02:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/15] writeback: update dirtied_when for synced inode
 to prevent livelock
Message-Id: <20110607160245.9270aa27.akpm@linux-foundation.org>
In-Reply-To: <20110607213853.635444678@intel.com>
References: <20110607213236.634026193@intel.com>
	<20110607213853.635444678@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 05:32:38 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Explicitly update .dirtied_when on synced inodes, so that they are no
> longer considered for writeback in the next round.

It sounds like this somewhat answers my questions for [1/15].

But I'm not seeing a description of exactly what caused the livelock.

> We'll do more aggressive "keep writeback as long as we wrote something"
> logic in wb_writeback(). The "use LONG_MAX .nr_to_write" trick in commit
> b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") will
> no longer be enough to stop sync livelock.
> 
> It can prevent both of the following livelock schemes:
> 
> - while true; do echo data >> f; done
> - while true; do touch f;        done

You're kidding.  This livelocks sync(1)?  When did we break this?

Why is this?  Because the inode keeps on getting rotated to head-of-list?
