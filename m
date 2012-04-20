Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2DTQRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:17:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37997 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab2DTQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <1334913084.2463.29.camel@laptop>
References: <1334791449-402-1-git-send-email-asharma@fb.com> <1334913084.2463.29.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 09:16:42 -0700
X-Google-Sender-Auth: 0CL5NqiBdEL6gR-aZxIprBr_rxw
Message-ID: <CA+55aFwg-LvxYUGD_mD=V4mt=zi8J34hQu+ZBGAHH9yX8WET2Q@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Disable sanity check
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 2:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Makes me really nervous.. Ingo, Linus ?

I don't care as long as this only *ever* triggers for user stacks, and
the code verifies that. And I'm not sure it does, actually.

Why am I not sure? Because it uses copy_from_user_nmi(), which in turn
uses "access_ok()". But can we perhaps have the perf event happen
*while* the kernel has done a "set_fs(KERNEL_DS)" - and we just
happen to follow the user stack too? In which case we may be copying
kernel memory.

So I think this user stack following code is buggy in *other* ways.

Guys: stack following has to be *f^&%ing* careful! This shows yet
again how people blithely follow frame pointers without verifying
everything they damn well can.

Also, I note that the deepest stack chain allowed is something
*ridiculously* deep (like 255), and we use copy_from_user_nmi() for
this each entry. Which is slow as hell. So I would suggest at least
considering limiting that depth more.

End result: I'm ok with removing that one test. But I want more tests
to replace it. The user frame pointer had damn well better be in user
space (and no, "access_ok()" is not valid or sufficient in interrupt
context!) and I suspect there are other things you could check.

                  Linus
