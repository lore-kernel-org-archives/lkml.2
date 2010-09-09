Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0IIMyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:54:02 -0400
Received: from h165.iphase.com ([157.175.3.165]:33124 "EHLO
	exmail.interphase.iphase.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751451Ab0IIMyA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:54:00 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 08:54:00 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: PROBLEM: tty_buffer_request_room() vs. ppp_sync_input(): a single  buffer may contains several frames
Date: Thu, 9 Sep 2010 07:41:54 -0500
Message-ID: <0D81855AB9880044B3FD8FE8A7B520595B040D@EXMAIL.interphase.iphase.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM: tty_buffer_request_room() vs. ppp_sync_input(): a single  buffer may contains several frames
Thread-Index: ActQHGJXS4DF7IFbSB2gEYCJESvy1Q==
From: "Stephane Grosjean" <grosjean@iphase.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you to forward that mail to the team which maintains the
drivers/char tty interface.
This problem seems to be present in all versions of the Kernel, I
personnally use 2.6.21 but saw the same code in some newer versions...
 
I'm using ppp_sync line discipline with an internal char driver which
intends to interface between the kernel tty interface and our hardware.
In my isr, I use "tty_insert_flip_string()" when I just received a frame
from my hardware then, I call "tty_schedule_flip()" to ask that frame to
be pass to the ppp_sync ldisc receive callback.
 
My problem is that the "tty_buffer_request_room()" function may use the
same buffer (the tail) if it finds enough place to store the incoming
frame in.
But when such a case does occur, the buffer contains 2 (or more) frames
and nothing to separate them...
This is a problem when "ppp_sync_input()" is then called as it considers
a buffer as a SINGLE frame container (as it is written in the function
header:

/* called when the tty driver has data for us.
 *
 * Data is frame oriented: each call to ppp_sync_input is considered
 * a whole frame. If the 1st flag byte is non-zero then the whole
 * frame is considered to be in error and is tossed.
 */
static void
ppp_sync_input(struct syncppp *ap, const unsigned char *buf,
      char *flags, int count)


Running "pppd" with the "debug" option shows that it doesn't understand
some incoming frames and starts retransmission cycles (see below).
 
Since the "commit" field of a buffer object is set to the value of
"used" field when that buffer is pushed, one fix I found is to change
the condition used to search for a valid buffer in
"tty_buffer_request_room()":
 
   /* OPTIMISATION: We could keep a per tty "zero" sized buffer to
      remove this conditional if its worth it. This would be invisible
      to the callers */
   if ((b = tty->buf.tail) != NULL)
      left = b->size - b->used;
   else
      left = 0;
 
  -if (left < size) {
  +if (left < size || (b->commit >= b->used)) {
      /* This is the slow path - looking for new buffers to use */
      if ((n = tty_buffer_find(tty, size)) != NULL) {

Please let me know if I'm right and if this fix is the only way to pass
synchronous frames to upper layers.
 
Local "pppd" debug ouput shows at least 2 received buffers which contain
2 PPP frames each (see ->):

pppd /dev/ttyDCC0 sync nolock 10.10.10.1:10.10.10.2 -detach debug
      Thu Jan  1 03:54:13 UTC 1970
      using channel 11
      Using interface ppp0
      Connect: ppp0 <--> /dev/ttyDCC0
      sent [LCP ConfReq id=0x1 <asyncmap 0x0> <magic 0xd7da1d35> <pcomp>
<accomp>]
      rcvd [LCP ConfAck id=0x1 <asyncmap 0x0> <magic 0xd7da1d35> <pcomp>
<accomp>]
      rcvd [LCP ConfReq id=0x4b <asyncmap 0x0> <magic 0x767ed47a>
<pcomp> <accomp>]
      sent [LCP ConfAck id=0x4b <asyncmap 0x0> <magic 0x767ed47a>
<pcomp> <accomp>]
      sent [CCP ConfReq id=0x1 <deflate 15> <deflate(old#) 15> <bsd v1
15>]
      sent [IPCP ConfReq id=0x1 <compress VJ 0f 01> <addr 10.10.10.1>]
   -> rcvd [LCP EchoReq id=0x0 magic=0x767ed47a] 80 21 01 73 00 10 02 06
00 2d 0f 01 03 06 0a 0a 0a 02 80 fd 01 4b 00 04 80 fd 04 01 00 08 1a 04
...
      sent [LCP EchoRep id=0x0 magic=0xd7da1d35]
      rcvd [IPCP ConfAck id=0x1 <compress VJ 0f 01> <addr 10.10.10.1>]
   -> rcvd [IPCP ConfReq id=0x73 <compress VJ 0f 01> <addr 10.10.10.2>]
80 fd 01 4b 00 04
      sent [IPCP ConfAck id=0x73 <compress VJ 0f 01> <addr 10.10.10.2>]
      local  IP address 10.10.10.1
 
Thanks
