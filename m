Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2HXL6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:58:21 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:39425 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2HXL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:58:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,304,1344211200"; 
   d="scan'208";a="14167642"
Date: Fri, 24 Aug 2012 12:57:51 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <20120824113644.GE11007@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208241242010.15568@kaball.uk.xensource.com>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 24, 2012 at 12:03:09PM +0200, Borislav Petkov wrote:
> > On Thu, Aug 23, 2012 at 06:13:39PM +0100, Attilio Rao wrote:
> > > You seriously think that adding a single-check, that will be
> > > certainly skipped (now), in a boot-time function is going to add any
> > > performance burden?
> > > 
> > > >What you are doing is actively wrong. You suggest that it's fine to
> > > >call that function with something different than pgt_buf_start as the
> > > >start argument. That's complete nonsense. The early pages are
> > > >allocated bottom up beginning at pgt_buf_start. So what the heck would
> > > >make it sane to change that argument ever?
> > > 
> > > If you really don't like this approach, at this point I think the
> > > best thing to do is to assume that the start address will be
> > > pgt_buf_start and loose the starting argument at all.
> > > If you agree I can make a patch for that.
> > 
> > One thing I don't understand is why is xen touching x86 code when it
> > doesn't have to? At least I cannot find a single reason for it in this
> > thread.
>
> Has this discussion gotten off the wrong track... The underlaying reason
> for this x86_init.mapping.pagetable_reserve is to fix Xen guests from
> crashing at bootup time b/c the pagetables that were hooked up were not
> labeled as RO (but as RW). The git commit for the line in question
> should say that. There was also a lengthy discussion about this and
> why other attempts (like sticking the check in xen_set_pte_init and
> not have pagetable_reserve) did not work. And Stefano also posted a
> patch series that would remove the x86_init.mapping.pagetable_reserve
> and change the logic in the earlier code to determine the _exact_ size
> of the pagetable that is required. Ingo liked it, but Peter was not to
> thrilled (or maybe he was OK but that was the timeline when his son was
> born) and decided that we will stick with the
> x86_init.mapping.pagetable_reserve for now.
> 
> (Sorry about not posting the links to the discussions - will to that in
> a couple of hours).

Here are a couple of links to the original discussions about the bug
that pagetable_reserve now solves:

http://marc.info/?l=linux-kernel&m=129901609503574
http://marc.info/?l=linux-kernel&m=130133909408229

If you are interested in the subject it is worth starting from the
beginning of the two threads.

Just to give you a bit of background: Xen PV guests predate VMX, they
just run in ring3 (ring1 on x86_32); they have a different entry point
and  pagetable pages have to be mapped RO so that's why they need
special treatment.


> > Here's a simple answer: if it doesn't fix a bug on x86 baremetal (and
> > you're changing x86 native code only for the sake of xen), there's no
> > reason wasting energy to create patches.

I really wish that it would never be necessary to modify x86 native
code only for the sake of Xen, but unfortunately, given the peculiarities
mentioned above, sometimes it has proven to be necessary in the past.
