Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2DRSZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:25:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44230 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2DRSZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120418171438.GA24290@redhat.com>
References: <20120417172142.GA30237@redhat.com> <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com> <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418031935.GB29828@redhat.com> <CA+55aFwrARr4=ZztWseFbND1h6W=QV52r98qioL+bK6jKrehSA@mail.gmail.com>
 <20120418171438.GA24290@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Apr 2012 11:24:54 -0700
X-Google-Sender-Auth: 0FvVnqbi8lxZ3LTWAXP1amx5khA
Message-ID: <CA+55aFwwKZ2DrjX5Qp+rsOhkSTjt2RiadRMjr=njCRfeW+uXrQ@mail.gmail.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:14 AM, Dave Jones <davej@redhat.com> wrote:
>
> One thing I'm curious about.. Some of the function names are repeated
> for a reason that doesn't seem obvious to me, when the call chain doesn't
> call them in a loop. What's that about ?

In a "real" stack trace, it's usually due to a pointer to a function
that just gets passed around as an argument.

However, in this case, I think it's simply because you are seeing a
lot of stack-traces "on top of each other", where the callers had
slightly different stack offsets, but old stack traces "shine through"
because the stack of the newer trace is not very dense.

Gcc often generates very sparse stack frames. Sometimes it is because
of stack alignment issues, but more often it's because gcc generates
the frame for all possible local variables, and then we took an early
exit from the function (or are still in the middle of the call chain)
and part of the stack simply hasn't been modified at all.

And sometimes it is because gcc stack space allocation simply sucks.
There was a time when gcc would never share stack space between local
variables even when they had no overlap in lifetime. I know they fixed
*some* of those cases, but I suspect it's still true that gcc just
often allocates way more stack than it really needs, and then you see
old stale stack contents shine through.

                         Linus
