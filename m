Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0KMOtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:49:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:32973 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0KMOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:49:21 -0500
Date: Sat, 13 Nov 2010 06:49:54 -0800
From: Greg KH <gregkh@suse.de>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lawrence Rust <lvr@softsystem.co.uk>
Subject: Re: [PATCH 11/19] 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT)
	hang
Message-ID: <20101113144954.GA29977@suse.de>
References: <20101112213215.GB9294@kroah.com> <1289598066-10112-11-git-send-email-gregkh@suse.de> <AANLkTi=OrD-icAD7Nv5oDrVBekEFMGRSoApWytWgnDbT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=OrD-icAD7Nv5oDrVBekEFMGRSoApWytWgnDbT@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 07:18:30AM +0300, Alexey Zaytsev wrote:
> Hi.
> 
> This one kills the serial console for me. Luckily, in qemu:
> 
> (gdb) bt
> #0  __const_udelay (xloops=4295000) at arch/x86/lib/delay.c:117
> #1  0xc137ab7c in panic (fmt=0xc147f8e1 "Attempted to kill the idle task!")
>     at kernel/panic.c:151
> #2  0xc1020731 in do_exit (code=9) at kernel/exit.c:915
> #3  0xc100476a in oops_end (flags=70, regs=<value optimized out>, signr=9)
>     at arch/x86/kernel/dumpstack.c:265
> #4  0xc1014317 in no_context (regs=0xc14ebe68, error_code=<value
> optimized out>,
>     address=192) at arch/x86/mm/fault.c:673
> #5  0xc1014411 in __bad_area_nosemaphore (regs=0xc14ebe68,
>     error_code=<value optimized out>, address=192, si_code=196609)
>     at arch/x86/mm/fault.c:739
> #6  0xc1014426 in bad_area_nosemaphore (regs=0x418958, error_code=81,
>     address=3238124885) at arch/x86/mm/fault.c:746
> #7  0xc101475a in do_page_fault (regs=0xc14ebe68, error_code=0)
>     at arch/x86/mm/fault.c:1070
> #8  0xc137ced9 in ?? () at arch/x86/kernel/entry_32.S:1265
> #9  0xc11db236 in list_empty (head=0xc0) at include/linux/list.h:182
> #10 0xc11db374 in waitqueue_active (q=0x98) at include/linux/wait.h:115
> #11 0xc11dea4e in serial8250_do_set_termios (port=0xc1c31320,
> termios=0xc14ebf2c,
>     old=0xc1c31240) at drivers/serial/8250.c:2349
> #12 0xc11decb6 in serial8250_set_termios (port=0xc1c31320, termios=0xc14ebf2c,
>     old=0xc1c31240) at drivers/serial/8250.c:2424
> #13 0xc11da10b in uart_set_options (port=0xc1c31320, co=0xc164f0a0, baud=9600,
>     parity=110, bits=8, flow=110) at drivers/serial/serial_core.c:1935
> #14 0xc1684d30 in serial8250_console_setup (co=0xc164f0a0, options=0x0)
>     at drivers/serial/8250.c:2864
> #15 0xc101e46f in register_console (newcon=0xc164f0a0) at kernel/printk.c:1300
> #16 0xc1684d5e in serial8250_console_init () at drivers/serial/8250.c:2889
> #17 0xc1683da0 in console_init () at drivers/tty/tty_io.c:3208
> #18 0xc166b7ba in start_kernel () at init/main.c:635
> #19 0xc166b0b7 in i386_start_kernel () at arch/x86/kernel/head32.c:75
> #20 0x00000000 in ?? ()
> (gdb) p up->port.state
> $13 = (struct uart_state *) 0x0
> 

Ick.

Lawrence, any ideas?  If not, I'm going to have to revert this patch
from the tree.

thanks,

greg k-h


