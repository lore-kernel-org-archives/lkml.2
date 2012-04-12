Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2DLGUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:20:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:33551 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756921Ab2DLGUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:20:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net>
	<CALLzPKbAGKL-o66UmWJ4uGSmA1TymdCQA0CfBajHLVYzt_60UA@mail.gmail.com>
	<alpine.LNX.2.00.1204120030130.2137@swampdragon.chaosbits.net>
Date: Thu, 12 Apr 2012 09:20:33 +0300
Message-ID: <CALLzPKY0Jd26gJTgcm5aXLZtzHJKqKVGXipBYtnzsisumnTR5A@mail.gmail.com>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Jesper Juhl <jj@chaosbits.net>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 1:31 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Tue, 13 Mar 2012, Kasatkin, Dmitry wrote:
>
>> On Thu, Mar 1, 2012 at 11:33 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>> >
>> > Ping?
>> >
>> > On Mon, 6 Feb 2012, Jesper Juhl wrote:
>> >
>> >> At the start of the function we assign 'a->d' to 'ap'. Then we use the
>> >> RESIZE_IF_NEEDED macro on 'a' - this may free 'a->d' and replace it
>> >> with newly allocaetd storage. In that case, we'll be operating on
>> >> freed memory further down in the function when we index into 'ap[]'.
>> >> Since we don't actually need 'ap' until after the use of the
>> >> RESIZE_IF_NEEDED macro we can just delay the assignment to it until
>> >> after we've potentially resized, thus avoiding the issue.
>> >>
>> >> While I was there anyway I also changed the integer variable 'n' to be
>> >> const. It might as well be since we only assign to it once and use it
>> >> as a constant, and then the compiler will tell us if we ever assign to
>> >> it in the future.
>> >>
>> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> >> ---
>> >>  lib/mpi/mpi-bit.c |    5 +++--
>> >>  1 files changed, 3 insertions(+), 2 deletions(-)
>> >>
>> >>  only compile tested.
>> >>
>> >> diff --git a/lib/mpi/mpi-bit.c b/lib/mpi/mpi-bit.c
>> >> index 2f52662..0c50536 100644
>> >> --- a/lib/mpi/mpi-bit.c
>> >> +++ b/lib/mpi/mpi-bit.c
>> >> @@ -177,8 +177,8 @@ int mpi_rshift(MPI x, MPI a, unsigned n)
>> >>   */
>> >>  int mpi_lshift_limbs(MPI a, unsigned int count)
>> >>  {
>> >> -     mpi_ptr_t ap = a->d;
>> >> -     int n = a->nlimbs;
>> >> +     const int n = a->nlimbs;
>> >> +     mpi_ptr_t ap;
>> >>       int i;
>> >>
>> >>       if (!count || !n)
>> >> @@ -187,6 +187,7 @@ int mpi_lshift_limbs(MPI a, unsigned int count)
>> >>       if (RESIZE_IF_NEEDED(a, n + count) < 0)
>> >>               return -ENOMEM;
>> >>
>> >> +     ap = a->d;
>> >>       for (i = n - 1; i >= 0; i--)
>> >>               ap[i + count] = ap[i];
>> >>       for (i = 0; i < count; i++)
>> >>
>> >
>> > --
>> > Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
>> > Don't top-post http://www.catb.org/jargon/html/T/top-post.html
>> > Plain text mails only, please.
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>>
>> Hello,
>>
>> I was travelling last week.
>> I will review the patch now..
>>
>
> Hi.
>
> Did you get a chance to review the patch?  Did you find it acceptable or
> flawed?
>
> If it is OK, what do I need to from this point forward to get it merged?
>
>

Hello Jesper & James,

That is of course correct.

James, can you please apply this patch to security fixes?

 Acked-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

- Dmitry

> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
