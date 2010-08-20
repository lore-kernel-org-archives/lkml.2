Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0HTQHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:07:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab0HTQHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 09:07:14 -0700
Message-ID: <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 8:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 20, 2010 at 5:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>>
>> Since we have split the original VMA into 3, shouldn't only the bottom
>> one still have VM_GROWSDOWN set? (how can the top two grow down with the
>> bottom one in the way?) Certainly it seems wrong to enforce a guard page
>> on anything but the bottom VMA (which is what appears to be happening).
>
> Yes, it does seem like we should teach vma splitting to remove
> VM_GROWSDOWN on all but the lowest mapping.

Actually, thinking some more about it, that may not be a good idea.
Why? Simply because we may want to merge the vma's back together if
you do munlock. And it won't (and mustn't) merge if the vm_flags
differ in VM_GROWSDOWN.

So I do think we want to keep VM_GROWSDOWN (and VM_GROWSUP on PA-RISC)
even across a vma split.

Of course, we could set a flag whether the vma really does have a
guard page or not.

That said, it does strike me as rather odd to do VM ops on partial
stacks. What are you doing, exactly, to hit this?

                         Linus
