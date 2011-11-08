Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1KHBbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:31:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab1KHBal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:41 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=WHM5n-Ytuc8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=yj0WTn7CRDrG6XgJDsUA:9 a=iK0aRX6K21KmLf-OVogA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=09PfNBgrfLDYlbvkziIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013040.157614372@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/10] ftrace: Fix hash record accounting bug
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Fix-hash-record-accounting-bug.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If the set_ftrace_filter is cleared by writing just whitespace to
it, then the filter hash refcounts will be decremented but not
updated. This causes two bugs:

1) No functions will be enabled for tracing when they all should be

2) If the users clears the set_ftrace_filter twice, it will crash ftrace:

------------[ cut here ]------------
WARNING: at /home/rostedt/work/git/linux-trace.git/kernel/trace/ftrace.c:13=
84 __ftrace_hash_rec_update.part.27+0x157/0x1a7()
Modules linked in:
Pid: 2330, comm: bash Not tainted 3.1.0-test+ #32
Call Trace:
 [<ffffffff81051828>] warn_slowpath_common+0x83/0x9b
 [<ffffffff8105185a>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810ba362>] __ftrace_hash_rec_update.part.27+0x157/0x1a7
 [<ffffffff810ba6e8>] ? ftrace_regex_release+0xa7/0x10f
 [<ffffffff8111bdfe>] ? kfree+0xe5/0x115
 [<ffffffff810ba51e>] ftrace_hash_move+0x2e/0x151
 [<ffffffff810ba6fb>] ftrace_regex_release+0xba/0x10f
 [<ffffffff8112e49a>] fput+0xfd/0x1c2
 [<ffffffff8112b54c>] filp_close+0x6d/0x78
 [<ffffffff8113a92d>] sys_dup3+0x197/0x1c1
 [<ffffffff8113a9a6>] sys_dup2+0x4f/0x54
 [<ffffffff8150cac2>] system_call_fastpath+0x16/0x1b
---[ end trace 77a3a7ee73794a02 ]---

Link: http://lkml.kernel.org/r/20111101141420.GA4918@debian

Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0fcc6ca..7caa450 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1210,7 +1210,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (!src->count) {
 		free_ftrace_hash_rcu(*dst);
 		rcu_assign_pointer(*dst, EMPTY_HASH);
-		return 0;
+		/* still need to update the function records */
+		ret =3D 0;
+		goto out;
 	}
=20
 	/*
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIZAAAoJEIy3vGnGbaoAZU0P/ArhGkYHjhqqJOWqKMVsRjYU
0wYRZ1aNDK1nYEFX0XpmgzeGBUip2Etu/HIQVPx66k2c6vSu+mnfhiQLd7bZrrvx
pD29ol559wqvPmI71cVjuykQrmZHju2HG86o2l7VcOHECk8udC4h+/msbQu7883J
KGdBFVAscbAmvUK+05QkPhtaO16Wy4gn283tunDJGjT0z9AYwfy2e3+icMemfa7y
iFwGin06mb7t78B3jbTWlE2hcKnwAHtfMyJrCLegdG3QQReXjgp5nEIIdeFMiCe0
GtxIZ5rL+n9CHZD6cY74L9DIt7Ep5IrvoOe3T+VojWnZV45PW/gkl/nBNKkVuHat
InCrnsVeAtXInt1vEXwbgLoL84MRfJktPWtBmQgB7MaPyVENB5QzE73c+oLi6WS4
aWXNpjhrmkYLrFNLH6D+ILc8beUvt86YrYU7zeQ7xiTOn7wTxNHDk++z83hAmJc7
a9c/++pUp/6VlBe27fbLCtZK8Ef/644HN/pDevRh+OFMo7X59bv9HRqh4ckgW4p8
cP6avDkziiVg7JlorB0t5QygJB0SdOg+NOmn6gg6gNn5RkWkrdPn81pQA5NdC+OZ
ATqVYjxpj2LR0geDzl/abkLPDyjK4NCJqiedOSng3/I1yjUQoLZEFk239UTS19Fg
Huw2WgPqjNL3XxCzfu4A
=vFqn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
