Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0GFIb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:31:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63664 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0GFIbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ppNvUP5rXCgZXFNQc7xj2PuN4Y+AYj499op3cXsciOM4RI+nZlL9VGjwnxqzfBx5pU
         CpkOZYaGKBjuXRZmchGr0yWcp7eo4RQljupQaKGGKOj2otJXzy8EQMD1qOSpCTrkgrbL
         RCHNwtTpGMw6MAMdqPd6MNsONA8rtDJkxTXy8=
MIME-Version: 1.0
In-Reply-To: <20100706074641.GS10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
	<20100702085323.GF10072@secunet.com>
	<AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
	<AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
	<20100702111138.GI10072@secunet.com>
	<AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
	<20100706053612.GQ10072@secunet.com>
	<20100706054406.GR10072@secunet.com>
	<AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
	<20100706074641.GS10072@secunet.com>
Date: Tue, 6 Jul 2010 12:31:21 +0400
X-Google-Sender-Auth: sFcfhXiBxnlqKlNeVGWSxtLrKAQ
Message-ID: <AANLkTimYK_4PcVrAniOE3pQjgYNwYNjI6q8p1FMZntEa@mail.gmail.com>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 11:46 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Tue, Jul 06, 2010 at 11:40:11AM +0400, Dan Kruchinin wrote:
>> >> >
>> >>
>> >> I think we can use RCU anyway. For instance we could use a structure
>> >>
>> >> struct pcrypt_cpumask {
>> >>       cpumask_var_t           pmask;
>> >>       cpumask_var_t           smask;
>> >> };
>> >>
>> >> and add a pointer to a structure of that type to the instance context.
>> >> Then we could use this pointer for RCU and replace the whole structure
>> >> if a cpumask changes.
>>
>> But is pcrypt interested pmask? If it isn't, pmask field will be unused.
>>
>
> It's probaply not, in this case the struct could look like
>
> struct pcrypt_cpumask {
>        cpumask_var_t           smask;
> };
>

Would't it be the same as with a pointer to cpumask_var_t? I mean:
struct pcrypt {
  ...
  struct pcrypt_cpumask *mask;
  ...
} pencrypt;

To assign a pointer via RCU:

int cpumask_change_nitify(...) {
   ...
  struct pcrypt_cpumask *new_mask = kmalloc(sizeof(*mask), GFP);
  struct pcrypt_cpumask *old_mask = pencrypt.mask;

  if (!new_mask)
     error();
  if (!alloc_cpumask_var(&new_mask->smask, GFP_KERNEL))
     error();

  get_serial_cpumask_from_padata(new_mask->mask);
  rcu_assign_pointer(pencrypt.mask, new_mask);
  synchronize_rcu_bh();

  free_cpumask_var(old_mask->smask);
  kfree(old_mask);
  ...
}

It's a bit hard to read this code because at the first sight it
appears unclear and odd why we allocate the structure with only one
member.

-- 
W.B.R.
Dan Kruchinin
