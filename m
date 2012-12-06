Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946054Ab2LFQvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:51:22 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35135 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424218Ab2LFQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:51:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121206161934.GA17258@suse.de>
References: <20121206091744.GA1397@polaris.bitmath.org> <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Dec 2012 08:50:54 -0800
X-Google-Sender-Auth: IkKARusN7uttb4oFtWu1FDXEsVk
Message-ID: <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 8:19 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> Still travelling and am not in a position to test this properly :(.
> However, this bug feels very similar to a bug in the migration scanner where
> a pfn_valid check is missed because the start is not aligned.

Ugh. This patch makes my eyes bleed.

Is there no way to do this nicely in the caller? IOW, fix the
'end_pfn' logic way upstream where it is computed, and just cap it at
the MAX_ORDER_NR_PAGES boundary?

For example, isolate_freepages_range() seems to have this *other*
end-point alignment thing going on, and does it in a loop. Wouldn't it
be much better to have a separate loop that looped up to the next
MAX_ORDER_NR_PAGES boundary instead of having this kind of very random
test in the middle of a loop.

Even the name ("isolate_freepages_block") implies that we have a
"block" of pages. Having to have a random "oops, this block can have
other blocks inside of it that aren't mapped" test in the middle of
that function really makes me go "Uhh, no".

Plus, is it even guaranteed that the *first* pfn (that we get called
with) is pfnvalid to begin with?

So I guess this patch fixes things, but it does make me go "That's
really *really* ugly".

                  Linus
