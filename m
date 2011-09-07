Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1IGUQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:16:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55572
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab1IGUQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:16:34 -0400
Date: Wed, 7 Sep 2011 16:16:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, hch@infradead.org,
        Jeremy Fitzhardinge <jeremy@goop.org>, jbeulich@novell.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110907201620.GB26548@infradead.org>
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907181740.GG31726@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hmm, for some reason I never manage to receive Konrads mails directly,
 but only get the replies, or copies via the list]

On Wed, Sep 07, 2011 at 02:17:40PM -0400, Vivek Goyal wrote:
> On Wed, Sep 07, 2011 at 01:48:32PM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Christoph,
> > 
> > I was wondering what you think is the proper way of implementing a
> > backend to support the 'barrier' type requests? We have this issue were
> > there are 2.6.36 type guests that still use barriers and we would like
> > to support them properly. But in 3.0 there are no barriers - hence
> > the question whether WRITE_fLUSH_FUA would be equal to WRITE_BARRIER?
> 
> I think WRITE_FLUSH_FUA is not same as WRITE_BARRIER. Because it does
> not ensure request ordering. A request rq2 which is issued after rq1 (with
> WRITE_flush_FUA), can still finish before rq1. In the past WRITE_BARRIER
> would not allow that.
> 
> So AFAIK, WRITE_flush_fua is not WRITE_BARRIER.

Indeed.  And while most guests won't care some will.  E.g. reiserfs
which is the standard filesystem in most SuSE guests, which happen to
be fairly popular with Xen.

I'd suggest you look at the pre-2.6.36 barrier implementation and see
if you can move that into xen-blkfront.

For the qemu side doing this is a bit easier as you'll just have to wait
for all pending aio requests to complete.  The current qemu xen disk
code gets thus horribly wrong, though.

