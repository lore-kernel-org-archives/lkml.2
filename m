Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab1IOPrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:47:55 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:39679 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934097Ab1IOPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:47:53 -0400
Date: Thu, 15 Sep 2011 10:47:48 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
 <20110915145556.GA19902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915145556.GA19902@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Christoph,

On Thu, Sep 15, 2011 at 10:55:57AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> > I've got a workload that is latency sensitive that writes data to a
> > memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> > up to 100ms that occur during writeback that we did not see with older
> > kernels.  I've traced the stalls and it looks like they are blocking
> > on wait_on_page_writeback() introduced in
> > d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> > should wait for writeback to finish"
> > 
> > Reading the commit description doesn't really explain to me why this
> > change was needed.
> 
> It it there to avoid pages beeing modified while they are under
> writeback, which defeats various checksumming like DIF/DIX, the iscsi
> CRCs, or even just the RAID parity calculations.  All of these either
> failed before, or had to work around it by copying all data was
> written.

I'm assuming you mean software RAID here?  We do have a hardware RAID
controller.  Also for anything that was working around this issue
before by copying the data, are those workarounds still in place?

> If you don't use any of these you can remove the call and things
> will work like they did before.

I may do this for now.

In the longer term is there any chance this could be made better?  I'm
not an expert here so my suggestions may be naive.  Could a mechanism
be made to check if the page needs to be checksummed and only block in
that case?  Or perhaps some mount option, madvise() flag or other hint
from user-mode to disable this, or hint that I'm going to be touching
that page again soon?

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

