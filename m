Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2LJN6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:58:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57659 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LJN6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:58:02 -0500
Date: Mon, 10 Dec 2012 13:57:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are
	synchronised across all cpus
Message-ID: <20121210135747.GK14363@n2100.arm.linux.org.uk>
References: <1354888985.17101.41.camel@gandalf.local.home> <1354892111.13000.50.camel@linaro1.home> <1354894134.17101.44.camel@gandalf.local.home> <20121207162346.GW14363@n2100.arm.linux.org.uk> <1354898200.17101.50.camel@gandalf.local.home> <20121207164530.GX14363@n2100.arm.linux.org.uk> <1354900436.17101.58.camel@gandalf.local.home> <1354902347.8263.12.camel@linaro1.home> <20121210100433.GB6624@mudshark.cambridge.arm.com> <1355144537.17101.155.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355144537.17101.155.camel@gandalf.local.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 08:02:17AM -0500, Steven Rostedt wrote:
> On Mon, 2012-12-10 at 10:04 +0000, Will Deacon wrote:
> > Yes, and I think if you do use two 16-bit nops, you can even get rid of all
> > the intermediate `sync' operations (I guess you might want one at the end if
> > you want the call to become visible at a particular point).
> 
> Wont work. We are replacing a 32bit call with a nop. That nop must also
> be 32bits, because we could eventually replace the nop(s) with a 32bit
> call.

... which, if it's misaligned to a 32-bit boundary, which can happen with
Thumb-2 code, will require the replacement to be done atomically; you will
need to use stop_machine() to ensure that other CPUs don't try to execute
the instruction mid-way through modification... as I have already
explained in my previous mails.
