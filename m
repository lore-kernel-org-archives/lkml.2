Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1FEUPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:15:37 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36542 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1FEUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:15:36 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEBE3DF.70104@die-jansens.de>
Date: Sun, 05 Jun 2011 22:15:27 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu> <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de> <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu> <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu> <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
In-Reply-To: <20110605194419.GA12965@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 21:44, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>>  From the timing I see I'd guess it has something to do with the
>> scheduler kicking in during printk. I'm neither familiar with the
>> printk code nor with the scheduler.
>
> Yeah, that's the well-known wake-up of klogd:
>
> void console_unlock(void)
> {
> ...
>          up(&console_sem);
>
> actually ... that's not the klogd wake-up at all (!). I so suck today
> at bug analysis :-)
>
> It's the console lock()/unlock() sequence, and guess what does it:
>
>   drivers/tty/tty_io.c:   console_lock();
>   drivers/tty/vt/selection.c:     console_lock();
>
> and the vt.c code in a dozen places.
>
> So maybe it's some sort of tty related memory corruption that was
> made *visible* via the extra assert that the scheduler is doing? The
> pi_list is embedded in task struct.
>
> This would explain why only printk() triggers it and other wakeup
> patterns not.
>
> Now, i don't really like this theory either. Why is there no other
> type of corruption? And exactly why did only the task_struct::pi_lock
> field get corrupted while nearby fields not? Also, none of the fields
> near pi_lock are even remotely tty related.

Can lockdep just get confused by the lockdep_off/on calls in printk
while scheduling is allowed? There aren't many users of lockdep_off().

I'll can try again tomorrow to get a dump of all logs from the
watchdog, but enough for today...

