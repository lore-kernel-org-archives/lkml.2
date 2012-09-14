Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2INVnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:43:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58435 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab2INVnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120914212717.GA29307@liondog.tnic>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Sep 2012 14:42:44 -0700
X-Google-Sender-Auth: xqqQw3Y8ARBWd1SKkgSZhf_WHFc
Message-ID: <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 2:27 PM, Borislav Petkov <bp@alien8.de> wrote:
>
> as Nikolay says below, we have a regression in 3.6 with pgbench's
> benchmark in postgresql.
>
> I was able to reproduce it on another box here and did a bisection run.
> It pointed to the commit below.

Ok. I guess we should just revert it. However, before we do that,
maybe Mike can make it just use the exact old semantics of
select_idle_sibling() in the update_top_cache_domain() logic.

Because the patch in question seems to do two things:
 (a) cache the "idle_buggy" logic, so that we don't have those costly loops
 (b) change it to do that "left-right" thing.

and that (b) thing may be what causes a regression for you.

So my gut feel is that the patch was wrong to begin with, exactly
because it did two independent changes. It *should* have treated those
two issues as independent changes and separate commits.

Maybe I'm mis-reading it. Mike? Peter?

            Linus
