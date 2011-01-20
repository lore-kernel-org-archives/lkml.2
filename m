Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1ATIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:04:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36683 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1ATIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:04:31 -0500
Message-ID: <4D37EC89.2080802@monstr.eu>
Date: Thu, 20 Jan 2011 09:04:25 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Uartlite - ulite_transmit
References: <4D2465E0.2000707@monstr.eu> <4D246672.3070002@monstr.eu>	<87vd22h3dq.fsf@macbook.be.48ers.dk> <4D257D61.2060400@monstr.eu>	<87r5cqh0bn.fsf@macbook.be.48ers.dk> <4D25871D.2000408@monstr.eu>	<87mxnegy4u.fsf@macbook.be.48ers.dk> <4D26C538.3010101@monstr.eu>	<4D26D79C.8060304@monstr.eu> <4D2D78F3.2040903@monstr.eu>	<87aaj6zays.fsf@macbook.be.48ers.dk> <4D2D8113.1020504@monstr.eu>	<8739oyza2n.fsf@macbook.be.48ers.dk> <4D32B5A2.1070508@monstr.eu>	<87r5cc5zqp.fsf@macbook.be.48ers.dk> <4D345DA3.8020105@monstr.eu> <87oc7cgbi1.fsf@macbook.be.48ers.dk>
In-Reply-To: <87oc7cgbi1.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> Hi,
> 
>  >> The problem is the uart_flush_buffer() call we see after uart_open() in
>  >> 4. If doesn't seem to come from serial_core (only called from uart_close
>  >> / uart_hangup), so presumably it comes from the TTY core or
>  >> userspace. Could you add a bit more debug to figure out where exactly it
>  >> comes from?
> 
>  Michal> Last week I have also implemented simple ioctl function for
>  Michal> uartlite - just printk to see what happen. Look at the second
>  Michal> log below.
> 
>  Michal> uart_open(0) called
>  Michal> ulite_ioctl 5401 bff76a18
>  Michal> n_tty_ioctl
>  Michal> ulite_ioctl 540b 2
>  Michal> n_tty_ioctl
>  Michal> n_tty_ioctl_helper TCFLSH
>  Michal> tty_perform_flush TCIOFLUSH
>  Michal> tty_perform_flush TCOFLUSH
>  Michal> tty_driver_flush_buffer
>  Michal> uart_flush_buffer(0) called
> 
> So your userspace is calling tcflush, and serial_core responds by
> flushing (dropping) the buffer. That seems like expected behaviour to
> me.
> 
> This is presumably from the busybox getty applet, which does:
> 
> static void termios_init(struct termios *tp, int speed, struct options *op)
> {
> 	speed_t ispeed, ospeed;
> 	/*
> 	 * Initial termios settings: 8-bit characters, raw-mode, blocking i/o.
> 	 * Special characters are set after we have read the login name; all
> 	 * reads will be done in raw mode anyway. Errors will be dealt with
> 	 * later on.
> 	 */
> 	/* flush input and output queues, important for modems! */
> 	tcflush(0, TCIOFLUSH);
> 
> You could change that to a tcdrain() if that's not what you want.
> 

Great that's work. Just for the record it is tcdrain(STDOUT_FILENO);
Patch against busybox 1.14.3 version is below. Maybe worth to added it 
mainline busybox.

Thanks for your big help.
Michal


diff --git 
a/software/petalinux-dist/user/busybox/busybox-1.14.3/loginutils/getty.c 
b/software/petalinux-dist/user/busybox/busybo
index 24a182f..4c99e92 100644
--- a/software/petalinux-dist/user/busybox/busybox-1.14.3/loginutils/getty.c
+++ b/software/petalinux-dist/user/busybox/busybox-1.14.3/loginutils/getty.c
@@ -279,6 +279,8 @@ static void termios_init(struct termios *tp, int 
speed, struct options *op)
          * later on.
          */
  #ifdef __linux__
+       /* wait until all output written to the stdout has been 
transmitted */
+       tcdrain(STDOUT_FILENO);
         /* flush input and output queues, important for modems! */
         ioctl(0, TCFLSH, TCIOFLUSH); /* tcflush(0, TCIOFLUSH)? - same */
  #endif


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
