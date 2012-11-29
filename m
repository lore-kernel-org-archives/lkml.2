Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2K2FGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:06:39 -0500
Received: from intranet.asianux.com ([58.214.24.6]:39487 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2K2FGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:06:37 -0500
X-Spam-Score: -100.8
Message-ID: <50B6ED90.6060100@asianux.com>
Date: Thu, 29 Nov 2012 13:07:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] drivers/tty: drivers/char/:  for MAX_ASYNC_BUFFER_SIZE
References: <50B6E751.9000000@asianux.com>
In-Reply-To: <50B6E751.9000000@asianux.com>
X-Forwarded-Message-Id: <50B6E751.9000000@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg Kroah-Hartman:

for MAX_ASYNC_BUFFER_SIZE:
  it is defined as 4096;
  but for the max buffer size which it processes, is 65535.
  so suggest to #define MAX_ASYNC_BUFFER_SIZE 0x10000  (better than 0xffff)

  I use 3 Step to prove it, please see below:

by the way:
  I find it only through code review, not test it.
  so I send it as suggestions (not a patch).
  next time:
    for the same case, if it is better to send a patch, directly.
    please tell me by replying for this mail.
    (at least, it can save your time, since you are busy)

gchen.

---------------------------------------------------------------------------------
Step 1:

the MAX_ASYNC_BUFFER_SIZE is 4096:

root@gchen-desktop:~/linux# grep -rn MAX_ASYNC_BUFFER_SIZE *
drivers/char/pcmcia/synclink_cs.c:213:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
drivers/tty/synclink_gt.c:320:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
drivers/tty/synclink_gt.c:321:	char char_buf[MAX_ASYNC_BUFFER_SIZE];
drivers/tty/synclink.c:294:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
drivers/tty/synclink.c:295:	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
drivers/tty/synclinkmp.c:265:	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
drivers/tty/synclinkmp.c:266:	char char_buf[MAX_ASYNC_BUFFER_SIZE];
include/uapi/linux/synclink.h:54:#define MAX_ASYNC_BUFFER_SIZE	4096

---------------------------------------------------------------------------------
Step 2:

one sample in drivers/char/pcmcia/synclink_cs.c: (same for another files)

  we check the framesize according to info->max_frame_size in line 3687..3689.
    and call ldisc_receive_buf without checking whether it is larger than MAX_ASYNC_BUFFER_SIZE at line 3705
  info->max_frame_size can be the value between 4096 and 65535 in line 2729..2732.
  ldisc_receive_buf call ld->ops->receive_buf to perform the work.


 496 static void ldisc_receive_buf(struct tty_struct *tty,
 497                               const __u8 *data, char *flags, int count)
 498 {
 499         struct tty_ldisc *ld;
 500         if (!tty)
 501                 return;
 502         ld = tty_ldisc_ref(tty);
 503         if (ld) {
 504                 if (ld->ops->receive_buf)
 505                         ld->ops->receive_buf(tty, data, flags, count);
 506                 tty_ldisc_deref(ld);
 507         }
 508 }
 ...

2728 
2729         if (info->max_frame_size < 4096)
2730                 info->max_frame_size = 4096;
2731         else if (info->max_frame_size > 65535)
2732                 info->max_frame_size = 65535;
2733 
...

3686         if (framesize) {
3687                 if ((info->params.crc_type & HDLC_CRC_RETURN_EX &&
3688                       framesize+1 > info->max_frame_size) ||
3689                     framesize > info->max_frame_size)
3690                         info->icount.rxlong++;
3691                 else {
3692                         if (status & BIT5)
3693                                 info->icount.rxok++;
3694 
3695                         if (info->params.crc_type & HDLC_CRC_RETURN_EX) {
3696                                 *(buf->data + framesize) = status & BIT5 ? RX_OK:RX_CRC_ERROR;
3697                                 ++framesize;
3698                         }
3699 
3700 #if SYNCLINK_GENERIC_HDLC
3701                         if (info->netcount)
3702                                 hdlcdev_rx(info, buf->data, framesize);
3703                         else
3704 #endif
3705                                 ldisc_receive_buf(tty, buf->data, info->flag_buf, framesize);
3706                 }
3707         }

