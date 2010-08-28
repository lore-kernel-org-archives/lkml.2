Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0H1KqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 06:46:14 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:38308 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1KqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 06:46:13 -0400
Message-ID: <4C78E8EF.1000009@cesarb.net>
Date: Sat, 28 Aug 2010 07:46:07 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>	 <4C784650.2030200@cesarb.net> <1282962104.1946.179.camel@Joe-Laptop>
In-Reply-To: <1282962104.1946.179.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-08-2010 23:21, Joe Perches escreveu:
> On Fri, 2010-08-27 at 20:12 -0300, Cesar Eduardo Barros wrote:
>> Em 27-08-2010 04:39, Joe Perches escreveu:
>>> On Thu, 2010-08-26 at 22:38 -0300, Cesar Eduardo Barros wrote:
>>>> - The first "MCP power limit exceeded" seems very bogus.
>>>> - What do you mean, core_power_limit is zero?
>>> I added a logging message whenever the turbo limits change
>>> and logging messages for power/temp on MCH for completeness.
>>> Maybe this will show something useful like when/how
>>> CPU power limit gets set to 0.
>
>> Running with it right now, did not help much:
>>
>> $ dmesg | fgrep 'intel ips'
>> intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value
>> (found 25, expected 35)
>> intel ips 0000:00:1f.6: PCI INT C ->  GSI 18 (level, low) ->  IRQ 18
>> intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
>> intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:8058 +
>> mch:23392829
>> intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5675
>> intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6369
>
> I believe all these limits should always have non-zero values.
> So I still think you've hardware problems, but I suppose it
> could be the driver not reading the right registers or some
> such.  It seems odd that the driver never printed a logging
> message for either of the polling or irq methods to read the
> device cpu and thermal limits.

Come on, no blaming the BIOS? ;-)

If I read the code with your previous patch correctly, show_turbo_limits 
will never be called if poll_turbo_status is false but no interrupt 
happens. And we know no interrupt happened (at least not with nonzero 
register values), because the interrupt handler does two dev_info() 
right at the beginning. So the limits could still be the ones initially 
set at ips_probe().

I will try to enable dev_dbg() later and see what it prints.

>
> Jesse or any Intel folk, can you verify or suggest anything
> better?
>
> If cpu_power_limit, or any _limit, is not set perhaps changing
> the test style to verify limit and adding a printed_once alert
> for each 0 value limit.  At least that'd shut up the continuous
> logging but at least give a notification message.
>
> if (limit) {
> 	if (measured_val>  limit)
> 		dev_info(foo)
> } else
> 	dev_alert_once()

Wouldn't it make more sense to do the alert when the limit is set, 
instead of when it is used? Also, it should still treat it as limit 
exceeded (better safe than sorry). Something like:

if (measured_val > limit) {
     if (limit)
         dev_info(...);
     ret = true;
}

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
