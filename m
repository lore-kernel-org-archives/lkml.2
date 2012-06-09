Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839Ab2FICEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 22:04:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761478Ab2FICEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 22:04:21 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=9-WDtcdztSMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=pGLkceISAAAA:8 a=i0edBJzXuhCFFf0-4wIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=-Ocx19QOEvgf1SzSsu4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120609020418.424293827@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 22:02:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/3 v2] x86: Save cr2 in NMI in case NMIs take a page fault
References: <20120609020257.248773533@goodmis.org>
Content-Disposition: inline; filename=0001-x86-Save-cr2-in-NMI-in-case-NMIs-take-a-page-fault.patch
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

Originally I wrote a patch to solve this by saving the cr2 on the stack.
Brian Gerst suggested to save it in the r12 register as both r12 and rbx
are saved by the do_nmi handler as required by the C standard. But rbx
is already used for saving if swapgs needs to be run on exit of the NMI
handler.

Link: http://lkml.kernel.org/r/4FBB8C40.6080304@redhat.com
Link: http://lkml.kernel.org/r/1337763411.13348.140.camel@gandalf.stny.rr.c=
om

Reported-by: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7d65133..111f6bb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1758,10 +1758,30 @@ end_repeat_nmi:
 	 */
 	call save_paranoid
 	DEFAULT_FRAME 0
+
+	/*
+	 * Save off the CR2 register. If we take a page fault in the NMI then
+	 * it could corrupt the CR2 value. If the NMI preempts a page fault
+	 * handler before it was able to read the CR2 register, and then the
+	 * NMI itself takes a page fault, the page fault that was preempted
+	 * will read the information from the NMI page fault and not the
+	 * origin fault. Save it off and restore it if it changes.
+	 * Use the r12 callee-saved register.
+	 */
+	movq %cr2, %r12
+
 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
+
+	/* Did the NMI take a page fault? Restore cr2 if it did */
+	movq %cr2, %rcx
+	cmpq %rcx, %r12
+	je 1f
+	movq %r12, %cr2
+1:
+=09
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
 nmi_swapgs:
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP0q8iAAoJEIy3vGnGbaoAIVIP/irCvPhDFQIFT2zCe9ZVs5LL
KJGAmJwrNsx15a8VgoeXozD5GLB/sqe12jd8EcklJl5wR8GoPNaGylKY/fIUgDEB
akzZ40TMPBuk5yWS/sZoddvrrDLDHr7hlut6ObMVGaDhBdT35y3HIX5OcwsJ+S1w
Zjp80C7V3nHtyie1vTV6VzWPvdeVuXkzUyoX8Tk5Sh3uOobkDF+NeQpaob2UYi1D
rygF5uXdcY3NTJgq/6u/GtmVk3HpC5CHM7w6GZb9+1fzUbavQBg0hX9lpXbZsRor
D9ONg+AEu6itZBHVLsG7w1BlXOYP3Easm9lFc4SDZYKIGmGxC7vVA+y/l2hED3cD
QEF2+GUO+2tqX/Px74aFuBihsQWUGGhW059NpVq8CaEdzpU+xbpnHGHi9euyDAL+
7xngH6c8UN7s7Z9N2nJLOPmBK2GPpb0lFNVE3Pjx1dmF2232Ub4PEbzegAEldcir
ItKWTPQXEhrgxI30rOvalU6Pfp9Bl7/cFWU588dVMI/vPn4zvj2zR5BPu5UjFh0S
ISOLADTDw9mGCeKaXGPu6yQrTNeDls+U7R5CorfKS3IemQA3SD0LtY6R22KCLP3y
J5bg2tCj9sUz9fyK5JX/8IqKpC9qhcSgp0tqBRSK1L/zjzj9sK+Bbl5T4YjHqDH9
TNAtXiRoRwnFpfcjBGxe
=5bD8
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
