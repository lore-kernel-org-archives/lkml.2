Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1DGVnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 17:43:17 -0400
Received: from wnohang.net ([178.79.154.173]:39920 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab1DGVnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 17:43:15 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net ED0BE24463
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net E16E02416C
Date: Fri, 8 Apr 2011 03:13:07 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110407214307.GA6449@Xye>
References: <cover.1302137785.git.luto@mit.edu>
 <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com>
 <20110407164245.GA21838@one.firstfloor.org>
 <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Thu, Apr 07, 2011 at 10:20:31AM -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>On Thu, Apr 7, 2011 at 9:42 AM, Andi Kleen <andi@firstfloor.org> wrote:

>> I'm sure a single barrier would have fixed the testers, as you point out,
>> but the goal wasn't to only fix testers.
>
>You missed two points:
>
> - first off, do we have any reason to believe that the rdtsc would
>migrate down _anyway_? As AndyL says, both Intel and AMD seem to
>document only the "[lm]fence + rdtsc" thing with a single fence
>instruction before.
>
>  Instruction scheduling isn't some kind of theoretical game. It's a
>very practical issue, and CPU schedulers are constrained to do a good
>job quickly and _effectively_. In other words, instructions don't just
>schedule randomly. In the presense of the barrier, is there any reason
>to believe that the rdtsc would really schedule oddly? There is never
>any reason to _delay_ an rdtsc (it can take no cache misses or wait on
>any other resources), so when it is not able to move up, where would
>it move?
>
>IOW, it's all about "practical vs theoretical". Sure, in theory the
>rdtsc could move down arbitrarily. In _practice_, the caller is going
>to use the result (and if it doesn't, the value doesn't matter), and
>thus the CPU will have data dependencies etc that constrain
>scheduling. But more practically, there's no reason to delay
>scheduling, because an rdtsc isn't going to be waiting for any
>interesting resources, and it's also not going to be holding up any
>more important resources (iow, sure, you'd like to schedule subsequent
>loads early, but those won't be fighting over the same resource with
>the rdtsc anyway, so I don't see any reason that would delay the rdtsc
>and move it down).
>
>So I suspect that one lfence (before) is basically the _same_ as the
>current two lfences (around). Now, I can't guarantee it, but in the
>absense of numbers to the contrary, there really isn't much reason to
>believe otherwise. Especially considering the Intel/AMD
>_documentation_. So we should at least try it, I think.

If only one lfence or serializing instruction is to be used, can't we
just use RDTSCP instruction (X86_FEATURE_RDTSCP,available only in >=
i7's and AMD)  which both provides TSC as well as an upward serializing
guarantee. I see that instruction being used elsewhere in the kernel to
obtain the current cpu/node (vgetcpu), is it not possible to use it in
this case as well ?
>
> - the reason "back-to-back" (with the extreme example being in a
>tight loop) matters is that if something isn't in a tight loop, any
>jitter we see in the time counting wouldn't be visible anyway. One
>random timestamp is meaningless on its own. It's only when you have
>multiple ones that you can compare them. No?

I was looking at this documentation -
http://download.intel.com/embedded/software/IA/324264.pdf (How to
Benchmark Code Execution Times on Intel IA-32 and IA-64) where they try
to precisely benchmark code execution times, and later switch to using
RDTSCP twice to obtain both upward as well as downward guarantees of the
barrier. Now, based on context (loop or not), will a second serializing
instruction be needed or can that too be avoided ?

>
>So _before_ we try some really clever data dependency trick with new
>inline asm and magic "double shifts to create a zero" things, I really
>would suggest just trying to remove the second lfence entirely and see
>how that works. Maybe it doesn't work, but ...
>
>                              Linus

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNni/rAAoJEKYW3KHXK+l3Kh4IAJHaFH5fmRDNAMCsDzIFrO2c
iw0tO6tBFpi7GuhVODJinjL6fNfLQ2UwCbO+5KA/MCW2orHBcTRkaicDp3jbVzB2
Lclvy6EyATXZ5pIu61S/i7bLzPhTyC9kbHjXSts4BiuiSnnnoHt+5kiOmdosXJSm
7uhr/bCLBcLhrcY8RcgeTQ1knDPbTwcG4a8uFGyFU6mw5zzw0A2t+I/X0vIvQqkq
d45EKobwYarvNre5UO86Zvrhw1yK3y7b3DKvduvNgnngJfsQPN06PGpoz6xijFxA
XvI00JjP6iYvvsLem7ocGLwzaV308eVquZ40viz0kY4QGQjTbmirp8b7Oncd8Xs=
=jbb5
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
