Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1BHRHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:07:45 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63841 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705Ab1BHRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:07:44 -0500
Message-ID: <4D5178B3.4050900@metafoo.de>
Date: Tue, 08 Feb 2011 18:09:07 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000
 support
References: <1296953291-10373-1-git-send-email-lars@metafoo.de> <AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com> <4D4F4B18.6030502@metafoo.de> <AANLkTimgejf7D9LWyxa=W7Hc4MTWEotMnr7h2SC9iPCQ@mail.gmail.com> <4D516BBB.5090506@metafoo.de> <20110208162802.GA29842@oksana.dev.rtsoft.ru>
In-Reply-To: <20110208162802.GA29842@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 05:28 PM, Anton Vorontsov wrote:
> On Tue, Feb 08, 2011 at 05:13:47PM +0100, Lars-Peter Clausen wrote:
>> On 02/08/2011 12:40 PM, Grazvydas Ignotas wrote:
>>> That works. However I wonder about the delay, I've experimentally
>>> determined that bq27500 refreshes in about a second, so before this
>>> series I could for example run 'watch -n 1 cat current_now' and see
>>> current changes almost in realtime (when toggling backlight, for
>>> example). Maybe we could have different cache timeout for different
>>> chips or have quickly changing properties (like current and voltage)
>>> bypass the cache.
>>
>> Looking at the datasheet confirms that the bq27500 updates the current register
>> every second. The bq27000 updates it only every 5.12 seconds.
>> I think reducing the the cache time for bq27500 to 1 second would render the
>> cache mostly useless, but maybe it makes sense to bypass the cache for voltage
>> and current on the bq27500.
> 
> Nope, it's not useless. I.e. for `cat /sys/class/power_supply/*/*`.
> Actually, it was only the purpose for caching the battery values.
> 
> So, 1 second is OK.

Yes, the purpose of the register cache was that registers aren't read multiple
times if multiple properties are queried at once. Which is what I consider the
standard use case, since this is what a power monitor application would
normally do.
The other use case is constantly monitor a single property like CURRENT_NOW.
Since we would now read all properties instead of just one and would increase
the load on the bus by 12 times.

The other purpose of the register cache was to be able to tell whether
registers have changed when polling the battery. Since we already ignore the
*_NOW properties when comparing the the old and the new state it would make
sense to bypass the cache completely for them.
This would reduce the load when monitoring such a property and it would also
reduce the load when polling the battery since we would only read 8 instead of
12 registers.

> 
> p.s. Lars, on the next resend, can you please remove "POWER:"
> prefix from the patch description line, bound the commit message
> width to 76 symbols, and add all the collected Acked-by lines.
> That way I can just pull your tree.

Sure.

- Lars

