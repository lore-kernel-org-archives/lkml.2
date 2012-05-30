Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2E3TnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:43:00 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60785 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2E3Tm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:42:57 -0400
Message-ID: <1338406967.2257.24.camel@localhost>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Eric Paris <eparis@parisplace.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 15:42:47 -0400
In-Reply-To: <20120530163605.GV11775@ZenIV.linux.org.uk>
References: <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
	 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
	 <1337112446.20904.50.camel@falcor>
	 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
	 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
	 <20120516004251.GO22082@ZenIV.linux.org.uk>
	 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
	 <20120516021828.GP22082@ZenIV.linux.org.uk>
	 <1337807899.15138.31.camel@falcor>
	 <20120530043443.GA3200@ZenIV.linux.org.uk>
	 <20120530163605.GV11775@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17)
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 17:36 +0100, Al Viro wrote:

> The only question is what do we want passed to resulting two hooks.  LSM
> folks?

Current hook:
 int security_file_mmap(struct file *file, unsigned long reqprot,
                        unsigned long prot, unsigned long flags,
                        unsigned long addr, unsigned long addr_only)

Obvious easy split:
 int security_file_mmap(struct file *file, unsigned long reqprot,
                        unsigned long prot, unsigned long flags)

 int security_addr_mmap(unsigned long addr)

security_addr_mmap would be used as you described.  Which means
security_file_mmap() would pretty much only be used in do_mmap_pgoff()
(or validate_mmap_request)

file:
capabilities: does not use
apparmor/smack/selinux: used to get security blobs from
file/dentry/inode

reqprot: the PROT_* requested by userspace.
prot: the actual PROT_* which will be applied (read-implies-exec is the
difference)

capabilities: does not use *prot
SMACK: does not use *prot
apparmor: only uses prot (not reqprot)
SELinux: uses prot or reqprot based on a kernel build/selinuxfs/cmdline
value.  Fedora/RHEL uses reqprot, not prot.  This seems dumb, but it's
what we are doing.

These are basically used to check permission to read/write/execute the
file based on PROT_READ/PROT_WRITE/PROT_EXECUTE etc.  If you move this
up we won't have reqprot and prot, we'll only have reqprot.  So we would
need a helper in the mm code which allow us to easily calculate the
read-implies-exec behavior.  for apparmor (and less common selinux)

***flags
capabilities: does not use
SMACK: does not use
apparmor: if (!(flags & MAP_PRIVATE))
SELinux: if ((flags & MAP_TYPE) == MAP_SHARED)

So both apparmor and SELinux only use flags to know if PROT_WRITE will
actually change the backing file.  PROT_WRITE is ignored if MAP_PRIVATE.
So this could be a bool called "shared" or the LSMs can just parse the
flags.  Doesn't matter to me.

