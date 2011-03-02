Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab1CBTs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:48:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab1CBTsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110302.114018.104077586.davem@davemloft.net>
References: <20110302162650.GA26810@redhat.com> <20110302164428.GF26810@redhat.com>
 <AANLkTinzQmprg+XHKjTj7bA+jFf_N4hta3_09M+SEfRt@mail.gmail.com> <20110302.114018.104077586.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Mar 2011 11:48:03 -0800
Message-ID: <AANLkTi=e7n63cCTUe1T+C0d6Ni1VVBFZZ6y_rj-2RQwu@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] exec: unify native/compat code
To: David Miller <davem@davemloft.net>
Cc: oleg@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pageexec@freemail.hu,
        solar@openwall.com, eteo@redhat.com, spender@grsecurity.net,
        roland@redhat.com, miltonm@bga.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 11:40 AM, David Miller <davem@davemloft.net> wrote:
>
> We purposely don't do that "page table entry typedef'd to aggregate" stuff
> on sparc32 because otherwise such values get passed on the stack.
>
> Architectures can currently avoid this bad code generation for the
> page table case, but with this new code they won't be able to avoid
> pass-by-value.

Well, the thing is, on architectures that _can_ pass by value, it
avoids one indirection.

And if you do pass it on stack, then the code generated will be the
same as if we passed a pointer. So sparc may not be able to take
advantage of the optimization, but I don't think the code generation
would be worse.

For the page table case, we don't have that kind of trade-off: the
trade-off there is literally just between "pass in registers, or pass
on stack". Here the trade-off is "pass as an aggregate value or pass
as a pointer to an aggregate value".

That said, since I suspect that the main user will always just get
inlined (ie the helper function that actually fetches the pointers), I
suspect even sparc will see the advantage of the pass-by-value model.

But you might want to actually test the difference and look at the
code generation.

                      Linus
