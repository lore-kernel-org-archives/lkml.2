Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2DMWxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:53:43 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28229 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab2DMWxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:53:42 -0400
Date: Sat, 14 Apr 2012 00:53:40 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
In-Reply-To: <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1204140052450.13233@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net> <alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net> <CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com> <alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
 <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1886282438-1334357620=:13233"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1886282438-1334357620=:13233
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Apr 2012, Kasatkin, Dmitry wrote:

> On Thu, Apr 12, 2012 at 1:31 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Tue, 13 Mar 2012, Kasatkin, Dmitry wrote:
> >
> >> On Thu, Mar 1, 2012 at 11:33 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >> >
> >> > Ping?
> >> >
> >> > On Mon, 6 Feb 2012, Jesper Juhl wrote:
> >> >
> >> >> At the start of the function we assign 'a->d' to 'ap'. Then we use the
> >> >> RESIZE_IF_NEEDED macro on 'a' - this may free 'a->d' and replace it
> >> >> with newly allocaetd storage. In that case, we'll be operating on
> >> >> freed memory further down in the function when we index into 'ap[]'.
> >> >> Since we don't actually need 'ap' until after the use of the
> >> >> RESIZE_IF_NEEDED macro we can just delay the assignment to it until
> >> >> after we've potentially resized, thus avoiding the issue.
> >> >>
> >> >> While I was there anyway I also changed the integer variable 'n' to be
> >> >> const. It might as well be since we only assign to it once and use it
> >> >> as a constant, and then the compiler will tell us if we ever assign to
> >> >> it in the future.
> >> >>
> >> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >> >> ---
> >> >>  lib/mpi/mpi-bit.c |    5 +++--
> >> >>  1 files changed, 3 insertions(+), 2 deletions(-)
> >> >>
> >> >>  only compile tested.
> >> >>
> >> >> diff --git a/lib/mpi/mpi-bit.c b/lib/mpi/mpi-bit.c
> >> >> index 2f52662..0c50536 100644
> >> >> --- a/lib/mpi/mpi-bit.c
> >> >> +++ b/lib/mpi/mpi-bit.c
> >> >> @@ -177,8 +177,8 @@ int mpi_rshift(MPI x, MPI a, unsigned n)
> >> >>   */
> >> >>  int mpi_lshift_limbs(MPI a, unsigned int count)
> >> >>  {
> >> >> -     mpi_ptr_t ap = a->d;
> >> >> -     int n = a->nlimbs;
> >> >> +     const int n = a->nlimbs;
> >> >> +     mpi_ptr_t ap;
> >> >>       int i;
> >> >>
> >> >>       if (!count || !n)
> >> >> @@ -187,6 +187,7 @@ int mpi_lshift_limbs(MPI a, unsigned int count)
> >> >>       if (RESIZE_IF_NEEDED(a, n + count) < 0)
> >> >>               return -ENOMEM;
> >> >>
> >> >> +     ap = a->d;
> >> >>       for (i = n - 1; i >= 0; i--)
> >> >>               ap[i + count] = ap[i];
> >> >>       for (i = 0; i < count; i++)
> >> >>
> >> >
> >> > --
> >> > Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> >> > Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> >> > Plain text mails only, please.
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >> Hello,
> >>
> >> I was travelling last week.
> >> I will review the patch now..
> >>
> >
> > Hi.
> >
> > Did you get a chance to review the patch?  Did you find it acceptable or
> > flawed?
> >
> > If it is OK, what do I need to from this point forward to get it merged?
> >
> >
> 
> Hello Jesper & James,
> 
> That is of course correct.
> 
> James, can you please apply this patch to security fixes?
> 
>  Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> 

Thank you for your time to review and your ACK :-)

-- 
Jesper Juhl <jj@chaosbits.net>


--8323328-1886282438-1334357620=:13233--
