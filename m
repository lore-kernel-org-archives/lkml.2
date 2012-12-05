Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2LEIsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:48:01 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53612 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2LEIr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:47:58 -0500
Message-ID: <50BF0A3A.1090801@ilyx.ru>
Date: Wed, 05 Dec 2012 12:47:54 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH -next 0/2] tty: Correct tty buffer flush.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
Only flush the data for ldisc(tty->buf.head->read = tty->buf.head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.

Also revert:
  commit c56a00a165712fd73081f40044b1e64407bb1875
  tty: hold lock across tty buffer finding and buffer filling
In order to delete the unneeded locks any more.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
