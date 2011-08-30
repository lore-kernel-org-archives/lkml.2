Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1H3XMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:12:53 -0400
Received: from fn.samba.org ([216.83.154.106]:54515 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1H3XMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:12:50 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 19:12:50 EDT
Date: Tue, 30 Aug 2011 16:03:42 -0700
From: Jeremy Allison <jra@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110830230342.GB16326@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
 <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
 <4E5D5817.6040704@kernel.dk>
 <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
 <4E5D64E8.7000102@kernel.dk>
 <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830155438.bc31ab99.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 03:54:38PM -0700, Andrew Morton wrote:
> 
> Also, glibc has userspace for POSIX AIO.  A successful kernel-based
> implementation would result in glibc migrating away from its current
> implementation.  So we should work with the glibc developers on ensuring
> that the migration can happen.

Unfortunately the glibc userspace POSIX AIO limits asynchronicity to
one outstanding request per file descriptor. From aio_misc.c in glibc:

  if (runp != NULL
      && runp->aiocbp->aiocb.aio_fildes == aiocbp->aiocb.aio_fildes)
    {
      /* The current file descriptor is worked on.  It makes no sense
         to start another thread since this new thread would fight
         with the running thread for the resources.  But we also cannot
         say that the thread processing this desriptor shall immediately
         after finishing the current job process this request if there
         are other threads in the running queue which have a higher
         priority.  */

      /* Simply enqueue it after the running one according to the
         priority.  */

I have often wondered if this is actually the case ? I created
my own glibc with a patches AIO that removed this restriction
(thus had multiple outstanding threads on a single fd). In testing
I saw a dramatic increase in performance (2x speedup) but then
testing with use in actual code (Samba smbd) it made the client
throughput *worse*. I never got to the bottom of this and so
didn't submit my fixes to glibc.

Any ideas if this is still the case ? Or comments on why glibc
insists on only one outstanding request per fd ? Is this really
needed for kernel performance ?

Jeremy.
