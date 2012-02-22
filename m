Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2BVHzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:55:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48847 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab2BVHzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:55:35 -0500
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120222074839.GA24890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups + docs
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Feb 2012 23:55:00 -0800
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not arguing that, but the static aspect is still key... or people will read it as another version of likely/unlikely.  I'd be fine with static_likely/unlikely for example; I wish "static" wasn't such an overloaded word in C but I can't.personally think of a better term.

Ingo Molnar <mingo@elte.hu> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 02/21/2012 11:25 PM, Ingo Molnar wrote:
>> > 
>> > There is a fundamental assymetry, and intentionally so. You 
>> > *really* have to think what the common case is, and make 
>> > sure the build defaults to that. It's not the end of the 
>> > world to have it flipped over, but there's costs and those 
>> > costs are higher even in the branch path than a regular 
>> > likely()/unlikely().
>> 
>> No, not really -- it's still an unconditional branch, which 
>> means you will not tax the branch predictor in any way and 
>> which can be followed by the front end without taking a 
>> speculation hit. [...]
>
>You are talking about CPU level costs, I am also talking about 
>costs introduced at build time.
>
>Fact is, jump-label unlikely branches are moved *out of line*: 
>they are often in unlikely portions of the function (near other 
>unlikely branches), with instruction cache granularity costs and 
>potentially higher instruction-cache miss costs attached, etc.
>
>You are missing three important aspects:
>
>Firstly, instead of:
>
>  ins1
>  ins2
>  ins3
>  ins4
>  ins5
>  ins-compare
>  ins-branch
>  ins6
>  ins7
>  ins8
>  ins9
>  ins10
>
>We have:
>
>  ins1
>  ins2
>  ins3
>  ins4
>  ins5
>  ins-jump
>
>  [ hole ]
>
>  ins6
>  ins7
>  ins8
>  ins9
>  ins10
>  ins-jump back
>
>Where the 'hole' fragments the instruction cache layout. Given 
>that most of kernel execution is instruction-cache-cold, the 
>'straightness' of kernel code matters quite a bit.
>
>Secondly, there's build time instruction scheduling costs as 
>well: GCC will prefer the likely branch over the unlikely one, 
>so we might see extra instructions in the out-of-line code:
>
>
>  ins1
>  ins2
>  ins3
>  ins4
>  ins5
>  ins-jump
>
>  [ hole ]
>
>  ins-extra-1
>  ins-extra-2
>  ins6
>  ins7
>  ins8
>  ins9
>  ins10
>  ins-jump back
>
>In that sense jump labels are unlikely() branches combined with 
>a patching mechanism.
>
>Thus *both* aspects are important: if a branch is *truly* 50/50 
>then it's quite possibly *NOT* a correct optimization to use 
>jump-labels as the 'uncommon' code goes through extra hoops and 
>fragments out of the fastpath, which in quite many real life 
>cases can outstrip the advantage of the avoidance of a single 
>branch ...
>
>Thirdly,
>
>even if it's a correct optimization and both branches happen to 
>outperform the pre-jump-label version, regardless of the 
>direction of the jump label flag, it's *STILL* fundamentally 
>assymetric: due to the hole and due to the possible extra 
>instructions the out of line code will be slower by a few 
>instruction and the NOP fall-through will be faster.
>
>This is fundamentally so, and any naming that tries to *hide* 
>that assymetry and the associated micro-costs is confused.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
