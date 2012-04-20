Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2DTP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:57:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64466 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2DTP5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120420080914.GF6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk> <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 08:56:57 -0700
X-Google-Sender-Auth: whSKeGZyf-8B8NNGoRcr-lRmy7w
Message-ID: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 1:09 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Note that we do *not* need to bother with fput_light() - even if it does
> fput(), that fput() won't usually be the final one.

Ack. Most of the time the fput_light()->fput will just decrement the use count.

> We also get something else out of that - AFAICS, the kludge in __scm_destroy()
> can be killed after that.  We did it to prevent recursion on fput(), right?
> Now that recursion will be gone...

Hmm.. That points out that we may have a *lot* of these pending final
fput's, though. So the deferral queueing should be fairly light. What
were your particular plans for it?

This actually sounds like a fairly good usage-case for Oleg's new
task_work_add() thing. That would defer the final fput, but at the
same time guarantee that it gets done before returning to user space -
in case there are any issues with synchronous actions. Have you looked
at Oleg's series? You weren't cc'd because it didn't affect you, but
look at lkml for "task_work_add()" to find it.

NOTE! If pure kernel threads do fput() deferral (and maybe they do -
I'm thinking nfsd etc), then the task-work thing might need some extra
thought.

                     Linus
