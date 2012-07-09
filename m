Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2GIOTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2GIOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:19:09 -0400
Date: Mon, 9 Jul 2012 17:19:04 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120709141904.GC7298@redhat.com>
References: <4FFAE6D8.5050609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFAE6D8.5050609@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 08:12:40AM -0600, David Ahern wrote:
> This is 100% reproducible with Fedora 17, 3.4.2-1.fc16.x86_64 kernel.
> 
> Using the precise attribute (:p or :pp) with perf-record, eg,
> 
> perf record -e cycles:p -ag -- sleep 10
> 
> All running VMs are killed. The VMs appear to be restarted but crash
> on restart.
> 
> From one of the VMs that has the console redirected to ttyS0 and
> ttyS0 of the VM mapped to stdio I was able to capture some boot logs
> on the restart of the VM:
> 
Yes, this is knows problem that I can't find time to fix. The crash is
cause by CPU using host PEBS virtual address while guest is running
which causes guest memory corruption. We should disable evens that use
PEBS at the guest entry.


> [    0.019136] BUG: unable to handle kernel paging request at 13832f88
> [    0.020252] IP: [<c0104ed0>] mcount+0x0/0xc
> [    0.021000] *pdpt = 0000000000572001 *pde = 0000000000000000
> [    0.021942] Oops: 0000 [#1] SMP
> [    0.021996] __die: Die type Oops
> [    0.021996] Modules linked in:
> [    0.021996]
> [    0.021996] Pid: 0, comm: swapper Not tainted (2.6.27.47 #0)
> [    0.021996] EIP: 0060:[<c0104ed0>] EFLAGS: 00010296 CPU: 0
> [    0.021996] EIP is at mcount+0x0/0xc
> [    0.021996] EAX: f78026c0 EBX: 00000000 ECX: f78026c0 EDX: 000080d0
> [    0.021996] ESI: f782c228 EDI: f780b240 EBP: c051fef0 ESP: c051fed4
> [    0.021996]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.021996] Process swapper (pid: 0, ti=c051e000 task=c04d0380
> task.ti=c051e000)
> [    0.021996] Stack: c0193339 c0267510 c051feec c026745f 00000000
> f782c228 f780b240 c051fefc
> [    0.021996]        c026c6b3 f780b240 c051ff14 c0267690 00000000
> 00000000 f782c200 f780b2a0
> [    0.021996]        c051ff4c c026720e 00000001 f88055af f782c228
> 00000000 f782c200 00000000
> 
> 
> 
> David

--
			Gleb.
