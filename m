Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab1CDOpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:45:47 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:40622 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab1CDOpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:45:45 -0500
Message-ID: <4D70FAC2.5010109@linux.vnet.ibm.com>
Date: Fri, 04 Mar 2011 11:44:18 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tpm_tis on Lenovo T410 broken in 2.6.38-rc6
References: <E1PuKHL-0000lw-RM@tytso-glaptop> <4D6CFA80.3020505@linux.vnet.ibm.com> <AANLkTi=BtfXYV+1_JZh0SRZhJz=Ys3wCF-t5rBR2iz8O@mail.gmail.com> <4D6D61B1.7000302@linux.vnet.ibm.com> <20110301213756.GA2959@thunk.org>
In-Reply-To: <20110301213756.GA2959@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11030414-5054-0000-0000-00000079415D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, sorry for the delay.

On 03/01/2011 06:37 PM, Ted Ts'o wrote:
> On Tue, Mar 01, 2011 at 06:14:25PM -0300, Rajiv Andrade wrote:
>> I was referring to the first, 9b29050f, and the commitc4ff4b82  reverted by Ted fixes a bug for other users.
> What's the bug that other users suffer by having a longer timeout?  It
> means that if things fails it takes longer for them to get an error
> message in the case of something that's going to fail anyway, right?
> Somehow that seems less serious than the TPM simply completely failing
> to function caused by too-short timeouts.  (My situation).  So sorry
> if I'm feeling selfish, but a longer timeout before returning failure
> seems less important than my not being able to access the TPM at all.
The bug was that when running the kernel with IMA, at boot time, it 
issues 3 TPM commands IIRC, given the 2 min timeout,
when the TPM didn't respond due to it not working with interrupts for 
example, the boot hang for 6 minutes. The TPM device
driver then relies on the default values, given neither 
tpm_get_timeouts() can succeed. Unfortunately, yes, I don't have a
fix for TPMs not working with interrupts yet, however we've been making 
progress there recently, should be out soon.

I understand, and I didn't mean one was more or less important than the 
other, just gave the reason I wrote it at that time,
considering that I wasn't aware of the effect you're facing.
You're not being selfish from my POV also, both bugs need to be fixed.

> So, the results of my experiments.  First of all, trying to merge in
> your for_james branch doesn't help at all.  I used the tip of Linus's
> tree as of this morning (commit 3e1f2356ce2) and then merged in your
> for-james tree (commit b83452256e).  No go.  I tried setting the
> interrupts parameter to both 0 and 1, and either way, things still
> didn't work.
>
> OK, next, I tried Linus's idea, which was to put a WARN macro here in
> tpm_calc_ordinal_duration:
>
>          if (duration_idx != TPM_UNDEFINED) {
> 		duration = chip->vendor.duration[duration_idx];
>                  /* if duration is 0, it's because chip->vendor.duration wasn't \
> */
>                  /* filled yet, so we set the lowest timeout just to give enough\
>   */
>                  /* time for tpm_get_timeouts() to succeed */
> NEW ---->	WARN(duration<=0,
> 		    "no duration for ordinal %x (diration_idx %d)",
> 		    ordinal, duration_idx);
>                  return (duration<= 0 ? HZ : duration);
> 	} else
>                  return 2 * 60 * HZ;
> }
>
> That resulted in the following data (see attached), which you will
> hopefully find useful.
Thanks, it is. HZ isn't enough time for this TPM/setup to have short 
timeout commands to succeed, including
the tpm_get_timeouts(). I was skeptic at first that this would be the 
reason since I have the same machine,
and was working for me, the reason I asked for these parameters setup 
attempts. I'll write a patch that will
contemplate the long boot time timeout and this bugs fixed, pursuing the 
interrupts fix path.

Rajiv

