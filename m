Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0JAOHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab0JAOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:07:20 -0400
Message-ID: <4CA5EB03.1070403@redhat.com>
Date: Fri, 01 Oct 2010 10:06:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] Release mmap_sem when page fault blocks on disk transfer.
References: <1285909484-30958-1-git-send-email-walken@google.com> <1285909484-30958-3-git-send-email-walken@google.com>
In-Reply-To: <1285909484-30958-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 01:04 AM, Michel Lespinasse wrote:
> This change reduces mmap_sem hold times that are caused by waiting for
> disk transfers when accessing file mapped VMAs. It introduces the
> VM_FAULT_RELEASED flag, which indicates that the call site holds mmap_lock
> and wishes for it to be released if blocking on a pending disk transfer.
> In that case, filemap_fault() returns the VM_FAULT_RELEASED status bit
> and do_page_fault() will then re-acquire mmap_sem and retry the page fault.
> It is expected that the retry will hit the same page which will now be cached,
> and thus it will complete with a low mmap_sem hold time.

The concept makes sense.  A nitpick, though...

> +	if (release_flag) {	/* Did not go through a retry */
> +		if (fault&  VM_FAULT_MAJOR) {
> +			tsk->maj_flt++;
> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
> +				      regs, address);
> +		} else {
> +			tsk->min_flt++;
> +			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
> +				      regs, address);
> +		}
> +		if (fault&  VM_FAULT_RELEASED) {
> +			/*
> +			 * handle_mm_fault() found that the desired page was
> +			 * locked. We asked for it to release mmap_sem in that
> +			 * case, so as to avoid holding it for too long.
> +			 * Retry starting at the mmap_sem acquire, this time
> +			 * without FAULT_FLAG_RETRY so that we avoid any
> +			 * risk of starvation.
> +			 */
> +			release_flag = 0;
> +			goto retry;
> +		}

Do we really want to count a minor page fault when we
got VM_FAULT_RELEASED?

-- 
All rights reversed
