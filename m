Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DVQXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:23:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0DVQXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SlgTYNbESggiz+0jTE6YzOOgE7aKPkdDWgWTWocgctW6ArVMI3OMDPDH/EkWirGhAb
         jXH8U5uEd0ydqp1TnmHHWR2zMzPtioWrsCsk8KjRnkzkDv6E1H3jC/9erhCLEAtcAYox
         CHUP5gl3R8AoMJXFeWOnQvXcfTI9CLVCtS1fI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 0/5] Add second memory region for crash kernel
Date: Thu, 22 Apr 2010 18:23:07 +0200
Message-Id: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch applies to 2.6.34-rc5

On x86 platform, even if hardware is 64-bit capable, kernel starts
execution in 32-bit mode. When system is kdump-enabled, crashed kernel
switches to 32 bit mode and jumps into new kernel. This automatically
limits location of dump-capture kernel image and it's initrd by first
4Gb of memory. Switching to 32 bit mode is performed by purgatory
code, which has relocations of type R_X86_64_32S (32-bit signed), and
this cuts "good" address space for crash kernel down to 2 Gb. I/O
regions may cut down this space further.

When system has a lot of memory (hundreds of gigabytes), dump-capture
kernel also needs relatively a lot of memory to account old kernel's
pages. It may be impossible to reserve enough memory below 2 or even 4
Gb. Simplest solution is it break dump-capture kernel's reserved
memory region into two pieces: first (small) region for kernel and
initrd images may be easily placed in "good" address space in the
beginning of physical memory, and second region may be located
anywhere.

This serie of patches realizes this approach. It requires also changes
in kexec utility to make this feature work, but is
backward-compatible: old versions of kexec will work with new
kernel. I will post patch to kexec-tools upstream separately.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

 Documentation/kdump/kdump.txt       |   40 ++++++++
 Documentation/kernel-parameters.txt |   19 +++-
 arch/x86/kernel/setup.c             |   56 +++++++----
 include/linux/kexec.h               |    6 +
 kernel/kexec.c                      |  182 ++++++++++++++++++++++++++---------
 5 files changed, 232 insertions(+), 71 deletions(-)

