Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1ASFnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:43:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071Ab1ASFnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:43:32 -0500
MIME-Version: 1.0
In-Reply-To: <20110119051049.GA2536@WALL-E>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com> <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
 <20110119051049.GA2536@WALL-E>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jan 2011 21:42:42 -0800
Message-ID: <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1
To: nobody <darwinskernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 9:10 PM, nobody <darwinskernel@gmail.com> wrote:
>
> i wish i could do that for everything. i am pulling up to 500MiB every
> -rc cycle and mostly codes for hardwares i don't have.

No you're not.

The *WHOLE* Linux kernel git archive fits in one 388M pack. That's not
some -rc release, that's the whole git history going back to 2.6.12 or
whenever it was that git was started (admittedly fairly well-packed,
but still). The incremental for some -rc cycle can be megabytes, but
we're still talking single megabytes, not hundreds of megs.

So no, you're not pulling 500MiB every -rc cycle, unless you're doing
something stupid like using http (which will trigger a re-fetch, since
I end up repacking a couple of times a release) or always re-cloning.

So the fix is not to try to fetch just a part - that will not work.
Exactly because git is so good at packing, doing silly hacks like
"--depth=1" actually fetches MORE data than just doing one clone once
and then pulling incrementally after that. And no, you can't just get
partial trees (although you can then try to save some disk space by
checking out only partial trees - it's not worth the pain, though).

So the fix is:

 - don't use http or rsync (they're fine for the initial clone, but
don't ever use it for any incrementals, and even then I'd suggest
keeping to rsync and not http)

 - if you have some firewall issue that means that you can only use
http, get the firewall fixed. It's not a git issue.

no need to fix git.

When pulling from 2.6.37 to 2.6.38-rc1, it should look something like this:

  remote: Counting objects: 84898, done.
  remote: Compressing objects: 100% (14274/14274), done.
  Receiving objects: 100% (71245/71245), 21.07 MiB | 26.53 MiB/s, done.
  remote: Total 71245 (delta 59086), reused 67779 (delta 56042)
  Resolving deltas: 100% (59086/59086), completed with 7395 local objects.

ie you got 21.07MiB for the whole change between 2.6.37 and 2.6.38-rc1.

(it does expand if you do it every day because then you won't be able
to delta quite as well, and the "completed with 7395 local objects"
means that the local packs will be much bigger on disk because they
will be expanded to have all the base objects, but that 21MB should be
the approximate actual network usage)

Considering that just the _diff_ between 2.6.37 and 2.6.38-rc1 is
about 42MB in size, the fact is that git is damn good at network
bandwidth.

                   Linus
