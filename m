Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab0FBVMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:12:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:46513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab0FBVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:12:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,348,1272870000"; 
   d="scan'208";a="626967884"
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <1275417720.27810.28160.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	 <1275136178.27810.13539.camel@twins> <1275139902.27810.13737.camel@twins>
	 <AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	 <1275412748.27810.27883.camel@twins>
	 <AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
	 <1275414172.27810.27961.camel@twins>
	 <AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
	 <1275417720.27810.28160.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 02 Jun 2010 14:11:14 -0700
Message-Id: <1275513074.2913.258.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 11:42 -0700, Peter Zijlstra wrote:
> On Tue, 2010-06-01 at 11:09 -0700, Venkatesh Pallipadi wrote:
> > On Tue, Jun 1, 2010 at 10:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, 2010-06-01 at 10:34 -0700, Venkatesh Pallipadi wrote:
> > >>
> > >> Yes. This will cover all the cases on insert. But on erase, there is
> > >> still a case where a rotate of sibling node is done during the
> > >> re-coloration process. There we have a child change on sibling's
> > >> child. I am not able to think of any easy way to handle that case.
> > >
> > > Let me go draw some figures with pen and paper to match up the erase
> > > path with the rb_augment_erase_begin() code, because I can't quite spot
> > > the case we're missing.
> > >
> > > If you have it handy, ascii art might help..
> > 
> > It is this case
> > 
> >     P
> >    / \
> >   N   S
> >      / \
> >     SL SR
> > 
> > changing to
> > 
> >     P
> >    / \
> >   N  SL
> >       \
> >        S
> >         \
> >         SR
> 
> Right, but see: http://en.wikipedia.org/wiki/Red-black_tree
> That is delete_case5, however then we fall into delete_case6 and perform
> a left rotation.
> 
> So suppose we start with the tree:
> 
>     P                  P               P                SL
>   /   \               / \             / \               / \
>  D     S      -->    N  S      -->   N   SL     -->    P   S
>   \   / \              / \                \           /     \
>    N SL  SR          SL* SR                S*        N      SR
>                                             \
>                                              SR
> 
> and then remove D, delete case 5 and finally delete case 6, * marks red.
> 
> rb_augment_erase_begin(D) will return N, and then rb_augment_path(N)
> will re-augment: N, P, SL and S.


      P                       SL
    /  \                     /  \
   N    S       --->        N    S
  /   /  \                 /      \
 C   SL  SR               C        SR

If P needs to be removed, we need to re-augment S also in this case,
right? It looks like we are not handling this case.

thanks,
suresh



