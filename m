Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab2IZCWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:22:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38271 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2IZCWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <1348624845.7100.147.camel@marge.simpson.net>
References: <1348503163.11847.97.camel@twins> <CA+55aFzU2QOgexc2cpEkWqPBw6wPJMBuUzRyxTxu=rxZV_ay3A@mail.gmail.com>
 <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <1348624845.7100.147.camel@marge.simpson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Sep 2012 19:22:22 -0700
X-Google-Sender-Auth: v4neaxo1rgekFnYMpj3NZNxATYQ
Message-ID: <CA+55aFw8F=M7O6KfpotnhWoyJ6MiFF1U5S4RDboxyzPjW4hs6A@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 7:00 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Yes.  On AMD, the best thing you can do for fast switchers AFAIKT is
> turn it off.  Different story on Intel.

I doubt it's all that different on Intel.

Your patch showed improvement for Intel too on this same benchmark
(tbench). Borislav just went even further. I'd suggest testing that
patch on Intel too, and wouldn't be surprised at all if it shows
improvement there too.

It's pgbench that then regressed with your patch, and I suspect it
will regress with Borislav's too.

So I'm sure there are architecture differences (where HT in particular
probably changes optimal scheduling strategy, although I'd expect the
bulldozer approach to not be *that*different - but I don't know if BD
shows up as "HT siblings" or not, so dissimilar topology
interpretation may make it *look* very different).

So I suspect the architectural differences are smaller than you claim,
and it's much more about the loads in question.

You probably looked at the fact that the original report from Nikolay
says that the Intel E6300 hadn't regressed on pgbench, but I suspect
you didn't realize that E6300 is just a dual-core CPU without even HT.
So I doubt it's about "Intel vs AMD", it's more about "six cores" vs
"just two".

And the thing is - with just two cores, the fact that your patch
didn't change the Intel numbers is totally irrelevant. With two cores,
the whole "buddy_cpu" was equivalent to the old code, since there was
ever only one other core to begin with!

So AMD and Intel do have differences, but they aren't all that radical.

          Linus
