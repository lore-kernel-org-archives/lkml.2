Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2BVHEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:04:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2BVHEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:04:12 -0500
Message-ID: <4F44934B.2000808@zytor.com>
Date: Tue, 21 Feb 2012 23:03:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu>
In-Reply-To: <20120222065016.GA16923@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 10:50 PM, Ingo Molnar wrote:
> 
> The pattern has spread beyond the niche of tracing internals and 
> nobody seemed to have any second thoughts about the actual 
> readability of these names. That is a major FAIL and it was my 
> primary concern.
> 
> For those *reading* the code, the similarity of 
> very_likely()/very_unlikely() to the likely()/unlikely() 
> patterns is *INTENTIONAL*, as functionally the branch site 
> itself is very similar to a real branch!
> 
> Secondly, for those *writing* such code, you cannot just 
> 'accidentally' change a unlikely() to a very_unlikely() and get 
> something you didn't ask for ...
> 
> It is the modification site that is dissimilar (and which is 
> slow in the jump label case) - and that is very apparently 
> dissimilar that it takes some effort to change these flags. If 
> you write such code you have to add the whole jump label 
> mechanism to it, which makes it very apparent what is happening 
> and makes the costs very apparent as well.
> 
> Thirdly, the fact that it's a 'jump label' is an 
> *implementational* detail. On some architectures very_unlikely() 
> indeed maps to unlikely(), because jump labels have not been 
> implemented yet. On some architectures very_unlikely() is 
> implemented via jump labels. On some future architectures it 
> might be implemented via JIT-ing the target function. (I made 
> the last one up)
> 
> So it makes sense to decouple 'jump labels' from the actual high 
> level naming of this API.
> 
> Anyway, I've Cc:-ed Linus and Andrew, I plan to take the renames 
> but they can NAK me if doing that is stupid.
> 

I have to VEHEMENTLY disagree with you here.

likely()/unlikely() are supposed to be used when it is clear at the time
the code is written which way the branch is biased or which path is
important (unlikely() is typically used for performance-unimportant
bailouts.)

Jump labels are not that way.  The key aspect for when the jump label
optimization is relevant is *how often is the direction changed*.  It is
perfectly sane for this to be done on a 50:50 branch, as long as the
50:50-ness is settled once for all dring a boot.  Consider, for example,
an Intel CPU versus an AMD CPU.  Wouldn't you agree that it would be
absolutely ridiculous and downright offensive to have:

	if (very_unlikely(cpu_vendor_amd)) {

Yet this is a *fantastic* use of the jump labels, because your CPU
vendor isn't going to change in the middle of execution (hot VM
migrations excepted ;)

So the key aspect of this is the staticness of the conditional, NOT the
degree of bias of the branch.  Hence my past insistence on the
"static_branch" name (rather than "jump_label")... the branch part can
be omitted, as an implementation detail, but the staticness of it is its
absolutely key defining characteristic.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

