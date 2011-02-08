Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1BHFo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:44:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36598 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1BHFo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:44:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=o9xY0PvbD/8KU8OBfQTLWXij2ZsZyvduP7zCsjE1OEg+LipUmQ8/lDwYOL4lv5BdMH
         N+ZcT/2avEfxAQXI15A47GTyoI6J6ICKmEV742xFHAyxe7EKDNnT0EqhHhhR0EijGNst
         z3BadhdSFF31YVs+FfbKnt1GfJbzj7UHf0W+w=
MIME-Version: 1.0
In-Reply-To: <20110207180606.GB2966@flint.arm.linux.org.uk>
References: <20110207180606.GB2966@flint.arm.linux.org.uk>
Date: Tue, 8 Feb 2011 07:44:56 +0200
X-Google-Sender-Auth: P09yapw2FTgctrbG_i_1X93nSYI
Message-ID: <AANLkTi=Lftr41mHDXzK0c=pf7JYYOVWMjLX65JCLqDsU@mail.gmail.com>
Subject: Re: "slab: Fix missing DEBUG_SLAB last user" breaks ARM
From: Pekka Enberg <penberg@kernel.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Shiyong Li <shi-yong.li@motorola.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Feb 7, 2011 at 8:06 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> commit 5c5e3b33 appears to break ARM thusly:
>
> | Mount-cache hash table entries: 512
> | slab error in verify_redzone_free(): cache `idr_layer_cache': memory outside object was overwritten
> | Backtrace:
> | [<c0227088>] (dump_backtrace+0x0/0x110) from [<c0431afc>] (dump_stack+0x18/0x1c)
> | [<c0431ae4>] (dump_stack+0x0/0x1c) from [<c0293304>] (__slab_error+0x28/0x30)
> | [<c02932dc>] (__slab_error+0x0/0x30) from [<c0293a74>] (cache_free_debugcheck+0x1c0/0x2b8)
> | [<c02938b4>] (cache_free_debugcheck+0x0/0x2b8) from [<c0293f78>] (kmem_cache_free+0x3c/0xc0)
> | [<c0293f3c>] (kmem_cache_free+0x0/0xc0) from [<c032b1c8>] (ida_get_new_above+0x19c/0x1c0)
> | [<c032b02c>] (ida_get_new_above+0x0/0x1c0) from [<c02af7ec>] (alloc_vfsmnt+0x54/0x144)
> | [<c02af798>] (alloc_vfsmnt+0x0/0x144) from [<c0299830>] (vfs_kern_mount+0x30/0xec)
> | [<c0299800>] (vfs_kern_mount+0x0/0xec) from [<c0299908>] (kern_mount_data+0x1c/0x20)
> | [<c02998ec>] (kern_mount_data+0x0/0x20) from [<c02146c4>] (sysfs_init+0x68/0xc8)
> | [<c021465c>] (sysfs_init+0x0/0xc8) from [<c02137d4>] (mnt_init+0x90/0x1b0)
> | [<c0213744>] (mnt_init+0x0/0x1b0) from [<c0213388>] (vfs_caches_init+0x100/0x140)
> | [<c0213288>] (vfs_caches_init+0x0/0x140) from [<c0208c0c>] (start_kernel+0x2e8/0x368)
> | [<c0208924>] (start_kernel+0x0/0x368) from [<c0208034>] (__enable_mmu+0x0/0x2c)
> | c0113268: redzone 1:0xd84156c5c032b3ac, redzone 2:0xd84156c5635688c0.
> | slab error in cache_alloc_debugcheck_after(): cache `idr_layer_cache': double free, or memory outside object was overwritten
> | ...
> | c011307c: redzone 1:0x9f91102ffffffff, redzone 2:0x9f911029d74e35b
> | slab: Internal list corruption detected in cache 'idr_layer_cache'(24), slabp c0113000(16). Hexdump:
> |
> | 000: 20 4f 10 c0 20 4f 10 c0 7c 00 00 00 7c 30 11 c0
> | 010: 10 00 00 00 10 00 00 00 00 00 c9 17 fe ff ff ff
> | 020: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
> | 030: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
> | 040: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
> | 050: fe ff ff ff fe ff ff ff fe ff ff ff 11 00 00 00
> | 060: 12 00 00 00 13 00 00 00 14 00 00 00 15 00 00 00
> | 070: 16 00 00 00 17 00 00 00 c0 88 56 63
> | kernel BUG at /home/rmk/git/linux-2.6-rmk/mm/slab.c:2928!
>
> This hasn't been noticed as I guess not many people use SLAB on ARM
> anymore, and even less people probably have SLAB debugging enabled.
> With SLAB debugging disabled, the system appears to behave correctly -
> or maybe the problem is just hidden.

I thought the fix was for ARM, actually, but unfortunately the
changelog is somewhat terse (shame on me). Hmm?
