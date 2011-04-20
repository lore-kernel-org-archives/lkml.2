Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1DTPWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:22:11 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:24298 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753931Ab1DTPWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:22:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: uEAmpKYVM1m4cbtGmMfVXGigaTgGU9Xa4IhPgxXiKvHamXM
 q7KcVzb8XMicqrEjMqxptLTsbr7Gzhkn1v8BaGXjcsXToz1WSgBMd5onfLVX
 cv.kQYENY0awKfJAm7iLp7NicQ4Bl4ialUz6KXW5qkInJ489eroHbzABZSoE
 fCvfCpfq5iK7LdYyAXA3C8VVXoPCxWSpDFNOjqchcN77IV3fjEk12.zO5uw3
 vqAStBJUp4D3Xolgmf0jR6AFKqtIhainkHArx225S.Up.ZfLycPkgVOGgjxr
 k9ZXtRzHnvqRRe8Olhzby4l7XMq52yIeAeYeDOKWLky9FoZzL
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Apr 2011 10:22:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>, linux-arch@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303311779.2587.19.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104201018360.9266@router.home>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com>  <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>  <20110420161615.462D.A69D9226@jp.fujitsu.com>  <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>  <20110420112020.GA31296@parisc-linux.org> 
 <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com>  <1303308938.2587.8.camel@mulgrave.site>  <alpine.DEB.2.00.1104200943580.9266@router.home> <1303311779.2587.19.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, James Bottomley wrote:

> > The older code may work. SLAB f.e. does not call page_to_nid() in the
> > !NUMA case but keeps special metadata structures around in each slab page
> > that records the node used for allocation. The problem is with new code
> > added/revised in the last 5 years or so that uses page_to_nid() and
> > allocates only a single structure for !NUMA. There are also VM_BUG_ONs in
> > the page allocator that should trigger if page_to_nid() returns strange
> > values. I wonder why that never occurred.
>
> Actually, I think slab got changed when discontigmem was added ...
> that's why it all works OK.

Could be. I was not around at the time.

> > >      3. Finally we could look at deprecating DISCONTIGMEM in favour
> > of >         SPARSEMEM, but we'd still need to fix -stable for that case.
> > >         Especially as it will take time to convert all the architectures
> >
> > The fix needed is to mark DISCONTIGMEM without NUMA as broken for now. We
> > need an audit of the core VM before removing that or making it contingent
> > on the configurations of various VM subsystems.
>
> Don't be stupid ... that would cause six architectures to get marked
> broken.

Yes they are broken right now. Marking just means showing the user that we
are aware of the situation.

> Look, I'm not really interested in who understands what.  The fact is we
> have six architectures with the possibility for DISCONTIGMEM && !NUMA,
> so that's the case we need to fix in -stable.
>
> They oops with SLUB, as far as I can tell, there are still no oops
> reports with SLAB.  The simplest -stable fix seems to be to mark SLUB
> broken on DISCONTIGMEM && !NUMA.

There is barely any testing going on at all of this since we have had this
issue for more than 5 years and have not noticed it. The absence of bug
reports therefore proves nothing. Code inspection of the VM shows
that this is an issue that arises in multiple subsystems and that we have
VM_BUG_ONs in the page allocator that should trigger for these situations.

Usage of DISCONTIGMEM and !NUMA is not safe and should be flagged as such.

