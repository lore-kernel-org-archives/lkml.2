Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab2FAPCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:02:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854Ab2FAPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:00:59 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Sctnh-S1GJcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=LRC3DT7tojW0X7KM0icA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OO7mIP9Trq4IVjtDYHIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120601150057.838951997@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Jun 2012 10:57:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5 v2] x86: Reset the debug_stack update counter
References: <20120601145702.428441016@goodmis.org>
Content-Disposition: inline; filename=0003-x86-Reset-the-debug_stack-update-counter.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When an NMI goes off and it sees that it preempted the debug stack,
to keep the debug stack safe, it changes the IDT to point to one that
does not modify the stack on breakpoint (to allow breakpoints in NMIs).

But the variable that gets set to know to undo it on exit never gets
cleared on exit. Thus every NMI will reset it on exit the first time
it is done even if it does not need to be reset.

[ Added H. Peter Anvin's suggestion to use this_cpu_read/write ]

Cc: <stable@vger.kernel.org> # v3.3
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 9087527..a0b2f84 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -444,14 +444,16 @@ static inline void nmi_nesting_preprocess(struct pt_r=
egs *regs)
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		debug_stack_set_zero();
-		__get_cpu_var(update_debug_stack) =3D 1;
+		this_cpu_write(update_debug_stack, 1);
 	}
 }
=20
 static inline void nmi_nesting_postprocess(void)
 {
-	if (unlikely(__get_cpu_var(update_debug_stack)))
+	if (unlikely(this_cpu_read(update_debug_stack))) {
 		debug_stack_reset();
+		this_cpu_write(update_debug_stack, 0);
+	}
 }
 #endif
=20
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyNkpAAoJEIy3vGnGbaoADtYQALj/+2Rd3Ik8wlgLHuceANp7
nJ27vrpd6dBmh2hd4qzuy0+5ghVFeImxih7gNuP5kBXcXYpgmgqPxk1UsQ3XTgBB
zqlkSSt+lfuCl0dwWkQxibjK6cGFmxthhdoYNraHfFkNxJCfkLRcEr1bDi2S68qS
7YiAwtj23UF1LKWrQ/D/SmgKIYRVInsxaueibE71rfMA9AgyUaMJs9zvdiTBUwjB
lk7qO82PXHcgLyhY6nQaTBseXZkB5eMhcf8hrsXXhvLL4KiS5fJE7f7by2EKXV7q
ZR+25d7YHptTMrx6Mr0JsRWuj3k7EdWS8yil6X5UgRW3ypqz36872DqVDCeFyCPK
Y8cucYkNKv8ns3ZEOF3SYUO4iFY8ZtJR29ygvwj0e0+tP00XQ+7MjIWf7bmZhYap
hpoP1MhQz7Ya/4/8Vo9YYhNEeM9EOka1Bg/IgU6AyFBI0eeHh2rzWzwHrgQPw2Dl
bIW169QS2/Arybhl/NlXAdp/9756EqbDsx3bDAVGIkMYo9tx9E0LrYFKIENEWpje
GBUOpuCM7fp9pO1V6ijSwvV2Md/Ram9jdhcI7zYpsF/DVxFg3VHnXgl61Gb2IL42
eGKbygCZbjkNipc59UlANVkVylVCKcUQ8W5SFhkCPxmCp9cDL4Cu1zrVlgjBv4SF
vf0SUpvS9312WjS3tiow
=oeZQ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
