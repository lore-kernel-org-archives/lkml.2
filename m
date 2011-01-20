Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1ATQ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:57:54 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:57490 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589Ab1ATQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:57:52 -0500
Message-ID: <4D386986.3030506@fluff.org>
Date: Thu, 20 Jan 2011 16:57:42 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111101314.GA774@linux-sh.org>	<201101111830.18597.jeremy.kerr@canonical.com>	<20110111121816.GB774@linux-sh.org>	<4D2D09E2.5030305@codeaurora.org> <20110112022546.GA2350@linux-sh.org>
In-Reply-To: <20110112022546.GA2350@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/11 02:25, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 05:54:42PM -0800, Saravana Kannan wrote:
>> On 01/11/2011 04:18 AM, Paul Mundt wrote:
>>> Again, you are approaching it from the angle that an atomic clock is a
>>> special requirement rather than the default behaviour. Sleeping for
>>> lookup, addition, and deletion are all quite acceptable, but
>>> enable/disable pairs have always been intended to be usable from atomic
>>> context. Anyone that doesn't count on that fact is either dealing with
>>> special case clocks (PLLs, root clocks, etc.) or simply hasn't bothered
>>> implementing any sort of fine grained runtime power management for their
>>> platform.
>>
>> Paul,
>>
>> I see you repeating this point a couple of times and I'm a bit confused 
>> how you handle the clock tree/dependencies.
>>
>> Does your clock driver NOT hide the details of what root clock/PLL a 
>> branch clock is sourced from? If you do hide the details of the root/PLL 
>> source, how do you get the branch clk_enable() to be done atomically if 
>> the root/PLL enables are not possible in atomic context?
>>
>> Is it simply a matter of your hardware having PLLs and root clocks that 
>> can be turned on/off quickly?
>>
> There are a few cases where PLL clocks would benefit from a clk_enable()
> that can sleep, but for us these are almost all in the device space. Most
> of the SoCs however have fairly straightforward clock topologies where
> the root clock in question is an external oscillator that can't be
> disabled, and anything chained below that sits behind a PLL divider or
> multiplier bank that can likewise be adjusted atomically. The vast
> majority of the clocks below that can likewise be trivially
> enabled/disabled from atomic context.

All the Samsung SoCs have multiple PLLs as the root of their clock
trees, with some muxing options to feed in oscillator inputs. Many
of the systems I've seen have a 48MHz source for the USB, 12MHz
as a PLL source and then generate a pile of different frequencies for
various peripherals via the PLLs...

this is especially important for the cases where you need very specific
frequencies such as audio playback of tv encoding.
