Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2JVNTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:19:55 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2493 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2JVNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:19:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,629,1344211200"; 
   d="scan'208";a="15309717"
Date: Mon, 22 Oct 2012 14:19:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
In-Reply-To: <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-10-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com> <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Yinghai Lu wrote:
> On Fri, Oct 19, 2012 at 9:24 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > On Thu, 18 Oct 2012, Yinghai Lu wrote:
> >> Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
> >> then use mapped pages to map more range below, and keep looping until
> >> all pages get mapped.
> >>
> >> alloc_low_page will use page from BRK at first, after that buff is used up,
> >> will use memblock to find and reserve page for page table usage.
> >>
> >> At last we could get rid of calculation and find early pgt related code.
> >>
> >> -v2: update to after fix_xen change,
> >>      also use MACRO for initial pgt_buf size and add comments with it.
> >> -v3: skip big reserved range in memblock.reserved near end.
> >> -v4: don't need fix_xen change now.
> >>
> >> Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > The series is starting to get in good shape!
> > I tested it on a 2G and an 8G VM and it seems to be working fine.
> 
> domU on 32bit and 64bit?

domU 64bit


> > The most important thing to do now is testing it on different machines
> > (with and without xen) and writing better commit messages.
> > We can help you with the testing but you really need to write better
> > docs.
> 
> I tested on native one on 32bit, and 64bit.
> 
> Also xen dom0 32bit and 64bit.

Good, thanks!


> Changelog is always problem now. Looks like everyone is complaining about that.
> 
> Actually I already tried my best on that, really don't know what to do next.
> 
> >
> > In particular you should state in clear letters that alloc_low_page is
> > always going to return a page that is already mapped. You should write
> > it both in the commit message and in the code as a comment.
> > This is particularly important because it is going to become part of the
> > interface between the common x86 code and the other x86 subsystems like
> > Xen.
> 
> alloc_low_page() is used in arch/x86/mm/init*.c. How come it becomes
> interface to
> other subsystem?

I chose the wrong words.

I meant that always allocating pages from areas that are already mapped,
will become an assumption for other x86 subsystems like Xen.
One shouldn't just go ahead and change this assumption without changing
the subsystems too.


> I'm not sure if we really need that comment in code for that:
> ---
> the page that alloc_low_page return is directed mapped already, could
> use virtual address
> to access it.
> ---

I just want to make sure that 3 years from now, when somebody comes up
with a new great idea to improve the intial pagetable allocation, he
doesn't forget that changing alloc_low_page might break other subsystems.

So I think that a comment is required here and should explicitly
mention why it is important that alloc_low_page returns a mapped page.


> > Also, it wouldn't hurt to explain the overall design at the beginning of
> > the series: I shouldn't have to read your code to understand what you
> > are doing. I should read the description of the patch, understand what
> > you are doing, then go and check if the code actually does what you say
> > it does.
> 
> Actually I really don't like to read too long change log in commit.
> Changelog should be concise and precise.
> code change is more straightforward to me.

Many people don't think like that.
Of course you shouldn't document line by line changes in the commit
message but you should include a full explanation of your changes, like
I wrote before.
