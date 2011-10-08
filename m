Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1JHRND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 13:13:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1JHRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 13:13:01 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=LtiaR5B5kVEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=cahJxx6UZF3xCAIBq47FAQ==:17 a=dcgnAszI5WCZjGCqGecA:9 a=AcqmeVZW7B0ZAnhOgFAA:7 a=QEXdDO2ut3YA:10 a=nXXYuOTM90UGdzn0KE8A:9 a=cahJxx6UZF3xCAIBq47FAQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 69.204.222.235
Message-Id: <20111008170227.792806635@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Oct 2011 13:02:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3][RFC] trace_printk() using percpu buffers
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Peter,

You had issues with the previous version of my trace_printk() code.
I rewrote it to do the following.

By default, it still uses the single buffer protected by a spinlock
and an atomic (for NMIs). The NMI case can cause dropped prints if
the NMI happens while a trace_printk() is processing.

When trace_printk_percpu is enabled, either via the trace options or
the kernel command line, then two sets of percpu buffers are made,
one for normal and irqs (interrupts are still disabled), and the other
is for NMIs. These can be added or removed at anytime.

The last patch adds a CONFIG_TRACE_PRINTK_PERCPU that makes trace_printk()
permanently use two sets of per_cpu buffers, and these can not be
removed. This will give the least amount of overhead for trace_printk()
with the sacrifice of memory overhead. This is an option I could imagine
you would just set and forget about.

Let me know your thoughts.

Thanks,

-- Steve


Steven Rostedt (3):
      tracing: Do not allocate buffer for trace_marker
      tracing: Add optional percpu buffers for trace_printk()
      tracing: Add config to permanently have trace_printk() use percpu buf=
fers

----
 Documentation/kernel-parameters.txt |   11 +
 kernel/trace/Kconfig                |   18 ++
 kernel/trace/trace.c                |  360 ++++++++++++++++++++++++++++---=
----
 kernel/trace/trace.h                |    1 +
 4 files changed, 320 insertions(+), 70 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkISaAAoJEIy3vGnGbaoAchsQAJUryxzQx++tRhUWh4pxvJ7U
FiYASmtWgG+Zm9vPcQvjjovMh6PW9/+CyTTFjxVDzcriFmy4RW4ZP4vzVWkr3aCb
cd4TE2uWfub6F0ZABY92wsaDZMWWi3lluG9CAlZF0t2Kc5w/UZYxMPMS8YF4QwJn
8Fd9apBMGFWvgcV4wuhPgOCcMegU5MfMQnbsJD1CpZSGqHpunNXci5oW6DojZVIl
sdXBlZMxIO5ZVeDhIr8oGYFJRsLZMpT1wevvacKlhGZkrXVz6ppkS+zG2rfXpKXt
UAmScZEzWFJQG7MtPDitH9Jv2EsuGPAt9ZSpHYZ7iBXodOtyg9lI2q1V01Q+CwWo
jx4Y9kFT8gtpZIC0PXY2v/3HCc2N03UGmxBBbh19ctEAp2G4K7YQ9a0nbwBZ740G
VowqAGbiGhMY/6eRemXKoRkRhRGKpedFNX7DY4FIZn20u6XfJdQKVL9hnCcgv2oF
ECOOmW6iPYwyEKPZ042r1cvXIlj01AXvMYPWv0nz+sDrziUHNxJdHE+41xlukyEo
Ec/ozORnyU0LOsUzb+pbzERcKeAbnVeo61lVW9vylFIlil/kA1SCJ/XpKbcdNgmL
1DXOx8eTBUSX7afbpCks917kZxgPqN+0WjWcg6P+vbrissZXYwbfCDAHh6TimsJq
DnvNAQRSApQ1HUO2ia1q
=KwTJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
