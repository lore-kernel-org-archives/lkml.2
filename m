Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2BBObR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:31:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab2BBObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:31:15 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=WfulkdPnAAAA:8 a=gFyO0h5d9Ng7Wv7kPowA:9 a=PUjeQqilurYA:10 a=l29vjEC0CZ8A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328193068.5882.95.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 02 Feb 2012 09:31:08 -0500
In-Reply-To: <4F2A9960.2090500@zytor.com>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
	 <1327936060.22710.165.camel@gandalf.stny.rr.com>
	 <20120131194813.GA12074@elte.hu>
	 <1328072925.5882.57.camel@gandalf.stny.rr.com>
	 <20120201080539.GA11770@elte.hu>
	 <1328109697.5882.65.camel@gandalf.stny.rr.com>
	 <20120202135154.GA10315@elte.hu> <4F2A9960.2090500@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 06:10 -0800, H. Peter Anvin wrote:
> On 02/02/2012 05:51 AM, Ingo Molnar wrote:
> > [    0.000000] Unexpected op at enqueue_task_fair+0xab/0x1fb [ffffffff81078a8d] (0f 1f 44 00 00) arch/x86/kernel/jump_label.c:74
> 
> So this is presumably the expected NOP... what was it expecting instead?

It's expecting the "ideal_nop" that was determined at run time.

This code died on "enabling" the nop. I think the code now enables some
nops by default on boot up, which doesn't expect to see the
"default_nop".

I need to look at the code to see why it is enabling the nop this early.
I think there were patches out there to enable jump labels on boot up,
but I didn't think they were included yet.

But I have a good idea of what is happening.

Which explains why my box didn't trigger this bug. The one box that can
boot tip/master has the ideal_nop the same as the default_nop.

I'm still working on getting my other box to boot. I'm still hunting
down the patch in "out-of-tree" that prevents it from booting. This was
a pain, because the mainline commit that the "out-of-tree" was based on
contained another bug that prevented this box to boot. I just finished a
ktest reverse bisect on the mainline branch to find that bug:

commit 124482935fb7fb9303c8a8ab930149c6a93d9910
Author: Andi Kleen <andi@firstfloor.org>
Date:   Fri Jun 18 23:09:00 2010 +0200

    x86: Fix vsyscall on gcc 4.5 with -Os

Now I'm running a ktest bisect on the out-of-tree branch to find the
commit that prevents this box from booting. (there's a PRE_BUILD and
POST_BUILD option that lets me apply this patch at ever bisect :-)

-- Steve



