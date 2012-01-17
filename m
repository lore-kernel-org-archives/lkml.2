Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2AQRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:16:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51113 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2AQRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:16:57 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1326788038-29141-1-git-send-email-minchan@kernel.org>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
Date: Tue, 17 Jan 2012 09:16:56 -0800
Message-ID: <CAOesGMjgXMctGr3o=X3n2gx2_g990FzCPn88NQz8tN8m1aHsGQ@mail.gmail.com>
Subject: Re: [RFC 0/3] low memory notify
From: Olof Johansson <olof@lixom.net>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        leonid.moiseichuk@nokia.com, kamezawa.hiroyu@jp.fujitsu.com,
        penberg@kernel.org, Rik van Riel <riel@redhat.com>, mel@csn.ul.ie,
        rientjes@google.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 17, 2012 at 12:13 AM, Minchan Kim <minchan@kernel.org> wrote:
> As you can see, it's respin of mem_notify core of KOSAKI and Marcelo.
> (Of course, KOSAKI's original patchset includes more logics but I didn't
> include all things intentionally because I want to start from beginning
> again) Recently, there are some requirements of notification of system
> memory pressure. It would be very useful for various cases.
> For example, QEMU/JVM/Firefox like big memory hogger can release their memory
> when memory pressure happens. Another example in embedded side,
> they can close background application. For this, there are some trial but
> we need more general one and not-hacked alloc/free hot path.
>
> I think most big problem of system slowness is swap-in operation.
> Swap-in is a synchronous operation so application's latency would be
> big. Solution for that is prevent swap-out itself. We couldn't prevent
> swapout totally but could reduce it with this patch.
>
> In case of swapless system, code page is very important for system response.
> So we have to keep code page, too. I used very naive heuristic in this patch
> but welcome to any idea.
>
> I want to make kernel logic simple if possible and just notify to user space.
> Of course, there are lots of thing we have to consider but for discussion
> this simple patch would be a good start point.

This is almost exactly what we've been looking at doing for Chrome OS
(which is swapless). In our case, the browser is by far the largest
memory consumer on the system, and we have for quite a while been
playing tricks with OOM scores trying to make the interaction between
the VM and the application happen right such that if we're OOM, the
"right" tab process gets killed, etc. But it's not enough (and it's
not always accurate enough). Chrome definitely knows already what it
would prefer to do to release memory, so having a simple notifier for
low memory condition is preferred.

We have considered doing it through cgroups but it adds a level of
complexity that we don't need for this use case (we do already use
cgroups for other reasons though). If this simpler solution is heading
towards inclusion we'll probably use it instead.


-Olof
