Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964940Ab2HWR1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:27:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:56370 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HWR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:27:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,301,1344211200"; 
   d="scan'208";a="14153862"
Message-ID: <503664C3.7010301@citrix.com>
Date: Thu, 23 Aug 2012 18:13:39 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for x86_init.mapping.pagetable_reserve
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208231800530.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/12 18:14, Thomas Gleixner wrote:
> On Thu, 23 Aug 2012, Attilio Rao wrote:
>    
>> On 23/08/12 16:46, Thomas Gleixner wrote:
>>      
>>> On Wed, 22 Aug 2012, Attilio Rao wrote:
>>>
>>>
>>>        
>>>> - Allow xen_mapping_pagetable_reserve() to handle a start different from
>>>>     pgt_buf_start, but still bigger than it.
>>>>
>>>>          
>>> What's the purpose of this and how is this going to be used and how is
>>> it useful at all?
>>>
>>>        
>> (Just replying here as all the other your comments are derivative)
>> Looks like you are missing the whole point of the patch.
>> What the patch is supposed to do is just to "enforce a correct semantic for
>> the setup function" and not fix an actual problem found in the code.
>> This means that after the patch you know exactly what expect in terms of
>> semantic by the function and the callers will work following it.
>>
>> Otherwise, what could happen is that if one day for a reason or another begin
>> start being different from pgt_buf_start this function will just break
>> silently, reintroducing the original problem in a different form.
>>      
> Which original problem?
>
>    

This one:

http://marc.info/?l=linux-kernel&m=129901609503574
http://marc.info/?l=linux-kernel&m=130133909408229

and more specifically the one fixed in:
commit 279b706bf800b5967037f492dbe4fc5081ad5d0f
Author: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
Date:   Thu Apr 14 15:49:41 2011 +0100

     x86,xen: introduce x86_init.mapping.pagetable_reserve


>> I think this was clarified by the 0/2 but evidently you completely missed it.
>>      
> No, I did not miss it. And it's still not telling what the whole thing
> is about.
>
> There is no reason why start should ever be different. So your whole
> argument is that someone might change the call site of
> x86_init.mapping.pagetable_reserve().
>    

My actual reason is that I want a clear semantic for this function and 
enforce it.

> And then you tell in 1/2 changelog:
>
>   - Allow xen_mapping_pagetable_reserve() to handle a start different from
>     pgt_buf_start, but still bigger than it.
>
> without giving a rationale why this is necessary and why this can ever
> happen. It's wrong to begin with to feed that function something else
> than pgt_buf_start, period.
>    
> Don't misunderstand me. I'm not against documenting and not against
> making code safe and less error prone, but we do not add checks just
> because some moron might change the callee arguments to random
> nonsense or because some tinkerer might use the same function for
> something else.
>
> Following your argumentation we'd need to plaster the kernel code with
> sanity checks. This is not a random Java API used by a gazillion of
> code monkeys; it's low level architecture code and not a driver
> API. People who touch that code should better know what they are
> doing.
>    

You seriously think that adding a single-check, that will be certainly 
skipped (now), in a boot-time function is going to add any performance 
burden?

> What you are doing is actively wrong. You suggest that it's fine to
> call that function with something different than pgt_buf_start as the
> start argument. That's complete nonsense. The early pages are
> allocated bottom up beginning at pgt_buf_start. So what the heck would
> make it sane to change that argument ever?
>    

If you really don't like this approach, at this point I think the best 
thing to do is to assume that the start address will be pgt_buf_start 
and loose the starting argument at all.
If you agree I can make a patch for that.

Attilio
