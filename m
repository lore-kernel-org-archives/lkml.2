Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2A3Rw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:52:29 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46148 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752234Ab2A3Rw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:52:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mN6JRv4VM1lBNT4PIIuSkqYUxRNQHwBuUYFPednVW6_sC_i
 b.Swqo.65xYBG06QQbpBF4EWJgMS80BkhWtmry4BcHzk4lKi7OOUn9xGQM8T
 MZKMGhwtji.qo0KKoHxYIYyp2125wCzFjNAXYqdomJU9XyIPmnVYCqa5ID6y
 iiktbLuGPOs5oKA6dZtLHnQEr4NefahC.BNDsfUN5_37viAm.N989LhzPN2E
 cU7_wNLzcz72cw5M8UgsOA5NiW7JL.NTRSkGIt.dC3YskebfKrCHL2fcIjkR
 aRx.5_tCiPPObEZP98PdrJszQLKtq8fZaUNPDqIWozBAWn5UIXABZxU.f._l
 eCSOF5ODvSyScE0LyNgAaYGWP3dJURJX2m9u75m76ez2vGG39cTgKvJnru4X
 aRoVYU3T.2Odoh3.x3yoTzo20shTll4fbXY.y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 11:52:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130174256.GF3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301145570.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <alpine.DEB.2.00.1201301121330.28693@router.home> <20120130174256.GF3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> On Mon, Jan 30, 2012 at 11:22:14AM -0600, Christoph Lameter wrote:
> > On Mon, 30 Jan 2012, Tejun Heo wrote:
> >
> > > Percpu pointers are in a different address space and using
> > > ZERO_SIZE_PTR directly will trigger sparse address space warning.
> > > Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> > > percpu address space (maybe it is but I don't think we have anything
> > > enforcing that).
> >
> > We are already checking for NULL on free. So there is a presumption that
> > these numbers are unused.
>
> Yes, we probably don't use 16 as valid dynamic address because static
> area would be larger than that.  It's just fuzzier than NULL.  And, as
> I wrote in another reply, ZERO_SIZE_PTR simply doesn't contribute
> anything.  Maybe we can update the allocator to always not use the
> lowest 4k for either static or dynamic and add debug code to
> translation macros to check for percpu addresses < 4k, but without
> such changes ZERO_SIZE_PTR simply doesn't do anything.

We have two possibilities now:

1. We say that the value returned from the per cpu allocator is an opaque
value.

	This means that we have to remove the NULL check from the free
	function. And audit the kernel code for all occurrences where
	a per cpu pointer value of NULL is assumed to mean that no per
	cpu allocation has occurred.

2. We say that there are special values for the per cpu pointers (NULL,
	ZERO_SIZE_PTR)

	Then we would have to guarantee that the per cpu allocator never
	returns those values.

	Plus then the ZERO_SIZE_PTR patch will be fine.

	The danger exist of these values being passed as
	parameters to functions that do not support them (per_cpu_ptr
	etc). Those would need VM_BUG_ONs or some other checks to detect
	potential problems.


