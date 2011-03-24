Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab1CXTvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:51:45 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:24699 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933934Ab1CXTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:51:43 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xUGcm6wVM1m8Yuhc.VBOBDtRiNcEmOy8cS6MY.wCGgE06Wz
 QzoEzYXDe2Dt3bAY5bot2sXy_TxYSUqFV2IQrqz12RrSWH_n1YApkNZEnvFo
 mGomrroFSXtX2w6At_j2Kxo9fTDsNISjK2CULcVv3tOjqRexa83WoppP_Pj.
 XRjLg4XeQz8.UoyPIl1SZVOWhiuCLtU.l7ylPMmwHsrzhZZNEh.hlo0y.D4l
 _kQvyG8.DZpIfQsPNbecbcUmua_D0gwdwEKcIvsFjVT4EOYWfgdeOsxq8lEc
 9fGKqQXdyLdYHiWzpleIK7x.MBLtJEwYtAV0xbb56p_zJBQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 14:51:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103241451060.5576@router.home>
References: <alpine.DEB.2.00.1103241300420.32226@router.home> <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com> <alpine.DEB.2.00.1103241312280.32226@router.home> <1300990853.3747.189.camel@edumazet-laptop> <alpine.DEB.2.00.1103241346060.32226@router.home>
 <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com> <20110324185903.GA30510@elte.hu> <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com> <alpine.DEB.2.00.1103241404490.5576@router.home> <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
 <20110324193647.GA7957@elte.hu> <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Pekka Enberg wrote:

> Thanks, Ingo! Christoph, may I have your sign-off for the patch and
> I'll send it to Linus?


Subject: SLUB: Write to per cpu data when allocating it

It turns out that the cmpxchg16b emulation has to access vmalloced
percpu memory with interrupts disabled. If the memory has never
been touched before then the fault necessary to establish the
mapping will not to occur and the kernel will fail on boot.

Fix that by reusing the CONFIG_PREEMPT code that writes the
cpu number into a field on every cpu. Writing to the per cpu
area before causes the mapping to be established before we get
to a cmpxchg16b emulation.

Tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-03-24 14:03:10.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-03-24 14:04:08.000000000 -0500
@@ -1604,7 +1604,7 @@ static inline void note_cmpxchg_failure(

 void init_kmem_cache_cpus(struct kmem_cache *s)
 {
-#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
+#ifdef CONFIG_CMPXCHG_LOCAL
 	int cpu;

 	for_each_possible_cpu(cpu)
