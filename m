Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914Ab0HFMnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:43:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46191 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761203Ab0HFMnT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Fri, 6 Aug 2010 08:43:19 -0400
Message-Id: <4C5C1F80020000780000EA6D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 06 Aug 2010 13:43:12 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Peter Zijlstra" <peterz@infradead.org>
Cc: "Xen-devel" <xen-devel@lists.xensource.com>, "Avi Kivity" <avi@redhat.com>,
        "Nick Piggin" <npiggin@suse.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <1280761639.1923.213.camel@laptop> <4C56E1A1.6020005@goop.org>
In-Reply-To: <4C56E1A1.6020005@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.08.10 at 17:17, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 08/02/2010 08:07 AM, Peter Zijlstra wrote:
>> On Fri, 2010-07-16 at 18:03 -0700, Jeremy Fitzhardinge wrote:
>>> +       asm volatile (LOCK_PREFIX "xaddw %w0, %1\n"
>>> +                     : "+Q" (inc), "+m" (lock->slock) : : "memory", "cc");
>>   "+Q" (inc->slock)
>>
>>> +       for (;;) {
>>> +               if (inc.tickets.head == inc.tickets.tail)
>>> +                       return;
>>> +               cpu_relax();
>>> +               inc.tickets.head = ACCESS_ONCE(lock->tickets.head);
>>> +       }
>>> +       barrier();              /* make sure nothing creeps before the lock 
> is taken */
>>>   }
>> How will it ever get to that barrier() ?
> 
> The compiler treats this as being:

You certainly mean "the compiler currently treats this as being:" - I
don't think there's a guarantee it'll always be doing so.

> 	for (;;) {
> 		if (inc.tickets.head == inc.tickets.tail)
> 			goto out;
> 		...
> 	}
> out:	barrier();
> }
> 
> (Which would probably be a reasonable way to clarify the code.)

I therefore think it needs to be written this way.

Jan

