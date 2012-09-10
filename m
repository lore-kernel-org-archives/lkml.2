Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2IJHJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:09:56 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:20240 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab2IJHJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:09:37 -0400
Message-ID: <504D922C.1030407@c-s.fr>
Date: Mon, 10 Sep 2012 09:09:32 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
References: <201208141426.q7EEQSPc003956@localhost.localdomain> <20120814155227.018988da@pyramind.ukuu.org.uk> <502CF2A0.8080109@c-s.fr> <20120816152918.5ed2649f@pyramind.ukuu.org.uk> <502D054B.3010606@c-s.fr> <20120816162136.059b64b4@bob.linux.org.uk>
In-Reply-To: <20120816162136.059b64b4@bob.linux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/08/2012 17:21, Alan Cox a écrit :
>> MAX_IDL: Maximum idle characters. When a character is received, the
>> receiver begins counting idle characters. If MAX_IDL idle characters
>> are received before the next data character, an idle timeout occurs
>> and the buffer is closed,
>> generating a maskable interrupt request to the core to receive the
>> data from the buffer. Thus, MAX_IDL offers a way to demarcate frames.
>> To disable the feature, clear MAX_IDL. The bit length of an idle
>> character is calculated as follows: 1 + data length (5–9) + 1 (if
>> parity is used)
>> + number of stop bits (1–2). For 8 data bits, no parity, and 1 stop
>> bit, the character length is 10 bits
>
> So if you have slightly bursty high speed data as its quite typical
> before your change you would get one interrupt per buffer of 32 bytes,
> with it you'll get a lot more interrupts.
>
> You have two available hints about the way to set this - one of them is
> the baud rate (low baud rates mean the fifo isn't a big win and the
> latency is high), the other is the low_latency flag if the driver
> supports the low latency feature (and arguably you can still use a
> request for it as a hint even if you refuse the actual feature).
>
> So I think a reasonable approach would be set the idle timeout down for
> low baud rates or if low_latency is requested.
>
>> generated if there is at least one word in the FIFO and for a time
>> equivalent to the transmission of four characters
> Which is a bit more reasonable than one, although problematic at low
> speed (hence the fifo on/off).
>
What would then thing about:
* a value of 1 for all rates below 2400 (On 8250, fifo is set to 1 for 
such rates)
* a value of 2 for 2400 and 4800
* a value of 4 for 9600 (which is the default on the 8250 for all rates 
above 2400)
* a value of 8 for 19200
* a value of 16 for 38400 and above (on UCC_UART, maxidl is set to 16, 
never 32)

Christophe
