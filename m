Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab0KLVnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:43:04 -0500
Received: from kroah.org ([198.145.64.141]:41597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab0KLVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Lawrence Rust <lvr@softsystem.co.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/19] 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang
Date: Fri, 12 Nov 2010 13:40:58 -0800
Message-Id: <1289598066-10112-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lawrence Rust <lvr@softsystem.co.uk>

Calling tcsetattr prevents any thread(s) currently suspended in ioctl
TIOCMIWAIT for the same device from ever resuming.

If a thread is suspended inside a call to ioctl TIOCMIWAIT, waiting for
a modem status change, then the 8250 driver enables modem status
interrupts (MSI).  The device interrupt service routine resumes the
suspended thread(s) on the next MSI.

If while the thread(s) are suspended, another thread calls tcsetattr
then the 8250 driver disables MSI (unless CTS/RTS handshaking is
enabled) thus preventing the suspended thread(s) from ever being
resumed.

This patch only disables MSI in tcsetattr handling if there are no
suspended threads.

Program to demonstrate bug & fix:

/* gcc miwait.c -o miwait -l pthread */
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <linux/serial.h>

static void* monitor( void* pv);
static int s_fd;

int main( void)
  {
  const char kszDev[] = "/dev/ttyS0";
  pthread_t t;
  struct termios tio;

  s_fd = open( kszDev, O_RDWR | O_NONBLOCK);
  if ( s_fd < 0)
    return fprintf( stderr, "Error(%d) opening %s: %s\n", errno, kszDev, strerror( errno)), 1;

  pthread_create( &t, NULL, &monitor, NULL);

  /* Modem status changes seen here */
  puts( "Main: awaiting status changes");
  sleep( 5);

  tcgetattr( s_fd, &tio);
  tio.c_cflag ^= CSTOPB;

  /* But not after here */
  puts( "Main: tcsetattr called");
  tcsetattr( s_fd, TCSANOW, &tio);

  for (;;)
    sleep( 1);
  }

static void* monitor( void* pv)
  {
  (void)pv;
  for(;;)
    {
    unsigned uModem;
    struct serial_icounter_struct cnt;

    if ( ioctl( s_fd, TIOCMGET, &uModem) < 0)
      fprintf( stderr, "Error(%d) in TIOCMGET: %s\n", errno, strerror( errno));
    printf( "Modem status:%s%s%s%s%s%s\n",
      (uModem & TIOCM_RTS) ? " RTS" : "",
      (uModem & TIOCM_DTR) ? " DTR" : "",
      (uModem & TIOCM_CTS) ? " CTS" : "",
      (uModem & TIOCM_DSR) ? " DSR" : "",
      (uModem & TIOCM_CD) ? " CD" : "",
      (uModem & TIOCM_RI) ? " RI" : ""
    );

    if ( ioctl( s_fd, TIOCGICOUNT, &cnt) < 0)
      fprintf( stderr, "Error(%d) in TIOCGICOUNT: %s\n", errno, strerror( errno));
    printf( "Irqs: CTS:%d DSR:%d RNG:%d DCD:%d Rx:%d Tx:%d Frame:%d Orun:%d Par:%d Brk:%d Oflow:%d\n",
      cnt.cts, cnt.dsr, cnt.rng, cnt.dcd,
      cnt.rx, cnt.tx, cnt.frame, cnt.overrun, cnt.parity,
      cnt.brk, cnt.buf_overrun
    );

    fputs( "Waiting...", stdout), fflush( stdout);
    if ( 0 > ioctl( s_fd, TIOCMIWAIT, (unsigned long)(TIOCM_CAR | TIOCM_RNG | TIOCM_DSR | TIOCM_CTS)))
      fprintf( stderr, "\nError(%d) in TIOCMIWAIT: %s\n", errno, strerror( errno));
    fputs( "\n", stdout);
    }
  return NULL;
  }

Signed-off by Lawrence Rust <lawrence@softsystem.co.uk>

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 4d8e14b..dd5e1ac 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2343,8 +2343,11 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/*
 	 * CTS flow control flag and modem status interrupts
+	 * Only disable MSI if no threads are waiting in
+	 * serial_core::uart_wait_modem_status
 	 */
-	up->ier &= ~UART_IER_MSI;
+	if (!waitqueue_active(&up->port.state->port.delta_msr_wait))
+		up->ier &= ~UART_IER_MSI;
 	if (!(up->bugs & UART_BUG_NOMSR) &&
 			UART_ENABLE_MS(&up->port, termios->c_cflag))
 		up->ier |= UART_IER_MSI;
-- 
1.7.1

