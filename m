Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab1EKX3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:29:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64026 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657Ab1EKX3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=KcR6Xcx+49CHk1F631jZ4okxtnYtUEklzG4QM/ofntizfyTqO4bZk+B17IMebxamKX
         U7FqrqRvcxYZSo54A4EWfAzOxxr/ew9JjoWFPznWzO97kh6KFXu57MsudNrGpdnQ9osh
         xU5OOxEFwzopMho10Nru/OfMX0k5PqcKWjwrc=
MIME-Version: 1.0
In-Reply-To: <m2fwokj0oz.fsf@firstfloor.org>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com> <m2fwokj0oz.fsf@firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 11 May 2011 19:28:46 -0400
X-Google-Sender-Auth: 9BW9ykxsgWrgheqPTZPKWb-6qtg
Message-ID: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 7:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Andrew Lutomirski <luto@mit.edu> writes:
>>
>> I can sometimes (but not always) trigger this by enabling swap and
>> running dirty_ram 2048 (attached).  (One time it took the system down
>> completely.  I have ~8 GB of swap, all of which was empty when I ran
>
> Never configure that much swap (> 1*RAM). It will just make any OOM more
> painful because it'll thrash forever. If you're 4x overcommited
> no workload will be happy.

Agreed.  But I only need to overcommit by a little to get it to crash.

>
>> This box is a Lenovo X220 Sandy Bridge laptop with 2G of RAM (the old
>> box had more) and runs ext4 on LVM on dm-crypt on an SSD.  I see the
>
> FWIW i had problems in swapping over dmcrypt for a long time -- not
> quite as severe as you. Never really tracked it down.
>
> But I suspect just not doing the swap over dmcrypt would make
> it a lot more usable.

Maybe.  But I can get to it crash just fine without any swap at all,
which I think ought to be the most stable configuration.

>
>> If I had to guess, I'd say that the VM gets confused when it's forced
>> to write data out to my LVM-over-dm-crypt partition and either starts
>> OOM-killing things when it's not out of memory or deadlocks because it
>> runs out of available RAM and can't service new dm-crypt and block
>> requests.
>>
>> Please help fix/debug this.  It's making my shiny new laptop almost useless.
>
> I would add some tracing to the dmcrypt paths and then log
> it over the network during the problem. Most likely some part
> of it stalls or tries to allocate more memory.

Yep, that's next.  I just added some instrumentation in mempool_alloc
to warn if it can't satisfy an allocation for five seconds and it
didn't trigger.  Most of the dm-crypt allocations I could find go
through mempool, so I think they're ruled out.

Do softlockups in kswapd0 mean anything?  I think I can rule out a
traditional vm deadlock, because the machine is currently stuck with
tons of things hitting the softlockup warning but with 809M of DMA32
space free (as well as 8M DMA and 16kB normal).

Here's a nice picture of alt-sysrq-m with lots of memory free but the
system mostly hung.  I can still switch VTs.

http://web.mit.edu/luto/www/meminfo.jpg

alt-sysrq-j to thaw filesystems caused the system to start printing
"Emergency Thaw on dm-2" in an infinite loop.  Time to power off and
go home...

--Andy

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
>
