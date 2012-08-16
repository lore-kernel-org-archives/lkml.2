Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2HPPEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:04:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:26420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab2HPPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:04:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="202769230"
Date: Thu, 16 Aug 2012 16:21:36 +0100
From: Alan Cox <alan@linux.intel.com>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
Message-ID: <20120816162136.059b64b4@bob.linux.org.uk>
In-Reply-To: <502D054B.3010606@c-s.fr>
References: <201208141426.q7EEQSPc003956@localhost.localdomain>
	<20120814155227.018988da@pyramind.ukuu.org.uk>
	<502CF2A0.8080109@c-s.fr>
	<20120816152918.5ed2649f@pyramind.ukuu.org.uk>
	<502D054B.3010606@c-s.fr>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> MAX_IDL: Maximum idle characters. When a character is received, the 
> receiver begins counting idle characters. If MAX_IDL idle characters
> are received before the next data character, an idle timeout occurs
> and the buffer is closed,
> generating a maskable interrupt request to the core to receive the
> data from the buffer. Thus, MAX_IDL offers a way to demarcate frames.
> To disable the feature, clear MAX_IDL. The bit length of an idle
> character is calculated as follows: 1 + data length (5–9) + 1 (if
> parity is used) 
> + number of stop bits (1–2). For 8 data bits, no parity, and 1 stop
> bit, the character length is 10 bits


So if you have slightly bursty high speed data as its quite typical
before your change you would get one interrupt per buffer of 32 bytes,
with it you'll get a lot more interrupts.

You have two available hints about the way to set this - one of them is
the baud rate (low baud rates mean the fifo isn't a big win and the
latency is high), the other is the low_latency flag if the driver
supports the low latency feature (and arguably you can still use a
request for it as a hint even if you refuse the actual feature).

So I think a reasonable approach would be set the idle timeout down for
low baud rates or if low_latency is requested.

> generated if there is at least one word in the FIFO and for a time 
> equivalent to the transmission of four characters

Which is a bit more reasonable than one, although problematic at low
speed (hence the fifo on/off).


