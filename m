Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1CRQy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:54:59 -0400
Received: from mail.ch.keymile.com ([193.17.201.103]:47610 "HELO
	mail.ch.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757186Ab1CRQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:54:53 -0400
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 12:54:52 EDT
Message-ID: <4D8389EC.5030704@keymile.com>
Date: Fri, 18 Mar 2011 17:35:56 +0100
From: Stefan Bigler <stefan.bigler@keymile.com>
Reply-To: stefan.bigler@keymile.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com> <20110317000408.GA18911@kroah.com>
In-Reply-To: <20110317000408.GA18911@kroah.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2011 16:35:56.0584 (UTC) FILETIME=[8E4CDA80:01CBE58A]
X-ESAFE-STATUS: Mail allowed
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Thanks for your quick answer. Meanwhile we ported our board to 2.6.38.
We recognize the same problem again.
I had also a look at the relevant fixes, a lot is done but I could not find
the required protection of the attribute receive_room.

I added a printk in case of failure were receive_room shows more
space that is really available in the queue and also used.

The printk is attached below and also the log.

Regards
Stefan


Log:
flush_to_ldisc, receive_room to small count=201, receive_room=287, 
real_room=0
flush_to_ldisc, receive_room to small count=225, receive_room=1031, 
real_room=0
flush_to_ldisc, receive_room to small count=33, receive_room=4095, 
real_room=0


diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index d8210ca..fa9ca62 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -442,6 +442,21 @@ static void flush_to_ldisc(struct work_struct *work)
                 line discipline as we want to empty the queue */
              if (test_bit(TTY_FLUSHPENDING, &tty->flags))
                  break;
+
+            /* add printk in case of inconsistante size */
+            if (tty->raw) {
+                unsigned long flags_r;
+                int real_room;
+                spin_lock_irqsave(&tty->read_lock, flags_r);
+                real_room = N_TTY_BUF_SIZE -tty->read_cnt - 1;
+                if (real_room < min(count, tty->receive_room)) {
+                    printk(KERN_ERR "flush_to_ldisc, receive_room to 
small count=%d,"
+                        " receive_room=%d, real_room=%d\n",
+                        count, tty->receive_room, real_room);
+                }
+                spin_unlock_irqrestore(&tty->read_lock,    flags_r);
+            }
+
              if (!tty->receive_room || seen_tail) {
                  schedule_delayed_work(&tty->buf.work, 1);
                  break;





Am 03/17/2011 01:04 AM, wrote Greg KH:
> On Wed, Mar 16, 2011 at 09:47:50PM +0100, Stefan Bigler wrote:
>> Hi all
>>
>> I'm facing a problem with TTY loosing data using u_serial gadget.
>>
>> I have a MPC8247 based system running 2.6.33.
> Oh, that's an old kernel, lots of work on the tty layer has happened
> since then that would fix issues like this.
>
> If you are stuck using this kernel, please go ask your vendor for
> support for it.
>
> If not, can you try out 2.6.38 and let us, and the
> linux-usb@vger.kernel.org list know if you still have problems with it?
>
> thanks,
>
> greg k-h

