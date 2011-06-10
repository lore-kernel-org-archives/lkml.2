Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab1FJI66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:58:58 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:41719 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1FJI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:58:54 -0400
Message-ID: <4DF1DCA9.9060604@parrot.com>
Date: Fri, 10 Jun 2011 10:58:17 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: uart : lost characters when system is busy
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the linux uart layer can loose some characters if the system is busy.

uart_throttle/uart_unthrottle is called from a workqueue.
If the system is busy, and the uart receive lot's of data, we fill the tty
buffer, but the workqueue doesn't run and we never have a chance to call
uart_throttle. So the uart is never slow down.

And because most uart driver call uart_insert_char (that doesn't return if
tty_insert_flip_char manage to push the character), we never detect that there
are some lost characters.


A workaround could be to check the buffer threshold in tty_flip_buffer_push and
call throttle callback if needed.


Matthieu
