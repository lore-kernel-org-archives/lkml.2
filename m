Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1DUTDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:03:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6689 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1DUTDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:03:15 -0400
X-IronPort-AV: E=Sophos;i="4.64,252,1301889600"; 
   d="scan'208";a="145859482"
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
In-Reply-To: <20110421034016.GB11501@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
	 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
	 <20110421034016.GB11501@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 12:03:12 -0700
Message-ID: <1303412592.9571.126.camel@agari.van.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 23:40 -0400, Christoph Hellwig wrote:
> > +#define WRITE_BARRIER	(REQ_WRITE | REQ_FLUSH | REQ_FUA)
> 
> Any in case you want to keep usingthis POS out of tree you really need
> to fix this.  REQ_FLUSH | REQ_FUA is not equivalent to the old barrier
> semantics that the Xen disk protocol exported to the guest.  You need
> to drain the whole queue of outstanding I/Os as some old guest (at least
> those using reiserfs, e.g. old SLES) rely on it.

Yes, everybody is aware that the semantics were broken. But note it's
not even a consistency issue at this point, because there's currently no
frontend which relies on the original ordering semantics either. Take
xen-blkfront, since blk_flush it uses the barrier op for a flush, being
just a superset when ordering is enforced.

>From here on, there's two ways we can proceed: 

We can add the reorderable flush command you asked for a while ago.

But before we just enumerate a new command, a potentially more viable
option would be FLUSH+FUA flags on the WRITE operation. As if mapping
bio bits.

The advantage is that it avoids the extra round trip implied by having
the frontend driving writes through FSEQ_PREFLUSH on their own. I'd
expect that to make much more of a performance difference. Somewhat
differentiating PV from the low physical layer.

Would you, maybe did you, consider that? I think it sounds interesting
enough to gather performance data, just asking beforehand.

Blk-flush presently has no concept of _not_ sequencing the preflush, but
eventually adding a REQ_FLUSH_FUA bit to the queue settings doesn't look
like a big diff compared to what's currently going on.

Note that it'd only be a device option for backends to offer, or not.
Userspace backends will almost certainly prefer to start out with FLUSH,
maybe FUA, because it's stateless and just maps to fdatasync().

Best,
Daniel

