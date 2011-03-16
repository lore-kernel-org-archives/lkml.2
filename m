Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1CPSe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1CPSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:34:20 -0400
Message-ID: <4D8102A9.9080202@redhat.com>
Date: Wed, 16 Mar 2011 15:34:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [ANNOUNCE] usbmon capture and parser script
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to debug some issues on a driver on Linux, and using a Beagleboard card as a
hardware USB sniffer[1], I noticed the need of having a parser to work with
the sniffer data. While wireshark provides a good way of looking into the info,
most of the times, I just want to convert the data into something more concise
that allows me to work on a char terminal, and that allows to use a device-specific 
parser that translates an obscure log into device-specific register reads and writes.

[1] using the code available at: http://beagleboard-usbsniffer.blogspot.com/

So, I wrote a parser, in perl, called parse_tcpdump_log.pl. The current version
is, in fact, more than a parser, as it allows both parsing a previously captured
log, or to start a capture and parse data in real time. The script is available
at the v4l-utils tree, on:
	http://git.linuxtv.org/v4l-utils.git?a=blob;f=contrib/parse_tcpdump_log.pl;h=f90e981125462a58cadefa607cbff0ecb4b5ed45;hb=HEAD

At the output, each line is a URB data control transfer. The script groups the
request and the complete URB's into one line, so, each line of the dump
will correspond to a call to usb_control_msg().

The output is:

        000000000 ms 000000 ms (000127 us EP=80) 80 06 00 01 00 00 28 00 >>> 12 01 00 02 00 00 00 40 40 20 13 65 10 01 00 01 02 01
        000000000 ms 000000 ms (000002 us EP=80) 80 06 00 01 00 00 28 00 >>> 12 01 00 02 09 00 00 40 6b 1d 02 00 06 02 03 02 01 01
        000000006 ms 000005 ms (000239 us EP=80) c0 00 00 00 45 00 03 00 <<< 00 00 10
        000001006 ms 001000 ms (000112 us EP=80) c0 00 00 00 45 00 03 00 <<< 00 00 10
        000001106 ms 000100 ms (000150 us EP=80) c0 00 00 00 45 00 03 00 <<< 00 00 10

The provided info on each of the above lines are:

       - Time from the script start;
       - Time from the last transaction;
       - Time between URB send request and URB response;
       - Endpoint for the transfer;
       - 8 bytes with the following URB fields:
           - Type (1 byte);
           - Request (1 byte);
           - wValue (2 bytes);
           - wIndex (2 bytes);
           - wLength (2 bytes);
       - URB direction:
           >>> - To URB device
           <<< - To host
       - Optional data (length is given by wLength).

It is also possible to produce a detailed log, when used with "--debug 2", like:

PARSED data:
		RAW: ID => 0xffff880105a53f00
		RAW: Payload => 00000000000000000000000000000000000200000000000012010002090000406b1d0200060203020101
		RAW: Time => 1300309970.745112
		RAW: Status => 0
		RAW: ArrivalTime => 5584788795812741120.745112
		RAW: URBLength => 18
		RAW: TransferType => 2
		RAW: Device => 1
		RAW: Type => C
		RAW: DataLength => 18
		RAW: BusID => 1
		RAW: HasData => present
		RAW: Endpoint => 128
		RAW: PayloadSize => 42
		RAW: SetupRequest => not present

There are a few other parsers at the v4l-utils git tree that can work with the 
default output format and produce a device-specific output. For example, the 
parser_em28xx.pl will produce a code that will look close to the C clauses
inside the em28xx driver. So, for a real-time debug of the em28xx driver, for
example, it will do:

# ./parse_tcpdump_log.pl --pcap |./parse_em28xx.pl 

em28xx_read_reg(dev, EM28XX_R26_COMPR);		/* read 0x0c */
em28xx_write_reg(dev, EM28XX_R26_COMPR, 0x0c);
i2c_master_send(0xb8>>1, { 02 00 }, 0x02);
i2c_master_send(0xb8>>1, { 00 00 }, 0x02);
i2c_master_send(0xb8>>1, { 03 }, 0x01);
i2c_master_recv(0xb8>>1, &buf, 0x01); /* 6f */
em28xx_read_reg(dev, 0x05);		/* read 0x00 */
i2c_master_send(0xb8>>1, { 03 6f }, 0x02);
em28xx_write_ac97(dev, AC97_MASTER_VOL, 0x8000);
em28xx_write_ac97(dev, AC97_LINE_LEVEL_VOL, 0x8000);
em28xx_write_ac97(dev, AC97_MASTER_MONO_VOL, 0x8000);
em28xx_write_ac97(dev, AC97_LFE_MASTER_VOL, 0x8000);

I wrote a short summary on how to use it at:
	http://linuxtv.org/wiki/index.php/Bus_snooping/sniffing#Snooping_Procedures:

The script also accepts the "--man" and "--help" parameters to produce a manpage
or a help.

In summary, I hope that this script will ease USB device driver debug and development.

Feedback, fixes, etc are welcome.

Have fun,
Mauro.
