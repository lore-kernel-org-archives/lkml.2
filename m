Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2DTQI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:08:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2DTQIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:08:55 -0400
Date: Fri, 20 Apr 2012 17:08:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420160848.GG6871@ZenIV.linux.org.uk>
References: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:56:57AM -0700, Linus Torvalds wrote:
> > We also get something else out of that - AFAICS, the kludge in __scm_destroy()
> > can be killed after that. ?We did it to prevent recursion on fput(), right?
> > Now that recursion will be gone...
> 
> Hmm.. That points out that we may have a *lot* of these pending final
> fput's, though. So the deferral queueing should be fairly light. What
> were your particular plans for it?

Doing removal from per-sb list immediately (i.e. before possible
deferral; we skip ones with zero ->f_count when we walk the list
anyway), then in case we decide to defer just move them to per-CPU
list and schedule work on that CPU, with handler that will pull the
corresponding list out and do the rest of __fput() for everything
in that list.  No extra locking, just preempt_disable() around the
"move to per-CPU list" bit.  Or a per-CPU spinlock with worker not
being tied to specific CPU and told which CPU's list to work with.
How does CPU hotplug interact with work scheduled on CPU about to
be taken down, BTW?
