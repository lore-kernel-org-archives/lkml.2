Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0GZR5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 13:57:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:33216 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0GZR5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 13:57:12 -0400
X-IronPort-AV: E=Sophos;i="4.55,262,1278288000"; 
   d="scan'208";a="1074427"
Date: Mon, 26 Jul 2010 18:57:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sheng Yang <sheng@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (xen
 tree related)
In-Reply-To: <4C4DC505.9040202@goop.org>
Message-ID: <alpine.DEB.2.00.1007261835360.19809@kaball-desktop>
References: <20100726152908.951a95b7.sfr@canb.auug.org.au> <alpine.DEB.2.00.1007261132180.22235@kaball-desktop> <4C4DC505.9040202@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010, Jeremy Fitzhardinge wrote:
>   On 07/26/2010 03:43 AM, Stefano Stabellini wrote:
> > On Mon, 26 Jul 2010, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> After merging the final tree, today's linux-next build (i386 defconfig)
> >> failed like this:
> >>
> >> arch/x86/built-in.o: In function `init_hypervisor_platform':
> >> (.init.text+0x3ca4): undefined reference to `x86_hyper_xen_hvm'
> >> arch/x86/built-in.o: In function `init_hypervisor_platform':
> >> (.init.text+0x3cad): undefined reference to `x86_hyper_xen_hvm'
> >>
> >> Caused by commit bee6ab53e652a414af20392899879b58cd80d033 ("x86: early PV
> >> on HVM features initialization").
> >>
> >> I reverted commit 4b9100d12d15c0eaf23d9edc86228e1bdf452dc2 ("Merge branch
> >> 'upstream/pvhvm' into upstream/xen") for today (since there were
> >> dependencies on the above commit).
> > The problem is that x86_hyper_xen_hvm is in arch/x86/xen/enlighten.c,
> > that is compiled only when CONFIG_XEN is enabled.
> > The appended patch fixes the issue moving x86_hyper_xen_hvm to
> > arch/x86/kernel/cpu/xen.c that is always compiled.
> >
> > An shorter alternative solution would be just to ifdef CONFIG_XEN
> > x86_hyper_xen_hvm in arch/x86/kernel/cpu/hypervisor.c.
> 
> Seems like the most sensible thing to do.  What's the point in detecting 
> Xen if we don't have CONFIG_XEN enabled?

There isn't much point in doing so apart from avoiding an ifdef.
This is the alternative:

---


Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index bffd47c..5bccedc 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -34,7 +34,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
 	&x86_hyper_vmware,
 	&x86_hyper_ms_hyperv,
+#ifdef CONFIG_XEN
 	&x86_hyper_xen_hvm,
+#endif
 };
 
 const struct hypervisor_x86 *x86_hyper;
