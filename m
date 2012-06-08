Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2FHN4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:56:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2FHN4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:56:06 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=IoUjMki_8_EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=pGLkceISAAAA:8 a=i0edBJzXuhCFFf0-4wIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=n1ftfSLLicqVg_bral0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120608135603.343815443@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 09:52:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 1/3] x86: Save cr2 in NMI in case NMIs take a page fault
References: <20120608135200.371649691@goodmis.org>
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

iQIcBAABAgAGBQJP0gRzAAoJEIy3vGnGbaoA9AMP/R5jo4sEslDfXftkbwmSwktZ
Y3KGo1Um62UKAlozxfeL1uAJEqDtN/ELrERPG4KmM74GMmKktObpo7yAd2gLkfgQ
otJ5wSpcPyYNYp8NDix52e+nF1gZMD075hhtxv7ZZ7VzkYXPiMAu24/DOzeIwHu7
hpAq3enTxWOLFb+EfkHnnEJ9oXVVWiJwpU7EfoNvcp+XcD01OIXkQBwFj7/pEhvm
5IIAJjwzdqpglFXvgRxaT+2T+WtcpRns3DVeUk5ui9ha/5y0JSPnE2t4KxmgEWaS
Qk0MZpwKVXdnf8BJyJFNEkDPmRJZm0F0oywL5Yw1/kFz2sU7AkyGL/lQuIopFgUD
iABtaT91i4gtWEBR/sU7O1ZoPrwevKzNXCJo6ebvUsmKLjlJQNxTZJseC7Ol+8vt
3NhHhW/uAkwomMI3OHLQn8MJ0aeMfWcOHuAg6JF9busN6dfdhTbAiWX1Shk+uRsh
5nm7WCSZuFVXgLoK92Pfj85XFRHilONhMFAL3N2i6mNsHRENOG3E8mGJTYhdzQt5
4ihMieXEfao/KTR3ApI7jBtACcTfcx+K+B+gkbJrf9+0sXl2tRgnfT882wNrj2k9
asgDh4fK1R7S3OD2plkr2jxDBRb8ZKDfLd2054lJYcZmLfxA25m1Y8TsL90Dhb4B
ID/MmVEP/TAuf1w/aED0
=i898
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
