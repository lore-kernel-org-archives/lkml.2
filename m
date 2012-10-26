Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966670Ab2JZWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:08:19 -0400
Received: from mail2.ruggedcom.com ([204.50.148.11]:34813 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab2JZWIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:08:12 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2012 18:08:12 EDT
Message-ID: <508B0743.9040806@ruggedcom.com>
Date: Fri, 26 Oct 2012 17:57:23 -0400
From: Richard Retanubun <richardretanubun@ruggedcom.com>
Organization: Ruggedcom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <catalin.marinas@arm.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>, <m.grzeschik@pengutronix.de>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        <bigeasy@linutronix.de>
Subject: kmemleak report on isp1763 and sierra MC8705
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I am debugging a reported kmemleak involving a sierra wireless MC8705 connected
through isp1763 on powerpc linux-3.0.22

We are still isolating the exact trigger, but this is a pretty good one so far

send "at!reset" to the modem control tty, wait until it finishes rebooting
then try to bring up a PPP link that will fail (non existent ISP).

After some time, we got the report (included at the end) from kmemleak.

There seems to be two variants of trace that is prevalent:

something like this:

unreferenced object 0xd58e58c8 (size 8):
   comm "khubd", pid 1034, jiffies 74467293 (age 2380.122s)
   hex dump (first 8 bytes):
     4d 43 38 37 30 35 00 00                          MC8705..
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30e77bc>] usb_enumerate_device+0x44/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68

and something like this:

unreferenced object 0xd5893e00 (size 512):
   comm "khubd", pid 1034, jiffies 74467270 (age 2378.786s)
   hex dump (first 32 bytes):
     09 02 a8 00 06 01 01 e0 00 00 00 00 d5 87 d6 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<e30f1740>] usb_get_configuration+0x5c/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68

Some questions:
1. Have you guys seen anything like this before?

2. The report does not point to sierra or isp1763, so our current understanding
    is that the memory is allocated outside these drivers and it is supposed
    to mark it done for someone to free it. We think this way because if
    we rigged a driver to leak a memory it allocates, kmemleak will trace
    right into it. Is this understanding correct?

3. Any ideas on how to deepen the probe to get more understanding of what happens?

4. Michael, is this similar to the problem you reported here?
    http://marc.info/?l=linux-usb&m=133432571801643&w=4
    From reading your report (serial device hanging), It doesn't look like it...

5. Our current hypothesis is this:
    we open the /dev/ttyUSB to send "at!reset", then a race begins
    between closing the file handle and freeing the driver resources
    and the modem hardware actually resetting, which then caused the leak.
    Can this be it? and if so, any ideas on how to solve it?

    To test this we are power cycling the modem using a gpio
    (without opening /dev/ttyUSB) to see if this is the culprit.

6. There is a worrisome line in our (old version) of isp1763 inherited from isp1760:

    isp1760_endpoint_disable()
    ...
	qh_destroy(qh);
	ep->hcpriv = NULL;
	/* remove requests and leak them.
	 * ATL are pretty fast done, INT could take a while...
	 * The latter shoule be removed
	 */
     What is leaking here? qh_destroy release the memory already.


Thanks for everyone's time!

-- Richard Retanubun

