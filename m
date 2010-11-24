Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0KXTNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:13:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0KXTNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:13:39 -0500
Message-ID: <4CED63DC.20608@redhat.com>
Date: Wed, 24 Nov 2010 21:13:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:18 PM, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
>
> here is a patch-set to make the instruction emulator aware of nested
> virtualization. It basically works by introducing a new callback into
> the x86_ops to check if a decoded instruction must be intercepted. If it
> is intercepted the instruction emulator returns straight into the guest.
>
> I am not entirely happy with this solution because it partially
> duplicates the code in the x86_emulate_insn function.

My big worry is that it makes svm.c aware of internal emulator variable, 
so it makes it harder to hack on the emulator.

> But there are so
> many SVM specific cases that need to be taken care of that I consider
> this solution the better one (even when looking at the diff-stat).
> Keeping this (SVM-specific) complexity in the SVM specific code is
> better than extending the generic instruction emulator code path.

I don't think there's a problem with svm specific code in the emulator 
for this.  My reasoning is that there are two classes of svm code: the 
common one is using svm to implement kvm, and the other one is emulating 
the svm instruction set.  Most of the current svm code belongs to the 
first class, even the nested svm code.  For example the code that 
emulates VMRUN is kvm-specific, while the code that decides whether to 
#GP on VMRUN or not is generic.

So I don't think there's a problem with coding the svm intercepts in 
emulate.c.  This is no different than emulating any AMD-specific 
instruction in the emulator - we're emulating an instruction in exactly 
the way it is specified in the manual.

Something you could do is allocate bits for the intercept bit number and 
exit code in opcode->flags.  This way most unconditional intercepts 
happen outside the instruction switch: generic code reads the intercept 
bit, the intercept word (via a callback), if the bit is set, returns the 
exit code.  That should completely kill the diffstat.  We only need to 
be careful wrt the order of the intercept check and the other permission 
checks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

