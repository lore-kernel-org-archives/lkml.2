Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2BATqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:46:47 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17096 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2BATqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:46:44 -0500
From: "Boehm, Hans" <hans.boehm@hp.com>
To: Torvald Riegel <triegel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "rguenther@suse.de" <rguenther@suse.de>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: RE: Memory corruption due to word sharing
Thread-Topic: Memory corruption due to word sharing
Thread-Index: AQHM4PTrUuQzu7yZv0OOPDwQnxvuBZYoPuuAgAARBQCAAB1GYA==
Date: Wed, 1 Feb 2012 19:44:40 +0000
Message-ID: <A3E67C2071F49C4CBC4F17E6D77CDDD23275408E@G4W3299.americas.hpqcorp.net>
References: <20120201151918.GC16714@quack.suse.cz>
	 <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb>
In-Reply-To: <1328118174.15992.6206.camel@triegel.csb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q11JkqQj021241

I'm clearly with Torvald here.

The original set of problems here is very clearly addressed by the C+11/C11 memory model.  It clearly implies, among other things:

- Updating a bit-field may interfere (create a data race with) other updates to that same contiguous sequence of bit-fields, but not with other adjacent fields.  Updating non-bit-fields may not interfere with accesses to any other field.  A zero length bit-field breaks a sequence of bit-fields.  The initial example here is a clear compiler bug by C11 semantics.
- Bit-fields may be updated, and indeed must be updated, in some cases, with multiple smaller stores.  Doing anything else would violate the preceding rule.
- Spurious writes to a variable may never be introduced.
- "Volatile" has nothing to do with thread interactions.  Atomic variables were introduced to allow unprotected accesses to shared objects.  (It doesn't make sense to use volatile for this for a number of good, mostly historically motivated reasons.  See http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2016.html if you really care.)

(Technically, this applies to C11 threads, because that's all it can talk about.  But an implementation would have to be insane to restrict it to that.  For implementations of atomic operations, I would expect most compilers to assume memory mappings and consistency as normally seen by user processes.)

C11 is a published standard.  Last I checked, gcc did not follow many of the above rules.  It looks like major changes were recently merged into the gcc trunk, and I haven't had a chance to test those, so it may well be fixed.  But more importantly, so far I haven't read anything here to dissuade me that they are the right target.

Hans

> -----Original Message-----
> From: linux-ia64-owner@vger.kernel.org [mailto:linux-ia64-
> owner@vger.kernel.org] On Behalf Of Torvald Riegel
> Sent: Wednesday, February 01, 2012 9:43 AM
> To: Linus Torvalds
> Cc: Jan Kara; LKML; linux-ia64@vger.kernel.org; dsterba@suse.cz;
> ptesarik@suse.cz; rguenther@suse.de; gcc@gcc.gnu.org
> Subject: Re: Memory corruption due to word sharing
> 
> On Wed, 2012-02-01 at 08:41 -0800, Linus Torvalds wrote:
> > If the gcc people aren't willing to agree that this is actually a
> flaw
> > in the standard (one that is being addressed, no less)
> 
> It has been addressed in the standards.
> 
> > and try to fix
> > it,
> 
> Again, this is being worked on, see
> http://gcc.gnu.org/wiki/Atomic/GCCMM
> 
> > we just have to extend our assumptions to something like "a
> > compiler would be stupid to ever access anything bigger than the
> > aligned register-size area". It's still just an assumption, and
> > compiler people could be crazy, but we could just extend the current
> > alpha rules to cover not just "int", but "long" too.
> 
> So, let's ignore everyone's craziness (the kernel is not the only GCC
> client...) and think about how we can improve the situation.
> 
> We need a proper memory model.  No vague assumptions with lots of
> hand-waving.  If you think that this is simple stuff and can
> sufficiently described by "don't do anything stupid", then please have
> a
> look at the issues that the Java memory model faced, and all the
> iterations of the C++11/C11 model and discussions about it.
> 
> The only candidate that I see is the C++11/C11 model.  Any other
> suggestions?
> 
> Now, if we assume this model, what does the kernel community think
> about
> it?  It might be good to split this discussion into the following two
> points, to avoid syntax flame wars:
> 1) The model itself (ie, the memory orders, ordering guarantees, (lack
> of) progress guarantees, etc.).
> 2) The syntax/APIs to specify atomics.
> 
> If something else or more is needed, the compiler needs to have a
> formal
> specification for that.  This will help users too, because it avoids
> all
> the ambiguities.
> 
> > Sure, the compiler people could use "load/store multiple" or
> something
> > like that, but it would be obviously crazy code, so if it happens
> past
> > a register size, at least you could argue that it's a performance
> > issue and maybe the gcc people would care.
> >
> > HOWEVER. The problem with the alpha rules (which, btw, were huge, and
> > led to the CPU designers literally changing the CPU instruction set
> > because they admitted they made a huge mistake) was never so much the
> > occasional memory corruption, as the fact that the places where it
> > could happen were basically almost impossible to find.
> >
> > So we probably have tons of random places in the kernel that violate
> > even the alpha rules - because the corruption is so rare, and the
> > architecture was so rare as to making the corruption even harder to
> > find.
> 
> I assume you still would want a weak memory model, or not?  (That is,
> rely on data-race-freedom, only atomics do not contribute to data
> races,
> and you need to mark data used for synchronization (or which is just
> accessed concurrently) as atomics).
> 
> If so, you need to tell the compiler which variables etc. are atomics.
> 
> > I assume this code generation idiocy only happens with bitfields? The
> > problem is, we really don't want to make all bitfields take up 64
> bits
> > just because we might have a lock or something else next to them. But
> > we could probably re-order things (and then *occasionally* wasting
> > memory) if we could just find the ones that are problematic.
> 
> If the compiler is aware what is a lock (or atomics, or similar), then
> a
> correct implementation should leave the lock alone.  But in a weak
> memory model, it needs to know what is a lock.
> (Same goes for volatile obviously, like in the other example posted in
> the thread where the bitfields interfered with the volatile.)
> 
> >
> > It's finding the problematic ones that is the issue. Which is why the
> > compiler should just generate code that matches what we told it to
> do,
> 
> So, would it be okay to tell the compiler which part of the state is
> accessed concurrently (ie, locks, atomics, ...)?
> 
> 
> Torvald
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
