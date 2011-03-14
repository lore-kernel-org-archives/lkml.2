Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1CNRhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:37:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754736Ab1CNRhR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110314165922.GE10696@random.random>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
 <20110314155232.GB10696@random.random> <alpine.LSU.2.00.1103140910570.2601@sister.anvils>
 <20110314165922.GE10696@random.random>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Mar 2011 10:30:11 -0700
Message-ID: <AANLkTikWh5tFUZuALYRP3Dx2Zcs33u0UVdjf4d_7KhPJ@mail.gmail.com>
Subject: Re: [PATCH] mm: PageBuddy and mapcount underflows robustness
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 9:59 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> +#define PAGE_BUDDY_MAPCOUNT_VALUE (-1024*1024)

I realize that this is a nitpick, but from a code generation
standpoint, large random constants like these are just nasty.

I would suggest aiming for constants that are easy to generate and/or
fit better in the code stream. In many encoding schemes (eg x86), -128
is much easier to generate, since it fits in a signed byte and allows
small instructions etc. And in most RISC encodings, 8- or 16-bit
constants can be encoded much more easily than something like your
current one, and bigger ones often end up resulting in a load from
memory or at least several immediate-building instructions.

> -       __ClearPageBuddy(page);
> +       if (PageBuddy(page)) /* __ClearPageBuddy VM_BUG_ON(!PageBuddy(page)) */
> +               __ClearPageBuddy(page);

Also, this is just disgusting. It adds no safety here to have that
VM_BUG_ON(), so it's just unnecessary code generation to do this.
Also, we don't even WANT to do that stupid "__ClearPageBuddy()" in the
first place! What those two code-sites actually want are just a simple

    reset_page_mapcount(page);

which does the right thing in _general_, and not just for the buddy
case - we want to reset the mapcount for other reasons than just
pagebuddy (ie the underflow/overflow case).

And it avoids the VM_BUG_ON() too, making the crazy conditionals be not needed.

No?

                        Linus
