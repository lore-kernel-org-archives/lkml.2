Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab1ADL4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:56:09 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56224 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1ADL4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TUV+UgpAfRJeXIIu6KQZog+FM3ukbQYLYT5rM2zKI2QQ9alsXFTCjB1hTmJUblqCO0
         NlvVVSVTQK4688UVAC8/d9Fwx2t5FzBPJRb6DDICxxSqGM/gmVqDFsH1WhVxzpOfkyTM
         4RsaiFB6qEIwvV6FSuqhrj90K6992bmArJi6s=
MIME-Version: 1.0
In-Reply-To: <20110103141727.GA1536@ucw.cz>
References: <20110102204532.GA12860@elf.ucw.cz>
	<20110102203023.GA1545@ucw.cz>
	<AANLkTika7HAEc+BbqSnbo8viUt4nOqoeB69qWZs85-9s@mail.gmail.com>
	<20110103141727.GA1536@ucw.cz>
Date: Tue, 4 Jan 2011 12:56:05 +0100
Message-ID: <AANLkTimFTzHjLy1zSURiOdcDJUSa9b-ZU1kxL_qK+7-T@mail.gmail.com>
Subject: Re: zaurus bluetooth regression
From: Yegor Yefremov <yegorslists@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> It seems this commit
>> >>
>> >> commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
>> > ...
>> >> ...is responsible for my bluetooth problems on zaurus -- at least
>> >> bisect pointed to it,  as I use 16C950-based bluetooth card, it seems
>> >> very logical. I'll try 2.6.37-rc8 with that patch reverted...
>> >>
>> >
>> > And yes, 37-rc8 with that reverted results in working bluetooth, so
>> > yrs, that patch is responsible.
>>
>> could you tell, what kind of problem you're encountering and if you
>> could tell, which flag UART_CAP_EFR or UART_CAP_SLEEP causes the
>> problem?
>
> Bluetooth will not work with 'tx command timeout', details should be
> in bugzilla.
>
> CAP_EFR seems to cause the problem.

Aside from sleep functions the only impact CAP_EFR makes is enabling
automatic CTS flow control. Below the cite from 16C950 data sheet:

"EFR[7]: Enable automatic CTS flow control.
logic 0 ⇒   CTS flow control is disabled (default).
logic 1 ⇒   CTS flow control is enabled in Enhanced mode
(i.e. EFR[4] = 1), where the data transmission is
prevented  whenever  the  CTS#  pin  is  held
inactive high. 650 and 950-mode drivers should
use  this  bit  to  enable  CTS  flow  control.    750
mode drivers should use MCR[5].

When automatic CTS flow control is enabled and the CTS#
input becomes active, the UART will disable transmission
as soon as any current character transmission is complete.
Transmission   is   resumed   whenever   the   CTS#   input
becomes inactive. "

I've tested with such an UART and transmitted some chunk of data with
and without RTS/CTS flow control enabled at 460800 b/s. The test
showed that in enabled state all data was transmitted correctly.
Without RTS/CTS flow control enabled there was massive data loss, as
expected. So the flow control function seems to work correctly.

Regards,
Yegor
