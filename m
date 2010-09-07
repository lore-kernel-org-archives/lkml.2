Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab0IGWM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:12:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63942 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab0IGWMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TST/zYiaWcJGAFpcbHKTmbBVTVLNE+GGjZtFlI16AN+k0zq1pABJyqwKgRmxjWxTvj
         EEek97yoap+ebreoRJWRbmJTlQmYdGmdUy/tm37dq9f5lqMvX/DwGItz0NVD7SRfhVHM
         JPcJoVhUVnKA05KsOf5iF35WbavxIw2yCOVtE=
MIME-Version: 1.0
Date: Tue, 7 Sep 2010 23:12:23 +0100
Message-ID: <AANLkTimqn6=uzE9FawJkWe3w3+AipiMUUcjLd8fo48s1@mail.gmail.com>
Subject: Promoting Crusoe and Geode Processors to i686 Status
From: Nick Lowe <nick.lowe@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

[x86: do not promote TM3x00/TM5x00 to i686-class] revoked the
promotion of Crusoe chips to i686 on the basis that they lacked NOPL.
Is this the right decision now?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a7ef94e6889186848573a10c5bdb8271405f44de

Now that many distributions are using or moving to i686 as a baseline,
shouldn't these chips be promoted to i686?

NOPL is not standard i686, it was originally publicly undocumented by
Intel and has just been supported de facto since the Pentium Pro.
The Crusoe and Geode chips support every instruction of i686 except
NOPL. This causes pain!
The correct solution for GNU/Linux is surely to ensure that when
something is compiled for generic i686, NOPL is nowhere to be seen...

Unfortunately, the semantics for choosing the NOP sequence in binutils
(GAS) have been completely wrong for a while. This, however, has
finally been fixed now!

http://sourceware.org/ml/binutils-cvs/2010-08/msg00057.html
http://gcc.gnu.org/ml/gcc/2010-08/msg00194.html

There is actually a workaround in the kernel for this bug:
[x86: prevent binutils from being "smart" and generating NOPLs for us]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=28f7e66fc1da53997a545684b21b91fb3ca3f321

The coded assumption there was that all i686 class processors did
support the NOPL instruction. This has been changed by the recent AMD
patches so that it is not assumed and it's specified as an extension
where it is supported.

The benefit of full i686 optimisation, which do have real performance
implications, are things like bswap (useful in networking),
cmpxchg/xadd (used in atomics) and cmov (useful in compiler generated
code).

The frustrating thing for me is that broken semantics for i686 have
led to, in my opinion, absurd patches such as the following being
proposed as a workaround to the situation:

http://groups.google.com/group/linux.kernel/browse_thread/thread/c1ec68f5498236dc/617726bec31595ed?show_docid=617726bec31595ed

The point that gets missed there, I think, is that, abstractly, a NOP
is meant to be exactly as it says on the tin, a No Operation.
It's meant to do nothing at all - for a predefined number of clock cycles.

A NOP is commonly used for timing purposes, doesn't this break that contract?

Again, NOPL is not standard i686 - albeit it's an extension supported
by the vast, vast majority of i686 class processors.
If you're compiling generically for i686, however, one should never
assume that it is present.

Bad patches like the above to work around broken compilation, I think,
cause more harm than good. They plaster over the real problem.

So what say you all?

Cheers,

Nick
