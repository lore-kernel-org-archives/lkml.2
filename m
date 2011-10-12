Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1JLRbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 13:31:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24623 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1JLRbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:31:11 -0400
Date: Wed, 12 Oct 2011 13:21:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111012172130.GC1732@phenom.oracle.com>
References: <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
 <4E940E21020000780005AA29@nat28.tlf.novell.com>
 <20111011155133.GC29349@phenom.oracle.com>
 <20111011205729.GB22668@phenom.oracle.com>
 <1318416842.21903.674.camel@zakaz.uk.xensource.com>
 <20111012154549.GB1732@phenom.oracle.com>
 <1318436097.21903.762.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318436097.21903.762.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E95CED5.009D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >             if (operation != REQ_DISCARD)
> >               /* Check that the number of segments is sane. */
> >          	nseg = req->nr_segments;
> > 	    else
> > 		nseg = 0;
> 
> Right above this hunk is a switch statement over the req->operation. The
> value of req->operation precisely defines the semantics/validity or
> otherwise of the req->nr_segments field and whether or not it contains
> the nr of segments or (due to the aliasing) something else. Why not set
> nsegs inside that switch statement (and explicitly zero it in the other
> cases) so that this obvious connection is retained?

Sure.
> 
> > > >         if (unlikely(nseg == 0 && operation != WRITE_FLUSH &&
> > > >                                 operation != REQ_DISCARD) ||
> > 
> > And I guess we can also skip the REQ_DISCARD test here.
> 
> I don't think so, if nseg == 0 and operation == REQ_DISCARD that is
> fine, right? The fact that there is all this "operation != xx &&

<nods>

..snip..
> (I think I'm right that BLKIF_OP_FLUSH_DISKCACHE can have associated
> data or not)

You are right.
> 
> However do discard and r/w really have so much in common that handling
> them all in dispatch_rw_block_io() and relying on nsegs == 0 when the
> operation is discard makes sense?
> 
> Would it be clearer if the caller (__do_block_io_op) had this switch
> over req->operation and called dispatch_rw_block_io(req, WRITE_FLUSH,
> nsegs), dispatch_discard(req) etc as appropriate?

Potentially. It would cut down on this functions bloated size so that
is a definite plus.
