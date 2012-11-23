Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2KWKxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:53:22 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:65135 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2KWKxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:53:21 -0500
X-IronPort-AV: E=Sophos;i="4.83,306,1352073600"; 
   d="scan'208";a="15970336"
Message-ID: <1353667998.13542.220.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v2 01/11] kexec: introduce kexec_ops struct
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Fri, 23 Nov 2012 10:53:18 +0000
In-Reply-To: <50AF567402000078000AABF6@nat28.tlf.novell.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
	 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
	 <87lidwtego.fsf@xmission.com>
	 <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
	 <87txshx28b.fsf@xmission.com> <50AE62E9.3000602@zytor.com>
	 <50AF567402000078000AABF6@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-23 at 09:56 +0000, Jan Beulich wrote:
> >>> On 22.11.12 at 18:37, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > I actually talked to Ian Jackson at LCE, and mentioned among other 

That was me actually (this happens surprisingly often ;-)).

> > things the bogosity of requiring a PUD page for three-level paging in 
> > Linux -- a bogosity which has spread from Xen into native.  It's a page 
> > wasted for no good reason, since it only contains 32 bytes worth of 
> > data, *inherently*.  Furthermore, contrary to popular belief, it is 
> > *not* pa page table per se.
> > 
> > Ian told me: "I didn't know we did that, and we shouldn't have to." 
> > Here we have suffered this overhead for at least six years, ...
> 
> Even the Xen kernel only needs the full page when running on a
> 64-bit hypervisor (now that we don't have a 32-bit hypervisor
> anymore, that of course basically means always).

I took an, admittedly very brief, look at it on the plane on the way
home and it seems like the requirement for a complete page on the
pvops-xen side comes from the !SHARED_KERNEL_PMD stuff (so still a Xen
related thing). This requires a struct page for the list_head it
contains (see pgd_list_add et al) rather than because of the use of the
page as a pgd as such.

>  But yes, I too
> never liked this enforced over-allocation for native kernels (and
> was surprised that it was allowed in at all).

Completely agreed.

I did wonder if just doing something like:
-	pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);
+	if (SHARED_KERNEL_PMD)
+		pgd = some_appropriate_allocation_primitive(sizeof(*pgd));
+	else
+		pgd = (pgd_t *)__get_free_page(PGALLOC_GFP);

to pgd_alloc (+ the equivalent for the error path & free case, create
helper funcs as desired etc) would be sufficient to remove the over
allocation for the native case but haven't had time to properly
investigate.

Alternatively push the allocation down into paravirt_pgd_alloc to
taste :-/

Ian.

