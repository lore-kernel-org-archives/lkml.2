Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2FLMjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:39:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab2FLMjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:39:14 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=aONDl-815hj8TuMJ4moA:9 a=PUjeQqilurYA:10 a=3uFqW_MJQ3aSgfpykNsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339504748.13377.121.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.19-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 12 Jun 2012 08:39:08 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-H7gX7uMCCm3o6rf9l/o/"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H7gX7uMCCm3o6rf9l/o/
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.2.19-rt31 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 9ff5baa988e758044a62a05b1f668b5ff556517c


Or to build 3.2.19-rt31 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.19.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.19-rt31.=
patch.xz


You can also build from 3.2.19-rt30 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.19-=
rt30-rt31.patch.xz



Enjoy,

-- Steve


Changes from 3.2.19-rt30:

---

John Kacur (1):
      scsi: qla2xxx: Use local_irq_save_nort() in qla2x00_poll

Priyanka Jain (1):
      net,RT:REmove preemption disabling in netif_rx()

Steven Rostedt (1):
      Linux 3.2.19-rt31

Thomas Gleixner (1):
      mips-remove-smp-reserve-lock.patch

----
 arch/mips/cavium-octeon/smp.c     |    6 ------
 drivers/scsi/qla2xxx/qla_inline.h |    4 ++--
 localversion-rt                   |    2 +-
 net/core/dev.c                    |    8 ++++----
 4 files changed, 7 insertions(+), 13 deletions(-)
---------------------------
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index efcfff4..86fce15 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -257,8 +257,6 @@ DEFINE_PER_CPU(int, cpu_state);
=20
 extern void fixup_irqs(void);
=20
-static DEFINE_SPINLOCK(smp_reserve_lock);
-
 static int octeon_cpu_disable(void)
 {
 	unsigned int cpu =3D smp_processor_id();
@@ -266,8 +264,6 @@ static int octeon_cpu_disable(void)
 	if (cpu =3D=3D 0)
 		return -EBUSY;
=20
-	spin_lock(&smp_reserve_lock);
-
 	cpu_clear(cpu, cpu_online_map);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
@@ -277,8 +273,6 @@ static int octeon_cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
=20
-	spin_unlock(&smp_reserve_lock);
-
 	return 0;
 }
=20
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_i=
nline.h
index 9902834..6d01db6 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -36,12 +36,12 @@ qla2x00_poll(struct rsp_que *rsp)
 {
 	unsigned long flags;
 	struct qla_hw_data *ha =3D rsp->hw;
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	if (IS_QLA82XX(ha))
 		qla82xx_poll(0, rsp);
 	else
 		ha->isp_ops->intr_handler(0, rsp);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
=20
 static inline uint8_t *
diff --git a/localversion-rt b/localversion-rt
index b72862e..a68b433 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt30
+-rt31
diff --git a/net/core/dev.c b/net/core/dev.c
index 811100d..578a74d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3030,7 +3030,7 @@ int netif_rx(struct sk_buff *skb)
 		struct rps_dev_flow voidflow, *rflow =3D &voidflow;
 		int cpu;
=20
-		preempt_disable();
+		migrate_disable();
 		rcu_read_lock();
=20
 		cpu =3D get_rps_cpu(skb->dev, skb, &rflow);
@@ -3040,13 +3040,13 @@ int netif_rx(struct sk_buff *skb)
 		ret =3D enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
=20
 		rcu_read_unlock();
-		preempt_enable();
+		migrate_enable();
 	}
 #else
 	{
 		unsigned int qtail;
-		ret =3D enqueue_to_backlog(skb, get_cpu(), &qtail);
-		put_cpu();
+		ret =3D enqueue_to_backlog(skb, get_cpu_light(), &qtail);
+		put_cpu_light();
 	}
 #endif
 	return ret;


--=-H7gX7uMCCm3o6rf9l/o/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP1zhsAAoJEIy3vGnGbaoARxUP/idZn09ooRqsWt0Uh2TtyQDn
hWxXmfY2ZfvuWMAhlLub2LvvD1mPWi5B5hIrPs3pbJBLepG2IXYEPzBw+1wlM7sq
7/lQ+FOHEj2lVHu800hSUHmvVbjJW9OEzOGr7dffteSwQejoedEV+XvoMhc2Pw0w
zBATFrpUa0LCIz0jxFMp8Z23HQXtLffOyOAhvD8bsPjOGVhgb0Mo1bbmCrbrVzJf
t2tpeG8ben9Ekx9moIjAjv0ZYWcS56Thbw08z63TTBMmBUbLlBmgq4TRV4efVU5c
Hx8I2HzblOHMCI1zCv9C1/umAhwxggLko+MqL45H4U/wck5nGufy1Ao74BY7/ghJ
aFAzMJjfNvv/XdqMx3q1G/h/9UZAspARQzDQmHEVKBODo7KExRLcbiMTDPZwyxB0
yhBJlPWK1kaPjHsRpB4vhJp68oTrXYreF6B7PUCOjpQ2wbYvKsR1niRWYFgmK8Gx
FR+4nGExCR0r7fUL/2iOKVqepiYcbn11OBr52vOYmzvT/qn777xu1vk+qn1avXnQ
ls7BeSa8ms/04Hv9k87klxKGuVDLeQbC6mz0LwjM5ObDCMTq7umHR7aZfOW72EiH
Ta40p1SocSCD7PiletGSOwzx9LYGOXa6Hn5vnzQpH4uPZMQaMFIKwX/F2ifwh7Dn
fJvlubT1WoL2UIxOF/iI
=2QQc
-----END PGP SIGNATURE-----

--=-H7gX7uMCCm3o6rf9l/o/--

