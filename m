Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0K3XuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:50:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956Ab0K3XuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:50:03 -0500
Date: Tue, 30 Nov 2010 15:49:05 -0800
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
Message-Id: <20101130154905.b5c8ab31.akpm@linux-foundation.org>
In-Reply-To: <1291100431.12648.165.camel@yhuang-dev>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
	<20101129190343.7d7cea12.akpm@linux-foundation.org>
	<1291087752.12648.95.camel@yhuang-dev>
	<20101129194033.393e1f70.akpm@linux-foundation.org>
	<1291100431.12648.165.camel@yhuang-dev>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 15:00:31 +0800
Huang Ying <ying.huang@intel.com> wrote:

> > However in this case you are avowedly treating the printks as a
> > userspace interface, with the intention that software be written to
> > parse them, yes?  So once they're in place, we cannot change them?  That
> > makes it more important.
> 
> If my understanding is correct, Linus still don't like the idea of user
> space hardware error tool.

I'm sure he has no problem with a userspace tool ;) Surely what he doesn't
like is the proposed kernel interface.

>  On the other hand, if we need this tool, I
> think printk is not a good tool-oriented hardware error reporting
> interface for it, because:
> 
> - There is no overall format or record boundaries for printk, because
> printk is traditionally for 1-2 lines.  This makes that printk is hard
> to parse in general.

Well.  These things can be addressed by careful choice of output
format.

> - Messages from different CPUs may be interleaved.

A single printk() should be atomic.

> - Good error reporting is too verbose for kernel log
> 
> - printk has no internal priority support, so that high severity errors
> has no more priority than low severity ones.
> 
> 
> So my opinion is:
> 
> - Use printk as human oriented hardware error reporting.
> - Use another tool oriented interface for user space hardware error tool
> if necessary.
> 
> Do you agree?  Do you think printk can be used as a good tool-oriented
> hardware error reporting interface too?

I agree that using printk() is pretty sucky.

However your proposals are waaaaaaaaay too narrow and specific IMO. 
There are several reasons why people want more regular and structured
kerenl->userspace messaging features.  One such requirement is for
internationalisation: people want messages to come out in some
non-language-specific manner so that userspace tools can perform
catalogue lookups and display the messages in the appropriate language.
 Others (eg google) want to feed the messages into large-scale
capturing systems for offline analysis.  And there are other
requirements which I forget.  Such a messaging/logging system would
also incorporate the requirement to log to a persistent store.

So I think that quite a lot of people would be interested in proposals
for a new and improved kernel->userspace messaging/logging facility. 
But talking about "hardware error reporting" (especially when it covers
only a teeny subset of possible hardware errors!) is very myopic.

And implementing the broad facility would be a pretty big project.  Simply
chasing down all the stakeholders and understanding their needs would
turn one's hair grey.

So we're a bit stuck, really.  We would benefit from a quite broad and
expensive-to-implement messaging/logging system, but we don't even know
what that will look like yet.  You have a small and highly-specific
subset of that.  If we merge the subset then it probably will live
forever even if the broader feature gets written one day, because the
subset is userspace-visible and adds interfaces which the larger system
probably won't even implement.

So...  for your pretty narrow and specific problem, perhaps using
printk as a stopgap until somethine better to come along is the correct
choice.
