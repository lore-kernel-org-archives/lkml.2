Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1ERJHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:07:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49943 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1ERJHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bC5sF+5jBRkz/QgmIP8GoGJGeS+tmPOAVWBScLdDFLqMOWhTqIL9xofzdWGvLcMpjI
         a4Bh5q9RwDFO9M36Bdx1vvZwgxYCV6c11XKDIzjTT0rqcdovGMQFRgfZ6Epdp2y4nkWG
         /ObXot7gk2maqEdhyaoB9543BJgnh8Uc7rQXE=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201105172240.46970.rjw@sisk.pl>
References: <20110512061928.GB2460@localhost.ucw.cz>
	<1305608346-23800-1-git-send-email-myungjoo.ham@samsung.com>
	<201105172240.46970.rjw@sisk.pl>
Date: Wed, 18 May 2011 18:07:50 +0900
X-Google-Sender-Auth: hc4Eeu3zuLZro6R1918-6f_5hEA
Message-ID: <BANLkTim6ygf9JN2k1ZnW5kLwvUggDBJyNA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] PM / Core: suspend_again callback for suspend_ops.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, May 17, 2011, MyungJoo Ham wrote:
[]
>> -static int suspend_enter(suspend_state_t state)
>> +static int suspend_enter(suspend_state_t state, bool *wakeup_pending)
>
> You don't need to use the wakeup_pending argument at all.  I think you
> shouldn't use it even, because in theory there may be a wakeup event after
> you've called pm_wakeup_pending() in suspend_enter() and in that case
> you should break the loop too.

In the case where:
- at the first instance of suspend_enter, pm_wakeup_pending() returns false.
- after suspend_ops->enter(state), the pm_wakeup_pending() "wants" to
return true.
- however, suspend_again forces to loop again.
- then, at the second instance of suspend_enter, pm_wakeup_pending()
returns true.
- the suspend_again's loop breaks.

Although it did not break the loop at the first while, it breaks
without calling suspend_ops->enter again anyway.

[]
>
> So I would simply call pm_wakeup_pending() here again.
>

Besides, if we simply call pm_wakeup_pending() again at there, the
loop will NOT break with pm_wakeup_pending() is true at the first call
inside of suspend_enter(). The function pm_wakeup_pending() clears out
the pending wakeup at each call; thus, in the following example, the
loop will not break:

- At the first instance of suspend_enter in the suspend-again loop,
pm_wakeup_pending() returns true in suspend_enter().
- suspend_enter() returns without error.
- pm_wakeup_pending() is called again at the while statement along
with suspend_ops->suspend_again().
- pm_wakeup_pending() now returns false because it has already
returned true before and cleared "events_check_enabled"
- the loop continues.

Because pm_save_wakeup_count will return true only once for each
wakeup-preventing-event, the result of pm_wakeup_pending in
suspend_enter() should be relayed outside to the loop anyway.

>>
>>   Resume_devices:
>>       suspend_test_start();
>>
>
> Thanks,
> Rafael
>


Cheers!

- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
