Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab0E0SsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:48:15 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:39724 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab0E0SsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:48:14 -0400
Date: Thu, 27 May 2010 11:46:02 -0700
From: Brandon Philips <brandon@ifup.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Regression] Crash in load_module() while freeing args
Message-ID: <20100527184602.GF7351@jenkins.ifup.org>
References: <201005252300.07739.rjw@sisk.pl>
 <201005262127.26235.rusty@rustcorp.com.au>
 <201005270056.25748.rjw@sisk.pl>
 <201005271456.20003.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005271456.20003.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:56 Thu 27 May 2010, Rusty Russell wrote:
> On Thu, 27 May 2010 08:26:25 am Rafael J. Wysocki wrote:
> > On Wednesday 26 May 2010, Rusty Russell wrote:
> > > I suspect that the increased parallelism enabled by this patch uncovered this
> > > bug.  Does this fix it?
> > 
> > Since the commit has been reverted, do you still want me to test this patch?
> > Quite frankly I'd prefer to test a complete replacement for that commit on top
> > of current -git.
> 
> OK, combo meal deal below, against Linus' latest.  I'd really appreciate
> a report, since AFAIK you're the only one hitting it, and only when that
> other (now reverted) patch was applied.

I tested this patch on my machine on top of Linus's latest and it
fixes the issue. Without the patch and using Linus's latest I
reproduce the original issue:

[   60.836022] bnx2: gave up waiting for init of module libcrc32c.
[   60.847997] bnx2: Unknown symbol crc32c

Note: Again, since I don't have bnx2x hardware I forced bnx2.ko to
depend on libcrc32c as bnx2x does:
  http://ifup.org/~philips/review/bnx2-hack-to-use-libcrc32c.patch

> As an side to Brandon: I can see how my patch fixed an explicit
> request_module inside module_init (that's how I tested it).  I can't
> see how we have a problem with an implicit dependency such as
> bne2x->crc32.  Modules go into the live state without retaking the
> lock.

libcrc32c is doing an explicit request_module inside of its
module_init. Follow the call chain in libcrc32c_mod_init()

libcrc32c_mod_init
 crypto_alloc_shash
  crypto_alloc_tfm
   crypto_find_alg
    crypto_alg_mod_lookup
     crypto_larval_lookup
      request_module

Cheers,

	Brandon
