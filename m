Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1BAU6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:58:00 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54506 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1BAU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:57:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6244"; a="72828775"
Message-ID: <4D4873D5.70203@codeaurora.org>
Date: Tue, 01 Feb 2011 12:57:57 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
References: <201102011711.31258.jeremy.kerr@canonical.com>	<20110201105449.GY1147@pengutronix.de>	<AANLkTimayMAfr+zA6uO_yUmZqsOLmJ3fiiS696mL_evn@mail.gmail.com>	<20110201140024.GZ1147@pengutronix.de>	<20110201151418.GN31216@n2100.arm.linux.org.uk>	<20110201152203.GE1147@pengutronix.de> <20110201152820.GQ31216@n2100.arm.linux.org.uk>
In-Reply-To: <20110201152820.GQ31216@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 07:28 AM, Russell King - ARM Linux wrote:
> On Tue, Feb 01, 2011 at 04:22:03PM +0100, Uwe Kleine-König wrote:
>> Full ack.  (I wonder if you misunderstood me or wanted to put my
>> statement into more words.  Jassi didn't like that a clk_enable without
>> a previous clk_prepare worked on some platforms and on others it
>> doesn't.  With BUG_ON(clk->ops->prepare&&  !clk->prepare_count) in
>> clk_enable we have exactly this situation.)
>
> Even with a NULL clk->ops->prepare function, we still want drivers to
> have called clk_prepare().  So we can do something like:
>
> 	if (WARN_ON(clk->prepare_count == 0))
> 		return -EINVAL;
>
> in clk_enable() should be sufficient and noisy enough not to be missed.

This code will only catch the error when it actually happens and will 
even miss catching some of them (if timed right -- unprepare happens in 
the other core after this check is executed).

I really wish there was something better we could do to help driver devs 
catch errors of calling enable without calling prepare(). Some thing 
like spin lock debug, or the might_sleeps() inside mutexes, etc.

Hmm... Jeremy, how about doing a similar check in the unprepare code? 
You could WARN/BUG ON the prepare count going to zero when the enable 
count is still non-zero?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
