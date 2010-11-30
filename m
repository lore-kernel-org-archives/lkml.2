Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0K3Dlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:41:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab0K3Dlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:41:45 -0500
Date: Mon, 29 Nov 2010 19:40:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print
 support
Message-Id: <20101129194033.393e1f70.akpm@linux-foundation.org>
In-Reply-To: <1291087752.12648.95.camel@yhuang-dev>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
	<20101129190343.7d7cea12.akpm@linux-foundation.org>
	<1291087752.12648.95.camel@yhuang-dev>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 11:29:12 +0800 Huang Ying <ying.huang@intel.com> wrote:

> On Tue, 2010-11-30 at 11:03 +0800, Andrew Morton wrote:
> > On Tue, 30 Nov 2010 10:51:40 +0800 Huang Ying <ying.huang@intel.com> wrote:
> > 
> > > printk is one of the methods to report hardware errors to user space.
> > > Hardware error information reported by firmware to Linux kernel is in
> > > the format of APEI generic error status (struct
> > > acpi_hes_generic_status).  This patch adds print support for the
> > > format, so that the corresponding hardware error information can be
> > > reported to user space via printk.
> > > 
> > > PCIe AER information print is not implemented yet.  Will refactor the
> > > original PCIe AER information printing code to avoid code duplicating.
> > > 
> > > ...
> > >  
> > > +#define pr_pfx(pfx, fmt, ...)			\
> > > +	printk("%s" fmt, pfx, ##__VA_ARGS__)
> > 
> > hm, why does so much code create little printk helper macros.  Isn't
> > there something generic somewhere?
> 
> Sorry, I do not find the generic code for this helper. But I think this
> macro may be helpful for others too, who need to determine the log level
> only at runtime. Here corrected errors should have log level:
> KERN_WARNING, while uncorrected errors should have log level: KERN_ERR.

Oh, is that what it does.  Replacing "pfx" everywhere with "loglevel"
(or similar) would have been much clearer?

> Do you think it is a good idea to make this macro generic?

hm, maybe.  It's the sort of thing which gives rise to much
chin-scratching, which is why people usually avoid doing it ;) If the
macro is well-named and its intended use is quite clear then yes, it's
probably worth pursuing.

> > This patchset appears to implement a new kernel->userspace interface. 
> > But that interface isn't actually described anywhere, so reviewers must
> > reverse-engineer the interface from the implementation to be able to
> > review the interface.  Nobody bothers doing that so we end up with an
> > unreviewed interface, which we must maintain for eternity.
> > 
> > Please fully document all proposed interfaces?
> 
> Sorry. I don't realize that printk-ing something means implementing a
> new kernel->userspace interface. I think the messages resulted are
> self-explaining for human. Is it sufficient just to add example messages
> in patch description?

Well normally a printk() isn't really considered a "userspace
interface".  This allows us to change them even though there surely
_are_ existing tools which treat particular messages as a userspace
interface.  But I don't recall hearing of much breakage from changed
kernel printks.

However in this case you are avowedly treating the printks as a
userspace interface, with the intention that software be written to
parse them, yes?  So once they're in place, we cannot change them?  That
makes it more important.

