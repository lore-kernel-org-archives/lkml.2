Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982Ab2FVCWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 22:22:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53599 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963Ab2FVCWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 22:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120621184536.6dd97746.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
 <20120621164606.4ae1a71d.akpm@linux-foundation.org> <CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
 <20120621184536.6dd97746.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Jun 2012 19:22:30 -0700
X-Google-Sender-Auth: u7k0xuKjVhL-zjhkYS80CbmCiQo
Message-ID: <CA+55aFzioa__XftM7GOh2_iz0ukrTqx1QDaYV=DhiQC4f6nC_w@mail.gmail.com>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous migration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 6:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> And casts to/from bool, perhaps.  To squish the warning we'd do things
> like a_bool = !!a_int.  That generates extra code, but gcc internally
> generates extra code for a_bool = a_int anyway, and a quick test here
> indicates that the generated code is identical (testl/setne).

It *has* to generate extra code. A cast to Bool is very much not at
all like a normal cast. All the traditional C casts just do a pure bit
truncate (or zero/sign extension) keeping the same value.

A cast to bool is totally different. It is exactly the same as "test
against zero" - so it in no way acts like a traditional integer cast
to a one-bit integer.

I'm not 100% sure the use of "bool" is a great idea, and people who
use pointers to bools are crazy mf's (you can break the fundamental
property of bools by assigning random values through the pointer), but
_Bool certainly ahs the _potential_ to be a good thing. The reason I'm
nervous about it is exactly that people get it wrong so easily because
they do *not* act like any other C type (the whole pointer-to-bool
thing being one example of people doing bad things - I personally
would be much happier if _Bool acted more like a one-bit bitfield and
could not have its address taken).

            Linus
