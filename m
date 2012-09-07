Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2IGQgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:36:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39938 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2IGQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:36:08 -0400
Message-ID: <504A2272.8040209@wwwdotorg.org>
Date: Fri, 07 Sep 2012 10:36:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Alex Courbot <acourbot@nvidia.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <201209061614.54022.heiko@sntech.de> <1887927.1deN8M9siP@percival> <201209071108.42083.heiko@sntech.de>
In-Reply-To: <201209071108.42083.heiko@sntech.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 03:08 AM, Heiko Stübner wrote:
> Am Freitag, 7. September 2012, 10:04:24 schrieb Alex Courbot:
>>> For your power_seq_run function you write that it simply returns an error
>>> code on failure and looking through it I also just found the error return
>>> statement. This would leave a device half turned on.
>>>
>>> So I'm wondering, if it shouldn't turn off all the things it turned on
>>> until the step that produced the error. All your possible step types
>>> (execpt the delay) are booleans, so it should be possible to simply
>>> negate them when backtracking through the previous steps.
>>
>> Indeed, I think you raised an important point. Right now all step types are
>> invertible, but we cannot rely on that statement to be true forever. For
>> instance, one short-term improvement will be to allow finer regulator
>> control, like voltage setting. In this case, how can we go back to the
>> initial state without recording it?
>>
>> If e.g. the power on sequence fails at step N (of M steps for that
>> sequence), one could try playing the corresponding power off sequence
>> (either completely of from step M - N), but then again we cannot rely on
>> sequences to be perfectly symetrical. Maybe this is more something for the
>> calling driver to check for and control?
> 
> Am Freitag, 7. September 2012, 10:15:03 schrieb Mark Brown:
>> On Fri, Sep 07, 2012 at 05:04:24PM +0900, Alex Courbot wrote:
>>> If e.g. the power on sequence fails at step N (of M steps for that
>>> sequence), one could try playing the corresponding power off sequence
>>> (either completely of from step M - N), but then again we cannot rely on
>>> sequences to be perfectly symetrical. Maybe this is more something for
>>> the calling driver to check for and control?
>>
>> That had been my thought too - depending on what the sequence is for it
>> may be that the corrective action is something very different to
>> reversing the sequence, for example a device reset may be required.
> 
> If I understood the description correctly, the power sequence should be 
> transparent to the driver, as it implements board specific actions and 
> shouldn't bother the driver with it to much.

Well, the contents/implementation of the sequence should be transparent
to the driver. The fact that a sequence exists and needs to be executed
obviously can't be transparent to the driver, since the driver needs to
call an API to execute the sequence.

I'd assert that requiring the driver to get back to a sane state by
executing sequence (b) if sequence (a) fails is fairly reasonable, and
doesn't give the driver any more knowledge of what the sequences are
than what it already has.

But then I start to wonder: What if the "help something went wrong"
sequence gets an error...

> Therefore my thoughts went along
> the lines how gpio_request_array handles this, always producing a sane state 
> at the end.
> 
> Recording the previous state, could be done by making a copy of the current 
> sequence, and just noting the previous values (including voltages etc) in the 
> respective entries. And in the error case running this new sequence from the 
> error point instead to power down again.
> 
> 
> As both Alex and Mark wrote, reversing the sequence might be the action of 
> choice only for some devices, but others might need to run a completely 
> different powerdown sequence and still others would need special handling.
> 
> Would it be possible to encode this in the sequence definition, something like
> 	on-error = "reverse"
> 
> 	on-error = "sequence"
> 	error-seq = <&other_sequence>
> 
> 	on-error = "driver"
> with better names and types of course.
> 
> This would keep the power sequence transparent to most drivers and only the 
> real esoteric ones would need to do their special handling on their own.

Yes, something like that sounds reasonable on the surface. I'm not sure
about the on-error="driver" case though; if the driver knows nothing
about the content of the sequences, I'm not sure how the driver could
possibly do anything other than execute some sequence to recover.
