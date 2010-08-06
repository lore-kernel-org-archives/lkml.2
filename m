Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab0HFVKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:10:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935106Ab0HFVKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:10:13 -0400
Message-ID: <4C5C7A0A.9080107@zytor.com>
Date: Fri, 06 Aug 2010 14:09:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <JBeulich@novell.com>, Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Nick Piggin <npiggin@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com> <1280761639.1923.213.camel@laptop> <4C56E1A1.6020005@goop.org> <4C5C1F80020000780000EA6D@vpn.id2.novell.com> <4C5C21E3.1020004@goop.org> <4C5C6DCE.4020206@zytor.com> <4C5C71A5.3050500@goop.org>
In-Reply-To: <4C5C71A5.3050500@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 01:33 PM, Jeremy Fitzhardinge wrote:
> On 08/06/2010 01:17 PM, H. Peter Anvin wrote:
>> On 08/06/2010 07:53 AM, Jeremy Fitzhardinge wrote:
>>> On 08/06/2010 05:43 AM, Jan Beulich wrote:
>>>> You certainly mean "the compiler currently treats this as being:" - I
>>>> don't think there's a guarantee it'll always be doing so.
>>>>
>>>>> for (;;) {
>>>>> if (inc.tickets.head == inc.tickets.tail)
>>>>> goto out;
>>>>> ...
>>>>> }
>>>>> out: barrier();
>>>>> }
>>>>>
>>>>> (Which would probably be a reasonable way to clarify the code.)
>>>> I therefore think it needs to be written this way.
>>>
>>> Agreed.
>>>
>>
>> A call/return to an actual out-of-line function is a barrier (and will
>> always be a barrier, as it is the fundamental ABI sequence points),
>> but to an inline function it is not.
>
> Yes. So the goto explicitly puts the barrier into the control flow which
> should stop the compiler from doing anything unexpected.
>

In this particular case, though, I would somewhat expect the more 
conventional:

while (inc.tickets.head != inc.tickets.tail) {
	cpu_relax();
	inc.tickets.head = ACCESS_ONCE(lock->tickets_head);
}

	-hpa
