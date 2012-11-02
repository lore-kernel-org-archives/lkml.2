Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab2KBJoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:44:30 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48077 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab2KBJo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:44:28 -0400
Date: Fri, 2 Nov 2012 10:44:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jean-Christophe PINCE <jcpince@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS ASID type conflicts
Message-ID: <20121102094423.GB17860@linux-mips.org>
References: <CAEiBgeAukAdZv1WNcJQ6DByP7Yy63gvRS0cY6q6yU27p+XRi4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEiBgeAukAdZv1WNcJQ6DByP7Yy63gvRS0cY6q6yU27p+XRi4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 01:49:26PM +0200, Jean-Christophe PINCE wrote:

> I am analyzing Linux MIPS tasks memory spaces and found out what I
> think is a bug in the ASID management.
> 
> The structure "struct cpuinfo_mips" defined in
> arch/mips/include/asm/cpu-info.h uses a "unsigned int" field for
> asid_cache while the context field defined in
> arch/mips/include/asm/mmu.h is a "unsigned long".
> 
> This is ok with 32bits kernel but leads to 4bytes vs 8bytes fields
> with a 64bits kernel. And when the scheduler checks if the ASID is of
> an older ASID_VERSION, the test will always return that the version
> differs when the context bits above bit31 will be set.
> 
> I imagine this should be a quite rare issue but could likely happen on
> devices running for very long and starting processes very often (or
> running more than 256 processes per cpu). When this condition (bit 32
> or above of asid_cache is set), the effect should be that the TLB will
> be flushed on each context_switch required by the scheduler but there
> shouldn't be any crash.

A full flush of the TLB can be implemented by picking a fresh ASID as
long as there are still fresh ASIDs available.  This happens fairly
frequently; a typical system has burned through the first 256 ASIDs
somewhen during bootup.

There is not much advantage to be gained from having the ASID and generation
counter in a 64-bit variable so I think I'm just going to change
mmu_context_t to:

typedef struct {
        unsigned int asid[NR_CPUS];
        void *vdso;
} mm_context_t;

  Ralf
