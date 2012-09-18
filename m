Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2IRSbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:31:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46471 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2IRSbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:31:43 -0400
Message-ID: <5058BD9E.30909@linaro.org>
Date: Tue, 18 Sep 2012 11:29:50 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org> <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com> <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
In-Reply-To: <20120918180200.GA2281@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091818-2398-0000-0000-00000B1A5A83
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00175239; UDB=6.00039679; UTC=2012-09-18
 18:31:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 11:02 AM, Richard Cochran wrote:
> On Mon, Sep 17, 2012 at 05:20:41PM -0700, John Stultz wrote:
>> On 09/17/2012 04:49 PM, Andy Lutomirski wrote:
>>> 2. There's nothing vsyscall-specific about the code in
>>> vclock_gettime.c.  In fact, the VVAR macro should work just fine in
>>> kernel code.  If you moved all this code into a header, then in-kernel
>>> uses could use it, and maybe even other arches could use it.  Last
>>> time I checked, it seemed like vclock_gettime was considerably faster
>>> than whatever the in-kernel equivalent did.
>> I like the idea of unifying the implementations, but I'd want to
>> know more about why vclock_gettime was faster then the in-kernel
>> getnstimeofday(), since it might be due to the more limited locking
>> (we only update vsyscall data under the vsyscall lock, where as the
>> timekeeper lock is held for the entire execution of
>> update_wall_time()), or some of the optimizations in the vsyscall
>> code is focused on providing timespecs to userland, where as
>> in-kernel we also have to provide ktime_ts.
> This there a valid technical reason why each arch has its own vdso
> implementation?
I believe its mostly historical, but on some architectures that history 
has become an established ABI, making it technical.

powerpc, for example exports timekeeping data at a specific address, and 
the code logic to use that data is in userland libraries, outside of 
kernel control.  ia64 uses a fsyscall method, which is (to my 
understanding) a mode that allows limited access to kernel data from 
userland, but restricts what instructions can be used, requiring it to 
be hand written in asm.

Now, x86_64 too had its own magic vsyscall address that was hard coded, 
but Andy did some very cool work allowing that to bounce to the normal 
syscall for compatability, allowing the nicer vdso method to be used.  
It may be that such a vdso method could be introduced and migrated to on 
these other arches, but we'd still have to preserve the existing ABI as 
well (and in cases like ppc, that preservation would be just as 
complicated as it is now).

> If not, I would suggest that the first step would be to refactor these
> into one C-language header. If this can be shared with kernel code,
> then all the better.
>
> It would make it a lot easier to fix the leap second thing, too.
Indeed, it would be nice.  Tweaking the ia64 fsyscall  isn't anything I 
look forward to. :)

But such heavy lifting will likely need to be done by arch maintainers. 
That's why with this patchset I preserve the existing method, but make 
it clear its deprecated and allow arches that don't need the old method 
to avoid the extra overhead caused by the additional rounding fix. Then 
those arches can migrate when they can, rather then having to block 
change on everyone conforming to a new standard.

thanks
-john

