Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HISW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:22:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41512 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1HISWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:22:55 -0400
Message-ID: <4E417AF8.7090202@gmail.com>
Date: Tue, 09 Aug 2011 23:52:48 +0530
From: Mayank Rungta <mr.mynk@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        yakui.zhao@intel.com, ajax@redhat.com, airlied@redhat.com,
        airlied@linux.ie
CC: "A.R Karthick" <a.r.karthick@gmail.com>, karthick.linuxdreamer@gmail.com,
        Self <mr.mynk@gmail.com>
Subject: [PATCH 2.6.38-10-generic] device driver: fix oops in radeon driver
 due to incorrect value from hardware
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a check for the radeon ring buffer write index in r600.c which 
reads 0xffffffff on resume. This results in an Oops during 
radeon_ring_write. Masking the value averts this.

This problem is not seen to be fixed in 3.0 r600.c as well.

Detailed analysis of the problem can be found at -

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/

---

BUG: unable to handle kernel paging request at fa501ffc - Oops at 
r600_cp_start+0x48/0x380 in r600_cp_resume+0x345/0x580 [radeon]

drivers/gpu/drm/radeon/r600.c



--- linux-2.6.38/drivers/gpu/drm/radeon/r600.c.orig    2011-08-05 
15:39:40.824612700 +0530
+++ linux-2.6.38/drivers/gpu/drm/radeon/r600.c    2011-08-08 
05:29:21.744417857 +0530
@@ -2218,6 +2218,8 @@ int r600_cp_resume(struct radeon_device

      rdev->cp.rptr = RREG32(CP_RB_RPTR);
      rdev->cp.wptr = RREG32(CP_RB_WPTR);
+    /* protect against crazy HW on resume */
+    rdev->cp.wptr &= rdev->cp.ptr_mask;

      r600_cp_start(rdev);
      rdev->cp.ready = true;


         Developer's Certificate of Origin 1.1

         By making a contribution to this project, I certify that:

         (a) The contribution was created in whole or in part by me and I
             have the right to submit it under the open source license
             indicated in the file; or

         (b) The contribution is based upon previous work that, to the best
             of my knowledge, is covered under an appropriate open source
             license and I have the right under that license to submit that
             work with modifications, whether created in whole or in part
             by me, under the same open source license (unless I am
             permitted to submit under a different license), as indicated
             in the file; or

         (c) The contribution was provided directly to me by some other
             person who certified (a), (b) or (c) and I have not modified
             it.

     (d) I understand and agree that this project and the contribution
         are public and that a record of the contribution (including all
         personal information I submit with it, including my sign-off) is
         maintained indefinitely and may be redistributed consistent with
         this project or the open source license(s) involved.


     Signed-off-by: A R Karthick <a.r.karthick@gmail.com>

     Reported-by: Mayank Rungta <mr.mynk@gmail.com>

     Tested-by: Mayank Rungta <mr.mynk@gmail.com>
