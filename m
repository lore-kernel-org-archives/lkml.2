Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2LJTAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:00:47 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:56747 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab2LJTAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:00:45 -0500
Message-ID: <50C63157.6000601@ilyx.ru>
Date: Mon, 10 Dec 2012 23:00:39 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012 11:07, Peter Hurley wrote:
> 
> The most common cause stems from the n_tty_close() path spuriously
> scheduling buffer work, when the ldisc has already been halted.
> This is fixed in 'tty: Don't reschedule buffer work while closing'

Thank you, 
very useful.
Fix this:

WARNING: at drivers/tty/tty_buffer.c:429 flush_to_ldisc+0x52/0x192()
Hardware name: P5K Premium
tty is NULL
...
Pid: 1394, comm: kworker/0:2 Tainted: P        W  O 3.7.0-rc8-next-20121210-debtty.1+ #4
Call Trace:
 [<ffffffff8102d2f8>] warn_slowpath_common+0x80/0x98
 [<ffffffff8102d3a4>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8119c53a>] flush_to_ldisc+0x52/0x192
 [<ffffffff812594bd>] ? __schedule+0x5dd/0x60c
 [<ffffffff8103f146>] process_one_work+0x1c1/0x279
 [<ffffffff8119c4e8>] ? tty_buffer_free_all+0x4d/0x4d
 [<ffffffff8104104b>] worker_thread+0x154/0x24e
 [<ffffffff81040ef7>] ? manage_workers+0x26c/0x26c
 [<ffffffff810446ef>] kthread+0xb0/0xb8
 [<ffffffff8104463f>] ? kthread_parkme+0x1f/0x1f
 [<ffffffff8125f7ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104463f>] ? kthread_parkme+0x1f/0x1f

