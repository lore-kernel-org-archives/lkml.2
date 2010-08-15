Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab0HOVEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 17:04:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab0HOVEb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 17:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <20100815133015.883c7069.akpm@linux-foundation.org>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
 <AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com> <20100815133015.883c7069.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 14:04:09 -0700
Message-ID: <AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sedat.dilek@gmail.com, Andi Kleen <ak@linux.intel.com>,
        len.brown@intel.com, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 1:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> I'd be suspecting that we have two patches both of which worked
> separately but which broke when combined.  Is there some other patch in
> that tree which adds a new reference to `ref' in acpi_power_seq_show()?

The offending patch isn't about acpi_power_seq_show(), it's about
acpi_power_off_device().

But that may well explain the breakage: there does seem to be an
unused ref in acpi_power_seq_show() (around line 556). It's just that
the patch in question doesn't remove that one, it removes the
very-much-used one in acpi_power_off_device() (line 256 or so).

And the contexts don't even match. Well, they do match to 2 lines. But
they're not very close. However, Len's tree does have a patch to just
remove all the procfs crap, so acpi_power_seq_show() has gone away,
which I guess explains how the subsequent patch was then applied to
something it should never have been applied to. Probably with GNU
patch that doesn't mind the fact that it doesn't match exactly (or
somebody used git and explicitly said "apply it with fuzz").

So that seems to explain how the patch got corrupted.

But nothing explains the fact that clearly _zero_ testing was done.
The tree was clearly never even compiled. Len apparently did a blind
patch application (or rebase, or whatever), and never bothered to
compile the end result afterwards, just sent it to me sight-unseen.

What does that say about the _rest_ of the patches? What does that say
about (lack of) -next testing?

                         Linus
