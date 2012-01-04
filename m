Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2ADKj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:39:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:16673 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2ADKjZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 4 Jan 2012 05:39:25 -0500
Message-Id: <4F043AA2020000780006A55B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 04 Jan 2012 10:40:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Christoph Lameter" <cl@linux.com>
Cc: <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: irqsafe_cpu_...() 64-bit operations on 32-bit platform
References: <4EF4581C0200007800069BA2@nat28.tlf.novell.com>
 <alpine.DEB.2.00.1112230908550.1691@router.home>
 <4F018015020000780006A015@nat28.tlf.novell.com>
 <alpine.DEB.2.00.1201031034240.2810@router.home>
In-Reply-To: <alpine.DEB.2.00.1201031034240.2810@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.01.12 at 17:37, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 2 Jan 2012, Jan Beulich wrote:
> 
>> > However, if you are using a loop to sum up all counters from every
>> > processor then you cannot use the this_cpu ops but would have to use
>> > something like get_64().
>>
>> I understand that, but again statistics aren't my focus here.
> 
> Ok then we need to understand better what you are trying to accomplish.
> You may be outside of the realm of percpu data and be just trying to read
> and write 64 bit variables reliably on 32 bit?

The get_64bit() use case is quite obvious: arch/x86/xen/time.c has
get64(), which really should be required to get defined here.

The same file has potential for using the per-CPU variant: In particular
after the "blocked time" accounting gets removed from
do_stolen_accounting() (for which there is a patch pending), obtaining
a full runstate snapshot (via get_runstate_snapshot()) becomes sort
of overkill - reading the RUNSTATE_runnable and RUNSTATE_offline
array entries individually (and atomically) would be sufficient and faster,
and as xen_runstate is a per-CPU variable doing this through a
per-CPU accessor would be the obviously preferred method. Except
that "irqsafe_...()" isn't really the right thing (as emulating it through
disabling interrupts is not a correct alternative - it has to be
implemented as a single instruction, but since this is arch-specific
code, using it would be safe; alternatively some accessor could be 
introduced that doesn't have fallbacks when there's no single-
instruction implementation, causing the improper use to be noticed
at build time).

Jan


