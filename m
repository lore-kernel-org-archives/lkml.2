Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2BAV1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:27:15 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48476 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526Ab2BAV1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:27:12 -0500
From: "Boehm, Hans" <hans.boehm@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "rguenther@suse.de" <rguenther@suse.de>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: RE: Memory corruption due to word sharing
Thread-Topic: Memory corruption due to word sharing
Thread-Index: AQHM4PTrUuQzu7yZv0OOPDwQnxvuBZYoPuuAgAARBQCAACK6AIAADxkAgAAFFACAAAIaIA==
Date: Wed, 1 Feb 2012 21:25:39 +0000
Message-ID: <A3E67C2071F49C4CBC4F17E6D77CDDD232754183@G4W3299.americas.hpqcorp.net>
References: <20120201151918.GC16714@quack.suse.cz>
 <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
 <1328118174.15992.6206.camel@triegel.csb>
 <CA+55aFw=z2SKFGoSE5e_0ZmKcAAjK5q0DBM4PaxBH2D9tuikzA@mail.gmail.com>
 <1328128874.15992.6430.camel@triegel.csb>
 <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
In-Reply-To: <CA+55aFx4SdtZcYaWZ-=JG3yVFJxsBa-Yqn0m+h4Y=QHdRjx6_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Linus Torvalds
> Don't try to make it anything more complicated. This has *nothing* to
> do with threads or functions or anything else.
> 
> If you do massive inlining, and you don't see any barriers or
> conditionals or other reasons not to write to it, just write to it.
> 
> Don't try to appear smart and make this into something it isn't.
> 
> Look at the damn five-line example of the bug. FIX THE BUG. Don't try
> to make it anything bigger than a stupid compiler bug. Don't try to
> make this into a problem it simply isn't.
> 
My impression is that all of us not on the hook to fix this are in violent agreement on this example.

Here are some more interesting ones that illustrate the issues (all declarations are non-local, unless stated otherwise):

struct { char a; int b:9; int c:7; char d} x;

Is x.b = 1 allowed to overwrite x.a?  C11 says no, essentially requiring two byte stores.  Gcc currently does so.  I'm not sure I understand Linus' position here.


int count;
/* p and q are local */

for (q = p; q = q -> next; q != 0) if (q -> data > 0) ++count;

Can count be promoted to a register, and thus written even if there are no positive elements.  C11 says no. gcc at least used to do this.


for (q = p; q = q -> next; q != 0) { ++count; if (rare_cond) f(); }

Same question, with cond saved and restored around the call to f() (which might include a fence).  C11 says no.  I think Linus is also arguing for no.


for (i = 0; i < 1000; ++i) { if (i%1) a[i] = i; }

Can I vectorize the loop writing back the original even values, and thus writing all entries of the array.  C11 and Linus both say no.


My impression is that we are generally in agreement.

Hans
