Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2LFLhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 06:37:53 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:49480 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab2LFLhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 06:37:52 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 06:37:52 EST
Message-ID: <50C08233.9030905@erwinrol.com>
Date: Thu, 06 Dec 2012 12:32:03 +0100
From: Erwin Rol <mailinglists@erwinrol.com>
Organization: Erwin Rol Software Engineering
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: at91sam9260 MACB problem with IP fragmentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Dec 2012 11:31:35.0335 (UTC) FILETIME=[3F942370:01CDD3A5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas, Havard, all,

I have a very obscure problem with a at91sam9260 board (almost 1 to 1
copy of the Atmel EK).

The MACB seems to stall when I use large (>2 * MTU) UDP datagrams. The
test case is that a udp echo client (PC) sends datagrams with increasing
length to the AT91 until the max length of the UDP datagram is reached.
When there is no IP fragmentation everything is fine, but when the
datagrams are starting to get fragmented the AT91 will not reply
anymore. But as soon as some network traffic happens it goes on again,
and non of the data is lost.

With wireshark the effect can be easily seen (192.168.1.4 is the PC echo
client, and 192.168.1.133 is the at91 echo server) After the first
request there comes no reply. After a 5 second timeout the second
request is send. And then both replies are returned.

When I enabled debugging output it all started to work. So I tried some
udelays in the driver instead of printk and with a 1ms delay in the irq
handler it started working. Of course that is an unacceptable fix, but
it looks like that is some weird race condition that causes the sending
to stall. The only difference with normal MTU sized datagrams I can
think of is that the fragmented packets can be passed very quickly to
the macb tx function, because the kernel has all 5 skb's ready.

I would be very interested to hear if someone else could reproduce this
problem. Or even better, has seen this problem and has a fix for it.

I tried several kernels including the test version from Nicolas that he
posted on LKML in October. They all show the same effect.

please CC me because I am currently not on the list.

- Erwin

The wireshark dump;

> No.     Time           Source                Destination           Protocol Length Info
>       1 0.000000000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=0, ID=0654) [Reassembled in #5]
>       2 0.000123000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=1480, ID=0654) [Reassembled in #5]
>       3 0.000113000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=2960, ID=0654) [Reassembled in #5]
>       4 0.000147000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=4440, ID=0654) [Reassembled in #5]
>       5 0.000114000    192.168.1.4           192.168.1.133         ECHO     1259   Request
>       6 4.527395000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=0, ID=065d) [Reassembled in #10]
>       7 0.000174000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=1480, ID=065d) [Reassembled in #10]
>       8 0.000026000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=2960, ID=065d) [Reassembled in #10]
>       9 0.000213000    192.168.1.4           192.168.1.133         IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=4440, ID=065d) [Reassembled in #10]
>      10 0.000018000    192.168.1.4           192.168.1.133         ECHO     1260   Request
>      11 0.001115000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=0, ID=c75d) [Reassembled in #15]
>      12 0.000120000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=1480, ID=c75d) [Reassembled in #15]
>      13 0.000205000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=2960, ID=c75d) [Reassembled in #15]
>      14 0.000167000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=4440, ID=c75d) [Reassembled in #15]
>      15 0.000006000    192.168.1.133         192.168.1.4           ECHO     1259   Response
>      16 0.000396000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=0, ID=c75e) [Reassembled in #20]
>      17 0.000224000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=1480, ID=c75e) [Reassembled in #20]
>      18 0.000009000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=2960, ID=c75e) [Reassembled in #20]
>      19 0.000237000    192.168.1.133         192.168.1.4           IPv4     1514   Fragmented IP protocol (proto=UDP 17, off=4440, ID=c75e) [Reassembled in #20]
>      20 0.000009000    192.168.1.133         192.168.1.4           ECHO     1260   Response


