Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab2HXKY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:24:27 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:22330 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2HXKYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:24:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,302,1344211200"; 
   d="scan'208";a="14165585"
Message-ID: <5037531E.1010906@citrix.com>
Date: Fri, 24 Aug 2012 11:10:38 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for x86_init.mapping.pagetable_reserve
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos> <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic>
In-Reply-To: <20120824100309.GG3019@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/08/12 11:03, Borislav Petkov wrote:
> On Thu, Aug 23, 2012 at 06:13:39PM +0100, Attilio Rao wrote:
>    
>> You seriously think that adding a single-check, that will be
>> certainly skipped (now), in a boot-time function is going to add any
>> performance burden?
>>
>>      
>>> What you are doing is actively wrong. You suggest that it's fine to
>>> call that function with something different than pgt_buf_start as the
>>> start argument. That's complete nonsense. The early pages are
>>> allocated bottom up beginning at pgt_buf_start. So what the heck would
>>> make it sane to change that argument ever?
>>>        
>> If you really don't like this approach, at this point I think the
>> best thing to do is to assume that the start address will be
>> pgt_buf_start and loose the starting argument at all.
>> If you agree I can make a patch for that.
>>      
> One thing I don't understand is why is xen touching x86 code when it
> doesn't have to? At least I cannot find a single reason for it in this
> thread.
>    

I really don't understand why you are saying here:
1) Are you implying that xen_mapping_pagetable_reserve() is unnecessary?
2) Are you implying that my patch is unnecessary?

In the 1 case you are wrong becsause it is of course necessary, unless 
you have a better way to fix the same bug keeping the same level of 
cleaniness. The reasons are reported earlier in the thread, but for 
your's sake they are summarized further here:

commit 279b706bf800b5967037f492dbe4fc5081ad5d0f
Author: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
Date:   Thu Apr 14 15:49:41 2011 +0100

      x86,xen: introduce x86_init.mapping.pagetable_reserve


In the case 2 you are wrong again. This is not a XEN-specific patch. 
pagetable_reserve() has no documentation and no clear semantic right 
now. hpa has asked to document all the kernel hooks, for a reference 
look here:
http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000070.html

So I'm sure this is something that is welcome also by Linux community.

> Thomas is clearly explaining to you that what you're trying to
> enforce cannot happen on baremetal x86 and you're still insisting on
> "documenting" that.
>
>    

I think that foundamentally there is a bit of misunderstanding here. 
There were 2 ways to provide a correct semantic:
1) Leave the arguments in place, but taking care to give some formalism 
to them
2) Remove the arguments and let handle all the pgt_buf_start, 
pgt_buf_end logic within the functions themselves.

Consensus by me, Konrad and Stefano went to case n.1, but now I see that 
Thomas has issues with it. I don't agree at all with his objections for 
several points:
- Few extra-checks, which are not necessary now but would leave the 
function sane in the future, in a boot-time mechanism aren't really a 
performance critical issue.
- He says that this function is not going to be used by drivers, but it 
is however part of the kernel infrastructure, so you cannot really leave 
it unlifted. Besides, Linux doesn't have a formal way to split his 
functions into private and public KPI, thus any function can be 
considered potentially usable by thirdy-part module (but I'm sure this 
is an arguable point)

However, the conclusion is that I respect Thomas authority here and I 
will implement approach 2, hoping that he would then consider patch for 
inclusion into tips.

> Here's a simple answer: if it doesn't fix a bug on x86 baremetal (and
> you're changing x86 native code only for the sake of xen), there's no
> reason wasting energy to create patches.
>
>    

You really should read (and understand) patches and e-mail more 
carefully before to send such mis-informed responses.

Attilio
