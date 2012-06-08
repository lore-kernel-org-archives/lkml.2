Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab2FHN5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:57:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2FHN4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:56:07 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Tb4t6z9ZV8EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=i0edBJzXuhCFFf0-4wIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Lk2BO9nPf4hE8Ae0:21 a=omOho46NVw95FoR_:21 a=vuROYcCBEGvB9-3XR0IA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120608135604.053254888@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 09:52:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/3] x86: Save cr2 in NMI in case NMIs take a page fault (for i386)
References: <20120608135200.371649691@goodmis.org>
Content-Disposition: inline; filename=0003-x86-Save-cr2-in-NMI-in-case-NMIs-take-a-page-fault-f.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Avi Kivity reported that page faults in NMIs could cause havic if
the NMI preempted another page fault handler:

   The recent changes to NMI allow exceptions to take place in NMI
   handlers, but I think that a #PF (say, due to access to vmalloc space)
   is still problematic.  Consider the sequence

    #PF  (cr2 set by processor)
      NMI
        ...
        #PF (cr2 clobbered)
          do_page_fault()
          IRET
        ...
        IRET
      do_page_fault()
        address =3D read_cr2()

   The last line reads the overwritten cr2 value.

This is the i386 version, which has the luxury of doing the work
in C code.

Link: http://lkml.kernel.org/r/4FBB8C40.6080304@redhat.com

Reported-by: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 43cce77..26ae7e5 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -396,6 +396,14 @@ static __kprobes void default_do_nmi(struct pt_regs *r=
egs)
  * thus there is no race between the first check of state for NOT_RUNNING
  * and setting it to NMI_EXECUTING. The HW will prevent nested NMIs
  * at this point.
+ *
+ * In case the NMI takes a page fault, we need to save off the CR2
+ * because the NMI could have preempted another page fault and corrupt
+ * the CR2 that is about to be read. As nested NMIs must be restarted
+ * and they can not take breakpoints or page faults, the update of the
+ * CR2 must be done before converting the nmi state back to NOT_RUNNING.
+ * Otherwise, there would be a race of another nested NMI coming in
+ * after setting state to NOT_RUNNING but before updating the nmi_cr2.
  */
 enum nmi_states {
 	NMI_NOT_RUNNING =3D 0,
@@ -403,6 +411,7 @@ enum nmi_states {
 	NMI_LATCHED,
 };
 static DEFINE_PER_CPU(local_t, nmi_state);
+static DEFINE_PER_CPU(unsigned long, nmi_cr2);
=20
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
@@ -412,11 +421,14 @@ static DEFINE_PER_CPU(local_t, nmi_state);
 			return;						\
 		}							\
 		local_set(__state, NMI_EXECUTING);			\
+		this_cpu_write(nmi_cr2, read_cr2());			\
 	} while (0);							\
 	nmi_restart:
=20
 #define nmi_nesting_postprocess()					\
 	do {								\
+		if (unlikely(this_cpu_read(nmi_cr2) !=3D read_cr2()))	\
+			write_cr2(this_cpu_read(nmi_cr2));		\
 		if (!local_dec_and_test(&__get_cpu_var(nmi_state)))	\
 			goto nmi_restart;				\
 	} while (0)
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0gR0AAoJEIy3vGnGbaoAr6wP+wfTmR4ZJfZ1vc8wlvWCRV3/
ISCUiBvj2mcFTs64wbPSGsK1bVBwODnO+YSHyyvk5qjAGKKt711DgntE1WuY7g9P
dUIrXoXeIbxgkhQJNLhMHP/mx4DfRbsTMUnyXA7zS1QkidrGbtqDhWnOl+UwA9sX
bLQY4sqW2vA246rKLTtFkMYosYrcP+Yk9Aek3ut+E8gJPXXWTcn3L9XXfIW1lZ6S
8beGiRmP/rMzpnKUsqyQESQVqfRcVG6F+qSWt1Lh1caDj/LN6igB7+G7I84d5+Aw
g/bmGkRLP1KZ07e+gbbw8ldZ8Z8drymFATjH2ncHnU/0GvjNXzj9bDWXjQLuuA7v
0k5FNW+V12Q1P8+FksYBt2z0I/NC3uxOUzOTHUzFu0L2hJyftIKmPuWFg8gwHgZ1
BQDTjl0HwzXvUeluENe2SJCzQ/Ut8f8UxJEz4j1rafuZ/IEA61ZYFKawXzfHvmt+
3uPtG1QMM00qS2/hrcTgWS9eDK1a0InzWtzKOLQwFA7qTQg2m4x6nkB5jmz4XPz9
X2AjkLz7PB24dRB8x4UZBms9BW9VD0d5gWYHfIJupStJpNauxFhg7MMZLEel7AaM
YRIElMjGonr67lxDNSb3H5FP0+WBxIgK1SziVHuGTRi18g6aKOBAyMbr0frdzRHh
9ItYpElZzVGNGtQ+azTb
=IQke
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
