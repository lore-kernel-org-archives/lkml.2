Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309Ab0LTXiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:38:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46972 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LTXiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YIKDDgtuasFslUHU4RVrJZocvclaQq9Ll9X7pQy+oqqNm3RSL9gDcOEAR7KkWRio8X
         +DFD9FY+O0cNh2CvnnD3gh8aQg+t3Px+Sym6s3Ttg+d93L9Arp5P6tDIiLDBp5oh3Rnw
         kffLplxTQOhBdkmhXDFdHOwPjM7vCkmZIerEI=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012202302460.23785@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012192305260.6486@swampdragon.chaosbits.net>
	<AANLkTikNx5SG9Z=tUu6tyFRqnR2sLe5NxAjLCJr1UKmq@mail.gmail.com>
	<alpine.LNX.2.00.1012202302460.23785@swampdragon.chaosbits.net>
Date: Tue, 21 Dec 2010 08:38:23 +0900
Message-ID: <AANLkTikmKB+4vP-dox+T0QzF-yTz7LQrTURYMcqHShsa@mail.gmail.com>
Subject: Re: [updated PATCH] Close mem leak in error path in mm/hugetlb.c::nr_hugepages_store_common()
From: Minchan Kim <minchan.kim@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 7:05 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Mon, 20 Dec 2010, Minchan Kim wrote:
>
>> On Mon, Dec 20, 2010 at 7:10 AM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > Hi,
>> >
>> > The NODEMASK_ALLOC macro dynamically allocates memory for its second
>> > argument ('nodes_allowed' in this context).
>> > In nr_hugepages_store_common() we may abort early if strict_strtoul()
>> > fails, but in that case we do not free the memory already allocated to
>> > 'nodes_allowed', causing a memory leak.
>> > This patch closes the leak by freeing the memory in the error path.
>> >
>> >
>> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> > ---
>> >  hugetlb.c |    4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> >  compile tested only
>> >
>> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> > index 8585524..9fdcc35 100644
>> > --- a/mm/hugetlb.c
>> > +++ b/mm/hugetlb.c
>> > @@ -1439,8 +1439,10 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
>> >        NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
>> >
>> >        err = strict_strtoul(buf, 10, &count);
>> > -       if (err)
>> > +       if (err) {
>> > +               kfree(nodes_allowed);
>>
>> Nice catch. But use NODEMASK_FREE. It might be not kmalloced object.
>>
> Right. I just checked the macro and it used kmalloc(), so I just wrote
> kfree. But you are right, NODEMASK_FREE is the right thing to use here.
> Updated patch below.
>
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Could you resend the completed patch to save Andrew trouble?


-- 
Kind regards,
Minchan Kim
