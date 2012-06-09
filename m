Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab2FICEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:04:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761495Ab2FICEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:04:21 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=4gXByME9LvYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=i0edBJzXuhCFFf0-4wIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=57se8FGARDdnhAK3:21 a=497vQUWsqwsSQ4si:21 a=_LQfcg8f-ZNUGEzx5agA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120609020419.112989759@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 22:03:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/3 v2] x86: Save cr2 in NMI in case NMIs take a page fault (for i386)
References: <20120609020257.248773533@goodmis.org>
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
index a15a888..f84f5c5 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -395,6 +395,14 @@ static __kprobes void default_do_nmi(struct pt_regs *r=
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
@@ -402,6 +410,7 @@ enum nmi_states {
 	NMI_LATCHED,
 };
 static DEFINE_PER_CPU(enum nmi_states, nmi_state);
+static DEFINE_PER_CPU(unsigned long, nmi_cr2);
=20
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
@@ -410,11 +419,14 @@ static DEFINE_PER_CPU(enum nmi_states, nmi_state);
 			return;						\
 		}							\
 		this_cpu_write(nmi_state, NMI_EXECUTING);		\
+		this_cpu_write(nmi_cr2, read_cr2());			\
 	} while (0);							\
 	nmi_restart:
=20
 #define nmi_nesting_postprocess()					\
 	do {								\
+		if (unlikely(this_cpu_read(nmi_cr2) !=3D read_cr2()))	\
+			write_cr2(this_cpu_read(nmi_cr2));		\
 		if (this_cpu_dec_return(nmi_state))			\
 			goto nmi_restart;				\
 	} while (0)
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0q8jAAoJEIy3vGnGbaoAfOwP/j2u10bkjC5VpixWtxKkaE28
X4I/JrKagLtAtNRnODu4VBeVBohvX+n5Cwof1gSmH5bz9EAMDnDu6pd98YL46IkA
+064fJ6KJGQsr3DDjFY2gxzlOxC6lV5/RsbzCiDv2lPxCWy7lA10+Q0TdP2TfACd
t8xUM6+9DFZ8DJ2/V6lbYQ3Lr6lQjt48BiyWfAeOtZ3FV/8Vy+Yj6nwRSYAkwfuI
PaIVBXgCjABI9czoJVoeoOEwqw7JEXffjlbTn5Y6sn/TDwslo2x+ANgO3KkhKYJ4
3l4x7YZWPQ7cJmSXLJmbCFXHhWvcBRQyb/ui7m7hP4SBoHetPtlOlswzGHrfKNby
0fG32T4btEBGYlFcGZ/ZcZ03RnlW/Q/ohHeecYgQ7CKtAVhDJGTkUzZ2/MbrQPgF
18Daqd/9rBoY241zCtf9wCZ9X3YScGUvuddNZXSOJi43d1mZFcrGLtxYIAobNzbX
MN8C60W3eT5KS3rJeokp7NWn15PCARa6NGQPS2hL1sjRLJ/jhV9Ups7WZT9cbF5O
CHUEtKr//t78ipQX1EfSiEi5h1lV6hUtR+tWKiOglFWEMiWiuW0xIA1WhjX5O+ec
w87mL8gPLJn7VT7F9faRhupl+a9L2ltrR4NebszU2KN4Xz2soMTfdERgboe2B41H
YxrOUz0BbQoa4Lo5/8F/
=qhfH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
