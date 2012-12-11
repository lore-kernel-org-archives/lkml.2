Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2LKTK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:10:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57330 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2LKTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <1355252392.2356.131.camel@falcor>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
 <1355234914.2356.85.camel@falcor> <CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
 <1355249884.2356.108.camel@falcor> <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
 <1355252392.2356.131.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Dec 2012 11:10:04 -0800
X-Google-Sender-Auth: rV8AOkUTbOjHfojnJptcNra_vUk
Message-ID: <CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:59 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>  Bottom line,
> we can't say definitively whether or not a file needs to be measured for
> any caller.

.. but is that actually *always* the case? Is there some fundamental
reason why integrity rules can never have "this file just doesn't
matter"?

For example, if you have cases where you know that a file has a
particular policy (or no policy what-so-ever) that never cares, then
for that file you can say "don't bother measuring this file" even
though in the generic case that may not be true.

Things like that might be the common case. Like "normal files owned by
uid > 500 are user files, and we simply don't care, and fall back to
just normal unix permissions".

And yes, things like that may end up requiring that the flag be
cleared on other inode events (ie changing file ownership of
executable flags or whatever, which might change a file from "don't
bother" to "hey, now it might be interesting again"). So maybe
chmod/chown/chgrp would clear that flag..

Anyway, the whole "you can do it at file granularity" isn't the bulk
of my argument (the "we already have the field that makes sense" is).
But my point is that per-inode is not only the logically more
straightforward place to do it, it's also the much more flexible place
to do it. Because it *allows* for things like that.

                  Linus
