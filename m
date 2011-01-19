Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1ASF5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:57:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099Ab1ASF5C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:57:02 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com> <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
 <20110119051049.GA2536@WALL-E> <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jan 2011 21:56:38 -0800
Message-ID: <AANLkTikV6=FCQ+-Z=fAi8SH90M-izCUEBisinqGwo=DU@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1
To: nobody <darwinskernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 9:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> When pulling from 2.6.37 to 2.6.38-rc1, it should look something like this:
>
>  remote: Counting objects: 84898, done.
>  remote: Compressing objects: 100% (14274/14274), done.
>  Receiving objects: 100% (71245/71245), 21.07 MiB | 26.53 MiB/s, done.
>  remote: Total 71245 (delta 59086), reused 67779 (delta 56042)
>  Resolving deltas: 100% (59086/59086), completed with 7395 local objects.
>
> ie you got 21.07MiB for the whole change between 2.6.37 and 2.6.38-rc1.

Btw, what may confuse you a bit is that the on-disk representation of
the newly received pack ends up being about 69MB, ie the 21MiB of
network traffic almost tripled in size as a result of that "resolving
deltas" thing. That's because git pack-files are designed to always be
stand-alone, so on disk, the pack-file will always contain the base
objects needed to expand all the deltas.

But on the wire, we don't do that, which is why you have that
"Resolving deltas" phase - it's a purely local phase where it takes
the "pure delta" pack that came over the wire, and creates the
well-formed pack that doesn't have any deltas that depend on external
objects.

And that expansion will end up happening every time you pull: so if
you do daily pulls, all those pulls that will have been fairly small
on the wire will all have been expanded so that the resulting packs
are stand-alone. Which means that you often end up having the same (or
very similar) base objects duplicated in the packs.

So I can well imagine that if you do a pull every day, over two weeks
your .git/objects/pack directory will have new packs that together are
500MB in size due to all of that. That's why git likes doing some GC
on its data every once in a while - it will repack all those
individual packs into one big pack, which avoids all that duplication
of base objects.

And why do we expand the packs and make them stand on their own? Why
don't we just keep all the object data as deltas agains objects in
other packs, the way we pass data around on the network? The reason is
simply robustness. You can get into various nasty situations (like
circular delta dependencies) if you allow deltas between different
packs. So the only time we allow a so-called "thin pack" (ie the pack
is full of deltas against objects external to the pack) is for the
ephemeral pack that is transferred during a "pull" or "fetch". In that
situation we end up doing lots of extra sanity checking, and because
it's ephemeral you never get into the whole situation where deltas in
different packs could refer to each other (because by the time it's a
real pack, it will have been expanded out to be self-sufficient).

So do use "git gc" every once in a while to avoid unnecessary pack
duplication issues (it also makes object indexing much faster etc).

                  Linus
