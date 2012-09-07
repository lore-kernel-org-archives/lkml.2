Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2IGROm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:14:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49556 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2IGROj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:14:39 -0400
Message-ID: <1347037964.31197.100.camel@falcor>
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Date: Fri, 07 Sep 2012 13:12:44 -0400
In-Reply-To: <87ipbqhenn.fsf@rustcorp.com.au>
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
	 <87ipbqhenn.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090717-3534-0000-0000-00000C600E43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 09:45 +0930, Rusty Russell wrote:
> Kees Cook <keescook@chromium.org> writes:
> > Instead of (or in addition to) kernel module signing, being able to reason
> > about the origin of a kernel module would be valuable in situations
> > where an OS already trusts a specific file system, file, etc, due to
> > things like security labels or an existing root of trust to a partition
> > through things like dm-verity.
> >
> > This introduces a new syscall (currently only on x86), similar to
> > init_module, that has only two arguments. The first argument is used as
> > a file descriptor to the module and the second argument is a pointer to
> > the NULL terminated string of module arguments.
> 
> Thanks.  Minor comments follow:

Rusty, sorry for bringing this up again, but with Kees' new syscall,
which passes in the file descriptor, appraising the integrity of kernel
modules could be like appraising the integrity of any other file on the
filesystem.  All that would be needed is a new security hook, which is
needed in anycase for IMA measurement.

The concerns with this approach, expressed in the past by David Howells,
are that it requires IMA-appraisal to be enabled, extended attribute
support, and changes to userspace tools.  Normally I wouldn't be too
concerned about filesystems that don't support extended attributes, but
the initramfs is currently cpio.  Perhaps this isn't an issue in
anycase, as the initramfs would be appraised in the secure boot
environment.

The first two concerns could be addressed by passing in a digital
signature, which the new syscall supports. The signature could be stored
as an extended attribute, appended to the kernel module or, as
originally described by Dmitry, in a .sig file. Where/how the signature
is stored would be left up to the distro's and userspace tool's
discretion.

When EVM/IMA-appraisal is enabled, it would either appraise the kernel
module based on the xattr, if available, or the supplied signature.
Otherwise, without EVM/IMA-appraisal enabled, the stub hook would
appraise the kernel module based on the supplied signature, calling
integrity_digsig_verify() directly.

This method is a consistent and extensible approach to verifying the
integrity of file data/metadata, including kernel modules. The only
downside to this approach, I think, is that it requires changes to the
userspace tool.

thanks,

Mimi