--------------------------------------------------------------------------------
unreferenced object 0xd5922c00 (size 1024):
   comm "khubd", pid 1034, jiffies 74467113 (age 2378.943s)
   hex dump (first 32 bytes):
     ff ff ff ff 31 2e 32 00 00 00 00 00 00 00 00 00  ....1.2.........
     00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 03  ................
   backtrace:
     [<e30e4718>] usb_alloc_dev+0x48/0x290 [usbcore]
     [<e30e91ec>] hub_thread+0x654/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58e52b0 (size 8):
   comm "khubd", pid 1034, jiffies 74467113 (age 2378.943s)
   hex dump (first 8 bytes):
     32 2d 31 2e 32 00 04 00                          2-1.2...
   backtrace:
     [<c018a9ec>] kvasprintf+0x58/0x88
     [<c0180910>] kobject_set_name_vargs+0x34/0x84
     [<c01b3d20>] dev_set_name+0x50/0x60
     [<e30e4860>] usb_alloc_dev+0x190/0x290 [usbcore]
     [<e30e91ec>] hub_thread+0x654/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5893e00 (size 512):
   comm "khubd", pid 1034, jiffies 74467270 (age 2378.786s)
   hex dump (first 32 bytes):
     09 02 a8 00 06 01 01 e0 00 00 00 00 d5 87 d6 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<e30f1740>] usb_get_configuration+0x5c/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58e5930 (size 8):
   comm "khubd", pid 1034, jiffies 74467270 (age 2378.786s)
   hex dump (first 8 bytes):
     d5 8a dc c0 00 00 00 00                          ........
   backtrace:
     [<e30f1760>] usb_get_configuration+0x7c/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58adcc0 (size 192):
   comm "khubd", pid 1034, jiffies 74467271 (age 2378.786s)
   hex dump (first 32 bytes):
     09 02 a8 00 06 01 01 e0 00 09 04 00 00 02 ff ff  ................
     ff 00 07 05 81 02 00 02 20 07 05 01 02 00 02 20  ........ ......
   backtrace:
     [<e30f1804>] usb_get_configuration+0x120/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd59555c0 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.766s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 00 00 02 ff ff ff  ................
     00 00 00 00 d5 92 7a e0 00 00 00 00 d5 8a dc d2  ......z.........
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5955400 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.766s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 01 00 02 ff ff ff  ................
     00 00 00 00 d5 92 7a 20 00 00 00 00 d5 8a dc e9  ......z ........
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5955280 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 02 00 02 ff ff ff  ................
     00 00 00 00 d5 92 70 00 00 00 00 00 d5 8a dd 00  ......p.........
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd59554c0 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 03 00 03 ff ff ff  ................
     00 00 00 00 d5 8a d5 40 00 00 00 00 d5 8a dd 17  .......@........
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5955580 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 04 00 03 ff ff ff  ................
     00 00 00 00 d5 8a d2 40 00 00 00 00 d5 8a dd 35  .......@.......5
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5955300 (size 64):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     00 00 00 01 00 00 00 01 09 04 07 00 03 ff ff ff  ................
     00 00 00 00 d5 8a d3 00 00 00 00 00 d5 8a dd 53  ...............S
   backtrace:
     [<e30f1cb0>] usb_get_configuration+0x5cc/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5927ae0 (size 96):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     07 05 81 02 00 02 20 00 00 00 00 00 00 00 00 00  ...... .........
     d5 92 7a f0 d5 92 7a f0 00 00 00 00 00 00 00 00  ..z...z.........
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5927a20 (size 96):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.779s)
   hex dump (first 32 bytes):
     07 05 82 02 00 02 20 00 00 00 00 00 00 00 00 00  ...... .........
     d5 92 7a 30 d5 92 7a 30 00 00 00 00 00 00 00 00  ..z0..z0........
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5927000 (size 96):
   comm "khubd", pid 1034, jiffies 74467291 (age 2378.780s)
   hex dump (first 32 bytes):
     07 05 83 02 00 02 20 00 00 00 00 00 00 00 00 00  ...... .........
     d5 92 70 10 d5 92 70 10 00 00 00 00 00 00 00 00  ..p...p.........
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58ad540 (size 192):
   comm "khubd", pid 1034, jiffies 74467291 (age 2380.124s)
   hex dump (first 32 bytes):
     07 05 84 03 40 00 05 00 00 00 00 00 00 00 00 00  ....@...........
     d5 8a d5 50 d5 8a d5 50 00 00 00 00 00 00 00 00  ...P...P........
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58ad240 (size 192):
   comm "khubd", pid 1034, jiffies 74467291 (age 2380.124s)
   hex dump (first 32 bytes):
     07 05 86 03 40 00 05 00 00 00 00 00 00 00 00 00  ....@...........
     d5 8a d2 50 d5 8a d2 50 00 00 00 00 00 00 00 00  ...P...P........
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58ad300 (size 192):
   comm "khubd", pid 1034, jiffies 74467291 (age 2380.124s)
   hex dump (first 32 bytes):
     07 05 88 03 40 00 05 00 00 00 00 00 00 00 00 00  ....@...........
     d5 8a d3 10 d5 8a d3 10 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<e30f2514>] usb_get_configuration+0xe30/0x13a8 [usbcore]
     [<e30e7850>] usb_enumerate_device+0xd8/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd58e58c8 (size 8):
   comm "khubd", pid 1034, jiffies 74467293 (age 2380.122s)
   hex dump (first 8 bytes):
     4d 43 38 37 30 35 00 00                          MC8705..
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30e77bc>] usb_enumerate_device+0x44/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd587d3c0 (size 32):
   comm "khubd", pid 1034, jiffies 74467293 (age 2380.122s)
   hex dump (first 32 bytes):
     53 69 65 72 72 61 20 57 69 72 65 6c 65 73 73 2c  Sierra Wireless,
     20 49 6e 63 6f 72 70 6f 72 61 74 65 64 00 64 00   Incorporated.d.
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30e77cc>] usb_enumerate_device+0x54/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd670a1a0 (size 16):
   comm "khubd", pid 1034, jiffies 74467294 (age 2380.122s)
   hex dump (first 16 bytes):
     33 35 33 35 36 37 30 34 30 31 31 31 37 39 32 00  353567040111792.
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30e77dc>] usb_enumerate_device+0x64/0xf8 [usbcore]
     [<e30e7aa0>] usb_new_device+0x3c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd5927480 (size 96):
   comm "khubd", pid 1034, jiffies 74467294 (age 2380.122s)
   hex dump (first 32 bytes):
     d5 92 74 80 d5 92 74 80 c0 1b 35 4c c0 1b 36 a8  ..t...t...5L..6.
     00 00 00 00 00 10 01 00 00 20 02 00 00 00 00 00  ......... ......
   backtrace:
     [<c01b46c4>] device_private_init+0x34/0x8c
     [<c01b4f28>] device_add+0x27c/0x6a8
     [<e30e7b00>] usb_new_device+0x9c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
