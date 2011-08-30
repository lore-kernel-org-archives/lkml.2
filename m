Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1H3HPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:15:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1H3HPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
References: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
Date: Tue, 30 Aug 2011 09:15:38 +0200
Message-ID: <CACRpkdYkk+W98RoCCwRWXyF+_1_H9gujxHLCPnqtPMn401fZvg@mail.gmail.com>
Subject: Re: RFC : mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of multiple write blocks.
From: Linus Walleij <linus.walleij@linaro.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        Sebastian Rasmussen <Sebastian.Rasmussen@stericsson.com>,
        Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 6:44 AM, NamJae Jeon <linkinjeon@gmail.com> wrote:

> If card is infinitely holding pull down busy line(data 0) while
> writing multiple blocks, write will be blocked in
> mmc_wait_for_req_done().
> I suggest to use wait_for_completion_timeout instread of
> wait_for_completion like the below code.
>
> How do you think about my suggestion ?

Since this is a hardware lock-up it is up to the host driver to
timeout and return an error to the framework.

For example only the host driver have information on the
clock speed on the host controller and other information such
as request size that can be used to set a suitable timeout waiting
for the request to complete.

If you just grep for timeout_ns in drivers/mmc/host you can
see several drivers using the card-supplied timeout_ns for
handing the timeout properly given local clocking
constraints etc.

Often host controllers can take the number
of clock cycles until timeout as a parameter, and only
the host controller can calculate this number.
See for example in mmci_start_data()
in mmci.c.

So I seriously think you need to look closer at the problematic
host driver if this is a problem to you, e.g. rewrite it to use
wait_for_completion_timeout() there.

Yours,
Linus Walleij
