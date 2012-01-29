Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2A2BmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 20:42:23 -0500
Received: from mail.q3q.us ([209.40.103.103]:41661 "EHLO mail.q3q.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab2A2BmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 20:42:18 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jan 2012 20:42:17 EST
Date: Sat, 28 Jan 2012 20:32:50 -0500
From: Bryan Jacobs <its@easytoremember.us>
To: linux-kernel@vger.kernel.org
Subject: /proc/[pid]/mem write implications
Message-ID: <20120128203250.090abec6@easytoremember.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/FSycFyx/NtnLZ4DEFMzqtgr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FSycFyx/NtnLZ4DEFMzqtgr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Dear LKML,

I have a few questions on the recent change to allow writing
to /proc/[pid]/mem. If I understand correctly, the recent
privilege-escalation vulnerability was fundamentally caused by
incorrectly verifying that the memory being written to by a process was
its own. The goal was to only allow processes to write to their own
memory space - this was deemed harmless.

But I think that allowing arbitrary processes to write to **their own**
memory via a file descriptor might in itself be problematic. Please,
help me understand how this is safe.

Imagine an interpreted program running in a "secure" virtual machine.
This machine makes certain guarantees about program behavior
(typing, method privacy, &c) which it verifies through a
combination of static analysis and runtime checks. These guarantees rely
on the VM being able to instrument certain calls with the
aforementioned runtime safety checks. The VM runs in the same address
space as the interpreted program.

A concrete example of one such virtual machine is the Java VM. Another
is the PHP interpreter.

Now, let's say this VM has a function for opening a file in the local
filesystem. It outsources permissions checking to the host system; any
file which the user launching the VM could read or write, the VM could
also.

Let's say I run some interpreted code which opens up /proc/self/mem,
seeks it to the VM's location in memory (possibly using a signature I
know to orient myself in a randomized address space), I find the
portion of the VM's code which handles the dynamic checking, and I
brutally write NOPs all over it.

Now whenever the VM goes to make a safety check, it will pass, leaving
any interpreted code hosted by that VM free to do whatever it likes!

I see that this could be countered by SELinux or other MAC schemes, but
it seems to me like there may be a few ramifications to allowing
arbitrary-address writes to one's own virtual address space which
haven't been fully explored - or at least, I haven't seen any bulletins
or significant discussion.

Please, let the more knowledgeable correct me. I want to be wrong very
badly.

Bryan Jacobs

--Sig_/FSycFyx/NtnLZ4DEFMzqtgr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBCAAGBQJPJKHEAAoJEK0vMvSakaIQ5mgQAJqm2esJEVWhJ8my7AaHwv/2
7I9d9QH3FVkGRuyBAzOBng8468vFCR2QQMajCG7x5v3uSi75cLWb4is5mdLBRRQW
GshDx/laKN6HRhce+STFvW6T3LuQEP9UaNoCPtG4EU0znbG3CwTjSO6OLqafbWfo
G0gSnxqduz7TdZLJF4qVNfhp1X1Z1P9hGqfWOSS2HgnEr670OgtnljVunPADRggO
P9qzqbpAmeOSj2XFDF33kWIFpiE+CNtxgVJpw0WBzXQQ/ku+MFMjAitb0u8RcX9B
XF1Een/dY9QyOUCFVY5ajfHBBnUTmdvDqClfXhqWyHHz+XQoLJexplX1oBUn1wZa
s4Uq1FCE/fC8kSDAeSfN+POtAu05Y1q3i3WRUh4TwaoylS63aoS5VyNeB8GP7qEj
lXqy9kHngJzbWFlCLHTnKaf6t2lEPbZrFyt2NXC7zvVkc4W/ZBTWbccLt+yuY1U0
d9k+xDGSuI2R8F37V+yVf+0r3pCyq3sWbJJ4z9bQ+/ySGn5yJwicnZlDU341SrKL
uMP1cZFIrwG/AFsq7FcHCAGjkUmh7fRtmSbeBW+L8of3pLoWonfzQ9I7Q0Gov2Kd
ENFomveh2yvrBuYpNXcT14qq2aUL344H7QDmnciK/6DeZEQ2nq48A7pHO06+RNx1
Dt7n19iPvk+87QSUvsMO
=yb9b
-----END PGP SIGNATURE-----

--Sig_/FSycFyx/NtnLZ4DEFMzqtgr--
