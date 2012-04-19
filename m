Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2DSQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:53:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52871 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2DSQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:53:56 -0400
Date: Thu, 19 Apr 2012 18:53:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Borislav Petkov <bp@amd64.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Frank Arnold <frank.arnold@amd.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [GIT PULL] L3 CID fix for 3.5
Message-ID: <20120419165353.GF3221@aftab.osrc.amd.com>
References: <20120419070053.GB16645@elgon.mountain>
 <4F8FCA3A.5060504@linux.vnet.ibm.com>
 <20120419110229.GB30447@aftab>
 <20120419114453.GO6498@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419114453.GO6498@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull the following fix for L3 cache index disable into tip. Since
there's no real breakage but simply a correctness issue, it can wait for
3.5. I've also removed the stable tag I had in the previous version.

Thanks.

--
The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/l3-fix-for-3.5

for you to fetch changes up to a720b2dd2470a52345df11dca8d6c1466599f812:

  x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot() (2012-04-19 18:30:28 +0200)

----------------------------------------------------------------
A small L3 cache index disable fix from Srivatsa Bhat which unifies the
way the code checks for already disabled indices.

----------------------------------------------------------------
Srivatsa S. Bhat (1):
      x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()

 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Appending patch here too:

--
commit a720b2dd2470a52345df11dca8d6c1466599f812
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Thu Apr 19 12:35:08 2012 +0200

    x86, intel_cacheinfo: Fix error return code in amd_set_l3_disable_slot()
    
    If the L3 disable slot is already in use, return -EEXIST instead of
    -EINVAL. The caller, store_cache_disable(), checks this return value to
    print an appropriate warning.
    
    Also, we want to signal with -EEXIST that the current index we're
    disabling has actually been already disabled on the node:
    
    $ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
    $ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_0
    -bash: echo: write error: File exists
    $ echo 12 > /sys/devices/system/cpu/cpu3/cache/index3/cache_disable_1
    -bash: echo: write error: File exists
    $ echo 12 > /sys/devices/system/cpu/cpu5/cache/index3/cache_disable_1
    -bash: echo: write error: File exists
    
    The old code would say
    
    -bash: echo: write error: Invalid argument
    
    for disable slot 1 when playing the example above with no output in
    dmesg, which is clearly misleading.
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    Link: http://lkml.kernel.org/r/20120419070053.GB16645@elgon.mountain
    [Boris: add testing for the other index too]
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 73d08ed98a64..b8f3653dddbc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -433,14 +433,14 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
-		return -EINVAL;
+		return -EEXIST;
 
 	if (index > nb->l3_cache.indices)
 		return -EINVAL;
 
 	/* check whether the other slot has disabled the same index already */
 	if (index == amd_get_l3_disable_slot(nb, !slot))
-		return -EINVAL;
+		return -EEXIST;
 
 	amd_l3_disable_index(nb, cpu, slot, index);
 
@@ -468,8 +468,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
-			printk(KERN_WARNING "L3 disable slot %d in use!\n",
-					    slot);
+			pr_warning("L3 slot %d in use/index already disabled!\n",
+				   slot);
 		return err;
 	}
 	return count;

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
