Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1DRTdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:33:16 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59116 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DRTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=TrhlYxj9thndn0GtnRfyupfeaZmSuUs7tkcaS3SbIBFLntJKjPGkvtPoVxETtYMmv7
         VYLLJ34oSERQdejcHt5ziK3sdLGgpn2nCqRu2ZH2vwnw985zS+GFo4aWsVCqExk1AZ3n
         1dAk+9J2Vet4XcEB5OR5PmOdtHC02+675LG4o=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 18 Apr 2011 15:32:52 -0400
X-Google-Sender-Auth: b8PuGwPeS6Y1kSBl8bNKKSKpbVU
Message-ID: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
Subject: [RFT] Please test rdtsc on various x86-64 hardware (app included)
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

I'd appreciate some help testing rdtsc's ordering wrt memory on
various hardware.  You can download evil-clock-test code at:

https://gitorious.org/linux-test-utils/linux-clock-tests/blobs/raw/master/evil-clock-test.cc

or pull from:

git://gitorious.org/linux-test-utils/linux-clock-tests.git

or see it online at:

https://gitorious.org/linux-test-utils/linux-clock-tests

No kernel patches required.  If you have an old glibc then timing_test
will fail to build.  You can ignore that problem, because I'm only
really interested in what evil-clock-test says.

On Sandy Bridge, you'll see something like:

$ ./evil-clock-test
CPU vendor   : GenuineIntel
CPU model    : Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz
CPU stepping : 7
TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
Using lfence_rdtsc because you have an Intel CPU
Will test the "lfence;rdtsc" clock.
Now test passed  : margin 68 with 78370992 samples
Load3 test passed: margin 71 with 12740250 samples
Load test passed : margin 60 with 17743461 samples
Store test failed as expected: worst error 3316 with 14666029 samples

I've tested on Sandy Bridge, Allendale (i.e. Pentium Dual-Core),
Bloomfield. and C2D.  I don't have any AMD machines with usable tscs,
and I haven't tested on systems with multiple packages.  (If you're
feeling adventurous, you can play with the -p option.  If you give it
two cpu numbers, comma-separated, which live on different packages,
maybe you'll learn something interesting.  It might also be
interesting to try evil-clock-test -3 -p a,b,c where c is on a
different package from a and b.

(Oddly enough, the test *passes* on my C2D box, even though the kernel
thinks that my TSC halts in idle.  This is with a fair amount of time
spent in C6 and even after a suspend/resume cycle.  I'm not sure
what's going on there.)

For those of you who really care about this stuff, the 'store test'
will *fail* on most Intel systems.  IMO that's OK, since fixing it
would slow everything down and since I don't think it deserves to
pass, even though it looks like the tsc is warping.

--Andy