---------------------------------------------------------------------------------
Step 3:

one sample in drivers/tty/n_gsm.c  (same for another implementation)

  receive_buf is a function ptr which may be gsmld_receive_buf at line 2819. 
  it does not check the length of count whether larger than MAX_ASYNC_BUFFER_SIZE.
  if count is larger than MAX_ASYNC_BUFFER_SIZE, will cause issue.

  it is only a sample, maybe not the function ptr which mentioned in Step 2.
  at lease, I have checked 3 function ptr implementations, none of them check the MAX_ASYNC_BUFFER_SIZE.
  the all function ptr searching is at the bottom.

2257 static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
2258                               char *fp, int count)
2259 {
2260         struct gsm_mux *gsm = tty->disc_data;
2261         const unsigned char *dp;
2262         char *f;
2263         int i;
2264         char buf[64];
2265         char flags;
2266 
2267         if (debug & 4)
2268                 print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
2269                                      cp, count);
2270 
2271         for (i = count, dp = cp, f = fp; i; i--, dp++) {
2272                 flags = *f++;
2273                 switch (flags) {
2274                 case TTY_NORMAL:
2275                         gsm->receive(gsm, *dp);
2276                         break;
2277                 case TTY_OVERRUN:
2278                 case TTY_BREAK:
2279                 case TTY_PARITY:
2280                 case TTY_FRAME:
2281                         gsm->error(gsm, *dp, flags);
2282                         break;
2283                 default:
2284                         WARN_ONCE(1, "%s: unknown flag %d\n",
2285                                tty_name(tty, buf), flags);
2286                         break;
2287                 }
2288         }
2289         /* FASYNC if needed ? */
2290         /* If clogged call tty_throttle(tty); */
2291 }
2292 
...

2806 /* Line discipline for real tty */
2807 struct tty_ldisc_ops tty_ldisc_packet = {
2808         .owner           = THIS_MODULE,
2809         .magic           = TTY_LDISC_MAGIC,
2810         .name            = "n_gsm",
2811         .open            = gsmld_open,
2812         .close           = gsmld_close,
2813         .flush_buffer    = gsmld_flush_buffer,
2814         .chars_in_buffer = gsmld_chars_in_buffer,
2815         .read            = gsmld_read,
2816         .write           = gsmld_write,
2817         .ioctl           = gsmld_ioctl,
2818         .poll            = gsmld_poll,
2819         .receive_buf     = gsmld_receive_buf,
2820         .write_wakeup    = gsmld_write_wakeup
2821 };
2822 


input/serio/serport.c:244:	.receive_buf =	serport_ldisc_receive,
isdn/gigaset/ser-gigaset.c:758:	.receive_buf	= gigaset_tty_receive,
misc/ti-st/st_core.c:822:	.receive_buf = st_tty_receive,
net/can/slcan.c:626:	.receive_buf	= slcan_receive_buf,
net/hamradio/6pack.c:808:	.receive_buf	= sixpack_receive_buf,
net/hamradio/mkiss.c:996:	.receive_buf	= mkiss_receive_buf,
net/irda/irtty-sir.c:547:	.receive_buf	= irtty_receive_buf,
net/caif/caif_serial.c:378:	.receive_buf =	ldisc_receive,
net/ppp/ppp_synctty.c:428:	.receive_buf = ppp_sync_receive,
net/ppp/ppp_async.c:387:	.receive_buf = ppp_asynctty_receive,
tty/n_gsm.c:2819:	.receive_buf     = gsmld_receive_buf,
tty/n_tty.c:2129:	.receive_buf     = n_tty_receive_buf,
tty/n_hdlc.c:234:	.receive_buf	= n_hdlc_tty_receive,
tty/n_tracerouter.c:193:	.receive_buf	= n_tracerouter_receivebuf
tty/n_r3964.c:156:	.receive_buf = r3964_receive_buf,






