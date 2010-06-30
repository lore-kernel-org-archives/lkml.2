Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0F3OZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:25:28 -0400
Received: from claw.goop.org ([74.207.240.146]:41389 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0F3OZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:25:27 -0400
Message-ID: <4C2B53D1.90101@goop.org>
Date: Wed, 30 Jun 2010 16:25:21 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -	 Xen
 implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com> <4C2B4564.7030203@goop.org> <4C2B6AD60200007800008D90@vpn.id2.novell.com>
In-Reply-To: <4C2B6AD60200007800008D90@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 04:03 PM, Jan Beulich wrote:
>>>> On 30.06.10 at 15:23, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>         
>> For spinlocks, the pvop calls should only be in the slow case: when a
>> spinlock has been spinning for long enough, and on unlock when there's
>> someone waiting for the lock.  The fastpath (no contention lock and
>> unlock) should have no extra calls.
>>     
> Then what was all that performance regression noise concerning
> pvops spinlocks about, leading to CONFIG_PARAVIRT_SPINLOCKS
> being separated from the base CONFIG_PARAVIRT?
>   

Nobody knows.  The pv spinlocks appeared to cause a 5% performance
regression on some benchmarks, which is wildly huge.  It appears to
trigger some kind of microarchitectural catastrophe on some Intel cpus,
perhaps relating to the extra call in the path or something.
 
> Afaics the unlock still involves a function call *in all cases* with
> pvops spinlocks, whereas it's a single inline instruction without.
>   

No.  The unlock path can see if there are any further waiters by looking
at the ticket in the, and only do the kick call if there are some.

    J
