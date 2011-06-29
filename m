Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1F2Jic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:38:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3249 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab1F2JiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:38:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QQA/TA4cCUYQNRJlKmlrV0LK4G5YDJKEQf46yc6ZDQYPThim8k+XbsqCaMeTp/qPo
	KS/2K6BJsc/xubjMBtpqQ==
MIME-Version: 1.0
In-Reply-To: <20110628165302.706740714@goodmis.org>
References: <20110628164750.281686775@goodmis.org>
	<20110628165302.706740714@goodmis.org>
Date: Wed, 29 Jun 2011 02:38:20 -0700
Message-ID: <CANN689E0ckbGBZZfk-BMdyR=_E6eN2oQb5uhij3ARPVCicqGrQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Remove use of ALLOW_RETRY when RETRY_NOWAIT is set
From: Michel Lespinasse <walken@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> The only user of FAULT_FLAG_RETRY_NOWAIT also sets the
> FAULT_FLAG_ALLOW_RETRY flag. This makes the check in the
> __lock_page_or_retry redundant as it checks the RETRY_NOWAIT
> just after checking ALLOW_RETRY and then returns if it is
> set.  The FAULT_FLAG_ALLOW_RETRY does not make any other
> difference in this path.
>
> Setting both and then ignoring one is quite confusing,
> especially since this code has very subtle locking issues
> when it comes to the mmap_sem.
>
> Only set the RETRY_WAIT flag and have that do the necessary
> work instead of confusing reviewers of this code by setting
> ALLOW_RETRY and not releasing the mmap_sem.
>
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -151,8 +151,8 @@ extern pgprot_t protection_map[16];
>  #define FAULT_FLAG_WRITE       0x01    /* Fault was a write access */
>  #define FAULT_FLAG_NONLINEAR   0x02    /* Fault was via a nonlinear mapping */
>  #define FAULT_FLAG_MKWRITE     0x04    /* Fault was mkwrite of existing pte */
> -#define FAULT_FLAG_ALLOW_RETRY 0x08    /* Retry fault if blocking */
> -#define FAULT_FLAG_RETRY_NOWAIT        0x10    /* Don't drop mmap_sem and wait when retrying */
> +#define FAULT_FLAG_ALLOW_RETRY 0x08    /* Retry fault if blocking (drops mmap_sem) */
> +#define FAULT_FLAG_RETRY_NOWAIT        0x10    /* Wait when retrying (don't drop mmap_sem) */

You want to say "DONT wait when retrying" here...

Also - you argued higher up that having both flags set at once is
confusing, but I find it equally confusing to pass a flag to specify
you don't want to wait on retry if the flag that allows retry is not
set. I think the confusion comes from the way the nowait semantics got
bolted on the retry code for virtualization, even though (if I
understand the virtualization use case correctly) they dont actually
want to retry there, they just want to give up without blocking.


Would the following proposal make more sense to you ?

FAULT_FLAG_ALLOW_ASYNC: allow returning a VM_FAULT_ASYNC error code if
the page can't be obtained immediately (major fault).
FAULT_FLAG_ASYNC_WAIT: before returning VM_FAULT_ASYNC, drop the
mmap_sem and wait for major fault to complete.

existing uses of FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT
become FAULT_FLAG_ASYNC
existing uses of FAULT_FLAG_ALLOW_RETRY alone become FAULT_FLAG_ASYNC
| FAULT_FLAG_ASYNC_WAIT
existing uses of VM_FAULT_RETRY become VM_FAULT_ASYNC

This may also help your documentation proposal since the flags would
now work together rather than having one be an exception to the other.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
