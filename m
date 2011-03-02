Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1CBPzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:55:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46722 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1CBPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LuxMehg9vasT0ZByQ6O3R7CZWTxWY0wSwtwKAFLgS0kmSUDybGydqCZZ2njqmIlt8i
         /ALK45EuVchx6twx0XAQSIBkwYFsK1CsoSpMezWIlFsHEliDIjCwbeloSHL/9IbhKf9R
         QwFHSJ448wFMIyy293nVEccYyVhwtrf7Enbrg=
Message-ID: <4D6E6886.2060707@openvz.org>
Date: Wed, 02 Mar 2011 18:55:50 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
References: <4D6E631B.6040701@openvz.org> <20110302154645.GA11827@elte.hu>
In-Reply-To: <20110302154645.GA11827@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 06:46 PM, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> At moment we have only BSP apic configured to listen
>> for external NMIs. So there is no reason for additional
>> spinlock since only BSP will receive them.
>>
>> Though we still have UV chips which do enable external NMIs
>> on all cpus, but since an approach to allow retrieving
>> NMI reason on BSP only was working pretty fine before --
>> I assume it still remains valid.
> 
> I'm not sure I get the point here: we might get NMIs on non-BSP on UV
> systems ... so we want to remove the spinlock?
> 
> If UV systems can get NMIs on any CPU then the lock is needed.
> 
> It might have worked before - but UV systems are rare and relatively
> new - plus the race window is small, so it might not have been triggered
> in practice.

  Well, it is incomplete anyway. As far as I can tell even ordering such
NMIs with spinlock would not make situation better 'cause other cpu might
obtain unknown nmi (ie two or more cpu's gets NMI then handing started on
first found that it was say MCE error, handle it, unlock spinlock and then
the second cpu gets this nmi (the reason for which was already handled by
first cpu) and sees unknown NMI. So this lock might simply hiding a bug.
Of course I might be missing something.

> 
>> Also it's worth to mention that an initial idea of all this
>> NMI code-path changes was to make BSP hot-unpluggable but
>> until all other parts of kernel is prepared for it (which
>> might consume quite a time to implement) I believe we should
>> not lock/unlock for nothing.
> 
> That would be another argument in favor of keeping the lock, right?

Yes, but I think this lock should be the last thing which is introduced,
after all other parts of kernel are ready for bsp unplug.

> 
> Thanks,
> 
> 	Ingo


-- 
    Cyrill
