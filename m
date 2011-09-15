Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab1IOO4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:56:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54440
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756284Ab1IOO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:56:02 -0400
Date: Thu, 15 Sep 2011 10:55:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Stalls during writeback for mmaped I/O on XFS in 3.0
Message-ID: <20110915145556.GA19902@infradead.org>
References: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915144755.GB2235@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 09:47:55AM -0500, Shawn Bohrer wrote:
> I've got a workload that is latency sensitive that writes data to a
> memory mapped file on XFS.  With the 3.0 kernel I'm seeing stalls of
> up to 100ms that occur during writeback that we did not see with older
> kernels.  I've traced the stalls and it looks like they are blocking
> on wait_on_page_writeback() introduced in
> d76ee18a8551e33ad7dbd55cac38bc7b094f3abb "fs: block_page_mkwrite
> should wait for writeback to finish"
> 
> Reading the commit description doesn't really explain to me why this
> change was needed.

It it there to avoid pages beeing modified while they are under
writeback, which defeats various checksumming like DIF/DIX, the iscsi
CRCs, or even just the RAID parity calculations.  All of these either
failed before, or had to work around it by copying all data was
written.

If you don't use any of these you can remove the call and things
will work like they did before.

