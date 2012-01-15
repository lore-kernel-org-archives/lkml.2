Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2AOULA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:11:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AOUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:10:58 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=xGon_rIRNPUA:10 a=5SG0PmZfjMsA:10 a=8T59DR07AAAA:8 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=Tty9oNO6AAAA:8 a=meVymXHHAAAA:8 a=aytYSEgZPKhY4XHloFwA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=MtZ0aovZP2VkqLhl:21 a=FQLOtz1yWOyNb9pO:21 a=8YUwz8dvuHV2cpYmdO8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326658250.7642.136.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.3] tracepoints/module: Fix disabling
 tracepoints with taint CRAP or OOT
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Date: Sun, 15 Jan 2012 15:10:50 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-61aqrF1Ivt4f1ZOrcBfk"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-61aqrF1Ivt4f1ZOrcBfk
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

I was told when compiling modules out of tree, their tracepoints no
longer work. I tried it out by compiling the sample trace_event code,
and sure enough the tracepoints would not enable. They would look like
they were enabled, but no tracing would happen. I ran this through ktest
git bisect, and found it was caused by the commit:

commit 2449b8ba0745327c5fa49a8d9acffe03b2eded69
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Mon Oct 24 15:12:28 2011 +0200

    module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree

Then I looked at the tracepoint.c code, and found that it does not
enable tracepoints in any module that is tainted. This restriction
should not apply to out-of-tree or staging modules. Which this patch
fixes.

Note, I've included this on top of my last "urgent" branch which I
noticed that was pulled into perf/core.

https://lkml.org/lkml/2012/1/6/357

I still think it's a good idea to include both into mainline now. They
are both marked for the stable release as well.

Thanks!

-- Steve


Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: a4bd073dcd870c3eac1505eb8f0abe35d38cc98d


Steven Rostedt (1):
      tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT

----
 kernel/tracepoint.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
---------------------------
commit a4bd073dcd870c3eac1505eb8f0abe35d38cc98d
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Jan 13 21:40:59 2012 -0500

    tracepoints/module: Fix disabling tracepoints with taint CRAP or OOT
   =20
    Tracepoints are disabled for tainted modules, which is usually because =
the
    module is either proprietary or was forced, and we don't want either of=
 them
    using kernel tracepoints.
   =20
    But, a module can also be tainted by being in the staging directory or
    compiled out of tree. Either is fine for use with tracepoints, no need
    to punish them.  I found this out when I noticed that my sample trace e=
vent
    module, when done out of tree, stopped working.
   =20
    Cc: stable@vger.kernel.org # 3.2
    Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Ben Hutchings <ben@decadent.org.uk>
    Cc: Dave Jones <davej@redhat.com>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index db110b8..dc63553 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -636,8 +636,9 @@ static int tracepoint_module_coming(struct module *mod)
 	/*
 	 * We skip modules that tain the kernel, especially those with different
 	 * module header (for forced load), to make sure we don't cause a crash.
+	 * Staging and out-of-tree modules are fine.
 	 */
-	if (mod->taints)
+	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod =3D kmalloc(sizeof(struct tp_module), GFP_KERNEL);


--=-61aqrF1Ivt4f1ZOrcBfk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEzLLAAoJEIy3vGnGbaoAyKEQAMH42J1bp1HXSHuqmC4SMWOu
sQJDYSPygd9gpCjBE518HV8SL157xWN96kY69WI/pC9dls0YNaY/07Ro+Vv+unf0
i04jSEKlDDbyM6NJvi091FChpkK0SJ4eJhYO6Pw7Ho7H0boxmK/QoN07jOIatxc6
Mb0ohRE7ubGpLjvPRpzfbOH+91335J9zcGftU/4t6TTpJeHUbCCKGvt09WHFuHrG
sgEec5SAeXjSIP773cq9ZJUtzzi0Gg87NF7SkUMlHKGyE5pkNgqTRhurq0Ncp1RB
HWu0rYoYsL/p8inOqjKDrzAr5qqGteXOwjxI9PnspgMUt1UGNm/AoPrnxuS2wPKm
Rciv50G1cWNPmu/nNv6FQ5EHyS2vo+SEQ5mM9HPe5U2WeZq4Mdppog4hbaB373/P
neVsACZJkXCVPXtDi7TcBObpU2OBVsxZt+q1hE0VlbUS6wBlpBgef4h2C5/DaO9f
4DaVUQ7SLZZaeaagSResZqk6FBXp1e/OVQYHgUUxgn1gjUVXsnpm20E29MVqqMvt
rfDhgV2gKh8vqvLeq7OSPWqGVh0S/MePw+DPnMpgNK6WkfIImlDmfpl/qE4li6ui
esjG44LFE4IjeOsU7CVhSOMSJEbB9ZwCVETepdCd0cYZvOyrqnc59ia0Xd/qWn4d
u4jx7GRyStXZuWX+dHim
=wqzs
-----END PGP SIGNATURE-----

--=-61aqrF1Ivt4f1ZOrcBfk--

