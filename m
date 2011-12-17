Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1LQEae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:30:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37602 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab1LQEa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:30:28 -0500
Message-ID: <1324096223.2825.312.camel@deadeye>
Subject: [PATCH linux-firmware 2/4] dvb-ttpci: Add source code and makefile
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:30:23 +0000
In-Reply-To: <1324096119.2825.310.camel@deadeye>
References: <1324096119.2825.310.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UY0c4dde7dU7wOOm1zJT"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UY0c4dde7dU7wOOm1zJT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Downstream commercial distributors need to distribute the source code
as well as the binary.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE          |    4 ++-
 av7110/Boot.S   |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 av7110/Makefile |   11 ++++++
 3 files changed, 123 insertions(+), 1 deletions(-)
 create mode 100644 av7110/Boot.S
 create mode 100644 av7110/Makefile

diff --git a/WHENCE b/WHENCE
index 7553628..ef51ac1 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1094,10 +1094,12 @@ Licence: Redistributable. See LICENCE.phanfw for de=
tails.
 Driver: dvb-ttpci -- AV7110 cards
=20
 File: av7110/bootcode.bin
+Source: av7110/Boot.S
+Source: av7110/Makefile
=20
 Licence: GPLv2 or later
=20
-ARM assembly source code available at http://www.linuxtv.org/downloads/fir=
mware/Boot.S
+ARM assembly source code from http://www.linuxtv.org/downloads/firmware/Bo=
ot.S
=20
 --------------------------------------------------------------------------
