Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0LNJMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:12:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60041 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab0LNJMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:12:13 -0500
Subject: Re: kernel BUG at mm/truncate.c:475!
From: Peter Zijlstra <peterz@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michael Leun <lkml20101129@newton.leun.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.LSU.2.00.1012132246580.6071@sister.anvils>
References: <20101130194945.58962c44@xenia.leun.net>
	 <alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>
	 <E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu>
	 <20101201124528.6809c539@xenia.leun.net>
	 <E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
	 <20101202084159.6bff7355@xenia.leun.net>
	 <20101202091552.4a63f717@xenia.leun.net>
	 <E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu>
	 <20101202115722.1c00afd5@xenia.leun.net>
	 <20101203085350.55f94057@xenia.leun.net>
	 <E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu>
	 <20101206204303.1de6277b@xenia.leun.net>
	 <E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu>
	 <20101213142059.643f8080.akpm@linux-foundation.org>
	 <alpine.LSU.2.00.1012132246580.6071@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Dec 2010 10:11:35 +0100
Message-ID: <1292317895.6803.1329.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 23:31 -0800, Hugh Dickins wrote:
> > > +   clear_bit_unlock(AS_UNMAPPING, &mapping->flags);
> > > +   smp_mb__after_clear_bit();
> > > +   wake_up_bit(&mapping->flags, AS_UNMAPPING);
> > > +
> > 
> > I do think this was premature optimisation.  The open-coded lock is
> > hidden from lockdep so we won't find out if this introduces potential
> > deadlocks.  It would be better to add a new mutex at least temporarily,
> > then look at replacing it with a MiklosLock later on, when the code is
> > bedded in.
> > 
> > At which time, replacing mutexes with MiklosLocks becomes part of a
> > general "shrink the address_space" exercise in which there's no reason
> > to exclusively concentrate on that new mutex!
> 
> Yes, I very much agree with you there: valiant effort by Miklos to
> avoid bloat, but we're better off using a known primitive for now.

Also, bit-spinlocks _suck_.. They're not fair, they're expensive and
like already noted they're hidden from lockdep.

Ideally we should be removing bit-spinlocks from the kernel, not add
more.
