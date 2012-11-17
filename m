Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2KQOF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:05:29 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:54308 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2KQOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:05:27 -0500
Message-ID: <50A798D7.9040306@synopsys.com>
Date: Sat, 17 Nov 2012 19:31:59 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <arnd@arndb.de>
Subject: Re: [RFC PATCH v1 30/31] ARC: switch to generic kernel_execve() and
 sys_execve()
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-31-git-send-email-vgupta@synopsys.com> <20121116040847.GA22671@ZenIV.linux.org.uk>
In-Reply-To: <20121116040847.GA22671@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012 09:38 AM, Al Viro wrote:
> On Wed, Nov 07, 2012 at 10:47:53AM +0100, Vineet Gupta wrote:
>> +; When we land here, pt_regs have already been updated in-place correctly
>> +; A pointer to them is also passed by kernel_execve, we just need to make sure
>> +; that SP is set to point to them.
>> +ARC_ENTRY ret_from_kernel_execve
>> +	; Force SP to "normal" pt_regs just populated.
>> +	b.d   ret_from_system_call
>> +	mov   sp, r0
> won't that splatter crap into regs->r0?  IOW, why not branch to
> ret_from_exception here?

Yes it does - although I didn't notice the ill-effect since execve as an
API doesn't expect r0 to have a certain value (like fork for child).
Fixed in next revision.

>
>> +ARC_EXIT ret_from_kernel_execve
> Another thing: why not fold that branch to ret_from_exception into the end of
> ret_from_kernel_thread() (instead of calling sys_exit()), select
> GENERIC_KERNEL_EXECVE and lose __ARCH_WANT_KERNEL_EXECVE.

If you noticed I only had 3 patches and didn't have the equivalent of
"switch to saner kernel_execve() semantics" which would achieve above
because the bug you elucidate to below was giving me grief in bring up
(and I couldn't spend enough time debugging it).

> Actually, now that I look at your ret_from_kernel_thread...  How the hell
> will it cope with kernel_thread() payload trying to return?  AFAICS, this
> j.d [r1] will lose the return address, won't it? 

Exactly so. I was missing the equivalent of following

ARC_ENTRY ret_from_kernel_thread
	bl  @schedule_tail
	ld  r1, [sp, PT_r1]
-	j.d [r1]
+	jl.d [r1]
        ld  r0, [sp, PT_r0]
	j   @sys_exit
ARC_EXIT ret_from_kernel_thread

And since none of the bootup kernel threads took the return path I had a
working system - the problem only showed up when kernel_execve( )
started returning to exercise the broken path above.

>  And while we are at it,
> I would suggest passing callback and its argument via callee-saved registers -
> makes for simpler life in ret_from_kernel_thread(), since switch_to() itself
> will take care of loading those...

Absolutely - done that too !

Would you prefer to take a look at the updated patches now or will you
rather wait for v2 series which might take a week or two.

Thanks for taking the time to review this stuff.

-Vineet

