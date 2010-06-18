Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0FRWUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:20:12 -0400
Received: from lirone.symas.net ([64.71.152.235]:35360 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0FRWUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:20:10 -0400
Message-ID: <4C1BF111.6010807@symas.com>
Date: Fri, 18 Jun 2010 15:20:01 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan@lxorguk.ukuu.org.uk, greg@kroah.com
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OPhUs-0000W7-M9@lirone.symas.net>
In-Reply-To: <E1OPhUs-0000W7-M9@lirone.symas.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hyc@symas.com wrote:
> This patch is against the 2.6.34 source.
> @@ -1632,6 +1638,11 @@ static int copy_from_read_buf(struct tty_struct *tty,
>   		spin_lock_irqsave(&tty->read_lock, flags);
>   		tty->read_tail = (tty->read_tail + n)&  (N_TTY_BUF_SIZE-1);
>   		tty->read_cnt -= n;
> +		/* Check if last character is EOF */
> +		if (L_EXTPROC(tty)&&  tty->icanon) {
> +			if (!tty->read_cnt&&  (*b)[n-1] == EOF_CHAR(tty))
> +				n--;
> +		}
>   		spin_unlock_irqrestore(&tty->read_lock, flags);
>   		*b += n;
>   		*nr -= n;

This bit is wrong, only a naked EOF all by itself should be dropped. Should 
add this to the above:

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index bba123e..428f4fe 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1638,8 +1638,8 @@ static int copy_from_read_buf(struct tty_struct *tty,
                 spin_lock_irqsave(&tty->read_lock, flags);
                 tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
                 tty->read_cnt -= n;
-               /* Check if last character is EOF */
-               if (L_EXTPROC(tty) && tty->icanon) {
+               /* Turn single EOF into zero-length read */
+               if (L_EXTPROC(tty) && tty->icanon && n == 1) {
                         if (!tty->read_cnt && (*b)[n-1] == EOF_CHAR(tty))
                                 n--;
                 }


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
