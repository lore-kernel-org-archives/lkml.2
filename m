Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2EUU7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:59:53 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:58185 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758513Ab2EUU7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:59:51 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dI9371I1432N98dK4015Izz1202hzzz2fh2a8h668h839hd25hf0ah)
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
Message-ID: <4FBAACAC.3080300@am.sony.com>
Date: Mon, 21 May 2012 13:59:24 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Venkat Subbiah <vsubbiah@caviumnetworks.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT 2/2] fix printk flush of messages
References: <4FB44EF1.9050809@am.sony.com> <4FB44FD0.4090800@am.sony.com> <4FBAA150.6050308@caviumnetworks.com>
In-Reply-To: <4FBAA150.6050308@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/12 13:10, Venkat Subbiah wrote:
> On 05/16/2012 06:09 PM, Frank Rowand wrote:
>> Updates console-make-rt-friendly.patch
>>
>> #ifdef CONFIG_PREEMPT_RT_FULL, printk() output is never flushed by
>> printk() because:
> So this is an issue for printk() itself and is not just for early_printk()?
> 
> 
>     # some liberties taken in this pseudo-code to make it easier to follow
>     printk()
>        vprintk()
>           raw_spin_lock(&logbuf_lock)
>              # increment preempt_count():
>              preempt_disable()
>        result = console_trylock_for_printk()
> 
> As I read it console_trylock_for_printk() is called from printk() but in 
> code it is called from vprintk()

Yes, I goofed on the indentation, starting at console_trylock_for_printk().
It should have been:

   # some liberties taken in this pseudo-code to make it easier to follow
   printk()
      vprintk()
         raw_spin_lock(&logbuf_lock)
            # increment preempt_count():
            preempt_disable()
         result = console_trylock_for_printk()
            retval = 0
            # lock will always be false, because preempt_count() will be >= 1
            lock = ... && !preempt_count()
            if (lock)
               retval = 1
            return retval
         # result will always be false since lock will always be false
         if (result)
            console_unlock()
               # this is where the printk() output would be flushed

Thanks,

Frank

