Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab2JYL5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:57:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34083 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2JYL5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:57:22 -0400
Message-ID: <50892917.30201@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 04:57:11 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
References: <20121023164546.747e90f6.akpm@linux-foundation.org> <20121024062938.GA6119@dhcp22.suse.cz> <20121024125439.c17a510e.akpm@linux-foundation.org> <50884F63.8030606@linux.vnet.ibm.com> <20121024134836.a28d223a.akpm@linux-foundation.org> <20121024210600.GA17037@liondog.tnic> <50885B2E.5050500@linux.vnet.ibm.com> <20121024224817.GB8828@liondog.tnic> <5088725B.2090700@linux.vnet.ibm.com> <CAHGf_=pfdgoeG5pPJb+UgjqfieU1yxt=46FGW1=th0RbgVKNRQ@mail.gmail.com> <20121025092424.GA16601@liondog.tnic>
In-Reply-To: <20121025092424.GA16601@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102511-5406-0000-0000-000001685FAE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 02:24 AM, Borislav Petkov wrote:
> But let's discuss this a bit further. So, for the benchmarking aspect,
> you're either going to have to always require dmesg along with
> benchmarking results or /proc/vmstat, depending on where the drop_caches
> stats end up.
> 
> Is this how you envision it?
> 
> And then there are the VM bug cases, where you might not always get
> full dmesg from a panicked system. In that case, you'd want the kernel
> tainting thing too, so that it at least appears in the oops backtrace.
> 
> Although the tainting thing might not be enough - a user could
> drop_caches at some point in time and the oops happening much later
> could be unrelated but that can't be expressed in taint flags.

Here's the problem: Joe Kernel Developer gets a bug report, usually
something like "the kernel is slow", or "the kernel is eating up all my
memory".  We then start going and digging in to the problem with the
usual tools.  We almost *ALWAYS* get dmesg, and it's reasonably common,
but less likely, that we get things like vmstat along with such a bug
report.

Joe Kernel Developer digs in the statistics or the dmesg and tries to
figure out what happened.  I've run in to a couple of cases in practice
(and I assume Michal has too) where the bug reporter was using
drop_caches _heavily_ and did not realize the implications.  It was
quite hard to track down exactly how the page cache and dentries/inodes
were getting purged.

There are rarely oopses involved in these scenarios.

The primary goal of this patch is to make debugging those scenarios
easier so that we can quickly realize that drop_caches is the reason our
caches went away, not some anomalous VM activity.  A secondary goal is
to tell the user: "Hey, maybe this isn't something you want to be doing
all the time."

