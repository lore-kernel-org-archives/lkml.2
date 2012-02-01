Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2BAWUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:20:12 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:6618 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2BAWUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:20:09 -0500
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
Thread-Index: AQHM4PTrUuQzu7yZv0OOPDwQnxvuBZYoRnOAgAAFwICAADkJAIAAB5mAgAAEugCAAAi6QA==
Date: Wed, 1 Feb 2012 22:18:53 +0000
Message-ID: <A3E67C2071F49C4CBC4F17E6D77CDDD232754220@G4W3299.americas.hpqcorp.net>
References: <20120201151918.GC16714@quack.suse.cz>
	 <1328116137.15992.6146.camel@triegel.csb>
	 <CA+55aFyG3EifFPapU6SFYXCjrP+wQOF65hJGs3yyMxCgde5vdg@mail.gmail.com>
	 <1328129620.15992.6453.camel@triegel.csb>
	 <CA+55aFx=4AhdFEgjY3b=85__mGYX8BKcaXpFC=1XZzoFFjeTrw@mail.gmail.com>
 <1328132266.15992.6528.camel@triegel.csb>
In-Reply-To: <1328132266.15992.6528.camel@triegel.csb>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q11MKJSE023750

> From: Torvald Riegel
> > Oh, one of my favorite (NOT!) pieces of code in the kernel is the
> > implementation of the
> >
> >    smp_read_barrier_depends()
> >
> > macro, which on every single architecture except for one (alpha) is a
> no-op.
> >
> > We have basically 30 or so empty definitions for it, and I think we
> > have something like five uses of it. One of them, I think, is
> > performance crticial, and the reason for that macro existing.
> >
> > What does it do? The semantics is that it's a read barrier between
> two
> > different reads that we want to happen in order wrt two writes on the
> > writing side (the writing side also has to have a "smp_wmb()" to
> order
> > those writes). But the reason it isn't a simple read barrier is that
> > the reads are actually causally *dependent*, ie we have code like
> >
> >    first_read = read_pointer;
> >    smp_read_barrier_depends();
> >    second_read = *first_read;
> >
> > and it turns out that on pretty much all architectures (except for
> > alpha), the *data*dependency* will already guarantee that the CPU
> > reads the thing in order. And because a read barrier can actually be
> > quite expensive, we don't want to have a read barrier for this case.
> 
> I don't have time to look at this in detail right now, but it looks
> roughly close to C++11's memory_order_consume to me, which is somehwat
> like an acquire, but just for subsequent data-dependent loads.  Added
> for performance reasons on some architecture AFAIR.
> 
It's intended to address the same problem, though somewhat differently.  (I suspect there was overlap in the people involved?) One reason that C11 took a slightly different path is that compilers can, and sometimes do, remove dependencies, making smp_read_barrier_depends brittle unless it also imposes compiler constraints.

Hans

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
