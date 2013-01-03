Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3ACBHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:07:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58990 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab3ACBHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:07:01 -0500
Date: Thu, 3 Jan 2013 12:06:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-Id: <20130103120650.a19cea9d14a664893c0a5e30@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Jan_2013_12_06_50_+1100_JL+Q1SQ5Y+PmOpyV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Jan_2013_12_06_50_+1100_JL+Q1SQ5Y+PmOpyV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got conflicts in
arch/s390/include/asm/irq.h and arch/s390/kernel/irq.c between commit
bfb048f594d5 ("s390/irq: remove split irq fields from /proc/stat") from
the s390 tree and commit 7e64e0597fd6 ("KVM: s390: Add a channel I/O
based virtio transport driver") from the kvm tree.

I fixed it up (I think - see below) including the following merge fix
patch and can carry the fix as necessary (more action may be required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 Jan 2013 12:04:39 +1100
Subject: [PATCH] KVM: s390: fix for IOINT_VIR name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/s390/kvm/virtio_ccw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 1a5aff3..f94a0b1 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -745,7 +745,7 @@ static struct ccw_driver virtio_ccw_driver =3D {
 	.set_offline =3D virtio_ccw_offline,
 	.set_online =3D virtio_ccw_online,
 	.notify =3D virtio_ccw_cio_notify,
-	.int_class =3D IOINT_VIR,
+	.int_class =3D IRQIO_VIR,
 };
=20
 static int __init pure_hex(char **cp, unsigned int *val, int min_digit,
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/include/asm/irq.h
index 7def773,aa6d0d7..0000000
--- a/arch/s390/include/asm/irq.h
+++ b/arch/s390/include/asm/irq.h
@@@ -2,61 -2,44 +2,62 @@@
  #define _ASM_IRQ_H
 =20
  #include <linux/hardirq.h>
 +#include <linux/percpu.h>
 +#include <linux/cache.h>
  #include <linux/types.h>
 =20
 -enum interruption_class {
 +enum interruption_main_class {
  	EXTERNAL_INTERRUPT,
  	IO_INTERRUPT,
 -	EXTINT_CLK,
 -	EXTINT_EXC,
 -	EXTINT_EMS,
 -	EXTINT_TMR,
 -	EXTINT_TLA,
 -	EXTINT_PFL,
 -	EXTINT_DSD,
 -	EXTINT_VRT,
 -	EXTINT_SCP,
 -	EXTINT_IUC,
 -	EXTINT_CMS,
 -	EXTINT_CMC,
 -	EXTINT_CMR,
 -	IOINT_CIO,
 -	IOINT_QAI,
 -	IOINT_DAS,
 -	IOINT_C15,
 -	IOINT_C70,
 -	IOINT_TAP,
 -	IOINT_VMR,
 -	IOINT_LCS,
 -	IOINT_CLW,
 -	IOINT_CTC,
 -	IOINT_APB,
 -	IOINT_ADM,
 -	IOINT_CSC,
 -	IOINT_PCI,
 -	IOINT_MSI,
 -	IOINT_VIR,
 +	NR_IRQS
 +};
 +
 +enum interruption_class {
 +	IRQEXT_CLK,
 +	IRQEXT_EXC,
 +	IRQEXT_EMS,
 +	IRQEXT_TMR,
 +	IRQEXT_TLA,
 +	IRQEXT_PFL,
 +	IRQEXT_DSD,
 +	IRQEXT_VRT,
 +	IRQEXT_SCP,
 +	IRQEXT_IUC,
 +	IRQEXT_CMS,
 +	IRQEXT_CMC,
 +	IRQEXT_CMR,
 +	IRQIO_CIO,
 +	IRQIO_QAI,
 +	IRQIO_DAS,
 +	IRQIO_C15,
 +	IRQIO_C70,
 +	IRQIO_TAP,
 +	IRQIO_VMR,
 +	IRQIO_LCS,
 +	IRQIO_CLW,
 +	IRQIO_CTC,
 +	IRQIO_APB,
 +	IRQIO_ADM,
 +	IRQIO_CSC,
 +	IRQIO_PCI,
 +	IRQIO_MSI,
++	IRQIO_VIR,
  	NMI_NMI,
 -	NR_IRQS,
 +	CPU_RST,
 +	NR_ARCH_IRQS
  };
 =20
 +struct irq_stat {
 +	unsigned int irqs[NR_ARCH_IRQS];
 +};
 +
 +DECLARE_PER_CPU_SHARED_ALIGNED(struct irq_stat, irq_stat);
 +
 +static __always_inline void inc_irq_stat(enum interruption_class irq)
 +{
 +	__get_cpu_var(irq_stat).irqs[irq]++;
 +}
 +
  struct ext_code {
  	unsigned short subcode;
  	unsigned short code;
diff --cc arch/s390/kernel/irq.c
index 9df824e,a9806ea..0000000
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@@ -32,57 -29,39 +32,58 @@@ struct irq_class=20
  	char *desc;
  };
 =20
 -static const struct irq_class intrclass_names[] =3D {
 +/*
 + * The list of "main" irq classes on s390. This is the list of interrrupts
 + * that appear both in /proc/stat ("intr" line) and /proc/interrupts.
 + * Historically only external and I/O interrupts have been part of /proc/=
stat.
 + * We can't add the split external and I/O sub classes since the first fi=
eld
 + * in the "intr" line in /proc/stat is supposed to be the sum of all other
 + * fields.
 + * Since the external and I/O interrupt fields are already sums we would =
end
 + * up with having a sum which accounts each interrupt twice.
 + */
 +static const struct irq_class irqclass_main_desc[NR_IRQS] =3D {
  	[EXTERNAL_INTERRUPT] =3D {.name =3D "EXT"},
 -	[IO_INTERRUPT]	     =3D {.name =3D "I/O"},
 -	[EXTINT_CLK] =3D {.name =3D "CLK", .desc =3D "[EXT] Clock Comparator"},
 -	[EXTINT_EXC] =3D {.name =3D "EXC", .desc =3D "[EXT] External Call"},
 -	[EXTINT_EMS] =3D {.name =3D "EMS", .desc =3D "[EXT] Emergency Signal"},
 -	[EXTINT_TMR] =3D {.name =3D "TMR", .desc =3D "[EXT] CPU Timer"},
 -	[EXTINT_TLA] =3D {.name =3D "TAL", .desc =3D "[EXT] Timing Alert"},
 -	[EXTINT_PFL] =3D {.name =3D "PFL", .desc =3D "[EXT] Pseudo Page Fault"},
 -	[EXTINT_DSD] =3D {.name =3D "DSD", .desc =3D "[EXT] DASD Diag"},
 -	[EXTINT_VRT] =3D {.name =3D "VRT", .desc =3D "[EXT] Virtio"},
 -	[EXTINT_SCP] =3D {.name =3D "SCP", .desc =3D "[EXT] Service Call"},
 -	[EXTINT_IUC] =3D {.name =3D "IUC", .desc =3D "[EXT] IUCV"},
 -	[EXTINT_CMS] =3D {.name =3D "CMS", .desc =3D "[EXT] CPU-Measurement: Sam=
pling"},
 -	[EXTINT_CMC] =3D {.name =3D "CMC", .desc =3D "[EXT] CPU-Measurement: Cou=
nter"},
 -	[EXTINT_CMR] =3D {.name =3D "CMR", .desc =3D "[EXT] CPU-Measurement: RI"=
},
 -	[IOINT_CIO]  =3D {.name =3D "CIO", .desc =3D "[I/O] Common I/O Layer Int=
errupt"},
 -	[IOINT_QAI]  =3D {.name =3D "QAI", .desc =3D "[I/O] QDIO Adapter Interru=
pt"},
 -	[IOINT_DAS]  =3D {.name =3D "DAS", .desc =3D "[I/O] DASD"},
 -	[IOINT_C15]  =3D {.name =3D "C15", .desc =3D "[I/O] 3215"},
 -	[IOINT_C70]  =3D {.name =3D "C70", .desc =3D "[I/O] 3270"},
 -	[IOINT_TAP]  =3D {.name =3D "TAP", .desc =3D "[I/O] Tape"},
 -	[IOINT_VMR]  =3D {.name =3D "VMR", .desc =3D "[I/O] Unit Record Devices"=
},
 -	[IOINT_LCS]  =3D {.name =3D "LCS", .desc =3D "[I/O] LCS"},
 -	[IOINT_CLW]  =3D {.name =3D "CLW", .desc =3D "[I/O] CLAW"},
 -	[IOINT_CTC]  =3D {.name =3D "CTC", .desc =3D "[I/O] CTC"},
 -	[IOINT_APB]  =3D {.name =3D "APB", .desc =3D "[I/O] AP Bus"},
 -	[IOINT_ADM]  =3D {.name =3D "ADM", .desc =3D "[I/O] EADM Subchannel"},
 -	[IOINT_CSC]  =3D {.name =3D "CSC", .desc =3D "[I/O] CHSC Subchannel"},
 -	[IOINT_PCI]  =3D {.name =3D "PCI", .desc =3D "[I/O] PCI Interrupt" },
 -	[IOINT_MSI] =3D  {.name =3D "MSI", .desc =3D "[I/O] MSI Interrupt" },
 -	[IOINT_VIR]  =3D {.name =3D "VIR", .desc =3D "[I/O] Virtual I/O Devices"=
},
 +	[IO_INTERRUPT]	     =3D {.name =3D "I/O"}
 +};
 +
 +/*
 + * The list of split external and I/O interrupts that appear only in
 + * /proc/interrupts.
 + * In addition this list contains non external / I/O events like NMIs.
 + */
 +static const struct irq_class irqclass_sub_desc[NR_ARCH_IRQS] =3D {
 +	[IRQEXT_CLK] =3D {.name =3D "CLK", .desc =3D "[EXT] Clock Comparator"},
 +	[IRQEXT_EXC] =3D {.name =3D "EXC", .desc =3D "[EXT] External Call"},
 +	[IRQEXT_EMS] =3D {.name =3D "EMS", .desc =3D "[EXT] Emergency Signal"},
 +	[IRQEXT_TMR] =3D {.name =3D "TMR", .desc =3D "[EXT] CPU Timer"},
 +	[IRQEXT_TLA] =3D {.name =3D "TAL", .desc =3D "[EXT] Timing Alert"},
 +	[IRQEXT_PFL] =3D {.name =3D "PFL", .desc =3D "[EXT] Pseudo Page Fault"},
 +	[IRQEXT_DSD] =3D {.name =3D "DSD", .desc =3D "[EXT] DASD Diag"},
 +	[IRQEXT_VRT] =3D {.name =3D "VRT", .desc =3D "[EXT] Virtio"},
 +	[IRQEXT_SCP] =3D {.name =3D "SCP", .desc =3D "[EXT] Service Call"},
 +	[IRQEXT_IUC] =3D {.name =3D "IUC", .desc =3D "[EXT] IUCV"},
 +	[IRQEXT_CMS] =3D {.name =3D "CMS", .desc =3D "[EXT] CPU-Measurement: Sam=
pling"},
 +	[IRQEXT_CMC] =3D {.name =3D "CMC", .desc =3D "[EXT] CPU-Measurement: Cou=
nter"},
 +	[IRQEXT_CMR] =3D {.name =3D "CMR", .desc =3D "[EXT] CPU-Measurement: RI"=
},
 +	[IRQIO_CIO]  =3D {.name =3D "CIO", .desc =3D "[I/O] Common I/O Layer Int=
errupt"},
 +	[IRQIO_QAI]  =3D {.name =3D "QAI", .desc =3D "[I/O] QDIO Adapter Interru=
pt"},
 +	[IRQIO_DAS]  =3D {.name =3D "DAS", .desc =3D "[I/O] DASD"},
 +	[IRQIO_C15]  =3D {.name =3D "C15", .desc =3D "[I/O] 3215"},
 +	[IRQIO_C70]  =3D {.name =3D "C70", .desc =3D "[I/O] 3270"},
 +	[IRQIO_TAP]  =3D {.name =3D "TAP", .desc =3D "[I/O] Tape"},
 +	[IRQIO_VMR]  =3D {.name =3D "VMR", .desc =3D "[I/O] Unit Record Devices"=
},
 +	[IRQIO_LCS]  =3D {.name =3D "LCS", .desc =3D "[I/O] LCS"},
 +	[IRQIO_CLW]  =3D {.name =3D "CLW", .desc =3D "[I/O] CLAW"},
 +	[IRQIO_CTC]  =3D {.name =3D "CTC", .desc =3D "[I/O] CTC"},
 +	[IRQIO_APB]  =3D {.name =3D "APB", .desc =3D "[I/O] AP Bus"},
 +	[IRQIO_ADM]  =3D {.name =3D "ADM", .desc =3D "[I/O] EADM Subchannel"},
 +	[IRQIO_CSC]  =3D {.name =3D "CSC", .desc =3D "[I/O] CHSC Subchannel"},
 +	[IRQIO_PCI]  =3D {.name =3D "PCI", .desc =3D "[I/O] PCI Interrupt" },
 +	[IRQIO_MSI]  =3D {.name =3D "MSI", .desc =3D "[I/O] MSI Interrupt" },
++	[IRQIO_VIR]  =3D {.name =3D "VIR", .desc =3D "[I/O] Virtual I/O Devices"=
},
  	[NMI_NMI]    =3D {.name =3D "NMI", .desc =3D "[NMI] Machine Check"},
 +	[CPU_RST]    =3D {.name =3D "RST", .desc =3D "[CPU] CPU Restart"},
  };
 =20
  /*

--Signature=_Thu__3_Jan_2013_12_06_50_+1100_JL+Q1SQ5Y+PmOpyV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5NmqAAoJEECxmPOUX5FEV/EP/j2JGXApgp3QldqsWL4FWoEw
f6xQTc3H1NSCIn5Lyl9BvhFXJyQOKUYfHc9haVfQ5XBebSsdQXjtN4r6IgDtWVQ/
2hizgNjghWCMEef6FVcYFSLmq9LP7L7rkKVsyKkjicN8DELpYrXXPgOzfjPvHdcV
vO5Mmc1xeFD4Q24xXWUa2uBW18jBa6h02bAwJgET5FMNHH0Cl7YWiptyxLRTyvA/
eN0xVEojD9LYcbDFEMOKwVP7atoEDrkvms3xBClQLM2NiDlwQUud2oTgGTTuAIpQ
zoIeObeIcUORVXj7/Az9ZsLNRto1Vv3PKVkSRk/QylD6p4T/+yXqUsTXKRCwyjO7
MpV5nSZSUjaLy02Pav2N2KQwSpBJgKf+GtLa2RxsAOCW3XeLLjBLo3DltEUrDQgF
7yFRhH+fM0SgYGncvOIwSp+GFFzeFO5ZN2FFNGNICaprSwR/0yFynH0+S+8oTOhT
tGp7HyvIgz9UoEpIGKScebOeSWza53YRznBgRyw74MnpVfU+h0ChcR4a9WH0+7Yt
ANNhQKfuTgLIXFBZk0LDhrazyFPQbXrk7LLKGk5PEGxkifIKb8GzksejOVpf20/5
FhxnAltcMicQTyzg1s3B1rkoO1MjCylQeMBpHCX8aTRX7EPlEJBoIm1bSjpcEakm
ngYSkBOiiQuh+iiRcBy4
=1lwb
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Jan_2013_12_06_50_+1100_JL+Q1SQ5Y+PmOpyV--
