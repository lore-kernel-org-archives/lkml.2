Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1DYPaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:30:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab1DYPaF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110425111705.786ef0c5@neptune.home>
References: <20110424202158.45578f31@neptune.home> <20110424235928.71af51e0@neptune.home>
 <20110425114429.266A.A69D9226@jp.fujitsu.com> <BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
 <20110425111705.786ef0c5@neptune.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2011 08:22:38 -0700
Message-ID: <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 2:17 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Here it seems to happened when I run 2 intensive tasks in parallel, e.g.
> (re)emerging gimp and running revdep-rebuild -pi in another terminal.
> This produces a fork rate of about 100-300 per second.
>
> Suddenly kmalloc-128 slabs stop being freed and things degrade.

So everything seems to imply some kind of filesystem/vfs thing, but
let's try to gather a bit more information about exactly what it is.

Some of it also points to RCU freeing, but that "kmalloc-128" doesn't
really match my expectations. According to your slabinfo, it's not the
dentries.

One thing I'd ask you to do is to boot with the "slub_nomerge" kernel
command  line switch. The SLUB "merge slab caches" thing may save some
memory, but it has been a disaster from every other standpoint - every
time there's a memory leak, it ends up making it very confusing to try
to figure things out.

For example, your traces seem to imply that the kmalloc-128 allocation
is actually the "filp" cache, but it has gotten merged with the
kmalloc-128 cache, so slabinfo doesn't actually show the right user.

(Pekka? This is a real _problem_. The whole "confused debugging" is
wasting a lot of peoples time. Can we please try to get slabinfo
statistics work right for the merged state. Or perhaps decide to just
not merge at all?)

As to why it has started to happen now: with the whole RCU lookup
thing, many more filesystem objects are RCU-free'd (dentries have been
for a long time, but now we have inodes and filp's too), and that may
end up delaying allocations sufficiently that you end up seeing
something that used to be borderline become a major problem.

Also, what's your kernel config, in particular wrt RCU? The RCU
freeing _should_ be self-limiting (if I recall correctly) and not let
infinite amounts of RCU work (ie pending freeing) accumulate, but
maybe something is broken. Do you have a UP kernel with TINY_RCU, for
example? Or maybe I'm just confused, and there's never any RCU
throttling at all. Paul?

                               Linus
