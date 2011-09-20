Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1ITSmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:42:15 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42301 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab1ITSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:42:13 -0400
Date: Tue, 20 Sep 2011 13:42:08 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110920184208.GB2119@BohrerMBP.rgmadvisors.com>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
 <20110915145556.GA19902@infradead.org>
 <20110915154748.GC2235@BohrerMBP.rgmadvisors.com>
 <20110916002557.GN11984@tux1.beaverton.ibm.com>
 <20110916163232.GA2109@BohrerMBP.rgmadvisors.com>
 <20110920163034.GB18914@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920163034.GB18914@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 12:30:34PM -0400, Christoph Hellwig wrote:
> On Fri, Sep 16, 2011 at 11:32:32AM -0500, Shawn Bohrer wrote:
> > So for the most part it sounds like this change is needed for DIF/DIX.
> > Could we only enable the wait_on_page_writeback() if
> > CONFIG_BLK_DEV_INTEGRITY is set?  Does it make sense to tie these
> > together?
> 
> It will also allow for huge efficiency gains on software raid.  There
> have been some Lustre patches for that.
> 
> > The other thread in this case is the [flush-8:0] daemon writing back
> > the pages.  So in our case you could see the spikes every time it wakes
> > up to write back dirty pages.  While we can control this to some
> > extent with vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs
> > it essentially impossible to ensure the writeback doesn't coincide
> > with us writing to the page again.
> 
> Can you explain how your use case looks in more details?  Right now

In one case we have an app that receives multicast data from a socket
and appends it to one of many memory mapped files.  Once it writes the
data to the end of the file it updates the header to record the new
size.  Since we update the header page frequently we are very likely
to encounter a stall here as the header page gets flushed in the
background.  We also have reader processes that check the file header
to find the new data since the last time they checked.  A stall in
updating the header means the readers do not get the latest data.

It is also possible that as we append the data to the file a partially
filled page at the end of the file could get flushed in the background
causing a stall since we append in chunks smaller than 4K.  This is
less likely though because we have tuned our
vm.dirty_writeback_centisecs and vm.dirty_expire_centisecs so that we
normally completely fill a page before the OS flushes it.

> for example a mlock removes the page from the lru list and thus stops
> VM writeback.  If such an interface would be useful for you we could
> offer an fadvice call that stops writeback entirely, and requires you
> to force it when you want it.

For the case I described above I'm not sure this would help because
we don't know the incoming rate of data so even if we force the sync
it could still cause a stall.

I do have a second application that is also suffering from these
stalls and I believe we could avoid the stalls by using fadvise to
disable writeback for a portion of the file and manually sync it
ourselves.  So this could potentially solve one of my problems.

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

