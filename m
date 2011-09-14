Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1INJSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:18:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab1INJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:18:30 -0400
Message-ID: <4E70716B.3010201@gmail.com>
Date: Wed, 14 Sep 2011 17:18:35 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Player Thread is not woken after period elapsed
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 01:38 AM, Nallasellan, Singaravelan wrote:
> Hi,
>
> When I tried to root cause a glitch in the audio playback, I found a weird behavior.
>
> User thread which invokes the writei function which in turn  invokes a kernel function which waits for the free buffer to write the audio data.  This kernel function adds this thread to a wake(sleep) queue  and calls a schedule_timeout (msecs_to_jiffies(10000)).
>
> When the audio playback of a period is completed, the hardware generates an interrupt. The handler in the path wake_up the thread added to the sleep queue.  Most of the time, the playback thread is woken up.
>
> During this error case, the thread is not getting woken up. However the sleep queue is not empty.  This continues until the playback enter into underrun due to all the periods in the buffer are played back. Audio playback continues after recovery from xrun.
>

Its possible that your user thread was woken up by the IRQ handler but
it found out the 'free buffer' is not available and go back to sleep.

- check the /proc/<pid of user thread>/schedstat for whether the thread 
was scheduled
- your shared buffer design might has problems in it, it seemed there is 
a race between
     your IRQ handler and 'free buffer' checking logic.
- ftrace might be helpful

Cheers
Shan Hai

> Will you provide some hint on how to go about identifying the root cause?
>
> Thanks
> -Sing
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

