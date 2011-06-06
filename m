Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1FFG4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 02:56:45 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:46286 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1FFG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 02:56:42 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DEC7A1F.1000802@die-jansens.de>
Date: Mon, 06 Jun 2011 08:56:31 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605151323.GA30590@elte.hu> <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu> <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de> <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu> <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu> <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu> <4DEBE3DF.70104@die-jansens.de>
In-Reply-To: <4DEBE3DF.70104@die-jansens.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 22:15, Arne Jansen wrote:
> On 05.06.2011 21:44, Ingo Molnar wrote:
>>
>> * Arne Jansen<lists@die-jansens.de>  wrote:
>>
>>>  From the timing I see I'd guess it has something to do with the
>>> scheduler kicking in during printk. I'm neither familiar with the
>>> printk code nor with the scheduler.
>>
>> Yeah, that's the well-known wake-up of klogd:
>>
>> void console_unlock(void)
>> {
>> ...
>>          up(&console_sem);
>>
>> actually ... that's not the klogd wake-up at all (!). I so suck today
>> at bug analysis :-)
>>
>> It's the console lock()/unlock() sequence, and guess what does it:
>>
>>   drivers/tty/tty_io.c:   console_lock();
>>   drivers/tty/vt/selection.c:     console_lock();
>>
>> and the vt.c code in a dozen places.
>>
>> So maybe it's some sort of tty related memory corruption that was
>> made *visible* via the extra assert that the scheduler is doing? The
>> pi_list is embedded in task struct.
>>
>> This would explain why only printk() triggers it and other wakeup
>> patterns not.
>>
>> Now, i don't really like this theory either. Why is there no other
>> type of corruption? And exactly why did only the task_struct::pi_lock
>> field get corrupted while nearby fields not? Also, none of the fields
>> near pi_lock are even remotely tty related.
> 
> Can lockdep just get confused by the lockdep_off/on calls in printk
> while scheduling is allowed? There aren't many users of lockdep_off().
> 
> I'll can try again tomorrow to get a dump of all logs from the
> watchdog, but enough for today...

I just let it dump the locks in debug_show_all_locks, even though
for some reason debug_locks is false. Don't know if the result is
helpful in any way, as it might well be inaccurate.

INFO: lockdep is turned off.

Showing all locks held in the system:
2 locks held by syslog-ng/21624:
 #0:  (&tty->atomic_write_lock){+.+.+.}, at: [<ffffffff8142ade3>]
tty_write_lock+0x23/0x60
 #1:  (&tty->output_lock){+.+...}, at: [<ffffffff8142ee7a>]
n_tty_write+0x14a/0x490
1 lock held by agetty/22174:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22175:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22176:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22177:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22178:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22179:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by agetty/22180:
 #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff8142fb86>]
n_tty_read+0x5f6/0x8e0
1 lock held by tail/22197:
 #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8185ae42>] schedule+0xe2/0x940

Some more fact that might help figure out what happens:
 - I nearly always either see all 10000 messages or only 10.
   Never 9, never 11. I saw 40 once, and once 190.
 - If I printk only 1000 lines instead of 10000, nothing bad happens
 - If /var/log/syslog is not filled with binary garbage, I also just
   see the 10 lines.

-Arne
