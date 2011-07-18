Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1GRQ3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:29:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:35810 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1GRQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:29:46 -0400
X-IronPort-AV: E=Sophos;i="4.67,223,1309737600"; 
   d="scan'208";a="6836017"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20004.24417.577289.167313@mariner.uk.xensource.com>
Date: Mon, 18 Jul 2011 17:29:21 +0100
To: <stefano.stabellini@eu.citrix.com>
CC: <hpa@zytor.com>, <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@linux.intel.com>,
        <yinghai@kernel.org>
Subject: Re: [Xen-devel] [PATCH tip/x86/mm] x86_32: calculate additional memory
	needed by the fixmap
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1Qimoi-131463@chiark.greenend.org.uk>
References: <m2n.s.1Qimoi-131463@chiark.greenend.org.uk>
X-Mailer: VM 8.0.9 under Emacs 21.4.1 (i486-pc-linux-gnu)
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefano.stabellini@eu.citrix.com writes ("[Xen-devel] [PATCH tip/x86/mm] x86_32: calculate additional memory needed by the fixmap"):
> Unfortunately this code is rather complex and depends on the behaviour
> of other functions but I hope to have covered all the corner cases.

I'm sorry to say that think this is really the wrong approach.
I agree that *some* change needs to be made, as this is currently a
serious regression in tip/x86/mm.

But the correct change is in fact to undo the reversion of
  "x86,xen: introduce x86_init.mapping.pagetable_reserve"
That was a hook with a reasonable and defined interface.

What we are having instead, now, is a fragile piece of code that tries
to second-guess the complex config- and hardware-dependent
memory-allocation behaviour of the rest of the startup code.  This is
a recipe for making things break.

Indeed, since the reversion of "mapping.pagetable_reserve" and its
replacement with the new "exact calculation" code, tip/x86/mm has
already had to have two separated config-dependent fixes - and the
thing hasn't even been pushed to Linus's tip yet !

This is a hopelessly fragile approach.  We should go back to the new
pvop.  If the interface documentation in 279b706bf800b596 is not
satisfactory I would be happy to help improve it.  To be honest I
think much of the contents of the commit message should be in comments
in the code.

Indeed, I agree that the current lack of coherent semantic
specification for the pvops is a problem.  But the solution is not to
abolish pvops in favour of fragile duplication of logic.  The solution
is to fix the specification comments.

But, if the x86 maintainers absolutely won't have the new pvop then
this new second-guessing code, fragile as it is, has to go in to fix
the regression.

Thanks,
Ian.