> 
> 
> On Sat, Nov 13, 2010 at 00:40, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > From: Lawrence Rust <lvr@softsystem.co.uk>
> >
> > Calling tcsetattr prevents any thread(s) currently suspended in ioctl
> > TIOCMIWAIT for the same device from ever resuming.
> >
> > If a thread is suspended inside a call to ioctl TIOCMIWAIT, waiting for
> > a modem status change, then the 8250 driver enables modem status
> > interrupts (MSI). ??The device interrupt service routine resumes the
> > suspended thread(s) on the next MSI.
> >
> > If while the thread(s) are suspended, another thread calls tcsetattr
> > then the 8250 driver disables MSI (unless CTS/RTS handshaking is
> > enabled) thus preventing the suspended thread(s) from ever being
> > resumed.
> >
> > This patch only disables MSI in tcsetattr handling if there are no
> > suspended threads.
> >
> > Program to demonstrate bug & fix:
> >
> > /* gcc miwait.c -o miwait -l pthread */
> > #include <stdio.h>
> > #include <errno.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <pthread.h>
> > #include <termios.h>
> > #include <sys/ioctl.h>
> > #include <linux/serial.h>
> >
> > static void* monitor( void* pv);
> > static int s_fd;
> >
> > int main( void)
> > ??{
> > ??const char kszDev[] = "/dev/ttyS0";
> > ??pthread_t t;
> > ??struct termios tio;
> >
> > ??s_fd = open( kszDev, O_RDWR | O_NONBLOCK);
> > ??if ( s_fd < 0)
> > ?? ??return fprintf( stderr, "Error(%d) opening %s: %s\n", errno, kszDev, strerror( errno)), 1;
> >
> > ??pthread_create( &t, NULL, &monitor, NULL);
> >
> > ??/* Modem status changes seen here */
> > ??puts( "Main: awaiting status changes");
> > ??sleep( 5);
> >
> > ??tcgetattr( s_fd, &tio);
> > ??tio.c_cflag ^= CSTOPB;
> >
> > ??/* But not after here */
> > ??puts( "Main: tcsetattr called");
> > ??tcsetattr( s_fd, TCSANOW, &tio);
> >
> > ??for (;;)
> > ?? ??sleep( 1);
> > ??}
> >
> > static void* monitor( void* pv)
> > ??{
> > ??(void)pv;
> > ??for(;;)
> > ?? ??{
> > ?? ??unsigned uModem;
> > ?? ??struct serial_icounter_struct cnt;
> >
> > ?? ??if ( ioctl( s_fd, TIOCMGET, &uModem) < 0)
> > ?? ?? ??fprintf( stderr, "Error(%d) in TIOCMGET: %s\n", errno, strerror( errno));
> > ?? ??printf( "Modem status:%s%s%s%s%s%s\n",
> > ?? ?? ??(uModem & TIOCM_RTS) ? " RTS" : "",
> > ?? ?? ??(uModem & TIOCM_DTR) ? " DTR" : "",
> > ?? ?? ??(uModem & TIOCM_CTS) ? " CTS" : "",
> > ?? ?? ??(uModem & TIOCM_DSR) ? " DSR" : "",
> > ?? ?? ??(uModem & TIOCM_CD) ? " CD" : "",
> > ?? ?? ??(uModem & TIOCM_RI) ? " RI" : ""
> > ?? ??);
> >
> > ?? ??if ( ioctl( s_fd, TIOCGICOUNT, &cnt) < 0)
> > ?? ?? ??fprintf( stderr, "Error(%d) in TIOCGICOUNT: %s\n", errno, strerror( errno));
> > ?? ??printf( "Irqs: CTS:%d DSR:%d RNG:%d DCD:%d Rx:%d Tx:%d Frame:%d Orun:%d Par:%d Brk:%d Oflow:%d\n",
> > ?? ?? ??cnt.cts, cnt.dsr, cnt.rng, cnt.dcd,
> > ?? ?? ??cnt.rx, cnt.tx, cnt.frame, cnt.overrun, cnt.parity,
> > ?? ?? ??cnt.brk, cnt.buf_overrun
> > ?? ??);
> >
> > ?? ??fputs( "Waiting...", stdout), fflush( stdout);
> > ?? ??if ( 0 > ioctl( s_fd, TIOCMIWAIT, (unsigned long)(TIOCM_CAR | TIOCM_RNG | TIOCM_DSR | TIOCM_CTS)))
> > ?? ?? ??fprintf( stderr, "\nError(%d) in TIOCMIWAIT: %s\n", errno, strerror( errno));
> > ?? ??fputs( "\n", stdout);
> > ?? ??}
> > ??return NULL;
> > ??}
> >
> > Signed-off by Lawrence Rust <lawrence@softsystem.co.uk>
> >
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> > ??drivers/serial/8250.c | ?? ??5 ++++-
> > ??1 files changed, 4 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> > index 4d8e14b..dd5e1ac 100644
> > --- a/drivers/serial/8250.c
> > +++ b/drivers/serial/8250.c
> > @@ -2343,8 +2343,11 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
> >
> > ?? ?? ?? ??/*
> > ?? ?? ?? ?? * CTS flow control flag and modem status interrupts
> > + ?? ?? ?? ??* Only disable MSI if no threads are waiting in
> > + ?? ?? ?? ??* serial_core::uart_wait_modem_status
> > ?? ?? ?? ?? */
> > - ?? ?? ?? up->ier &= ~UART_IER_MSI;
> > + ?? ?? ?? if (!waitqueue_active(&up->port.state->port.delta_msr_wait))
> > + ?? ?? ?? ?? ?? ?? ?? up->ier &= ~UART_IER_MSI;
> > ?? ?? ?? ??if (!(up->bugs & UART_BUG_NOMSR) &&
> > ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??UART_ENABLE_MS(&up->port, termios->c_cflag))
> > ?? ?? ?? ?? ?? ?? ?? ??up->ier |= UART_IER_MSI;
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ??http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at ??http://www.tux.org/lkml/
> >
