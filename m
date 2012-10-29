Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab2J2Q4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:56:39 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:44739 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2J2Q4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:56:38 -0400
Date: Mon, 29 Oct 2012 10:56:21 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
Message-ID: <20121029165621.GF5190@beefymiracle.amer.corp.natinst.com>
References: <20121025224108.GA30705@elliptictech.com>
 <1351205254-2409-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <1351205254-2409-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 11:56:13 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/29/2012 11:56:13 AM,
	Serialize complete at 10/29/2012 11:56:13 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-29_02:2012-10-29,2012-10-29,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 06:47:34PM -0400, Nick Bowler wrote:
> The main UART on the Xilinx ZC702 board is UART1, located at address
> e0001000.  Add a Kconfig option to select this device as the low-level
> debugging port.  This allows the really early boot printouts to reach
> the USB serial adaptor on this board.
>=20
> For consistency's sake, add a choice entry for UART0 even though it is
> the the default if UART1 is not selected.
>=20
> As there are currently known issues related to the UART virtual
> mappings, this is KNOWN BROKEN, not to be merged yet!
>=20
> Not-Yet-Signed-off-by: Nick Bowler <nbowler@elliptictech.com>

Tested-by: Josh Cartwright <josh.cartwright@ni.com>

Now that v5 of the initial zynq cleanup patchset is queued up for
merging (with a workaround for the uart mapping problem), what would it
take for you to sign off on this patch?

There is some trivial merging that has to be done to get it to apply
cleanly on v5.  See a rebased version below.

Thanks,
  Josh

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index b0f3857..7754d51 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -132,6 +132,23 @@ choice
 		  their output to UART1 serial port on DaVinci TNETV107X
 		  devices.
=20
+	config DEBUG_ZYNQ_UART0
+		bool "Kernel low-level debugging on Xilinx Zynq using UART0"
+		depends on ARCH_ZYNQ
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to UART0 on the Zynq platform.
+
+	config DEBUG_ZYNQ_UART1
+		bool "Kernel low-level debugging on Xilinx Zynq using UART1"
+		depends on ARCH_ZYNQ
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to UART1 on the Zynq platform.
+
+		  If you have a ZC702 board and want early boot messages to
+		  appear on the USB serial adaptor, select this option.
+
 	config DEBUG_DC21285_PORT
 		bool "Kernel low-level debugging messages via footbridge serial port"
 		depends on FOOTBRIDGE
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index ba8d14f..93b9105 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -84,9 +84,9 @@ static struct map_desc io_desc[] __initdata =3D {
=20
 #ifdef CONFIG_DEBUG_LL
 	{
-		.virtual	=3D UART0_VIRT,
-		.pfn		=3D __phys_to_pfn(UART0_PHYS),
-		.length		=3D UART0_SIZE,
+		.virtual	=3D LL_UART_VADDR,
+		.pfn		=3D __phys_to_pfn(LL_UART_PADDR),
+		.length		=3D UART_SIZE,
 		.type		=3D MT_DEVICE,
 	},
 #endif
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zyn=
q/include/mach/zynq_soc.h
index 1b8bf0e..7f4f38b 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -25,8 +25,9 @@
  * address that is known to work.
  */
 #define UART0_PHYS		0xE0000000
-#define UART0_SIZE		SZ_4K
-#define UART0_VIRT		0xF0001000
+#define UART1_PHYS		0xE0001000
+#define UART_SIZE		SZ_4K
+#define UART_VIRT		0xF0001000
=20
 #define TTC0_PHYS		0xF8001000
 #define TTC0_SIZE		SZ_4K
@@ -36,12 +37,17 @@
 #define SCU_PERIPH_SIZE		SZ_8K
 #define SCU_PERIPH_VIRT		(TTC0_VIRT - SCU_PERIPH_SIZE)
=20
+#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
+#	define LL_UART_PADDR	UART1_PHYS
+#	define LL_UART_VADDR	UART_VIRT
+#else
+#	define LL_UART_PADDR	UART0_PHYS
+#	define LL_UART_VADDR	UART_VIRT
+#endif
+
 /* The following are intended for the devices that are mapped early */
=20
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
 #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
=20
-#define LL_UART_PADDR	UART0_PHYS
-#define LL_UART_VADDR	UART0_VIRT
-
 #endif

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQjrU1AAoJEEef0niEbw+l6CMP/idsiFFx5PvSGtsfmR6SfAWO
iQpupR5frPbAlYQHHffb0dsD/M71XHSr8NcY5SeQRPrg7EWGfdjht2fxRKkjOo8w
Cnfqbc0dunl343f3N2Yc5CdMqKRYtoIM/VJqWdwN741a/WjsvSY16xBLGUxvkIoB
R0ACfUlbIgxjeU0kYoV/dt/HCOAzeTbEuXqm1QXTYz2hsU9PydW4xHj/zFH/ulxz
hfZGeai/uRdbItHfLC7zISnXbUjVrcaXSHDXoxrGYDNA8KLF2LjHw8dRFVaQsZfK
2497Un95VjjV7NmAe1G/NjWxiRfrUBQ8oZ9gV+NkTIxJZ9STBOGWXlL6QpvF85dB
GBMflqHl0hChu0kPiIO1zbB+wQjvS1K/hLGAmAwcQyqzhU9f+BSWR4n6krbbNPN1
kDVh7ZSEWeM4rWgzArMTlEklf/koXPvjOUTFOZS3343UwuI4473zPTq5EJA4XfB+
0eXa/EcMkg74SzlrLIGfO35mr4AbQDi1FBqIzSh9fIOG03rDkoX4l35gzzkRNVn4
WCK4KbcNTKN/XBWVMVfmy1iRd8QVSypPpDxZDKX7R1UlRCmOGH6P5YTU4/drm8TW
estvspC7N+b+dt9sxD3wm9L3JTLbmeT2b9yvALmNPMEVivAEhw+3LCw2zWnXwlCX
riHzN+q/VOztIP7R5S3q
=sQkb
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
