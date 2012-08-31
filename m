Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2HaHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 03:33:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2HaHdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 03:33:16 -0400
MIME-Version: 1.0
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Fri, 31 Aug 2012 16:32:45 +0900
X-Google-Sender-Auth: UF5ESZ3hDO4XZXi67ogb9_VRkW0
Message-ID: <CABMQnVL4Dnee48aQs6Bhmqt5uu_T=Ro72E47sOWcS2CyZTtu4w@mail.gmail.com>
Subject: Can not get output of command line on SH
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Al.

I can not get output of command line on SH in latest linux kernel.
I bisected, I confirmed that this problem occurred by  following commit.

-----
commit 4a9d4b024a3102fc083c925c242d98ac27b1c5f6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jun 24 09:56:45 2012 +0400

    switch fput to task_work_add

    ... and schedule_work() for interrupt/kernel_thread callers
    (and yes, now it *is* OK to call from interrupt).

    We are guaranteed that __fput() will be done before we return
    to userland (or exit).  Note that for fput() from a kernel
    thread we get an async behaviour; it's almost always OK, but
    sometimes you might need to have __fput() completed before
    you do anything else.  There are two mechanisms for that -
    a general barrier (flush_delayed_fput()) and explicit
    __fput_sync().  Both should be used with care (as was the
    case for fput() from kernel threads all along).  See comments
    in fs/file_table.c for details.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
-----

For example ,when I input 'ls', nothing is displayed.
However, it is outputted when 'Ctrl+C' is inputted.
I checked other CPUs, it is only SH that this problem occurs.

Paul, do you think about this?

Best regards,
  Nobuhiro

-- 
Nobuhiro Iwamatsu
