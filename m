Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LUVfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:35:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:30887 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2LUVfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:35:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,332,1355126400"; 
   d="scan'208";a="183568763"
Date: Fri, 21 Dec 2012 21:55:05 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix unreasonable write toward closed pty.
Message-ID: <20121221215505.6dab13ca@bob.linux.org.uk>
In-Reply-To: <50D20E87.9060403@ilyx.ru>
References: <50D20E87.9060403@ilyx.ru>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 22:59:19 +0400
Ilya Zykov <ilya@ilyx.ru> wrote:

> We should not write toward the closed pty. 
> Now it happens, if one side close last file descriptor,
> and other side in this moment write to it.
> It also prevents scheduling unnecessary work.
> 
> Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
> ---
>  drivers/tty/pty.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
> index a82b399..1ce1362 100644
> --- a/drivers/tty/pty.c
> +++ b/drivers/tty/pty.c
> @@ -116,6 +116,8 @@ static int pty_space(struct tty_struct *to)
>  
>  static int pty_write(struct tty_struct *tty, const unsigned char
> *buf, int c) {
> +	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
> +		return -EIO;
>  	struct tty_struct *to = tty->link;

This

a) doesn't do anything in many cases because there is no lock to make
the test_bit meaningful

b) produces an obvious compiler warning

