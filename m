Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0F0EIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 00:08:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45416 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0F0EI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 00:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TVEv1s4suaxR7hqiHQRoz0pmLysqDjStUrVk9CMkepV5SgVZuQQ3qtpJytSV/RR1tY
         qLknYY34YSwJ0Ub4bltSgLa1j+dU0H0q5fkRN5NTZgY4PWfBvwG5fpxYfOiMqFbsR8tR
         1E7CEy/w/vP2YK69W/rAR7uJZDtljjhmSwvgw=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1006201120210.22272-100000@netrider.rowland.org>
References: <AANLkTikPOcNZk5ISX2WDHSmsPDw_a5_3Ic3owAbO4o0y@mail.gmail.com> 
	<Pine.LNX.4.44L0.1006201120210.22272-100000@netrider.rowland.org>
From: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>
Date: Sat, 26 Jun 2010 21:08:07 -0700
X-Google-Sender-Auth: 46l2N4zsxJx6rzBra3sAYW-2jI8
Message-ID: <AANLkTiktmoiyX4c8x1XtJ353sv0flV5NqIQrptrDXPnM@mail.gmail.com>
Subject: Re: [linux-pm] wait_for_completion_interruptible does not wait !!
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       vivin uthappa <vivinuthappa@gmail.com>,
       Sudhakar R <sudhakar.raj@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 8:52 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> What happens if the variable is completed while nobody is waiting for
> it?  The next time somebody tries to wait, won't the wait terminate
> immediately?
>

Haven't tested it but will reply with the answer once I get a chance to test it.


>> I tried wait_for_completion instead, but now the kernel refuses to suspend.
>>
>> I have tried wait queues and mutexs with no success.
>>
>> Could anyone please point me how I can resolve this issue? Is there
>> any construct which can block inside the kernel during suspend/resume?
>
> Yes: The freezer.
>
>> Can there be a blocking call active while we suspend?
>
> Yes, in theory.  In practice it's not a good idea, since the call
> wouldn't be able to distinguish between an actual signal and the onset
> of a suspend.  You might end up with a call that ignores all signals
> and hence cannot be interrupted.
>

Just for the information of others on the list, here is what we did to
solve this issue, we designed a freezer-friendly wrapper around
wait_for_completion_interruptible()

<SNIP>
#define wait_for_completion_freezable(ptr_completion)           \
({                                                              \
   int __retval;                                                \
   do {                                                         \
       __retval = wait_for_completion_interruptible(            \
                       ptr_completion);                         \
       if (__retval && !freezing(current))                      \
           break;                                               \
   } while (try_to_freeze());                                   \
   __retval;                                                    \
})

</SNIP>

Thanks
Suresh
