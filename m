Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2JWGai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:30:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2JWGah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:30:37 -0400
Date: Mon, 22 Oct 2012 23:30:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc 0/2] Introducing VmFlags field into smaps output
Message-Id: <20121022233025.09ec2d92.akpm@linux-foundation.org>
In-Reply-To: <20121023061341.GA7020@moon>
References: <20121022191452.785366817@openvz.org>
	<20121022122934.d2e2fa57.akpm@linux-foundation.org>
	<5085B1A8.4020609@parallels.com>
	<20121022205641.GL2303@moon>
	<20121022213449.GH31440@moon>
	<20121022145158.53bddfc1.akpm@linux-foundation.org>
	<20121023061341.GA7020@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 10:13:41 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Mon, Oct 22, 2012 at 02:51:58PM -0700, Andrew Morton wrote:
> ...
> > > +	__seq_show_vmflag(VM_DONTEXPAND,"de ");
> > > +	__seq_show_vmflag(VM_ACCOUNT,	"ac ");
> > > +	__seq_show_vmflag(VM_NORESERVE,	"nr ");
> > > +	__seq_show_vmflag(VM_HUGETLB,	"ht ");
> > > +	__seq_show_vmflag(VM_NONLINEAR,	"nl ");
> > > +	__seq_show_vmflag(VM_ARCH_1,	"ar ");
> > > +	__seq_show_vmflag(VM_DONTDUMP,	"dd ");
> > > +	__seq_show_vmflag(VM_MIXEDMAP,	"mm ");
> > > +	__seq_show_vmflag(VM_HUGEPAGE,	"hg ");
> > > +	__seq_show_vmflag(VM_NOHUGEPAGE,"nh ");
> ...
> > 
> > This code would be much denser if we did the old
> > 
> > 	static const char foo[] = "rdwrexshmrmw...";
> > 	unsigned i;
> > 
> > 	for (i = 0; i < BITS_PER_LONG; i++) {
> > 		if (flags & (1 << i))
> > 			seq_printf("%c%c ", foo[i * 2], foo[i * 2 + 1]);
> > 	}
> > 
> > trick.  But then we'd have to remember to fix foo[] each time we
> > alter the flags, so maybe let's not do that.
> 
> Yup, but not only that, this kind of trick hides associativity between
> VM_ constant and mnemonic, so on changes one would have to figure out
> which position some flag has in this foo[] array, so I vote for not
> use it :-)

Well you could do

struct {
	char x[2];
} y[] = {
	[CLOG2(VM_DONTEXPAND)] =	{ 'd', 'e' },
	[CLOG2(VM_ACCOUNT)] =		{ 'a', 'c' },
	[CLOG2(VM_NORESERVE)] =		{ 'n', 'r' },
};

	...

	for (i = 0; i < BITS_PER_LONG; i++) {
		if (flags & (1 << i))
			seq_printf("%c%c ", y[i][0], y[i][1]);
	}

where CLOG2() is extracted from the guts of ilog2().

I'll stop now :)
