Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab0KMWeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:34:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43658 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0KMWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p2SDfsR36ZDUae+Xp+CcObwVZ/EH4R5DlpaJf1x4g5b42CWlUIp5dYY14nXQuTEVdH
         eBBqNYehOfwj13ZcPvjdKFauRTMasWLTfWlY+wuKT2/WnXZcokkW2YDDBpJpjAjo9wEP
         vd26zzLHym34FHcnXw7wYBZFmOIhpkzCAtZKo=
Message-ID: <4CDF125E.3050803@redhat.com>
Date: Sat, 13 Nov 2010 23:34:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com> <20101113100527.GG3837@hack>
In-Reply-To: <20101113100527.GG3837@hack>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 11:05 AM, Américo Wang wrote:
> On Wed, Nov 03, 2010 at 10:59:44AM -0400, Jeremy Fitzhardinge wrote:
>>   * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>>   * (PPro errata 66, 92)
>>   */
>> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
>> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
>> +{
>> +	if (sizeof(lock->tickets.head) == sizeof(u8))
>> +		asm (LOCK_PREFIX "incb %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>> +	else
>> +		asm (LOCK_PREFIX "incw %0"
>> +		     : "+m" (lock->tickets.head) : : "memory");
>
> This 'if/else' really should be done with #ifdef, even though
> the compiler may be smart enough to remove it.

That's a sure path to bitrot.

Paolo
