Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1GFEen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:34:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36473 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1GFEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:34:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6398"; a="101826013"
Message-ID: <4E13E5B5.3030300@codeaurora.org>
Date: Tue, 05 Jul 2011 21:33:57 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>	<1306865673-20560-4-git-send-email-sboyd@codeaurora.org>	<20110630121909.d4ac1bfc.akpm@linux-foundation.org>	<4E0CCD4C.1090801@codeaurora.org> <20110630123616.dc17cfa9.akpm@linux-foundation.org>
In-Reply-To: <20110630123616.dc17cfa9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2011 12:36 PM, Andrew Morton wrote:
> On Thu, 30 Jun 2011 12:23:56 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Care to share the warnings? I'll run a build again and fix any new
>> warnings I find.

I only get one warning

In file included from /local/mnt2/workspace2/android/kernel/arch/x86/include/asm/uaccess.h:572,  
                 from /local/mnt2/workspace2/android/kernel/include/linux/uaccess.h:5,
                 from /local/mnt2/workspace2/android/kernel/drivers/staging/speakup/devsynth.c:4:
In function 'copy_from_user',
    inlined from 'speakup_file_write' at /local/mnt2/workspace2/android/kernel/drivers/staging/speakup/devsynth.c:28:
/local/mnt2/workspace2/android/kernel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct


But that's probably due to my compiler's age more than anything else
(and it seems you fixed it last Friday).

I did notice that I need to do an obj-y instead of a lib-y in the
Makefile. Can you please squash this into the patch titled
"consolidate-config_debug_strict_user_copy_checks.patch"?

----8<----->8------

diff --git a/lib/Makefile b/lib/Makefile
index 785f9b0..9ca779a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,7 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
         proportions.o prio_heap.o ratelimit.o show_mem.o \
         is_single_threaded.o plist.o decompress.o find_next_bit.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 


> In file included from /usr/src/devel/arch/x86/include/asm/uaccess.h:572,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:7,
>                  from include/linux/pagemap.h:10,
>                  from include/linux/mempolicy.h:70,
>                  from mm/mempolicy.c:68:
>
[snip]
> In function 'copy_from_user',
>     inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1246:
> /usr/src/devel/arch/x86/include/asm/uaccess_64.h:64: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
>

Does this help at all?

-----8<------->8-------

diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
index 92e7ea7..5c8f53c 100644
--- a/drivers/gpu/drm/radeon/radeon_state.c
+++ b/drivers/gpu/drm/radeon/radeon_state.c
@@ -2169,7 +2169,7 @@ static int radeon_cp_clear(struct drm_device *dev, void *data, struct drm_file *
 		sarea_priv->nbox = RADEON_NR_SAREA_CLIPRECTS;
 
 	if (DRM_COPY_FROM_USER(&depth_boxes, clear->depth_boxes,
-			       sarea_priv->nbox * sizeof(depth_boxes[0])))
+			       (size_t)sarea_priv->nbox * sizeof(depth_boxes[0])))
 		return -EFAULT;
 
 	radeon_cp_dispatch_clear(dev, file_priv->master, clear, depth_boxes);
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 098de2b..4dcdc3d 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -680,6 +680,10 @@ static int i2o_cfg_passthru32(struct file *file, unsigned cmnd,
 		}
 		size = size >> 16;
 		size *= 4;
+		if (size > sizeof(rmsg)) {
+			rcode = -EINVAL;
+			goto sg_list_cleanup;
+		}
 		/* Copy in the user's I2O command */
 		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 909ed9e..ce76d0c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2367,16 +2367,15 @@ static ssize_t
 sg_proc_write_adio(struct file *filp, const char __user *buffer,
 		   size_t count, loff_t *off)
 {
-	int num;
-	char buff[11];
+	int err;
+	unsigned long num;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	sg_allow_dio = simple_strtoul(buff, NULL, 10) ? 1 : 0;
+	err = kstrtoul_from_user(buffer, count, 0, &num);
+	if (err)
+		return err;
+	sg_allow_dio = num ? 1 : 0;
 	return count;
 }
 
@@ -2389,17 +2388,15 @@ static ssize_t
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)
 {
-	int num;
+	int err;
 	unsigned long k = ULONG_MAX;
-	char buff[11];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	k = simple_strtoul(buff, NULL, 10);
+
+	err = kstrtoul_from_user(buffer, count, 0, &k);
+	if (err)
+		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
 		sg_big_buff = k;
 		return count;
diff --git a/lib/Makefile b/lib/Makefile
index 785f9b0..9ca779a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,7 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o find_next_bit.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e7fb9d2..e9d4987 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1405,8 +1405,14 @@ asmlinkage long compat_sys_get_mempolicy(int __user *policy,
 	nr_bits = min_t(unsigned long, maxnode-1, MAX_NUMNODES);
 	alloc_size = ALIGN(nr_bits, BITS_PER_LONG) / 8;
 
-	if (nmask)
+	if (alloc_size > sizeof(bm))
+		return -EINVAL;
+
+	if (nmask) {
 		nm = compat_alloc_user_space(alloc_size);
+		if (!nm)
+			return -ENOMEM;
+	}
 
 	err = sys_get_mempolicy(policy, nm, nr_bits+1, addr, flags);
 
diff --git a/net/compat.c b/net/compat.c
index c578d93..b769233 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -789,6 +789,8 @@ asmlinkage long compat_sys_socketcall(int call, u32 __user *args)
 
 	if (call < SYS_SOCKET || call > SYS_SENDMMSG)
 		return -EINVAL;
+	if (nas[call] > sizeof(a))
+		return -EINVAL;
 	if (copy_from_user(a, args, nas[call]))
 		return -EFAULT;
 	a0 = a[0];
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index f76079c..2f4ea06 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1382,6 +1382,8 @@ static ssize_t pktgen_if_write(struct file *file,
 		len = strn_len(&user_buffer[i], sizeof(pkt_dev->src_min) - 1);
 		if (len < 0)
 			return len;
+		if (len > sizeof(buf))
+			return -EINVAL;
 
 		if (copy_from_user(buf, &user_buffer[i], len))
 			return -EFAULT;



-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

