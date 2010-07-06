Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0GFN0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 09:26:30 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49141 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab0GFN03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 09:26:29 -0400
Date: Tue, 6 Jul 2010 15:28:25 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100706132825.GT10072@secunet.com>
References: <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
 <20100702091726.GH10072@secunet.com>
 <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
 <20100702111138.GI10072@secunet.com>
 <AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
 <20100706053612.GQ10072@secunet.com>
 <20100706054406.GR10072@secunet.com>
 <AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
 <20100706074641.GS10072@secunet.com>
 <AANLkTimYK_4PcVrAniOE3pQjgYNwYNjI6q8p1FMZntEa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYK_4PcVrAniOE3pQjgYNwYNjI6q8p1FMZntEa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Jul 2010 13:26:27.0374 (UTC) FILETIME=[D662D4E0:01CB1D0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 12:31:21PM +0400, Dan Kruchinin wrote:
> 
> Would't it be the same as with a pointer to cpumask_var_t? I mean:

Using a pointer to cpumask_var_t is a bit problematic because
you don't know a priori about the type of cpumask_var_t.
The type depends whether the cpumasks are on/off stack.
So the easiest thing is to embed it to a struct, then you don't
need to care about the type. If you allocate a struct of type
pcrypt_cpumask you get what you want to have.

> struct pcrypt {
>   ...
>   struct pcrypt_cpumask *mask;
>   ...
> } pencrypt;
> 
> To assign a pointer via RCU:
> 
> int cpumask_change_nitify(...) {
>    ...
>   struct pcrypt_cpumask *new_mask = kmalloc(sizeof(*mask), GFP);
>   struct pcrypt_cpumask *old_mask = pencrypt.mask;
> 
>   if (!new_mask)
>      error();
>   if (!alloc_cpumask_var(&new_mask->smask, GFP_KERNEL))
>      error();
> 
>   get_serial_cpumask_from_padata(new_mask->mask);
>   rcu_assign_pointer(pencrypt.mask, new_mask);
>   synchronize_rcu_bh();
> 
>   free_cpumask_var(old_mask->smask);
>   kfree(old_mask);
>   ...
> }
> 
> It's a bit hard to read this code because at the first sight it
> appears unclear and odd why we allocate the structure with only one
> member.
> 

We can easily add a code comment if this appears to be unclear :)
