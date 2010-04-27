Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0D0AFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:05:52 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:35288 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753917Ab0D0AFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:05:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eb1asTMCpWexrtXyPGAsyvLep/oIQFvlFaUylpupdekFUKz3xDbBSCMZC+ojHg/cqtoRxwn93zCrNu/ebflnXw8hTwWRzCTfO6VudKXN/bW20KQZPyem89pTjvAUrc+W;
Date: Mon, 26 Apr 2010 17:05:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "Yinghai" <yinghai.lu@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below   
 BIOS_END
Message-ID: <20100426170547.5d7daa47@virtuousgeek.org>
In-Reply-To: <a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com>
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
	<20100426162517.4ad308ff@virtuousgeek.org>
	<a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 16:49:55 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> > Sorry, sounds like we're talking about a few different things here:
> >   1) devices which sit in e820 reserved space (whether at < 1M or > 1M)
> >   2) devices which sit in e820 ram or other space below 1M
> >   3) how to hand out space from the 0-1M region
> >
> > Bjorn's patch fixes (3) so that regular PCI devices don't get space
> > there, which makes sense.
> >
> > Some devices may be in the special region, but were pointed there by
> > the BIOS.  Generally this should be ok, so drivers requesting this
> > space should be allowed to get at it, but we should avoid putting
> > anything else there.
> >
> > And below it sounds like you're talking about (1).  If so, then yes I
> > guess we need a solution there, which will allow drivers to bind to
> > these "reserved" devices, even though the BIOS has marked them as off
> > limits, at least as far as e820 goes.
> >
> > So perhaps both (1) and (2) could be put into a new, special IO
> > resource space, or could use a new flag, since "busy" doesn't really
> > reflect what's going on there very well, as Bjorn pointed out.
> >
> > Jesse
> 
> Properly done, these aren't separate cases at all.
> 
> The E820 interface as specified doesn't reserve the address space below 1
> MB, because it is legacy space -- which is another way of saying "everyone
> already knows to reserve it."  The Right Thing[TM] to do is simply to
> modify the data output by E820 to reserve all non-memory space below 1 MB;
> this can (and should) be done in platform-specific initialization code to
> allow overrides.
> 
> Once that is done, both your (2) and (3) cases are nothing but special
> subcases of (1).  That's what I would like to see as the right solution,
> but it is clearly too late to do that in .34.
> 
> Bjorn's solution is very attractive for .34 since it is so simple, but
> it's not a complete solution.

Glad we agree.  As I said (and echoing Bjorn), I think it would be best
to reserve this space in a way that doesn't just use IORESOURCE_BUSY.
We want and need to do allocations from the special region, so we
should mark it as such.

-- 
Jesse Barnes, Intel Open Source Technology Center
