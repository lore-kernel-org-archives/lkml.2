Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1IBF6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:58:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52012 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1IBF6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYkk+W98RoCCwRWXyF+_1_H9gujxHLCPnqtPMn401fZvg@mail.gmail.com>
References: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
	<CACRpkdYkk+W98RoCCwRWXyF+_1_H9gujxHLCPnqtPMn401fZvg@mail.gmail.com>
Date: Fri, 2 Sep 2011 14:58:11 +0900
Message-ID: <CAKYAXd8VUAZ1gL-MZx7y6+nORJ4m2U+SFyzF2duB-9NUcbqBQw@mail.gmail.com>
Subject: Re: RFC : mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of multiple write blocks.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        Sebastian Rasmussen <Sebastian.Rasmussen@stericsson.com>,
        Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/30 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Aug 25, 2011 at 6:44 AM, NamJae Jeon <linkinjeon@gmail.com> wrote:
>
>> If card is infinitely holding pull down busy line(data 0) while
>> writing multiple blocks, write will be blocked in
>> mmc_wait_for_req_done().
>> I suggest to use wait_for_completion_timeout instread of
>> wait_for_completion like the below code.
>>
>> How do you think about my suggestion ?
>
> Since this is a hardware lock-up it is up to the host driver to
> timeout and return an error to the framework.
>
> For example only the host driver have information on the
> clock speed on the host controller and other information such
> as request size that can be used to set a suitable timeout waiting
> for the request to complete.
>
> If you just grep for timeout_ns in drivers/mmc/host you can
> see several drivers using the card-supplied timeout_ns for
> handing the timeout properly given local clocking
> constraints etc.
>
> Often host controllers can take the number
> of clock cycles until timeout as a parameter, and only
> the host controller can calculate this number.
> See for example in mmci_start_data()
> in mmci.c.
>
> So I seriously think you need to look closer at the problematic
> host driver if this is a problem to you, e.g. rewrite it to use
> wait_for_completion_timeout() there.
>
> Yours,
> Linus Walleij
>

We should consider DMA situation. As I know, host controller can not
rise timeout interrupt in write not read in DMA status. host
controller can just know whether card is finish to program to use busy
line. If unstable card is holding busy line while writing using DMA,
hang problem will happen by wait_for_completion.
so I think that mmc driver need some exception to avoid this problem.
