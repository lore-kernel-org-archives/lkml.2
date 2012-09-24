Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2IXQNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:13:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:41815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2IXQNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:13:07 -0400
Message-ID: <1348503163.11847.97.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 24 Sep 2012 18:12:43 +0200
In-Reply-To: <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de> <1348500647.11847.69.camel@twins>
	 <CA+55aFy5C-gFs6ZU5LyyVN=oxpuoaOpydkbJbhri215QkLx3aA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 08:52 -0700, Linus Torvalds wrote:
> And the whole "if we find any non-idle cpu, skip the whole domain"
> logic really seems a bit odd (that's not new to your patch, though).
> Can somebody explain what the whole point of that idiotically written
> function is? 

So we're looking for an idle cpu around @target. We prefer a cpu of an
idle core, since SMT-siblings share L[12] cache. The way we do this is
by iterating the topology tree downwards starting at the LLC (L3) cache
level. Its groups are either the SMT-siblings or singleton groups.

In case its the SMT things, we want to skip if there's a non-idle cpu in
that mask to avoid sharing L[12].

If we don't find an empty core, we go down the domain tree, either
finding a NULL domain and terminating, or finding the SMT domain, and
we'll see if there's an idle SMT sibling.

Is it pretty?, not really. Is there a better way of doing it?, possibly,
I just haven't thought of it yet :/
