Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1FOBIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1FOBIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:08:14 -0400
Message-ID: <4DF805F3.4030603@redhat.com>
Date: Tue, 14 Jun 2011 22:08:03 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 5/7] KVM-GST: KVM Steal time accounting
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>	 <1308007897-17013-6-git-send-email-glommer@redhat.com> <1308046203.19856.9.camel@twins>
In-Reply-To: <1308046203.19856.9.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 07:10 AM, Peter Zijlstra wrote:
> On Mon, 2011-06-13 at 19:31 -0400, Glauber Costa wrote:
>> +static inline int touch_steal_time(int is_idle)
>> +{
>> +       u64 steal, st = 0;
>> +
>> +       if (static_branch(&paravirt_steal_enabled)) {
>> +
>> +               steal = paravirt_steal_clock(smp_processor_id());
>> +
>> +               steal -= this_rq()->prev_steal_time;
>> +               this_rq()->prev_steal_time += steal;
>
> If you move this addition below this test:
>
>> +               if (is_idle || (steal<  TICK_NSEC))
>> +                       return 0;
>
> that is, right here, then you don't loose tiny steal deltas and
> subsequent ticks accumulate their steal time until you really
> have a full steal tick to account.

true
> I guess you want something different for the idle case though.

definitely.

>> +               while (steal>  TICK_NSEC) {
>
> 			/* really, if we wanted a division we'd have written one */
> 			asm("" : "+rm" (steal));

Out of curiosity, have we seen any compiler de-optimize it to a 
division, or are you just being careful ?

>> +                       steal -= TICK_NSEC;
>> +                       st++;
>> +               }
>> +
>> +               account_steal_time(st);
>> +               return 1;
>> +       }
>> +       return 0;
>> +}
>
>

