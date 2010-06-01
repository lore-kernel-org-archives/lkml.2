Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab0FASmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:42:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51959 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0FASmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:42:02 -0400
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	 <1275136178.27810.13539.camel@twins> <1275139902.27810.13737.camel@twins>
	 <AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	 <1275412748.27810.27883.camel@twins>
	 <AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
	 <1275414172.27810.27961.camel@twins>
	 <AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 20:42:00 +0200
Message-ID: <1275417720.27810.28160.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 11:09 -0700, Venkatesh Pallipadi wrote:
> On Tue, Jun 1, 2010 at 10:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-06-01 at 10:34 -0700, Venkatesh Pallipadi wrote:
> >>
> >> Yes. This will cover all the cases on insert. But on erase, there is
> >> still a case where a rotate of sibling node is done during the
> >> re-coloration process. There we have a child change on sibling's
> >> child. I am not able to think of any easy way to handle that case.
> >
> > Let me go draw some figures with pen and paper to match up the erase
> > path with the rb_augment_erase_begin() code, because I can't quite spot
> > the case we're missing.
> >
> > If you have it handy, ascii art might help..
> 
> It is this case
> 
>     P
>    / \
>   N   S
>      / \
>     SL SR
> 
> changing to
> 
>     P
>    / \
>   N  SL
>       \
>        S
>         \
>         SR

Right, but see: http://en.wikipedia.org/wiki/Red-black_tree
That is delete_case5, however then we fall into delete_case6 and perform
a left rotation.

So suppose we start with the tree:

    P                  P               P                SL
  /   \               / \             / \               / \
 D     S      -->    N  S      -->   N   SL     -->    P   S
  \   / \              / \                \           /     \
   N SL  SR          SL* SR                S*        N      SR
                                            \
                                             SR

and then remove D, delete case 5 and finally delete case 6, * marks red.

rb_augment_erase_begin(D) will return N, and then rb_augment_path(N)
will re-augment: N, P, SL and S.