unreferenced object 0xd587d600 (size 32):
   comm "khubd", pid 1034, jiffies 74467300 (age 2380.792s)
   hex dump (first 32 bytes):
     53 69 65 72 72 61 20 43 6f 6e 66 69 67 75 72 61  Sierra Configura
     74 69 6f 6e 00 2f 52 00 df 82 09 60 df 40 64 00  tion./R....`.@d.
   backtrace:
     [<e30efd74>] usb_cache_string+0x74/0xac [usbcore]
     [<e30f0264>] usb_set_configuration+0x4b8/0x60c [usbcore]
     [<e30f8850>] generic_probe+0x48/0xb8 [usbcore]
     [<e30f0b00>] usb_probe_device+0x38/0x70 [usbcore]
     [<c01b79e8>] driver_probe_device+0xc0/0x2a8
     [<c01b6be4>] bus_for_each_drv+0x70/0xac
     [<c01b7df4>] device_attach+0xb4/0xd8
     [<c01b6340>] bus_probe_device+0x2c/0x44
     [<c01b51b8>] device_add+0x50c/0x6a8
     [<e30e7b00>] usb_new_device+0x9c/0x13c [usbcore]
     [<e30e9824>] hub_thread+0xc8c/0x1544 [usbcore]
     [<c0043aa8>] kthread+0x7c/0x80
     [<c000ed48>] kernel_thread+0x4c/0x68
