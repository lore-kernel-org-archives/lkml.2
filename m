Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2BIR66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:58:58 -0500
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:40571 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757566Ab2BIR64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:58:56 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1202081446110.1320@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
 <alpine.LSU.2.00.1201271458130.3402@eggly.anvils> <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA@mail.gmail.com>
 <alpine.LSU.2.00.1201301217530.4505@eggly.anvils> <CAL1RGDVSBb1DVsfvuz=ijRZX06crsqQfKoXWJ+6FO4xi3aYyTg@mail.gmail.com>
 <alpine.LSU.2.00.1202071225250.2024@eggly.anvils> <alpine.LSU.2.00.1202081446110.1320@eggly.anvils>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 9 Feb 2012 09:50:49 -0800
X-Google-Sender-Auth: T_9Pbiu_QJ_NsqEUIbnmkwEi29M
Message-ID: <CAL1RGDWZ2LYO7ejPs9FvDzqze43cbfUEEdQVB=Ug2n3JpEe=AQ@mail.gmail.com>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages() parameters
To: Hugh Dickins <hughd@google.com>
Cc: linux-rdma@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 8, 2012 at 3:10 PM, Hugh Dickins <hughd@google.com> wrote:
> A doubt assaulted me overnight: sorry, I'm back to not understanding.
>
> What are these access flags passed into ibv_reg_mr() that are enforced?
> What relation do they bear to what you will pass to __get_user_pages()?

The access flags are:

enum ibv_access_flags {
        IBV_ACCESS_LOCAL_WRITE          = 1,
        IBV_ACCESS_REMOTE_WRITE         = (1<<1),
        IBV_ACCESS_REMOTE_READ          = (1<<2),
        IBV_ACCESS_REMOTE_ATOMIC        = (1<<3),
        IBV_ACCESS_MW_BIND              = (1<<4)
};

pretty much the only one of interest is IBV_ACCESS_REMOTE_READ --
all the others imply the possibility of RDMA HW writing to the page.

So basically if any flags other than IBV_ACCESS_REMOTE_READ are
set, we pass FOLL_WRITE to __get_user_pages(), otherwise we pass
the new FOLL_FOLLOW.  [does "Marcia, Marcia, Marcia" mean anything
to a Brit? ;)]

ie the change from the status quo would be:

[read-only]  write=1, force=1 --> FOLL_FOLLOW
[writeable]  wrote=1, force=0 --> FOLL_WRITE (equivalent)

> You are asking for a FOLL_FOLLOW ("follow permissions of the vma") flag,
> which automatically works for read-write access to a VM_READ|VM_WRITE vma,
> but read-only access to a VM_READ-only vma, without you having to know
> which permission applies to which range of memory in the area specified.

> But you don't need that new flag to set up read-only access, and if you
> use that new flag to set up read-write access to an area which happens to
> contain VM_READ-only ranges, you have set it up to write into ZERO_PAGEs.

First of all, I kind of like FOLL_FOLLOW as the name :)

Now you're confusing me: I think we do need FOLL_FOLLOW to
set up read-only access -- we want to trigger the COWs that userspace
might trigger by touching the memory up front.  This is to handle
a case like

    [userspace]
    int *buf = malloc(16 * 4096);
    // buf now points to 16 anonymous zero_pages
    mr = ibv_reg_mr(pd, buf, 16 * 4096, IBV_ACCESS_REMOTE_READ);
    // RDMA HW will only ever read buf, but...
    buf[0] = 2012;
    // COW triggered, first page of buf changed, RDMA HW has wrong mapping!

For something the RDMA HW might write to, then I agree we don't want
FOLL_FOLLOW -- we just would use FOLL_WRITE as we currently do.

When I get around to coding this up, I think I'm going to spend a lot
of time on the comments and on the commit log :)

 - R.
