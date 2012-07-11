Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab2GKVkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:40:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab2GKVkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:40:05 -0400
Date: Wed, 11 Jul 2012 14:40:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, chris@zankel.net, catalin.marinas@arm.com,
        arnd@arndb.de, cmetcalf@tilera.com
Subject: Re: [PATCH 2/3] ipc: allow compat IPC version field parsing if
 !ARCH_WANT_OLD_COMPAT_IPC
Message-Id: <20120711144001.b1f7c21d.akpm@linux-foundation.org>
In-Reply-To: <1342020741-12758-3-git-send-email-will.deacon@arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
	<1342020741-12758-3-git-send-email-will.deacon@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 16:32:20 +0100
Will Deacon <will.deacon@arm.com> wrote:

> Commit 48b25c43 ("[PATCH v3] ipc: provide generic compat versions of IPC
> syscalls") added a new ARCH_WANT_OLD_COMPAT_IPC config option for
> architectures to select if their compat target requires the old IPC
> syscall interface.
> 
> For architectures (such as AArch64) that do not require the internal
> calling conventions provided by this option, but have a compat target
> where the C library passes the IPC_64 flag explicitly,
> compat_ipc_parse_version no longer strips out the flag before calling
> the native system call implementation, resulting in unknown SHM/IPC
> commands and -EINVAL being returned to userspace.
> 
> This patch separates the selection of the internal calling conventions
> for the IPC syscalls from the version parsing, allowing architectures to
> select __ARCH_WANT_COMPAT_IPC_PARSE_VERSION if they want to use version
> parsing whilst retaining the newer syscall calling conventions.
> 
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/linux/compat.h |    1 +
>  ipc/compat.c           |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 4e89039..9f68e90 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -256,6 +256,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  			   compat_size_t __user *len_ptr);
>  
>  #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
> +#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>  long compat_sys_semctl(int first, int second, int third, void __user *uptr);
>  long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
>  long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
> diff --git a/ipc/compat.c b/ipc/compat.c
> index 53cebdf..a41600f 100644
> --- a/ipc/compat.c
> +++ b/ipc/compat.c
> @@ -118,7 +118,7 @@ extern int sem_ctls[];
>  
>  static inline int compat_ipc_parse_version(int *cmd)
>  {
> -#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
> +#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>  	int version = *cmd & IPC_64;
>  
>  	/* this is tricky: architectures that have support for the old

Could we do this purely in Kconfig?  Add a new
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION and always set it true if
CONFIG_ARCH_WANT_OLD_COMPAT_IPC?
