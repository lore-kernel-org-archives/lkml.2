Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2JVXtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:49:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JVXtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:49:03 -0400
Date: Mon, 22 Oct 2012 16:49:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 4/5] IPMI: Fix some uninitialized warning
Message-Id: <20121022164902.9b204646.akpm@linux-foundation.org>
In-Reply-To: <1350420820-7156-5-git-send-email-minyard@acm.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
	<1350420820-7156-5-git-send-email-minyard@acm.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 15:53:39 -0500
minyard@acm.org wrote:

> From: Corey Minyard <cminyard@mvista.com>
> 
> There was a spot where the compiler couldn't tell some variables
> would be set.  So initialize them to make the warning go away.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  drivers/char/ipmi/ipmi_msghandler.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index 2c29942..a0c84bb 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -1880,7 +1880,7 @@ int ipmi_request_supply_msgs(ipmi_user_t          user,
>  			     struct ipmi_recv_msg *supplied_recv,
>  			     int                  priority)
>  {
> -	unsigned char saddr, lun;
> +	unsigned char saddr = 0, lun = 0;
>  	int           rv;
>  
>  	if (!user)

The kernel build actually generates quite a lot of "bar uninitialised"
warnings for foo(&bar) expressions.  I just ignore them, because later
versions of gcc stopped doing that.

The fix is OK, I suppose.  But it will cause additional code to be
emitted.  Using uninitialized_var() avoids that, and makes things
clearer to the reader.
