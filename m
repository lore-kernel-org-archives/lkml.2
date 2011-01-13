Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1AMEJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:09:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1AMEJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:09:36 -0500
MIME-Version: 1.0
In-Reply-To: <20110113144803.ab311f36.sfr@canb.auug.org.au>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au> <alpine.LFD.2.02.1101121257580.18873@x980>
 <20110112131800.d64c1a86.akpm@linux-foundation.org> <201101122224.54330.rjw@sisk.pl>
 <alpine.LFD.2.02.1101121654000.19754@x980> <20110113114446.cba7a01f.sfr@canb.auug.org.au>
 <1294890340.26623.383.camel@gandalf.stny.rr.com> <20110113144803.ab311f36.sfr@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 20:08:42 -0800
Message-ID: <AANLkTikJjg330KDvOZZ4agg2dZV6np-rW06=PEuZRSPa@mail.gmail.com>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on NET)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 7:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Steve,
>
> On Wed, 12 Jan 2011 22:45:40 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> What happens if you have foo depends on bar || fib ?
>>
>> Do you automatically enable bar and fib?
>
> The plan was to error out and let the user decide ... or behave as we do
> and just warn?

One thing to notice is that a lot of the "a || b" conditionals tend to
be cases where one of the expressions is a known constant 'y'.

In other words, the most common case of "a || b" tends to be things
like "X86 || MIPS || POWER.." or possibly "PCI || ISA", where one of
the options will have been hard-coded by the initial architecture
config file - and would generally not be something that the user sets
at all.

Now that may not be _universally_ true, but a quick grep certainly
supports the notion that that is a very common case.

So I think we want the rule to be:

 - check all entries in the "||" chain - and if one of them is already
set to 'y', then just ignore the dependency as trivially fulfilled

 - if all are 'n' or unknown, error out (or warn)

and I think there won't be all that many cases where people get the
error in practice.

                      Linus
