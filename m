Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1HDGtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:49:20 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:47262 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1HDGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:49:16 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 02:49:16 EDT
Message-ID: <4E3A4053.6020107@mail.ru>
Date: Thu, 04 Aug 2011 10:46:43 +0400
From: "MRU.Ilya" <utdilya@mail.ru>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: BUG: pty.c  in linux 2.6.31-rc5+
Content-Type: multipart/mixed;
 boundary="------------070808080009000006020908"
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070808080009000006020908
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit

Synchronic's line disciplines(ppp_synctty, hdlc) can't work with pseudo 
terminals.

If frames send very fast from one side(master/slave) to other one,
frames merge in one (merge point "flip buffer") and the other side can 
read only one big frame.
But sync line discipline need one frame in one read.

For push one frame to ldisc I propose small patch, but this regression for
commit e043e42bdb66885b3ac10d27a01ccb9972e2b0a3.

I don't find any mutexes and other things forbidden in not user context,
in function flush_to_ldisc() , and I think this patch
is true and this function can called from any context. But I not sure.

Relative commit  86d23a057e718f73adc15e463c643d6e014a19cd.



--------------070808080009000006020908
Content-Type: text/plain;
 name="pty_set_low_latency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pty_set_low_latency.patch"

--- orig/pty.c	2011-07-13 07:29:43.000000000 +0400
+++ work/pty.c	2011-08-03 20:59:01.000000000 +0400
@@ -204,6 +204,7 @@
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
+	tty->low_latency = 1;
 out:
 	return retval;
 }

--------------070808080009000006020908--
