Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2BPUrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:47:07 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37648 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755498Ab2BPUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:47:05 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vXqa9.kVM1keWznWlIe9TDW.DoA5RmNjC4051NRpCfXka5a
 mA81K588EvAaWs53bIemK.yqMtBxrj_VAY3koGut200f8QNoH9HzTCM8Hwkc
 8HOqqxazlahIal1R80AYKYmQdM4jSDS5E19prRl21DdhDCMP_EhDRrlxuTK5
 6rOKBrQ.2b.bEm12G.so7fqBu__nCpJaV3dIVh3vrK49twRo3_TX4zLXNq6v
 hsitNghmJA7OjxI2KASKzABG4WVQ_BIUYVa0fA8IaB85coXP3OYxteT3psgz
 AvUEKwcDfjPF8qjpVQbgUY4LixRhrvHWzOwvXPGzQXEznuAnBC8eKhDMPkpK
 tzMnt0GF1Ci7CJW4n_etAddz1YFPLCvArwFXp4eLr6WXeCpg75YIJIdY89Ua
 ppZ8gb8s1Nxyfhazye0HmHVqz4YP_nGvDB43J
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 16 Feb 2012 14:47:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <5716B9E7-4E65-42ED-B429-92B278BC1E56@gmail.com>
Message-ID: <alpine.DEB.2.00.1202161442320.26083@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home>
 <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <20120214124518.f42bc03e.akpm@linux-foundation.org>
 <CAOJsxLEdSr983jQ00_YuSWr3=pfmQHbebX87347K6v1HoCiyLw@mail.gmail.com> <alpine.DEB.2.00.1202141503470.29019@router.home> <59F64CB9-832E-4F7C-8A6C-E2CD18563795@gmail.com> <alpine.DEB.2.00.1202141605240.32407 @router.home> <07635976-4FC3-4E14-9B94-CE4D6446FD4E@gmail.com>
 <alpine.DEB.2.00.1202151324060.28225@router.home> <E307A48D-2146-4052-8A84-E7FA690A6703@gmail.com> <alpine.DEB.2.00.120216084532 0.25847@router.home> <5716B9E7-4E65-42ED-B429-92B278BC1E56@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Xi Wang wrote:

> > The use of a function or macro makes the overflow check much more
> > universal and allows these array allocations to occur with different
> > allocation functions throughout the kernel.
>
> No, it does NOT.  It can be easily misued to introduce more bugs.
>
> 1) Should calculate_array_size() return 0 on overflow, as you
>    orginally proposed?

I thought you worked that out?

> No, as Dan, Pekka, and some others already pointed out.
>
> 2) Should calculate_array_size() return something like
>    KMALLOC_MAX_SIZE + 1?
>
> No, because you intended to use it with other allocators such as
> vmalloc().

vmalloc will also fail if you pass a large number.

> 3) Should calculate_array_size() return ULONG_MAX/SIZE_MAX/-1?
>
> No!  Consider devres_alloc() you mentioned.  Then you do
>
> devres_alloc(..., calculate_array_size(n, size), ...).
>
> It internally invokes kmalloc() with allocation size:
>
> sizeof(struct devres) + calculate_array_size(n, size).

That is an addition which is less likely to overflow. Especially if you
return MAX_ORDER << PAGE_SIZE from the array size calculation.

It would be best to be universal if you want to introduce size overflow
checking rather than just dealing with one case and let the rest of the
kernel fend for themselves. I think we need something like
calculate_array_size() with proper error handling (and no I am not
particular set on having it done a particular way. Just that is it done).


