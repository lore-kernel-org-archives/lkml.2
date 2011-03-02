Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1CBTQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:16:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:16:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=arBXAsB1IfkGfnJp/WLhuGIvdA8bpUtm0qJ2KZ7GJD04Tq5t9yuU+adAaz2CgJ/x7+
         0ydHdoeoD7MFbu6C89Lm0q5Vp74zRZlYt+1HvX9cJaszRCdE1oaRYMSRpOb7EvDPJlnw
         sf2h2uwo3sEdr9Qfs+lymQM4U4dQatg05+Bc8=
Message-ID: <4D6E9700.50501@openvz.org>
Date: Wed, 02 Mar 2011 22:14:08 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
References: <4D6E631B.6040701@openvz.org> <20110302154645.GA11827@elte.hu> <4D6E6886.2060707@openvz.org> <20110302160315.GA12620@elte.hu> <4D6E6CB6.7000700@openvz.org> <20110302184053.GW11359@redhat.com>
In-Reply-To: <20110302184053.GW11359@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 09:40 PM, Don Zickus wrote:
> On Wed, Mar 02, 2011 at 07:13:42PM +0300, Cyrill Gorcunov wrote:
>> On 03/02/2011 07:03 PM, Ingo Molnar wrote:
>> ...
>>>
>>> Well, the lock serializes the read-out of the 'NMI reason' port, the handling of 
>>> whatever known reason and then the reassertion of the NMI (on 32-bit). 
>>>
>>> EDAC has a callback in pci_serr_error() - and this lock serializes that. So we 
>>> cannot just remove a lock like that, if there's any chance of parallel execution on 
>>> multiple CPUs.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>
>> OK, probably we need some UV person CC'ed (not sure whom) just to explain the
>> reason for such nmi-listening model. Meanwhile -- lets drop my patch.
> 
> It's for debugging reasons.  When their huge machine deadlocks, they
> wanted an easy mechanism to dump the cpu stacks.  That mechanism was an
> nmi button.  The problem was the button would only dump the first cpu.  By
> opening up the other cpus to accept external nmis, they could dump all the
> cpus.

  Yeah, thanks Don, just noted that (actually the former commit log
/78c06176466cbd1b3f0f67709d3023c40dbebcbd/ didn't mention that x86
masks only LVT1).

> 
> Now this spinlock doesn't affect them, because they registered an nmi
> handler to catch it and dump their stack (I modified the code to use
> DIE_NMIUNKNOWN instead of DIE_NMI to avoid conflict with the
> nmi_watchdog).  But I don't know what the affect is, if that spinlock is
> not there (I sent a private email to SGI inquiring, their guy wasn't
> around this week).

  Don, do you know -- was new nmi-watchdog system tested with UV machine
somewhere?

> 
> Personally I am indifferent to this patch.  I don't have any problems with
> the code the way it is now, but can understand what you mean having stuff
> lying around as 'dead code'.  I had thought Intel would have pushed more
> patches upstream to remove the BSP lock-in by now.
> 
> Cheers,
> Don
> 

-- 
    Cyrill
