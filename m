Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab1LORIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:08:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62769 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab1LORIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <1323943005.18942.18.camel@twins>
References: <1323804803.9082.40.camel@twins> <CA+55aFxNWiRQ1CkifhgcnnBqBa-xRNdM9Ze6bnxhsYd4ZYPg6A@mail.gmail.com>
 <20111214104308.14d0500c@pyramind.ukuu.org.uk> <1323860206.28489.35.camel@twins>
 <20111214140527.GA18080@thunk.org> <1323872631.28489.37.camel@twins>
 <CA+55aFwu+oSPtqfN+bS3_fHXWU+VMd5BGhNd=J4MjuAJZT+fTQ@mail.gmail.com> <1323943005.18942.18.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Dec 2011 09:08:32 -0800
X-Google-Sender-Auth: 72p_0X-A06ZSvj9RWiZkEBGWoGE
Message-ID: <CA+55aFwhFoU5Fp_VTMtVU7XFMZiNvy1J7n7YJsVBu+-k-EH0Nw@mail.gmail.com>
Subject: Re: printk() vs tty_io
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 1:56 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> We probably could, I can have a closer look, but the main question is,
> are we going to commit to no wakeups from console implementations? That
> would mean removing the USB serial console support and other such stuff.

I guess we can't.

So new approach:

 - screw it. the rq lock is just too central, you cannot call printk
from under it. And if you have an oops under it, you're screwed.

   Peter, why do you want to try to work from under the rq lock?

 - Make a special "debug printk" that is not synchronous. Just make it
buffer things, and have it actually print out from a worker thread or
whatever. This one *only* takes the lock for that buffer itself, and
works everywhere. We could probably even do tricks to make it
NMI-safe.

   Make code that isn't an oops or other very synchronous "have to
print out *now*" aim to use this "softer" printk.

Hmm?

                   Linus
