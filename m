Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423339Ab2LFLoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 06:44:01 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56888 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423208Ab2LFLn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 06:43:59 -0500
Message-ID: <50C084FC.8040104@imgtec.com>
Date: Thu, 6 Dec 2012 11:43:56 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v2 23/44] metag: Traps
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-24-git-send-email-james.hogan@imgtec.com> <20121205174035.GX4939@ZenIV.linux.org.uk>
In-Reply-To: <20121205174035.GX4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_06_11_43_57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 05/12/12 17:40, Al Viro wrote:
> On Wed, Dec 05, 2012 at 04:08:41PM +0000, James Hogan wrote:
>> +TBIRES tail_end(TBIRES State, unsigned long orig_syscall)
>> +{
>> +	struct pt_regs *regs = (struct pt_regs *)State.Sig.pCtx;
>> +	unsigned long flags;
>> +
>> +	if (user_mode(regs)) {
>> +		local_irq_enable();
>> +		/* This is actually a crucial little line - if the process
>> +		 * needs swapping out, then this is where it happens!
>> +		 */
>> +		if (need_resched())
>> +			schedule();
>> +
>> +		flags = current_thread_info()->flags;
>> +		if (flags & (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME)) {
>> +			/* Note the passing in of the original syscall number.
>> +			 * This is used for implementing signal restart.
>> +			 */
>> +			do_notify_resume(regs, orig_syscall != 0,
>> +					 orig_syscall, flags);
> 
> Owww....  So
> 	a) you can't get there with !user_mode(regs)
> 	b) you handle only one signal (what happens if you fail sigframe
> allocation, BTW?  Sure, you get SIGSEGV delivered.  And don't handle it.)

I see, this indeed looks wrong.

If I understand correctly the second go around the loop when it asked
for the next signal should either stop process (SIGSEGV), or try to
invoke signal handler for SIGSEGV, and if allocation failed again it
would see it's already in a SIGSEGV (in force_sigsegv), change handler
to default, so that on the third go around the loop the process would
get stopped.

> 	c) you read ->flags with no protection whatsoever.  It should be
> done *before* you enable interrupts, and rechecked after you've done
> do_notify_resume() and redisabled them.  The same for schedule().  It really
> should be a loop; take a look at how it's done on arm and alpha - there that
> loop is in C, not in asm glue.

Thanks for pointing to ARM/alpha versions. This definitely needs some work.

> 	d) looks like your sigreturn is, indeed, broken.  It should *not* have
> syscall restart logics triggered at all.

I presume this is related to the other email about preventing syscall
restart logic for sigreturn. I can't see how any other arches prevent it
though.

Thanks a lot
James

