Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0FNUxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:53:21 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55770 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab0FNUxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:53:19 -0400
Date: Mon, 14 Jun 2010 22:53:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but
 not used
Message-ID: <20100614225315.2bae9e37@hyperion.delvare>
In-Reply-To: <1276547208-26569-7-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
	<1276547208-26569-7-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On Mon, 14 Jun 2010 13:26:46 -0700, Justin P. Mattock wrote:
> could be a right solution, could be wrong
> here is the warning:
>   CC      drivers/i2c/i2c-core.o
> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
> drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
>  
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/i2c/i2c-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 1cca263..79c6c26 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>  	mutex_lock(&core_lock);
>  	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
>  				 __process_new_adapter);
> +	if(!dummy)
> +		dummy = 0;

One word: scripts/checkpatch.pl

In other news, the above is just plain wrong. First we force people to
read the result of bus_for_each_drv() and then when they do and don't
need the value, gcc complains, so we add one more layer of useless
code, which developers and possibly tools will later wonder and
complain about? I can easily imagine that a static code analyzer would
spot the above code as being a potential bug.

Let's stop this madness now please.

Either __must_check goes away from bus_for_each_drv() and from every
other function which raises this problem, or we must disable that new
type of warning gcc 4.6.0 generates. Depends which warnings we value
more, as we can't sanely have both.

>  	mutex_unlock(&core_lock);
>  
>  	return 0;


-- 
Jean Delvare
