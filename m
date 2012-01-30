Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2A3SMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:12:22 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:23612 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752235Ab2A3SMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:12:21 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fTZl3lYVM1m3QLWm1CPsjTckg3c8J.51LXPpUAOySvenG9u
 PYNiNOZoo_i4dS0ic3TKx5fIkwpFZIO9iSGNBipk11UMTwnvYFmVv.W_pRdA
 5uth5DHxc8Kvj6eWP3qTwwkwdWY.D8DkdAarrF2flbhFvh2ZNingbuHqGc7e
 dshicIBzijQ6H4ZBTMgDS0qXaqQfy8GZPlA6eCkRHsiQSBCLvyx9SQ2j9DKM
 YSzVDMgxQW4nHlhO2.LCZT_VacBpFMx2xY5hQ1Tl7KweVuFP_17mps9b9cB3
 tmn5nfg68ZLHAEe8PzCrROAxJsLPCPSduo_zGlj6X5oUTv95fNElTN4kPbgt
 omgKhjpIV7ZdMLB0NM_hBtyKZgeuxcXzYLLRSDa_Kmbt9_gzSmKB7r3xSxsR
 N
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 12:12:18 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130180224.GH3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301206080.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <alpine.DEB.2.00.1201301121330.28693@router.home> <20120130174256.GF3355@google.com> <alpine.DEB.2.00.1201301145570.28693@router.home>
 <20120130175434.GG3355@google.com> <alpine.DEB.2.00.1201301156530.28693@router.home> <20120130180224.GH3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> Hello,
>
> On Mon, Jan 30, 2012 at 11:58:52AM -0600, Christoph Lameter wrote:
> > > No, NULL is never gonna be a valid return from any allocator including
> > > percpu.  Percpu allocator doesn't and will never do so.
> >
> > How do you prevent the percpu allocator from returning NULL? I thought the
> > per cpu offsets can wrap around?
>
> I thought it didn't.  I rememer thinking about this and determining
> that NULL can't be allocated for dynamic addresses.  Maybe I'm
> imagining things.  Anyways, if it can return NULL for valid
> allocation, it is a bug and should be fixed.

I dont see anything that would hinder an arbitrary value to be returned.
NULL is also used for the failure case. Definitely a bug.

> > > I'm saying we don't have this for ZERO_SIZE_PTR in any meaningful way
> > > at this point.  If somebody wants to implement it properly, please
> > > feel free to, but simply applying ZERO_SIZE_PTR without other changes
> > > doesn't make any sense.
> >
> > We have no clean notion of how a percpu pointer needs to be handled. Both
> > ways of handling things have drawbacks.
>
> We don't have returned addr >= PAGE_SIZE guarantee yet but I'm fairly
> sure that's the only acceptable direction if we want any improvement
> in this area.

The ZERO_SIZE_PTR patch would not make the situation that much worse.

If the per cpu allocator happens to return NULL for a valid allocation
then this allocation cannot be freed anymore since the free function
checks for NULL. Most callers check the result for NULL though and will
fail in other ways at a higher level. Such an allocation can only happen
once and from hen on some memory is wasted.

If the per cpu allocator just happens to return ZERO_SIZE_PTR for a valid
allocation then this value is going to be passed to other per cpu
functions. However, the size is 0 so no actual read or write should ever
take place.

On free its not going to be freed since the free function checks for
ZERO_SIZE_PTR. So we have a situation almost the same as for NULL pointer.
