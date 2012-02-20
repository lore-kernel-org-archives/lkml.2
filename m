Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2BTDWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 22:22:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35641 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2BTDWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 22:22:19 -0500
Date: Mon, 20 Feb 2012 14:22:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: build failure in Linus' tree with gcc 4.4.3
Message-Id: <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
In-Reply-To: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Feb_2012_14_22_08_+1100_jxxzDe7mNS5Bar=T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Feb_2012_14_22_08_+1100_jxxzDe7mNS5Bar=T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 20 Feb 2012 13:39:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> My x86_64 allmodconfig build fail like this:
>=20
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Setup is 14768 bytes (padded to 14848 bytes).
> System is 4766 kB
> /bin/sh: line 1: 20126 Segmentation fault      arch/x86/boot/tools/build =
arch/x86/boot/setup.bin arch/x86/boot/vmlinux.bin > arch/x86/boot/bzImage
>=20
> I have bisected it down to commit
> 291f36325f9f252bd76ef5f603995f37e453fc60 ("x86, efi: EFI boot stub
> support").  This may well be a compiler bug that this commit just happens
> to poke.
>=20
> The toolchain is PowerPC hosted cross tools:
> x86_64-linux-gcc (GCC) 4.4.3
> GNU ld (GNU Binutils) 2.20
>=20
> I tried an allmodconfig build with my native compiler (gcc (Debian
> 4.6.2-14) 4.6.2, GNU gold (GNU Binutils for Debian 2.22) 1.11) and it
> worked fine.
>=20
> That is a large commit, so I am not sure where to go from here.

Actually, that commit does the following:

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index fdc60a0..4e9bd6b 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -135,6 +135,9 @@ static void usage(void)
=20
 int main(int argc, char ** argv)
 {
+#ifdef CONFIG_EFI_STUB
+	unsigned int file_sz, pe_header;
+#endif
 	unsigned int i, sz, setup_sectors;
 	int c;
 	u32 sys_size;
@@ -194,6 +197,42 @@ int main(int argc, char ** argv)
 	buf[0x1f6] =3D sys_size >> 16;
 	buf[0x1f7] =3D sys_size >> 24;
=20
+#ifdef CONFIG_EFI_STUB
+	file_sz =3D sz + i + ((sys_size * 16) - sz);
+
+	pe_header =3D *(unsigned int *)&buf[0x3c];
+
+	/* Size of code */
+	*(unsigned int *)&buf[pe_header + 0x1c] =3D file_sz;
+
+	/* Size of image */
+	*(unsigned int *)&buf[pe_header + 0x50] =3D file_sz;
+
+#ifdef CONFIG_X86_32
+	/* Address of entry point */
+	*(unsigned int *)&buf[pe_header + 0x28] =3D i;
+
+	/* .text size */
+	*(unsigned int *)&buf[pe_header + 0xb0] =3D file_sz;
+
+	/* .text size of initialised data */
+	*(unsigned int *)&buf[pe_header + 0xb8] =3D file_sz;
+#else
+	/*
+	 * Address of entry point. startup_32 is at the beginning and
+	 * the 64-bit entry point (startup_64) is always 512 bytes
+	 * after.
+	 */
+	*(unsigned int *)&buf[pe_header + 0x28] =3D i + 512;
+
+	/* .text size */
+	*(unsigned int *)&buf[pe_header + 0xc0] =3D file_sz;
+
+	/* .text size of initialised data */
+	*(unsigned int *)&buf[pe_header + 0xc8] =3D file_sz;
+#endif /* CONFIG_X86_32 */
+#endif /* CONFIG_EFI_STUB */
+
 	crc =3D partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, stdout) !=3D i)
 		die("Writing setup failed");

Which is all endian specific code that will run on the host when building
the kernel ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Feb_2012_14_22_08_+1100_jxxzDe7mNS5Bar=T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQbxgAAoJEECxmPOUX5FE7x0P/jLzV9D2OgczzRmedJ4vZ2oh
XWrJehnoU9xHoqno8v5YqvC67ib7Icx/kyEl4RjsKeyL8gqemLO4kchTi9fhdd1i
HKIu/dmSQWjBr2D2pCpe0yWbbrLbuOpl5uhZACsfXqypq49YriU8iGv7e+a4z6rc
/f2nsIiAqn3qKVCLcGZ6kauqTLo+m0IL77GKq5XAcxsVA297ePv62RpGn1Xlcn1y
fiVsMjMpF0fOtIk0dM+xMBMvo2Gacie/rfJrm80F3p/PAQIx1oAA+hqcBj+z2V5n
LJAvkxhEimFotDEZlNP4jkxzW6rIQGN9k7AuTpScV+hMFD3VXH447PoMWw3Z5xgu
gkOO6Dlqi7BY1T0tcclxbddFCpPWfWHrdsfhtHFPDV+LIeHAdfOSggINckLuiDch
9ok1BNHjGLcFrirlnCu3rsTBvQlYm/majI94irZT6GgP/xzhpyZXCuqS2+/xH7te
gAQXEzgPYXyPbqmUogvtjCg+xY4YWA2q5TORRckHFcoXoTqsRZPD8WqRk4rzzILF
IAqJQjlJEc437rza5cfXYTjVNgPDXpc38iicgd0O18MoWImhLdiMQvr/WAayM+6r
+C1C0ad4eL7B7jWQabhbBQZFQaU8JTAwxLDK5frWW+tCERVpN2gbctptQ+SmfiqL
TUkpqt3Ozdg1bkYDEwf3
=2VIU
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Feb_2012_14_22_08_+1100_jxxzDe7mNS5Bar=T--
