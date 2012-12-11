Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2LKOj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:39:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab2LKOj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:39:27 -0500
Date: Tue, 11 Dec 2012 09:29:42 -0500
From: Dave Jones <davej@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: livelock in __writeback_inodes_wb ?
Message-ID: <20121211142942.GA1943@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org
References: <20121128145515.GA26564@redhat.com>
 <20121211082327.GA15706@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211082327.GA15706@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 04:23:27PM +0800, Fengguang Wu wrote:
 > On Wed, Nov 28, 2012 at 09:55:15AM -0500, Dave Jones wrote:
 > > We had a user report the soft lockup detector kicked after 22
 > > seconds of no progress, with this trace..
 > 
 > Where is the original report? The reporter may help provide some clues
 > on the workload that triggered the bug.

https://bugzilla.redhat.com/show_bug.cgi?id=880949 

 > The bug reporter should know best whether there are heavy IO.
 > 
 > However I suspect it's not directly caused by heavy IO: we will
 > release &wb->list_lock before each __writeback_single_inode() call,
 > which starts writeback IO for each inode.
 > 
 > > Should there be something in this loop periodically poking
 > > the watchdog perhaps ?
 > 
 > It seems we failed to release &wb->list_lock in wb_writeback() for
 > long time (dozens of seconds). That is, the inode_sleep_on_writeback()
 > is somehow not called. However it's not obvious to me how come this
 > can happen..

Right, it seems that we only drop the lock when there is more work to do.
And if there is no work to do, then we would have bailed from the loop.

mysterious.

	Dave