=20
diff --git a/av7110/Boot.S b/av7110/Boot.S
new file mode 100644
index 0000000..d562fdc
--- /dev/null
+++ b/av7110/Boot.S
@@ -0,0 +1,109 @@
+/*
+   Boot.S: boot loader for Siemens DVB-S card
+
+   Copyright (C) 2001 Convergence integrated media GmbH
+	              Written by Ralph Metzler
+		                 <rjkm@convergence.de>
+   Copyright (C) 2006 Matthieu CASTET <castet.mattheiu@free.fr>
+
+   This program is free software; you can redistribute it and/or
+   modify it under the terms of the GNU General Public License
+   as published by the Free Software Foundation; either version 2
+   of the License, or (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  =
USA.
+
+*/
+
+/*
+	check AV711x_3_1.pdf for some hardware infos
+	build it with :
+	$ cc -mbig-endian -c Boot.S
+	$ ld -Ttext 0x2c000000 -EB -o Boot Boot.o
+	$ objcopy -Obinary Boot
+*/
+
+	.text
+	.align
+	.globl _start
+_start:
+	b reset			// reset vector
+	movs  pc, r14           // undefined
+	subs  pc, r14, #4       // SWI
+	subs  pc, r14, #4       // prefetch abort
+	subs  pc, r14, #8       // data abort
+	subs  pc, r14, #4       // reserved
+	subs  pc, r14, #4       // IRQ
+	subs  pc, r14, #4       // FIQ
+
+	.word tbl               // table needed by firmware ROM
+tbl:	.word (endtbl - tbl)
+	.word 0
+  	.word conf
+endtbl:	.word 0
+conf:	.word 0xa5a55a5a
+	.word 0x001f1555
+	.word 0x00000009
+
+reset:	ldr	r13, buffer
+	ldr	r4, flag
+	mov	r0, #0
+	str	r0, [r4]
+	str	r0, [r4, #4]
+
+	ldr		r1, wait_address
+	ldr		r2, flag_address
+	ldr		r3, sram
+
+copycode: // copy the code HW Sram
+	ldmia	r1!, {r5-r12}
+	stmia	r3!, {r5-r12}
+	cmp		r1, r2
+	ble 	copycode
+	ldr		pc, sram // jump to the copied code
+
+wait:	ldrh	r1, [r4]        // wait for flag!=3D0
+ 	cmp	r1, #0
+	beq	wait
+
+	mov	r1, r13         // buffer address
+ 	ldr	r3, [r4,#4]     // destaddr
+
+ 	ldrh	r2, [r4,#2]     // get segment length
+	add     r2, r2, #63     // round length to next 64 bytes
+	movs	r2, r2, lsr #6  // and divide by 64
+	moveq	r0, #2          // if 0, set flag to 2, else signal
+	strh	r0, [r4]        // that buffer is accepted by setting to 0
+        beq wait
+=09
+copyloop:
+	ldmia	r1!, {r5-r12}
+	stmia	r3!, {r5-r12}
+	ldmia	r1!, {r5-r12}
+	stmia	r3!, {r5-r12}
+ 	subs	r2, r2, #1
+ 	bne	copyloop
+
+	eor     r13, r13, #0x1400    // switch to other buffer
+	b	wait
+
+// flag is stored at 0x2c0003f8, length at 0x2c0003fa,
+// destaddr at 0x2c0003fc
+
+flag:	.word	0x2c0003f8
+
+
+// buffer 1 is at 0x2c000400, buffer 2 at 0x2c001000
+
+buffer:	.word	0x2c000400
+
+sram: .word   0x9e000800
+wait_address: .word   wait
+flag_address: .word   flag
diff --git a/av7110/Makefile b/av7110/Makefile
new file mode 100644
index 0000000..a2776fe
--- /dev/null
+++ b/av7110/Makefile
@@ -0,0 +1,11 @@
+CC =3D arm-linux-gnueabi-gcc
+LD =3D arm-linux-gnueabi-ld
+OBJCOPY =3D arm-linux-gnueabi-objcopy
+
+bootcode.bin: Boot.S
+	$(CC) -mbig-endian -c Boot.S
+	$(LD) -Ttext 0x2c000000 -EB -o Boot Boot.o
+	$(OBJCOPY) -Obinary Boot bootcode.bin
+
+clean:
+	rm -f Boot.o Boot bootcode.bin
--=20
1.7.7.3




--=-UY0c4dde7dU7wOOm1zJT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwa3+e/yOyVhhEJAQoXag/+KhL0f5+yDbx0hjx5TLTrV9ydyKQ5CJSe
ScJAqRqHUZgZraBfOvqY+dhPz2k7G/YrKo+WaPq1XjzwTAanashopXWfLNVihHeN
nFNvB0gqksNQRvL5cOOYOVnE4GuNx7EWsa3KSGKnZRYiFWW8yV2yUwwUMy2ClKwp
RWUmthHTvUA/sTbwyq0SN6fO+3hPFD9lXl7rwLC+11riVDGYu6nr/1SCWjuV9sAE
UpMsG0ezzol+PWdqfxFH5sD2XHF0tJmEe9VfuvV9kgW+fNZguRwKDDbxpwnWppGz
S6mx5KiAzAsOFP2Kar47f8xlcvxG+iuc/p5PRvmo9JUIpTwGNDkXlHZbcnlSV7zi
GU3E4YsBznAwYHe6NjSfCLbyUWjmR525yBW1KPVZoSEWfAH6bhOwIAshQdz88g8S
Y2HHMAp2JAaTYc8vp3PAKlswdKNYdFVpUdP6B7O7nKxymXtD3tqSMviZ4EdzKj1e
2Dvuvu21iogSqxKRCD2pVji+E/KkcPwLOATD0Qz7yNcVU47HAe0DzncbR68dDPpa
LtXjIMldfHDB5IFMmbbHRkhRJkZRAMj0rMx8dNU0iA2pMT1a8VZbEWSv170a2z5K
vSgLqb4lDURkdMYLl3fId6U+f1GY99uv34J0URfk708yBfh20+1n3oyybZ3B45ZS
szIwrPbI4c0=
=rJVn
-----END PGP SIGNATURE-----

--=-UY0c4dde7dU7wOOm1zJT--
