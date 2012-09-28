Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2I1Oer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:34:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60503 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2I1Oeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <5064790E.4000207@cs.tu-berlin.de> <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 28 Sep 2012 16:34:24 +0200
Message-ID: <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:25 AM, Jan H. Schönherr
<schnhrr@cs.tu-berlin.de> wrote:

>> If really, really everything passes through vprintk_emit()
>> then we could keep all info about the previous message
>> there and definitely decide whether the current message continues
>> the previous one.
>>
>> Then, we wouldn't need to track the previous flags everywhere.
>
> Here is a patch that does just that.
>
> Seems to work. And it makes the code easier to understand.
> A more detailed description is below.

> -       if (!(lflags & LOG_NEWLINE)) {
> -               /*
> -                * Flush the conflicting buffer. An earlier newline was missing,
> -                * or another task also prints continuation lines.
> -                */
> -               if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
> -                       cont_flush(LOG_NEWLINE);
> +       cont_add(facility, level, lflags, dict, dictlen, text, text_len);

That fails the racing task test, and a cont user that was nicely
merged before is now all in separate records.

It seems, unconditionally using the cont buffer like in your patch,
for all incoming messages just makes the entire cont merge buffer
dance useless when it comes to races.

The current behaviour has the advantage, that non-cont users will not
race against a cont user (which is like 99.x% of the races I expect).
The cont buffer is currently only used when we expect a cont user,
non-cont users happening in the middle of a cont-print will not flush
the and disturb the cont buffer.

Thanks,
Kay
