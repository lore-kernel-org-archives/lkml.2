Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1AFVnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:43:06 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:35653 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751935Ab1AFVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:43:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JhUYe1EVM1mvIuvv8docx9rTqGDX32FnJXYNpJcBwoeHNKh
 lJMJ.ZsUHeZ05GjtDcKLvSKWan3kMYxVAtr.pT49U3NxAg0hQjCFb0YFHDWl
 j8Nnp4kkTnqDTYq.wKscU9BjBAVpmiZjUDE02w2q9FVzm6KFLKWqs9awCbBq
 WmkNgQhyPxX0qVYRf0yMslr_UibymDKRXEqt62AivpNCUGthxSJv0Mxzl.kG
 LxzkJGxdMlaoL93eUOYw9LGMW_AQACkUlg5Mrk4dxHxup2XwOg32pwNweRC5
 3LpCC.DvbXvGBCuOj554K0opMHXuLoJpOD2LgmTrclVtDijc-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 6 Jan 2011 15:43:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110106210846.GA3528@Krystal>
Message-ID: <alpine.DEB.2.00.1101061532080.13376@router.home>
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <20110106210846.GA3528@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Mathieu Desnoyers wrote:

> * Christoph Lameter (cl@linux.com) wrote:
> [...]
> > + * cmpxchg_double replaces two adjacent scalars at once. The first two
> > + * parameters are per cpu variables which have to be of the same size.
> > + * A truth value is returned to indicate success or
> > + * failure (since a double register result is difficult to handle).
> > + * There is very limited hardware support for these operations. So only certain
> > + * sizes may work.
>
> What's the issue with returning the value read by cmpxchg_double in addition to
> the boolean ? "returning" it per se might be an issue, but you could add 2 more
> parameters to the macros that take the addresses of these outputs. Returning the
> values read by cmpxchg instead of just the boolean result helps removing the
> extra reads from cmpxchg loops, which is why I think it's a shame to just return
> the boolean result.
>
> Thoughts ?

In the use cases so far the cmpxchg_double is usually successful. If
cmpxchg_double succeeds then we know what was in those memory locations
before the operation.

Returning the data is only interesting for the case where the
cmpxchg_double fails. We'd be optimizing for a very rare case.

cmpxchg_double is here not used for locking (where the mismatching value
is of importance in the failure case and where we spin frequently) but
for other types of serialization like the transactions id here. Note that
this matches *two* types of information. Each mismatch on its own would
require specific handling if we want to consider operating on the
mismatched values.

this_cpu_cmpxchg also includes the relocation relative to the current per
cpu area which is a third data item to keep in mind. A failure may be due
to having been rescheduled to another cpu. Sorting all of that out is not
worth it IMHO.

