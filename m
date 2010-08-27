Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0H0TqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:46:04 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:38577 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0H0TqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <4C779111.8000803@kernel.org>
References: <AANLkTimoCn9uWQ1NTJAhRu7cq1MA+oo6E5p30zeXA3f1@mail.gmail.com>
	<4C779111.8000803@kernel.org>
Date: Fri, 27 Aug 2010 14:45:59 -0500
Message-ID: <AANLkTinZLdSTVenJ=ShK9-f27eMQSyv=j6vYK+F3K96s@mail.gmail.com>
Subject: Re: [PATCH] scatterlist: prevent invalid free when alloc fails
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        Hu Tao <taohu@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 5:18 AM, Tejun Heo <tj@kernel.org> wrote:
> First of all, the patch is line-wrapped.  Please check your email
> settings.

Sorry about that.

> On 08/26/2010 06:04 PM, Jeffrey Carlyle wrote:
>> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>> index a5ec428..acf2c6e 100644
>> --- a/lib/scatterlist.c
>> +++ b/lib/scatterlist.c
>> @@ -163,7 +163,7 @@ void __sg_free_table(struct sg_table *table,
>> unsigned int max_ents,
>>               return;
>>
>>       sgl = table->sgl;
>> -     while (table->orig_nents) {
>> +     while (table->orig_nents && sgl) {
>>               unsigned int alloc_size = table->orig_nents;
>>               unsigned int sg_size;
>
> Why is this change necessary?

Well the problem we were seeing manifested itself when we called
free_fn on a NULL value. This was a naive attempt at avoiding that. If
the logic in __sg_alloc_table is corrected, I agree that we shouldn't
need this.

>> @@ -227,6 +227,7 @@ int __sg_alloc_table(struct sg_table *table,
>> unsigned int nents,
>>  {
>>       struct scatterlist *sg, *prv;
>>       unsigned int left;
>> +     unsigned int total_alloc = 0;
>>
>>  #ifndef ARCH_HAS_SG_CHAIN
>>       BUG_ON(nents > max_ents);
>> @@ -248,8 +249,14 @@ int __sg_alloc_table(struct sg_table *table,
>> unsigned int nents,
>>               left -= sg_size;
>>
>>               sg = alloc_fn(alloc_size, gfp_mask);
>> -             if (unlikely(!sg))
>> +             if (unlikely(!sg)) {
>> +                     table->orig_nents = total_alloc;
>> +                     /* mark the end of previous entry */
>> +                     sg_mark_end(&prv[alloc_size - 1]);
>
> prv[alloc_size - 1] is already marked as end by sg_init_table() during
> the previous iteration.  Also, prv can be NULL at this point.  AFAICS,
> the only thing necessary would be "if (prv) table->nents++", no?

You are right about prv possibly being NULL here. Sorry for not
catching that earlier; however, I don't think prv will be marked as an
end in the previous iteration. According to my read it will only get
marked if left is equal to 0, in which case the while loop exits.
Perhaps something like this would be more appropriate:

if(prv) {
        table->orig_nents = ++table->nents;
        sg_mark_end(&prv[alloc_size - 1]);
}

Thank you for taking the time to review this.
