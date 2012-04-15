Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2DOXnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:43:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35373 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2DOXnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120415223808.GA26214@redhat.com>
References: <20120414235238.GA11131@redhat.com> <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com>
 <20120415223808.GA26214@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Apr 2012 16:42:45 -0700
X-Google-Sender-Auth: GaKp3nDfMSxfKNrOvxW3u6_Ekr8
Message-ID: <CA+55aFwpts0X=V67+wUchJN9Bgjh17eZJqOo0Y0oc2Mzbfa7QA@mail.gmail.com>
Subject: Re: ptrace && fpu_lazy_restore
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 3:38 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Suppose that fpu_owner_task exits on CPU_0, and then fork() reuses
> its task_struct. The new child is still fpu_owner_task and this is
> obviously wrong (unless of course another thread uses fpu).
>
> Initially I thought this should be fixed too, but it seems that
> "p->fpu_counter = 0" in copy_thread() saves us.
>
> This looks a bit fragile... And could you confirm this is really
> fine?

That one is done by design. That fpu_counter=0 in copy_thread() is
there explicitly to avoid the problem. Although it's possible that we
should reset last_cpu instead. However, that line was actually added
before the lazy thing - see commit cea20ca3f318.

> Btw, do we really need this "old->thread.fpu.last_cpu = ~0" in
> the "else" branch of switch_fpu_prepare()? Just curious, I guees
> this doesn't matter since we reset old->fpu_counter. But if we
> can remove this line, then perhaps we can another optimization.

Possibly not needed, but quite frankly, I'd rather have last_cpu never
contain some stale value.

                  Linus
