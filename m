Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1FGK3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:29:30 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:41038 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1FGK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:29:28 -0400
X-IronPort-AV: E=Sophos;i="4.65,331,1304294400"; 
   d="scan'208";a="6136124"
Subject: Re: kexec/kdump for Xen - implementation question
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110606160434.GA26021@router-fw-old.local.net-space.pl>
References: <20110606160434.GA26021@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 7 Jun 2011 11:29:26 +0100
Message-ID: <1307442566.775.555.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 17:04 +0100, Daniel Kiper wrote:
> Hi,
> 
> Currently, I am working on kexec/kdump for Xen with emphasis on dom0
> implementation issues. After reviewing relevant Xen Linux Kernel
> Ver. 2.6.18 code I realized (as I expected) that original kexec/kdump
> in mainline kernel should be extensively amended. Further, after some
> discussion with Konrad Rzeszutek Wilk and Ian Campbell it was clear
> for me that it could be done in a few diffrent ways. Due to this facts
> I decided to establish general implementation details with LKML and
> Xen-devel community to avoid extensive code rewrite in case my own
> proposal would not be accepted.
> 
> Now I think about four solutions. I will present them in order of my
> preference. However, if you have another soultions to that problem
> please drop me a line.
> 
> 1) Currently existing kexec/kdump implementation should be amended
>    by adding Xen specific code mainly in arch/i386. It should look
>    like:
> 
>    void machine_kexec(struct kimage *image)
>    {
>    #ifdef CONFIG_XEN
>       if (xen_initial_domain()) {
>         ...
> 	Xen specific code
> 	...
>       }
>    #endif
> 
>      ...
>      generic kexec/kdump code
>      ...
>    }

This is about the ugliest way to do things and should be avoided.

Perhaps the actual kexec op (as opposed to any setup or control ops)
would make a reasonable addition to the existing machine_ops?

A lot of the other #ifdef ...XEN in the out of tree 2.6.18 code
(actually I'm looking at a 2.6.32 Novell fwd port) seem like they would
go away through the use of existing pvops (e.g. those for manipulating
page tables since the Xen implementations of those already incorporate
the necessary p2m translation).

> 2) Information about architecture depended kexec/kdump code should
>    be stored in struct machine_kexec_ops. It should contain
>    references to machine specific functions:
> 
>    struct machine_kexec_ops {
>      void (*machine_kexec)(struct kimage *image);
>      ...
>    }
> 
>    This structure should be initialized properly at system startup.

I think this approach would generally be much preferable to 1, 3, and 4.
We should be careful to ensure that any such hooks are actually needed
though and that they don't belong anywhere else -- I expect mostly
things will be covered by existing *_ops.

> 
> 3) kexec-tools should be able to detect current machine type. If it
>    detects Xen hypervisor it should call relevant (Xen specific)
>    ioctl() to perform kexec (Xen specific) instead of standard
>    kexec syscall.
> 
> 4) kexec-tools should be able to detect current machine type. If it
>    detects Xen hypervisor it should call newly established Xen specific
>    kexec syscall (lets call it sys_kexec_load_xen()) to perform kexec
>    (Xen specific) instead of standard kexec syscall.
> 
> I am looking forward for your comments, suggestions, etc.
> 
> Daniel


