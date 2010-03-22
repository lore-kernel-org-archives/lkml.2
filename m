Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0CVIA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:00:58 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61447 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0CVIA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Cl1hbrxr1WVq8ThEwwIJR89vEx38+UPOFUGQBM+4ub7I4en1BjAoU6KnWRABzSUtaL
         /UBRmvfjYarel3eFkFurbCfGFv+tpJFwN8KTSiAmxdWEo3/oxpvhYF82kN7/uJEMBDzl
         2ek77C4yP9eUzy5RdV33I3JTJ2cf6TFjqX1ho=
MIME-Version: 1.0
In-Reply-To: <20100322005610.5dfa70b1.akpm@linux-foundation.org>
References: <20100322053937.GA17637@laptop>
	 <20100322005610.5dfa70b1.akpm@linux-foundation.org>
Date: Mon, 22 Mar 2010 10:00:54 +0200
X-Google-Sender-Auth: e77e1b3ec8fe658e
Message-ID: <84144f021003220100r29ee1ff2x11a66531e0104167@mail.gmail.com>
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 6:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 22 Mar 2010 16:39:37 +1100 Nick Piggin <npiggin@suse.de> wrote:
>
>> It's ugly and lazy that we do these default aops in case it has not
>> been filled in by the filesystem.
>>
>> A NULL operation should always mean either: we don't support the
>> operation; we don't require any action; or a bug in the filesystem,
>> depending on the context.
>>
>> In practice, if we get rid of these fallbacks, it will be clearer
>> what operations are used by a given address_space_operations struct,
>> reduce branches, reduce #if BLOCK ifdefs, and should allow us to get
>> rid of all the buffer_head knowledge from core mm and fs code.
>
> I guess this is one way of waking people up.
>
> What happens is that hundreds of bug reports land in my inbox and I get
> to route them to various maintainers, most of whom don't exist, so
> warnings keep on landing in my inbox.  Please send a mailing address for
> my invoices.
>
> It would be more practical, more successful and quicker to hunt down
> the miscreants and send them rude emails.  Plus it would save you
> money.
>
>> We could add a patch like this which spits out a recipe for how to fix
>> up filesystems and get them all converted quite easily.
>>
>> ...
>>
>> @@ -40,8 +40,14 @@ void do_invalidatepage(struct page *page
>>       void (*invalidatepage)(struct page *, unsigned long);
>>       invalidatepage = page->mapping->a_ops->invalidatepage;
>>  #ifdef CONFIG_BLOCK
>> -     if (!invalidatepage)
>> +     if (!invalidatepage) {
>> +             static bool warned = false;
>> +             if (!warned) {
>> +                     warned = true;
>> +                     print_symbol("address_space_operations %s missing invalidatepage method. Use block_invalidatepage.\n", (unsigned long)page->mapping->a_ops);
>> +             }
>>               invalidatepage = block_invalidatepage;
>> +     }
>
> erk, I realise 80 cols can be a pain, but 165 cols is just out of
> bounds.  Why not
>
>        /* this fs should use block_invalidatepage() */
>        WARN_ON_ONCE(!invalidatepage);

/me gets his paint bucket...

How about

    WARN_ONCE(!invalidatepage, "this fs should use block_invalidatepage()")

                           Pekka
