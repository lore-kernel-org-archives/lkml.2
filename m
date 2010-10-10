Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0JJH4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 03:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0JJH4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 03:56:50 -0400
Date: Sun, 10 Oct 2010 09:56:25 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 08/12] Handle async PF in a guest.
Message-ID: <20101010075625.GM2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-9-git-send-email-gleb@redhat.com>
 <4CADC6C3.3040305@redhat.com>
 <20101007171418.GA2397@redhat.com>
 <4CAE00CB.1070400@redhat.com>
 <20101007180340.GI2397@redhat.com>
 <4CB0B8EF.3050702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB0B8EF.3050702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 08:48:15PM +0200, Avi Kivity wrote:
>  On 10/07/2010 08:03 PM, Gleb Natapov wrote:
> >>  >>
> >>  >Host side keeps track of outstanding apfs and will not send apf for the
> >>  >same phys address twice. It will halt vcpu instead.
> >>
> >>  What about different pages, running the scheduler code?
> >>
> >We can get couple of nested apfs, just like we can get nested
> >interrupts. Since scheduler disables preemption second apf will halt.
> 
> How much is a couple?
> 
> Consider:
> 
> SIGSTOP
> Entire process swapped out
> SIGCONT
> 
> We can get APF's on the current code, the scheduler code, the stack,
> any debugging code in between (e.g. ftrace), and the page tables for
> all of these.
> 
Lets count them all. Suppose guest is in a userspace process code and
guest memory is completely swapped out. Guest starts to run and faults
in userspace. Apf is queued but can't be delivered due to faults in
idt and exception stack. All of them will be taken synchronously due
to event pending check. After apf is delivered any fault in apf code
will be takes synchronously since interrupt are disabled. Just before
calling schedule() interrupts are enabled, so next pf that will happen
during call to schedule() will be taken asynchronously. Which will cause
another call to schedule() at which point vcpu will be halted since two
apfs happened at the same address. So I counted two of them.

--
			Gleb.
