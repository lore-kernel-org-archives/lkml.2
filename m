Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab0FILtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:49:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0FILtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:49:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent;
	b=F4HfJHqpSWwqpW2uALswfxZ1to0teLkJQS+7OZdCt4FrW/4z2JXXDlSQKr+yhG4As
	RAhuUqX1001WCGpp1lg6g==
Date: Wed, 9 Jun 2010 04:49:03 -0700
From: Michel Lespinasse <walken@google.com>
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
	reused immediately.
Message-ID: <20100609114903.GA9223@google.com>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 11:24:38PM -0700, Salman wrote:
> A program that repeatedly forks and waits is susceptible to having the
> same pid repeated, especially when it competes with another instance of the
> same program.  This is really bad for bash implementation.  Furthermore, many shell
> scripts assume that pid numbers will not be used for some length of time.
> 
> Thanks to Ted Tso for the key ideas of this implementation.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>
> ---
>  kernel/pid.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index e9fd8c1..8cedeab 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -153,8 +153,17 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
>  		if (likely(atomic_read(&map->nr_free))) {
>  			do {
>  				if (!test_and_set_bit(offset, map->page)) {
> +					int prev;
>  					atomic_dec(&map->nr_free);
> -					pid_ns->last_pid = pid;
> +
> +					do {
> +						prev = last;
> +						last = cmpxchg(&pid_ns->last_pid,
> +							       prev, pid);
> +						if (last >= pid)
> +							break;

You should make sure to handle pid wrap-around for this last/pid comparison.
I think proper way to do that would be:

	/* last is the pid we started scanning at
         * last_read is the last observed value of pid_ns->last_pid
         */
        last_read = last;
        do {
                prev = last_read;
                last_read = cmpxchg(&pid_ns->last_pid, prev, pid);
        /* Exit if one of these conditions is true:
         * - cmpxchg succeeded
         * - last <= pid <= last_read  (other thread already bumped last_pid)
         * - last_read <= last <= pid  (same with wraparound)
         * - pid <= last_read <= last  (same with different wraparound)
         */
        } while (last_read != prev &&
                 (last > pid || pid > last_read) &&
                 (last_read > last || last > pid) &&
                 (pid > last_read || last_read > last));

The last_read == pid case is also interesting - it means another thread found
the same pid, forked a child with that pid, and the child exited already
(since the bitmap was cleared). However we don't need to handle that case -
first, that race is much less likely to happen, and second, the duplicate
pid would be returned in two separate tasks - so this would not cause problems
in bash as in your example.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
