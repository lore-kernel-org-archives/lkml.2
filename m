Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0KOL1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:27:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0KOL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:27:34 -0500
Date: Mon, 15 Nov 2010 06:27:32 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Feng Tang <feng.tang@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Message-ID: <20101115112732.GA15953@infradead.org>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
 <20101115055420.GA21785@localhost>
 <20101115175943.490d3469@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115175943.490d3469@feng-i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 05:59:43PM +0800, Feng Tang wrote:
> + *
> + * Sometimes when this get called, the host inode may be under data
> + * syncing initiated by flush thread(especially for a large file), and 
> + * in such situation, we should skip this path of writeback
>   */
>  static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  {
> @@ -181,6 +185,13 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
>  		.range_end = i_size_read(mapping->host),
>  	};
>  
> +	spin_lock(&inode_lock);
> +	if (mapping->host->i_state & I_SYNC) {
> +		spin_unlock(&inode_lock);
> +		return 0;
> +	}
> +	spin_unlock(&inode_lock);
> +

inode_lock is not exported to modules, and that's for a pretty good
reason.  I think you want to change this code at a higher level to not
compete with the flusher threads at all.

