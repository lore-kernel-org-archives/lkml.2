Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0CYWbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:31:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:21006 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0CYWbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:31:38 -0400
Date: Thu, 25 Mar 2010 15:29:00 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/8] x86: do not free zero sized per cpu areas
Message-ID: <20100325222859.GC9984@mail.oracle.com>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Ian Campbell <ian.campbell@citrix.com>,
	Peter Zijlstra <peterz@infradead.org>
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
 <1269427029-21000-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269427029-21000-2-git-send-email-yinghai@kernel.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BABE3DF.00BF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:37:02AM -0700, Yinghai Lu wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.
> 
> -v5: put back start > end back into WARN_ONCE()
> -v6: use one line for if according to linus
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>

Tested-by: Joel Becker <joel.becker@oracle.com>

	I ran into this when moving my paravirt_ops PVMs to 2.6.34-rc1.
I turned on CONFIG_NO_BOOTMEM to try it because it was the default.  I
had to put earlyprintk=xen on the command line to debug the problem.
My boots hung after:

...
(early) Local APIC disabled by BIOS -- you can enable it with "lapic"
(early) APIC: disable apic facility
(early) APIC: switched to apic NOOP
(early) Allocating PCI resources starting at 78000000 (gap: 78000000:88000000)
(early) Booting paravirtualized kernel on Xen
(early) Xen version: 3.1.3-rc3
(early) setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1

	Bisecting narrowed the problem to fb90ef [early_res: Add
free_early_partial()].  Turning off CONFIG_NO_BOOTMEM allowed me to
boot.  I then hunted up references to this function, which found me this
patch.
	This patch successfully resolved the problem.

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
