Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0DPQS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:18:58 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37541 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab0DPQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CjX3yqL7ITlAO9zBkvpvac0X1CMOcpnTaI0aG10OChMvnfbbxJQ1sKOgrVUZhcoAsI
         9mko7KO/K+UnGPli5YR+ef/3KprKCrnB7ixf1H2TyoAiDinFD5DCobJjxd85YuIAG/iQ
         h8TqUJjCPBixohngSCvLyAEp78B9PO9TRJqH8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004160110360.3625@localhost.localdomain>
References: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>
	 <1269340105-6503-1-git-send-email-chripell@fsfe.org>
	 <alpine.LFD.2.00.1004160110360.3625@localhost.localdomain>
Date: Fri, 16 Apr 2010 18:18:54 +0200
X-Google-Sender-Auth: 54e6674203a32ab4
Message-ID: <w2gcabda6421004160918vc5dc5ee2y14a5814b4e8573b3@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] max3100: added raise_threaded_irq
From: christian pellegrin <chripell@fsfe.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, grant.likely@secretlab.ca,
       alan@lxorguk.ukuu.org.uk, spi-devel-general@lists.sourceforge.net,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 16, 2010 at 1:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> raise_threaded_irq schedules the execution of an interrupt thread
>
> I really have a hard time to understand _WHY_ we want to have that
> function.
>
.....
>
> Can you please explain, what you are trying to achieve and why it
> can't be done with the existing interfaces ?
>

The idea was that by using this function we just need one kind of
deferred work (interrupt threads) instead of two (for example
interrupt threads and workqueues) in some situations. This is very
handy with devices that do transmission and reception at the same
time, for example many SPI devices. The user case is the max3100 UART
on SPI driver. The same SPI instruction both receives and sends chars.
So when we need to send a char we just start the interrupt thread
instead of having another kind of deferred work doing the job. This
greatly simplifies locking and avoids duplication of functionality
(otherwise we must have an interrupt thread that does reception and a
workqueue that does sending and receiving for example) because
everything is done in just one point. The move from worqueues to
interrupt threads was motivated by the much smaller latency under load
of the latter because they are scheduled as RT processes. I hope this
doesn't sound like a terrible abuse of threaded interrupts. Let me
know before I try to fix other problems you mentioned.

Thanks

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
