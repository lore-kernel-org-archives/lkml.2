Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab2AGWcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 17:32:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2AGWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 17:32:08 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=oK-48iVQegJeGT75RskA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Wi4mVlzzk5fJWgKPNsYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325975521.7642.22.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 07 Jan 2012 17:32:01 -0500
In-Reply-To: <20120107122511.GB28462@elte.hu>
References: <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
	 <1325696759.12696.24.camel@gandalf.stny.rr.com>
	 <20120105091916.GA22598@elte.hu>
	 <1325764011.12696.38.camel@gandalf.stny.rr.com>
	 <20120107122511.GB28462@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OxVmYmpigA/EOWO80d93"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OxVmYmpigA/EOWO80d93
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-01-07 at 13:25 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> > > I'm also seeing build failures with certain configs:
> > >=20
> > > kernel/trace/trace_stack.c:387:3: error: implicit declaration of func=
tion =E2=80=98ftrace_set_early_filter=E2=80=99=20
> > > [-Werror=3Dimplicit-function-declaration]
> >=20
> > Hmm, your right. It depends on dyn_ftrace to be configured.=20
> > Strange that my tests didn't catch that as I thought one of my=20
> > tests compiles with static ftrace. I'll have to look into why=20
> > my test didn't catch that. I'll send a fix later today.
>=20
> Hm, i cannot re-test this tree with general randconfig until it=20
> keeps failing the build. I'll test the NMI bits, to be able to=20
> exclude those.


Ingo,

I updated the branch by adding the below patch that fixes the bug. You
can apply this and then run your tests again.

Thanks!

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 96de37b62ca525cd77d2e85aea1472846ee31c4d


Steven Rostedt (1):
      tracing: Fix compile error when static ftrace is enabled

----
 include/linux/ftrace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
---------------------------
commit 96de37b62ca525cd77d2e85aea1472846ee31c4d
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Sat Jan 7 17:26:49 2012 -0500

    tracing: Fix compile error when static ftrace is enabled
   =20
    The stack tracer uses the call ftrace_set_early_filter() function
    to allow the stack tracer to pick its own functions on boot.
    But this function is not defined if dynamic ftrace is not set.
    This causes a compiler error when stack tracer is enabled and
    dynamic ftrace is not.
   =20
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 41df6f5..028e26f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -339,6 +339,7 @@ static inline int ftrace_text_reserved(void *start, voi=
d *end)
  * functions may still be called. Use a macro instead of inline.
  */
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
+#define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
=20
 static inline ssize_t ftrace_filter_write(struct file *file, const char __=
user *ubuf,
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }


--=-OxVmYmpigA/EOWO80d93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPCMfhAAoJEIy3vGnGbaoA+EYP/jjZ6VRXGFM4czrMTfVPR+Au
LVrD7Q5fWpYY5utJoIubJ3h8qyr8E/f8oMDPV4wjUq64EAip0C1cfpGn7qkQL4jZ
jz8IZoZqdM8h937XOSXH9uxUZEpEowmrl0osHNYMh/1t5pD7R/a3dvm8WZaqtNfq
oS8dUwCDWI4ADv1znwuLKbuOxkWZxSUWXTwFrvzT1+zNdqWLNcyTbuQgLsjFvUO3
KahHXvJnICk1lLnTlLBNqgC0xZyj5B0YgXTWqLrrK0wcqFA/RG+00pHZaZaqtVGc
SQL4RvcCUvEA2jtJBXFrccKqMsWRUvEGeU5lEptgtHaZYyWn97NFYHNCw/YqPYYP
H6VM5XqjNWKx6/dr9Z6AKOXDkQYZlT9sFYjJsv2TqOUeuLqt4St4UznnG6E1P79w
oV4NbL7y66vzavW+mV0ITdy6x9NNneXMLaRtMqJmPBcmgL81xCZquV6GKY5E7nwN
n7yd3C5smv8U/iM0fmu/Xfmw626UyEjtnUZ1+toCcpYiu6cUWpUkg1N9yY8G4Hh+
/Pv2lzR5iaWIWJhmsceo1+RyhwMX4ZcCnioJLtvBZ07X2SwWepfVHh8qmptHB4YS
K+/QQthQAAVBinIe19vnRMHNQK3fCLHjclWzf2Y4EJjlrAASA/Eu1dh/mM1E4Jif
q50HGDPY1+4iZxtFfHdK
=/ioI
-----END PGP SIGNATURE-----

--=-OxVmYmpigA/EOWO80d93--

