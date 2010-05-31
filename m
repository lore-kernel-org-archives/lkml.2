Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0EaRmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:42:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45611 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0EaRmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:42:31 -0400
Date: Mon, 31 May 2010 19:42:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, herbert@gondor.hengli.com.au,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100531174225.GE10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03F04D.4040200@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 07:22:21PM +0200, Milan Broz wrote:
> On 05/31/2010 06:04 PM, Andi Kleen wrote:
> > DM-CRYPT: Scale to multiple CPUs
> > 
> > Currently dm-crypt does all encryption work per dmcrypt mapping in a
> > single workqueue. This does not scale well when multiple CPUs
> > are submitting IO at a high rate. The single CPU running the single
> > thread cannot keep up with the encryption and encrypted IO performance
> > tanks.
> 
> This is true only if encryption run on the CPU synchronously.

That's the common case isn't it?

On asynchronous crypto it won't change anything compared
to the current state.

> I did a lot of experiments with similar design and abandoned it.
> (If we go this way, there should be some parameter limiting
> used # cpu threads for encryption, I had this configurable
> through dm messages online + initial kernel module parameter.)

One thread per CPU is exactly the right number.

If you want less threads used submit IO from less CPUs (e.g.
with a cpuset). More never makes sense.

The only alternative possibility might be one per core
on a SMT system, but if that's done it should be implemented
in the workqueue interface. Right now one per SMT thread
is fine though.

> 1) How this scale together with asynchronous
> crypto which run in parallel in crypto API layer (and have limited
> resources)? (AES-NI for example)

AES-NI is not asynchronous and doesn't have limited resources.

> 
> 2) Per volume threads and mempools were added to solve low memory
> problems (exhausted mempools), isn't now possible deadlock here again?

Increasing the number of parallel submitters does not increase deadlocks
with mempool as long as they don't nest.  They would just
block each other, but eventually make progress as one finishes. 

This only matters when you're low on memory anyways, 
in the common case with enough memory there is full parallelism.

Nesting is possible, but the same as before.

> 
> (Like one CPU, many dm-crypt volumes - thread waiting for allocating
> page from exhausted mempool, blocking another request (another volume)

As long as they are not dependent that is not a deadlock
(and they are not) 

> Anyway, I still think that proper solution to this problem is run
> parallel requests in cryptoAPI using async crypt interface,
> IOW paralelize this on cryptoAPI layer which know best which resources
> it can use for crypto work.

I discussed this with Herbert before and he suggested that it's better
done in the submitter for the common case. There is a parallel crypt
manager now (pcrypt), but it has more overhead than simply doing it directly.
It can be still used when it is instantiated, but it's likely
only a win with very slow CPUs. For the case of reasonably fast
CPUs all that matters is that it scales.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
