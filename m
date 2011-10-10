Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1JJQnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:43:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31777 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1JJQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:43:18 -0400
Date: Mon, 10 Oct 2011 12:42:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
Message-ID: <20111010164250.GG28646@phenom.oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318263187.21903.464.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090206.4E93209E.02B7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 05:13:07PM +0100, Ian Campbell wrote:
> On Mon, 2011-10-10 at 16:28 +0100, Konrad Rzeszutek Wilk wrote:
> > diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
> > index 9324488..04f60b0 100644
> > --- a/include/xen/interface/io/blkif.h
> > +++ b/include/xen/interface/io/blkif.h
> > @@ -84,6 +84,10 @@ typedef uint64_t blkif_sector_t;
> >   *     e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc
> >   * http://www.seagate.com/staticfiles/support/disc/manuals/
> >   *     Interface%20manuals/100293068c.pdf
> > + * We also provide three extra XenBus options to the discard operation:
> > + * 'discard-granularity' - Max amount of sectors that can be discarded.
> > + * 'discard-alignment' - 4K, 128K, etc aligment on sectors to erased.
> > + * 'discard-secure' - whether the discard can also securely erase data.
> >   */
> >  #define BLKIF_OP_DISCARD           5
> >  
> > @@ -107,6 +111,7 @@ struct blkif_request_rw {
> >  struct blkif_request_discard {
> >         blkif_sector_t sector_number;
> >         uint64_t nr_sectors;
> > +       uint8_t secure:1;
> >  };
> >  
> >  struct blkif_request { 
> 
> Which tree/branch is this? I don't see BLKIF_OP_DISCARD in mainline or
> your linux-next branch.

Uh, that is not good. I must have forgotten to merge it in - that is the
#stable/for-jens-3.2 branch.

Let me do that right now.
> 
> Since this changes an inter-guest ABI we may need to consider backwards
> compatibility (I suspect this interface is new enough that no one has
> actually implemented it in anger and we can get away with changing it).

<nods>
> In any case it should also be posted against the canonical inter-guest
> interface definition in the xen tree for review with that in mind.

Yes! But I was thinking to first let this one rattle a bit and see what
folks thought about it before submitting the xen-devel.
> 
> I think an explicit flag variable is likely to be less trouble WRT
> maintaining compatibility in the future than a bit-field. Also I think
> you may as well align the struct size to something larger than a byte,
> either 4 or 8 bytes would make sense.

Ok. Will change it and make it an uint64_t secure_flag
variable. Later on if there are any "other" flags we can chop it down.
