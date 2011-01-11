Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1AKUcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:32:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1AKUco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IxzPvuEiCoT3DwZaTU8XEhuUW1n8vndiCirmI9UhAXEBvh7aUw0TaZUkLKuhnrVqOF
         FIsk0qA13DGAr+pg8XEQhNcjmKZV7yKl+IqemNnWfFJ4Z4IBPBR+5Dqb7WzSWdTpi20n
         FzNAeKQMaIXj8HTL/ZMLc0cGoldELZ0CMn5Sk=
MIME-Version: 1.0
In-Reply-To: <1294693597.3068.12.camel@work-vm>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
 <20110108175028.GA22308@riccoc20.at.omicron.at> <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
 <1294678145.3068.6.camel@work-vm> <AANLkTikdg4Pb5c4wcCU3d3Eku=mpiW_TEkBz0A2VPdVp@mail.gmail.com>
 <1294693597.3068.12.camel@work-vm>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Wed, 12 Jan 2011 05:32:03 +0900
Message-ID: <AANLkTik+2udoJ6JyZMhkd1yhr2W9hSWO_vD_zdm+BoOG@mail.gmail.com>
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 6:06 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2011-01-11 at 05:45 +0900, Kuwahara,T. wrote:
>> On Tue, Jan 11, 2011 at 1:49 AM, john stultz <johnstul@us.ibm.com> wrote:
>> > Leapsecond processing is done via an absolute hrtimer. Thus when the
>> > time offset is set, the hrtimers that should have expired will fire
>> > (just like with settimeofday) and the adjustment will then be made.
>>
>> How do you convert relative time to absolute time?  It's not trivial
>> because TAI offset is also a variable.
>
> I don't believe I understand what you're getting at.
>
> The proposed interface is almost identical in functionality to a
> userland application doing the following:
>
>        offset = my_calculate_offset();
>        clock_gettime(CLOCK_REALTIME, &now);
>        newtime = my_add_ts(now, offset);
>        settimeofday(&newtime, 0);
>
> The only difference is that you avoid the error from the delay between
> the gettime call and the settime call. It just adds the offset directly
> to the CLOCK_REALTIME.

For example, what time was it 3 seconds after 2008-12-31 23:59:59?
You may say, of course it's 2009-01-01 00:00:02.  But it's not true.
You wonder why?  Because a leap second had been added at midnight.

	unix time   UTC     offset
	---------- -------- ---
	1230767997 23:59:57  -2
	1230767998 23:59:58  -1
	1230767999 23:59:59   0
	1230768000 23:59:60   1 (leap second)
	1230768000 00:00:00   2
	1230768001 00:00:01   3
	1230768002 00:00:02   4

That's why I said it's not trivial, and that your patch is broken and
thus useless.  Unfortunately, there's no remedy for this as long as a
nonlinear timescale such as the unix time is being used, since the
leap second insertion/deletion is a non-deterministic event.
