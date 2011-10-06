Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab1JFTz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:55:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55654 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab1JFTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:55:26 -0400
Subject: Re: [PATCH] staging: zcache: fix crash on cpu remove
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, cascardo@holoscopio.com, dan.magenheimer@oracle.com,
        rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, rcj@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, ngupta@vflare.org
In-Reply-To: <1317929306-18471-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1317929306-18471-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 12:55:14 -0700
Message-ID: <1317930914.15807.64.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 14:28 -0500, Seth Jennings wrote:
> In the case that a cpu is taken offline before zcache_do_preload() is
> ever called on the cpu, the per-cpu zcache_preloads structure will
> be uninitialized.  In the CPU_DEAD case for zcache_cpu_notifier(),
> kp->obj is not checked before calling kmem_cache_free() on it.
> If it is NULL, a crash results.
> 
> This patch ensures that both kp->obj and kp->page are not NULL before
> calling the respective free functions. In practice, just checking
> one or the other should be sufficient since they are assigned together
> in zcache_do_preload(), but I check both for safety.

zcache_objnode_alloc() and zcache_obj_alloc() seem to do the same thing:
dereference 'kp' without checking it for NULL.  That's fine, but it
requires that preemption be off between zcache_do_preload() and calling
those functions.  That seems to be the case today, but it worries me.

I can see another user getting added that does zcache_obj_alloc() but
forgot to disable preemption.  

We at least need a BUG_ON(!in_atomic()) near the dereferences.  The
enable/disable paths out of zcache_do_preload() look OK to me, but
they're not trivial.

Was there another purpose behind the preempt_disabling()?  We have a
number of spots on the kernel that do preloads but *don't* protect the
percpu buffers in the same way.  The radix-tree code, for instance, uses
preempt_disable() to provide the guarantee that an allocation does not
occur, but its data structures are safe to access without preempt.

IOW, with the radix code, a missed preempt_disable() costs you an
-ENOMEM.  With zcache it costs you an oops.

-- Dave

