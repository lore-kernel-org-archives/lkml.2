Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0HXRvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:51:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab0HXRvn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <4c73f3ed34663af90@agluck-desktop.sc.intel.com>
References: <4c73f3ed34663af90@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Aug 2010 10:51:12 -0700
Message-ID: <AANLkTi=-JRUFH08TYNhB7TyN=YscnNbqwtZ_BwcwKJPS@mail.gmail.com>
Subject: Re: [PATCH] guard page for stacks that grow upwards
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Looking at the patch a bit more..

On Tue, Aug 24, 2010 at 9:31 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> +#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
> +       else if (vma->vm_flags & VM_GROWSUP) {
> +               address = PAGE_ALIGN(address + 1);
> +               if (address == vma->vm_end) {

So I react to two things:

 - that "else" looks wrong. At least conceptually, both could happen -
the code should be entirely able to handle a segment that expands both
ways (which is something that ia64 could do: stack one way, register
spills etc other, all in just one happy vma). I guess we don't set it
up that way now, but the "else" just annoys my sense of aesthetics.
It's an extra four letters that don't add value - just takes it away.

 - The "address = PAGE_ALIGN(address + 1);" thing is just ugly.
Wouldn't it be nicer to just move the earlier

  address &= PAGE_MASK

back outside the conditionals (and keep the original conditional the
way it was - you only changed it for that bogus "else" case anyway),
and then do

  if (address + PAGE_SIZE == vma->vm_end)

rather than have "PAGE_ALIGN(address + 1)" as yet another way of
aligning the address just right.

No?

                              Linus
