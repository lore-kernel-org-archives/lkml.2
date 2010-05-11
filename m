Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0EKDox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab0EKDou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:44:50 -0400
Date: Tue, 11 May 2010 00:43:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, agraf@suse.de, yoshikawa.takuya@oss.ntt.co.jp,
       fernando@oss.ntt.co.jp, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
       kvm-ia64@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, benh@kernel.crashing.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/12] KVM: introduce new API for getting/switching
 dirty bitmaps
Message-ID: <20100511034329.GB3458@amt.cnet>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
 <20100504220821.d68bde57.takuya.yoshikawa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504220821.d68bde57.takuya.yoshikawa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:08:21PM +0900, Takuya Yoshikawa wrote:
> Now that dirty bitmaps are accessible from user space, we export the
> addresses of these to achieve zero-copy dirty log check:
> 
>   KVM_GET_USER_DIRTY_LOG_ADDR
> 
> We also need an API for triggering dirty bitmap switch to take the full
> advantage of double buffered bitmaps.
> 
>   KVM_SWITCH_DIRTY_LOG
> 
> See the documentation in this patch for precise explanations.
> 
> About performance improvement: the most important feature of switch API
> is the lightness. In our test, this appeared in the form of improved
> responses for GUI manipulations.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> CC: Avi Kivity <avi@redhat.com>
> CC: Alexander Graf <agraf@suse.de>
> ---
>  Documentation/kvm/api.txt |   87 +++++++++++++++++++++++++++++++++++++++++++++
>  arch/ia64/kvm/kvm-ia64.c  |   27 +++++++++-----
>  arch/powerpc/kvm/book3s.c |   18 +++++++--
>  arch/x86/kvm/x86.c        |   44 ++++++++++++++++-------
>  include/linux/kvm.h       |   11 ++++++
>  include/linux/kvm_host.h  |    4 ++-
>  virt/kvm/kvm_main.c       |   63 +++++++++++++++++++++++++++++----
>  7 files changed, 220 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
> index a237518..c106c83 100644
> --- a/Documentation/kvm/api.txt
> +++ b/Documentation/kvm/api.txt
> @@ -892,6 +892,93 @@ arguments.
>  This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
>  irqchip, the multiprocessing state must be maintained by userspace.
>  
> +4.39 KVM_GET_USER_DIRTY_LOG_ADDR
> +
> +Capability: KVM_CAP_USER_DIRTY_LOG (>=1 see below)
> +Architectures: all
> +Type: vm ioctl
> +Parameters: struct kvm_user_dirty_log (in/out)
> +Returns: 0 on success, -1 on error
> +
> +This ioctl makes it possible to use KVM_SWITCH_DIRTY_LOG (see 4.40) instead
> +of the old dirty log manipulation by KVM_GET_DIRTY_LOG.
> +
> +A bit about KVM_CAP_USER_DIRTY_LOG
> +
> +Before this ioctl was introduced, dirty bitmaps for dirty page logging were
> +allocated in the kernel's memory space.  But we have now moved them to user
> +space to get more flexiblity and performance.  To achive this move without
> +breaking the compatibility, we will split KVM_CAP_USER_DIRTY_LOG capability
> +into a few generations which can be identified by its check extension
> +return values.
> +
> +This KVM_GET_USER_DIRTY_LOG_ADDR belongs to the first generation with the
> +KVM_SWITCH_DIRTY_LOG (4.40) and must be supported by all generations.
> +
> +What you get
> +
> +By using this, you can get paired bitmap addresses which are accessible from
> +user space.  See the explanation in 4.40 for the roles of these two bitmaps.
> +
> +How to Get
> +
> +Before calling this, you have to set the slot member of kvm_user_dirty_log
> +to indicate the target memory slot.
> +
> +struct kvm_user_dirty_log {
> +	__u32 slot;
> +	__u32 flags;
> +	__u64 dirty_bitmap;
> +	__u64 dirty_bitmap_old;
> +};
> +
> +The addresses will be set in the paired members: dirty_bitmap and _old.

Why not pass the bitmap address to the kernel, instead of having the
kernel allocate it. Because apparently you plan to do that in a new
generation anyway?

Also, why does the kernel need to know about different bitmaps?

One alternative would be:

KVM_SWITCH_DIRTY_LOG passing the address of a bitmap. If the active
bitmap was clean, it returns 0, no switch performed. If the active
bitmap was dirty, the kernel switches to the new bitmap and returns 1.

And the responsability of cleaning the new bitmap could also be left
for userspace.

