Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab0KPHlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:41:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:2075 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0KPHlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:41:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,204,1288594800"; 
   d="scan'208";a="574197739"
Date: Tue, 16 Nov 2010 16:13:37 +0800
From: Feng Tang <feng.tang@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Message-ID: <20101116161337.10733417@feng-i7>
In-Reply-To: <20101115112732.GA15953@infradead.org>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
	<20101115055420.GA21785@localhost>
	<20101115175943.490d3469@feng-i7>
	<20101115112732.GA15953@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hellwig,

On Mon, 15 Nov 2010 19:27:32 +0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Nov 15, 2010 at 05:59:43PM +0800, Feng Tang wrote:
> > + *
> > + * Sometimes when this get called, the host inode may be under data
> > + * syncing initiated by flush thread(especially for a large file),
> > and 
> > + * in such situation, we should skip this path of writeback
> >   */
> >  static int journal_submit_inode_data_buffers(struct address_space
> > *mapping) {
> > @@ -181,6 +185,13 @@ static int
> > journal_submit_inode_data_buffers(struct address_space
> > *mapping) .range_end = i_size_read(mapping->host), };
> >  
> > +	spin_lock(&inode_lock);
> > +	if (mapping->host->i_state & I_SYNC) {
> > +		spin_unlock(&inode_lock);
> > +		return 0;
> > +	}
> > +	spin_unlock(&inode_lock);
> > +
> 
> inode_lock is not exported to modules, and that's for a pretty good
> reason.  I think you want to change this code at a higher level to not
> compete with the flusher threads at all.
> 
Good point. The alternative I can think of is to use writeback_in_progress(),
thus the check will be changed to:

	if (writeback_in_progress(mapping->backing_dev_info))
		return 0;
This have the same effect as the original patch.


Thanks,
Feng
