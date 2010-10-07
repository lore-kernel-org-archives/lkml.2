Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0JGWhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:37:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:49327 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0JGWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:37:44 -0400
Message-ID: <4CAE4BB6.7080509@windriver.com>
Date: Thu, 07 Oct 2010 17:37:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: kgdb errors with serial console
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
In-Reply-To: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2010 22:37:43.0377 (UTC) FILETIME=[41A31C10:01CB6670]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 04:47 PM, Elvis Dowson wrote:
> Hi,
>         I'm getting the following errors when attempting to use kgdb with the serial console. Any idea how I can resolve this issue? 
>
> The correct serial parameters when I use kermit with the target board is 
>
> set flow-control off
> set carrier-watch none
> set speed 115200
>
> and it connects correctly.
>
> I'm not sure if the gdb configuration commands for the serial port are sufficient, and if there is a parameter that I am missing here. The host is connected to the target using an FTDI USB to serial converter, so it appears as /dev/ttyUSB0 on the host and as ttyS2 on the target.
>
> # su
> # cd /tool/patches/android-rowboat-froyo-2.2-patchwork/kernel
> # arm-angstrom-linux-gnueabi-gdb
> (gdb) file vmlinux
> Reading symbols from /tool/patches/android-rowboat-froyo-2.2-patchwork/kernel/vmlinux...done.
>
> (gdb) set remotebaud 115200
> (gdb) set remoteflow 0
> (gdb) set debug remote 1
> (gdb) set debug serial 1
>   
You don't want to use this one, it just tends to pollute the logs, "set
debug remote 1" should be enough.

> (gdb) target remote /dev/ttyUSB0
>
>   


Looks to me like you did not activate the kernel debugger before using
gdb to enter, because the gdb you are using is not going to send the
"sysrq g" sequence.


What you would want to do here is to "echo g > /proc/sysrq-trigger" with
your terminal program, disconnect and then try connecting the debugger
to the kernel.   Another option is to use the agent-proxy so you can
have a console connection and a debugger connection.

It would probably also be good to test if the debugger is working at all
on your serial port.

Configure the debugger with:
# echo ttyS2 > /sys/module/kgdboc/parameters/kgdboc
kgdb: Registered I/O driver kgdboc.
# echo g > /proc/sysrq-trigger
SysRq : DEBUG

And now to exit debugger you must blindly and perfectly type
$D#44+

Nothing will be echoed because at this stage the kernel serial polling
driver would just be collecting characters.

After typing that the kernel should return back to the running state and
print something like:
+$OK#9a#


Jason.





> Remote debugging using /dev/ttyUSB0
> Sending packet: $qSupported#37...[
> r +]Ack
> [$][q][S][u][p][p][o][r][t][e][d][#][3][7]Packet received: qSupported
> Packet qSupported (supported-packets) is supported
> warning: unrecognized item "qSupported" in "qSupported" response
> Sending packet: $Hg0#df...[+]Ack
> [$][H][g][0][#][d][f]Packet received: Hg0
> Sending packet: $?#3f...[+]Ack
> [$][?][#][3][f]Packet received: ?
> Sending packet: $Hc-1#09...[+]Ack
> [$][H][c][-][1][#][0][9]Packet received: Hc-1
> Sending packet: $qC#b4...[+]Ack
> [$][q][C][#][b][4]Packet received: qC
> Sending packet: $qAttached#8f...[+]Ack
> [$][q][A][t][t][a][c][h][e][d][#][8][f]Packet received: qAttached
> Packet qAttached (query-attached) is supported
> Sending packet: $qOffsets#4b...[+]Ack
> [$][q][O][f][f][s][\r][\r][\n][e][t][s][#][4][b]Bad checksum, sentsum=0x4b, csum=0x6f, buf=qOffs\r\r\nets
> [-][<Timeout: 2 seconds>]Timed out.
> [-][<Timeout: 2 seconds>]Timed out.
> Ignoring packet error, continuing...
> Malformed response to offset query, qOffs
> ets
> (gdb) 
>
>
> Best regards,
>
> Elvis Dowson
>
>
>   

