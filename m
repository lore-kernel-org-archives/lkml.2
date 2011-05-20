Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab1ETDiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:38:05 -0400
Received: from mailhost.anl.gov ([130.202.113.50]:42379 "EHLO mailhost.anl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1ETDiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:38:03 -0400
Message-ID: <4DD5E218.5030508@mcs.anl.gov>
Date: Thu, 19 May 2011 22:38:00 -0500
From: Kazutomo Yoshii <kazutomo@mcs.anl.gov>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Eric Van Hensbergen <ericvh@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
Subject: Re: [bg-linux] [PATCH 6/7] [RFC] enable early TLBs for BG/P
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>	<1305753895-24845-6-git-send-email-ericvh@gmail.com>	<1305851941.7481.92.camel@pasglop>	<BANLkTinAqeu7C+U_HFrOAOctFTuSUwG-iA@mail.gmail.com> <1305856442.7481.120.camel@pasglop>
In-Reply-To: <1305856442.7481.120.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 08:54 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2011-05-19 at 20:21 -0500, Eric Van Hensbergen wrote:
>    
>> On Thu, May 19, 2011 at 7:39 PM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org>  wrote:
>>      
>>> On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
>>>        
>>>> BG/P maps firmware with an early TLB
>>>>          
>>> That's a bit gross. How often do you call that firmware in practice ?
>>> Aren't you better off instead inserting a TLB entry for it when you call
>>> it instead ? A simple tlbsx. + tlbwe sequence would do. That would free
>>> up a TLB entry for normal use.
>>>
>>>        
>> Well, it depends on who you talk to.  The production software BG/P
>> guys use the firmware constantly, its the primary interface to the networks, the console,
>> and the management software which runs the machine.
>>      
> Yuck.
>    

Unfortunately, the firmware is also required:
- to configure Blue Gene Interrupt Controller(BIC)
- to configure Torus DMA unit. e.g. fifo
- to configure global interrupt (even we don't use, we need to disable 
some channel correctly)
- to access node personality information (node id, DDR size, HZ, etc) or 
maybe we can directly access SRAM?
etc, etc.

>> As such the IO Node guys, the Compute Node Kernel guys and the
>> ZeptoOS guys use it quite a bit.  The kittyhawk guys on the other hand
>> barely use it at all, in fact I believe they do all the interaction with
>> it during uboot and then shut it off.
>>      
>    
(I'm one of the ZeptoOS guys, btw)

As a regular ppc linux usage, our firmware dependency is minimum as well.
However,  with our HPC extension, the firmware functions are called when
it configures BGP specific network hardware.

We are not planning to submit our HPC extension here anytime soon
because our work is very special purpose and includes lots of dirty hack 
right now.

Thanks,
Kaz
> I would prefer that approach.
>
>    
>> IIRC, the sticky question is RAS support, there are certain things it
>> wants to jump to firmware to deal with and expects things to be mapped
>> an pinned into memory.
>>
>> Furthermore, I think it may make assumptions about where in the TLB the
>> mappings are.
>>      
> This is gross, especially on a system with only 64 SW loaded TLB
> entries :-(
>
>    
>> Since the kittyhawk guys
>> obviously ignore this by shutting it down, its not clear just how
>> important this is.  I'm game to
>> try the dynamic mapping as you suggest if you would prefer it.
>>      
> I would yes, we can sort things out later for RAS.
>
>    
>> Its worth mentioning that I believe with BG/Q, the plan is to rely on
>> the firmware even more extensively, but I haven't looked at any of the code yet to verify
>> whether or not this is true.
>>      
> This is tantamount to linking a binary blob with the kernel ... it's a
> fine line. At some point we might refuse the patches if they go too far
> in that direction.
>
> Cheers,
> Ben.
>
>    
>>       -eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>      
>
> _______________________________________________
> bg-linux mailing list
> bg-linux@lists.anl-external.org
> https://lists.anl-external.org/mailman/listinfo/bg-linux
> http://bg-linux.anl-external.org/wiki
>    

