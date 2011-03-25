Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1CYXIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:08:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab1CYXIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:08:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110325083448.GA5738@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-5-git-send-email-jeffbrown@android.com> <20110325083448.GA5738@polaris.bitmath.org>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 25 Mar 2011 16:07:40 -0700
Message-ID: <AANLkTinipkcuT=bBo39GWeQt5-tHGMf_pnHGCot6N95E@mail.gmail.com>
Subject: Re: [PATCH 4/4] input: evdev: only wake poll on EV_SYN
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -     if (event->type == EV_SYN)
>> +     if (event->type == EV_SYN && event->code != SYN_MT_REPORT)
>
> It is not clear what should happen at the other SYN events.  Maybe
> event->code == SYN_REPORT instead?
>
>>               kill_fasync(&client->fasync, SIGIO, POLL_IN);
>>  }

The reasoning here is that we want to wake up (for poll) or signal
(for fasync) the waiters when a complete packet is available.

SYN_CONFIG, SYN_REPORT and the proposed SYN_DROPPED are all
indications of a complete packet being ready or at least an indication
that the reader should do something.  The odd one out is
SYN_MT_REPORT.

>> -     wake_up_interruptible(&evdev->wait);
>> +     if (type == EV_SYN && code != SYN_MT_REPORT)
>> +             wake_up_interruptible(&evdev->wait);
>
> Ah, this is a good one. Since the code depends on the same logic being
> applied in evdev_pass_event as well, a boolean argument to that
> function would be good.

I agree.  We could pass a flag to evdev_pass_event to indicate whether
to signal fasync processes that are waiting for data.

Jeff.
