Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1FFQEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:04:54 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:41246 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1FFQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:04:52 -0400
Date: Mon, 6 Jun 2011 18:04:34 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: kexec/kdump for Xen - implementation question
Message-ID: <20110606160434.GA26021@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, I am working on kexec/kdump for Xen with emphasis on dom0
implementation issues. After reviewing relevant Xen Linux Kernel
Ver. 2.6.18 code I realized (as I expected) that original kexec/kdump
in mainline kernel should be extensively amended. Further, after some
discussion with Konrad Rzeszutek Wilk and Ian Campbell it was clear
for me that it could be done in a few diffrent ways. Due to this facts
I decided to establish general implementation details with LKML and
Xen-devel community to avoid extensive code rewrite in case my own
proposal would not be accepted.

Now I think about four solutions. I will present them in order of my
preference. However, if you have another soultions to that problem
please drop me a line.

1) Currently existing kexec/kdump implementation should be amended
   by adding Xen specific code mainly in arch/i386. It should look
   like:

   void machine_kexec(struct kimage *image)
   {
   #ifdef CONFIG_XEN
      if (xen_initial_domain()) {
        ...
	Xen specific code
	...
      }
   #endif

     ...
     generic kexec/kdump code
     ...
   }

2) Information about architecture depended kexec/kdump code should
   be stored in struct machine_kexec_ops. It should contain
   references to machine specific functions:

   struct machine_kexec_ops {
     void (*machine_kexec)(struct kimage *image);
     ...
   }

   This structure should be initialized properly at system startup.

3) kexec-tools should be able to detect current machine type. If it
   detects Xen hypervisor it should call relevant (Xen specific)
   ioctl() to perform kexec (Xen specific) instead of standard
   kexec syscall.

4) kexec-tools should be able to detect current machine type. If it
   detects Xen hypervisor it should call newly established Xen specific
   kexec syscall (lets call it sys_kexec_load_xen()) to perform kexec
   (Xen specific) instead of standard kexec syscall.

I am looking forward for your comments, suggestions, etc.

Daniel
