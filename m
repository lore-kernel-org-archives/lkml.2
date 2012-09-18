Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2IRQXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:23:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60530 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2IRQW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:22:56 -0400
References: <50530682.20406@niif.hu> <A19D4FD49346ED4CB58A13A508345ABE0F3D8422@exchange.Sonatest.net> <50584B17.9050909@niif.hu>
In-Reply-To: <50584B17.9050909@niif.hu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <C2709730-3790-4455-BD60-72F53D1C40CF@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: open list <linux-kernel@vger.kernel.org>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
Subject: Re: DS2408 kernel module usage
Date: Tue, 18 Sep 2012 12:22:52 -0400
To: =?iso-8859-1?Q?Szigeti_G=E1bor?= <szigeti@niif.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, I am including the linux-kernel list for this reply as my answers are
public domain interest.

Gabor, you should do the same when you ask questions so that everyone through
list archives have access to this info.

On 2012-09-18, at 6:21 AM, Szigeti Gábor wrote:

> Hi,
> 
> 2012-09-14 17:47 keltezéssel, Jean-Francois Dagenais írta:
>> On 2012-09-14, at 6:27 AM, Szigeti Gábor wrote:
>> 
>>> Hi Jean-François Dagenais,
>>> 
>>> Can you give me some introduction about the DS2408 kernel module usage?
>>> How can read or write information from the device?
>>> 
>>> Thanks in advance,
>>> Gabor Szigeti
>>> No malware was found: ProSecure Web and Email Threat Manager has scanned this mail and its attachment(s).
>>> 
>> Hi,
>> 
>> Read the DS2408 datasheet (google it). The driver basically exposes byte-size
>> sysfs attribute files which represent the registers of the chip.
> 
> First of all thanks your quick feedback about my question.
> I read the device's datasheet before I sent my previous email and try to use the kernel modul but it was not clear for me.
> 
> My hardware installation is similar for the Figure 19. in the datasheet. I changed the microcontroller to one Raspberrypi and I have only one ds2408 switch. I use resistor for the 1-wire bus and the VCC (3.3V) is coming from the Raspberrypi.
> 
> I see the following files after I load the kernel modul:
> 
>        pi@raspberrypi /sys/bus/w1/devices/29-0000000fde25 $ ls -l
>        total 0
>        -r--r--r-- 1 root root    1 Sep  7 08:11 activity
>        -r--r--r-- 1 root root    1 Sep  7 08:11 cond_search_mask
>        -r--r--r-- 1 root root    1 Sep  7 08:11 cond_search_polarity
>        lrwxrwxrwx 1 root root    0 Sep  7 08:11 driver -> ../../../bus/w1/drivers/w1_slave_driver
>        -r--r--r-- 1 root root 4096 Sep  7 08:11 id
>        -r--r--r-- 1 root root 4096 Sep  7 08:11 name
>        -rw-rw-r-- 1 root root    1 Sep  7 08:18 output
>        drwxr-xr-x 2 root root    0 Sep  7 08:11 power
>        -r--r--r-- 1 root root    1 Sep  7 08:11 state
>        -rw-rw-r-- 1 root root    1 Sep  7 08:11 status_control
>        lrwxrwxrwx 1 root root    0 Sep  7 08:11 subsystem -> ../../../bus/w1
>        -rw-r--r-- 1 root root 4096 Sep  7 08:11 uevent
> 
> I can read the output only with the less command and it contains always <FF> bytes.
> With cat command I got Bad address failure and the hexdump got a little bit more results:
> 
>    pi@raspberrypi /sys/bus/w1/devices/29-0000000fde25 $ hexdump output
>    hexdump: output: Bad address
>    0000000 00ff
>    0000001

Yeah this was my first kernel driver. I didn't know at the time that certain
consistency rules apply to sysfs attributes, which are completely violated here.

So the ds2408 is actually working with the RAW byte of each of the registers as
a sysfs attribute files (which is the no-no for a sysfs file) instead of ascii
representations. This means you need to make each read and write exactly 1 byte,
otherwise you get EACCES (Bad address). So to read the content, try "dd
if=./output bs=1 count=1 | hexdump" instead. To write from the command line, try
"echo \x01 |dd of=./output bs=1 count=1". This will ensure that the buffer
passed to and from the driver has a count request of 1 (byte).

I invite you to fix the driver if you want, and install an ABI description in
the Documentation dir. (something I obviously should had done.)

> 
> 
> The writing is more difficult for me. I get always Permission denied failure for every writable files.
> see:
> 
>    pi@raspberrypi /sys/bus/w1/devices/29-0000000fde25 $ echo \x00\x01 > output
>    -bash: output: Permission denied
>    pi@raspberrypi /sys/bus/w1/devices/29-0000000fde25 $ sudo echo \x00\x01 > output
>    -bash: output: Permission denied
>    pi@raspberrypi /sys/bus/w1/devices/29-0000000fde25 $ sudo echo \x00 > status_control
>    -bash: status_control: Permission denied
> 
Sorry for the inconvenience, I am getting better at this now, and as a (maybe
unfortunate) consequence, holding a little longer before I submit patches until
they are presentable.
/jfd