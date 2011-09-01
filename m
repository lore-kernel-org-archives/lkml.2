Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1IAP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:58:49 -0400
Received: from fn.samba.org ([216.83.154.106]:36833 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452Ab1IAP6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:58:47 -0400
Date: Thu, 1 Sep 2011 08:58:45 -0700
From: Jeremy Allison <jra@samba.org>
To: Ulrich Drepper <drepper@akkadia.org>
Cc: Jeremy Allison <jra@samba.org>, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110901155845.GA758@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
 <4E5D64E8.7000102@kernel.dk>
 <20110830154157.d802d097.akpm@linux-foundation.org>
 <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>
 <20110830155438.bc31ab99.akpm@linux-foundation.org>
 <20110830230342.GB16326@samba2>
 <20110830161130.592df746.akpm@linux-foundation.org>
 <4E5E152A.9050804@akkadia.org>
 <20110831165954.GC1611@samba2>
 <4E5F690C.4010209@akkadia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5F690C.4010209@akkadia.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 07:14:20AM -0400, Ulrich Drepper wrote:
> On 08/31/2011 12:59 PM, Jeremy Allison wrote:
> > I get that, but isn't that what the aio_init(const struct aioinit *init) call is meant to
> > solve ?
> 
> The problem cannot be solved by something that trivial.  Any thread can
> be delayed indefinitely.  If this happens for a file descriptor chances
> are that all threads for the same file descriptor are affected while
> there is I/O for all the other file descriptors ready to run.  I don't
> say this is anywhere near optimal or even good, at least it doesn't
> amplify problems.  If you know you want more parallelism on the same
> file descriptor, dup it.

Yes I did consider that of course. Problem is that leads you to the
nightmare that is losing all fcntl locks on the file when any of the
descriptors are closed. Of course we already have internal work arounds
for that - but they're not scalable in this case.  We'd have to dup on
every read/write, and because of the fcntl lock problem we have to keep
all fd's around until the final close of the file. Don't tell us to
implement our own locking instead because (a) we already do in the case
where we don't need locking consistency with NFS and (b) most vendors insist on
locking consistency with NFS - not good if locks on one protocol aren't
seen by another.

> If you don't want anyone like me implementing
> stupid limitations finally fix the kernel aio interface so that it is
> usable.

If you know the limitation is stupid then one wonders why you added it
in the first place :-). Whatever happened to "the application writer
knows best what they are trying to do" and let us hang ourselves ?

I agree the kernel aio interface is unusable from applications, no
arguments about that.

Jeremy.
