Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031338Ab2CVWjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:39:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52344 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab2CVWjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BA69F.1040707@openvz.org>
References: <20120321065140.13852.52315.stgit@zurg> <20120321100602.GA5522@barrios>
 <4F69D496.2040509@openvz.org> <20120322142647.42395398.akpm@linux-foundation.org>
 <20120322212810.GE6589@ZenIV.linux.org.uk> <20120322144122.59d12051.akpm@linux-foundation.org>
 <4F6BA221.8020602@openvz.org> <4F6BA69F.1040707@openvz.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 15:39:00 -0700
X-Google-Sender-Auth: yPSksWRw5u4Wj28kQsjouWF1C7k
Message-ID: <CA+55aFz4hWfT5c93rUWvN4OsYHjOSAjmNtoT7Rkjz7kYsaC7xg@mail.gmail.com>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 3:24 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
>
> # define __nocast       __attribute__((nocast))
>
> typedef long __nocast long_t;

So the intention is that this really creates a *new* type.

So "long_t" really is a different type from "long", but because
__nocast is so weak, it happily casts to another integer type of the
same size.

But a pointer to it is different, the same way "int *" is different
from "long *" even if "int" and "long" happen to have the same size.
So I do think that the warning you quote is correct and expected:

> 1.c:13:12: warning: incorrect type in argument 1 (different modifiers)
> 1.c:13:12:    expected int [nocast] [usertype] *x
> 1.c:13:12:    got int *<noident>
> 1.c:13:12: warning: implicit cast to nocast type
>
> Is this ok?

Yes.

The thing about __nocast is that it's so *very* very easy to lose it.
For example, do this:

  typedef long __nocast long_t;

  int main(long_t a)
  {
        return a;
  }

and you get the (expected) warning.

HOWEVER. Now do "return a+1" instead, and the warning goes away. Why?
Because the expression ends up having just the type "long", because
the "a" mixed happily with the "1" (that was cast from 'int' to 'long'
by the normal C type rules).

That is arguably a bug, but this kind of thing really wasn't what
__nocast was designed for. The __nocast design ended up being too
weak, though, and we hardly use it in the kernel.

                        Linus
