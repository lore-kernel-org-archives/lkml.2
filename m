Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1HaQ77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:59:59 -0400
Received: from fn.samba.org ([216.83.154.106]:41993 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab1HaQ75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:59:57 -0400
Date: Wed, 31 Aug 2011 09:59:54 -0700
From: Jeremy Allison <jra@samba.org>
To: Ulrich Drepper <drepper@akkadia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeremy Allison <jra@samba.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110831165954.GC1611@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
 <4E5D5817.6040704@kernel.dk>
 <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
 <4E5D64E8.7000102@kernel.dk>
 <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
 <20110830230342.GB16326@samba2>
 <20110830161130.592df746.akpm@linux-foundation.org>
 <4E5E152A.9050804@akkadia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5E152A.9050804@akkadia.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 07:04:10AM -0400, Ulrich Drepper wrote:
> On 08/30/2011 07:11 PM, Andrew Morton wrote:
> > I don't know.  Uli cc'ed.
> 
> glibc has to create the parallelism of the operations through threads.
> More threads mean more overhead.  There are insane people out there who
> wrote code which pushed the number of helper threads into the hundreds
> (at that time a high number, today this would be in the thousands).
> Anyway, any scheme which is worth changing the code for would be in the
> kernel.  Only the kernel knows which requests can actually be handled
> concurrently.

I get that, but isn't that what the aio_init(const struct aioinit *init) call is meant to
solve ?

After all:

struct aioinit
  {
    int aio_threads;            /* Maximal number of threads.  */
    int aio_num;                /* Number of expected simultanious requests. */
    int aio_locks;              /* Not used.  */
    int aio_usedba;             /* Not used.  */
    int aio_debug;              /* Not used.  */
    int aio_numusers;           /* Not used.  */
    int aio_idle_time;          /* Number of seconds before idle thread
                                   terminates.  */
    int aio_reserved;
  };

Would seem to be the existing way to limit this. What I don't understand
is why you restrict the pthread aio implementation to only allow
*one* outstanding request per file descriptor ?

Surely it doesn't matter what fd the requests are outstanding on, isn't
it the total number of outstanding threads that really matter ?

By limiting this to one outstanding request per fd, this prevents
any parallelization for requests on a single file for a file server
written to use the aio interface in glibc. Windows SMB2 client issue
multiple simultaneous asynchronous requests on a single file, and
the current glibc implementation throttles them to be linear.

Volker had to create a vfs_aio_fork Samba VFS module that uses
forked processes and shared memory communication to get around
this exact problem. It does improve performance for SMB2 clients,
but means we have many more processes than we'd otherwise need
if we didn't have the restriction.

Do you have benchmark data that shows that limiting outstanding requests
to one per fd is a performance win ?

Do you want to see my patch to glibc that removes this restriction
so we can test this on any benchmarks you used to decide on the
one-request-per-fd restriction ?

Jeremy.
