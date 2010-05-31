Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0EaJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:40:37 -0400
Received: from ozlabs.org ([203.10.76.45]:45285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab0EaJkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:40:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Mon, 31 May 2010 19:10:31 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <201005252300.07739.rjw@sisk.pl> <201005271456.20003.rusty@rustcorp.com.au> <20100527184602.GF7351@jenkins.ifup.org>
In-Reply-To: <20100527184602.GF7351@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005311910.32407.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 04:16:02 am Brandon Philips wrote:
> On 14:56 Thu 27 May 2010, Rusty Russell wrote:
> > On Thu, 27 May 2010 08:26:25 am Rafael J. Wysocki wrote:
> > > On Wednesday 26 May 2010, Rusty Russell wrote:
> > > > I suspect that the increased parallelism enabled by this patch uncovered this
> > > > bug.  Does this fix it?
> > > 
> > > Since the commit has been reverted, do you still want me to test this patch?
> > > Quite frankly I'd prefer to test a complete replacement for that commit on top
> > > of current -git.
> > 
> > OK, combo meal deal below, against Linus' latest.  I'd really appreciate
> > a report, since AFAIK you're the only one hitting it, and only when that
> > other (now reverted) patch was applied.
> 
> I tested this patch on my machine on top of Linus's latest and it
> fixes the issue. Without the patch and using Linus's latest I
> reproduce the original issue:
> 
> [   60.836022] bnx2: gave up waiting for init of module libcrc32c.
> [   60.847997] bnx2: Unknown symbol crc32c
> 
> Note: Again, since I don't have bnx2x hardware I forced bnx2.ko to
> depend on libcrc32c as bnx2x does:
>   http://ifup.org/~philips/review/bnx2-hack-to-use-libcrc32c.patch
> 
> > As an side to Brandon: I can see how my patch fixed an explicit
> > request_module inside module_init (that's how I tested it).  I can't
> > see how we have a problem with an implicit dependency such as
> > bne2x->crc32.  Modules go into the live state without retaking the
> > lock.
> 
> libcrc32c is doing an explicit request_module inside of its
> module_init. Follow the call chain in libcrc32c_mod_init()

Thanks for confirmation, I figured that must be the case as I pondered
it on the weekend after sending my query.

Linus didn't like dropping the lock, so I'll create a more ambitious patch
which reduces the lock coverage to those places which really need it.

Cheers,
Rusty.


