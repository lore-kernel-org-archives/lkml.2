Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2JRDHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:07:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47814 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JRDHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:07:49 -0400
Date: Wed, 17 Oct 2012 20:07:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>,
        Li Zefan <lizefan@huawei.com>, Aristeu Rozanski <aris@redhat.com>,
        Tejun Heo <tj@kernel.org>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [ima_inode_post_setattr] kernel BUG at mm/slub.c:3479!
In-Reply-To: <20121018024317.GA25407@localhost>
Message-ID: <alpine.DEB.2.00.1210171957380.32271@chino.kir.corp.google.com>
References: <20121018024317.GA25407@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Fengguang Wu wrote:

> Mimi,
> 
> Although this occurs in the xen tree head, it's more likely related to
> ima_inode_post_setattr().
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/for-linus-3.8
> head:   d01b193de1a961e028ee6df5ad0b34c3e56a995f
> commit: d01b193de1a961e028ee6df5ad0b34c3e56a995f [0/0] xen/acpi: Support ACPI hotplug of CPUs.
> 
> [  115.499469] Write protecting the kernel read-only data: 2752k
> [  134.707390] ------------[ cut here ]------------
> [  134.707390] kernel BUG at /c/kernel-tests/src/linux/mm/slub.c:3479!
> [  134.707390] invalid opcode: 0000 [#1] 
> [  134.707390] Pid: 1, comm: init Not tainted 3.6.0-00451-gd01b193 #2 Bochs Bochs
> [  134.707390] EIP: 0060:[<c1235dbe>] EFLAGS: 00000246 CPU: 0
> [  134.707390] EIP is at kfree+0x2be/0x490
> [  134.707390] EAX: 00000001 EBX: 00000001 ECX: 00000000 EDX: 00000000
> [  134.707390] ESI: cdeef760 EDI: cd83bdac EBP: cd83bd70 ESP: cd83bd50
> [  134.707390]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> [  134.707390] CR0: 80050033 CR2: b7782000 CR3: 0f9a8000 CR4: 00000690
> [  134.707390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  134.707390] DR6: 00000000 DR7: 00000000
> [  134.707390] Process init (pid: 1, ti=cd83a000 task=cd838000 task.ti=cd83a000)
> [  134.707390] Stack:
> [  134.707390]  00000000 cd83bd5c c1085b74 cd83bd88 c1298a5e cd83a000 ffffffc3 cd83bd90
> [  134.707390]  cd83bd88 c1298a5e cd83bd90 c1ffdf63 00000001 cd832914 cd83bd98 c1298d4a
> [  134.707390]  00000000 00000002 cd83bdac c11e0400 c995c980 cd832914 00000000 cd83bdc4
> [  134.707390] Call Trace:
> [  134.707390]  [<c1085b74>] ? irq_exit+0x74/0x180
> [  134.707390]  [<c1298a5e>] ? __simple_xattr_set+0x28e/0x360
> [  134.707390]  [<c1298a5e>] __simple_xattr_set+0x28e/0x360
> [  134.707390]  [<c1298d4a>] simple_xattr_remove+0x2a/0x40
> [  134.707390]  [<c11e0400>] shmem_removexattr+0xc0/0x120
> [  134.707390]  [<c14f11ed>] ima_inode_post_setattr+0x21d/0x250

This is a scary one because it involves kfree() of memory that is not 
allocated through the slab allocator, and not bypassed because its too 
large or otherwise we would have PageCompound() set.

Examining __simple_xattr_set(), though, we know flags has XATTR_REPLACE 
set and value == NULL since it's being called from simple_xattr_remove().  
That means the local new_xattr variable is initialized to itself, which is 
just going to be anything that happens to be on the stack.  If the name 
passed to simple_xattr_remove() isn't found in the list of xattrs, then 
this will call kfree(xattr) which was never set to anything else.

This was changed in commit 38f38657444d ("xattr: extract simple_xattr code 
from tmpfs") and the old code actually properly initialized new_xattr to 
NULL in which case this would simply fail with -ENODATA instead of causing 
the BUG().

So while it's probably not advised to call simple_xattr_remove() for a 
name that does not exist in the xattr list, this seems to be as a result 
of that commit rather than anything from ima_inode_post_setattr().

Let's add Aristeu Rozanski, Li, Hugh, and Tejun to the cc list.
