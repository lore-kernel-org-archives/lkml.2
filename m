Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2K2TMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:12:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38688 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2TMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:12:18 -0500
Date: Thu, 29 Nov 2012 11:12:14 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129191214.GG15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-23-git-send-email-koverstreet@google.com>
 <m28v9kgsen.fsf@firstfloor.org>
 <20121129185720.GE15094@google.com>
 <20121129185953.GW16230@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129185953.GW16230@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 07:59:53PM +0100, Andi Kleen wrote:
> On Thu, Nov 29, 2012 at 10:57:20AM -0800, Kent Overstreet wrote:
> > On Thu, Nov 29, 2012 at 10:45:04AM -0800, Andi Kleen wrote:
> > > Kent Overstreet <koverstreet@google.com> writes:
> > > 
> > > > This implements a refcount with similar semantics to
> > > > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > > > but dynamically switches to per cpu refcounting when the rate of
> > > > gets/puts becomes too high.
> > > 
> > > This will only work if you put on the same CPU as you get, right?
> > 
> > Nope, no such restriction.
> 
> I don't see how you ensure you're doing the __this_cpu_dec on the same
> CPU as you did the get

I'm not.

(I probably should've documented this a bit more before I sent it
out...)

The trick is that we don't watch for the refcount hitting 0 until we're
shutting down - so this only works if you keep track of your initial
refcount. As long as we're not shutting down, we know the refcount can't
hit 0 because we haven't released the initial refcount.

When we do want to shutdown, the user calls percpu_ref_kill() which
converts the percpu ref back to a single atomic ref, calls
synchronize_rcu(), then sets the ref's state to PCPU_REF_DEAD.

Only then does the caller drop the initial ref, and percpu_ref_put()
only does atomic_dec_and_test() when the ref is dead - otherwise it's
just doing a decrement.

Also, with the percpu refs - you can have all your gets happening on one
cpu, and all your puts happening on another - the percpu refs are
unsigned ints so overflow isn't undefined, and if they wrap they'll
still sum to the right value when we go to shut things down in
percpu_ref_kill().
