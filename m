Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2LSXMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:12:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2LSXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:12:44 -0500
Date: Wed, 19 Dec 2012 15:12:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dae S. Kim" <dae@velatum.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char/misc.c: misc_register: Do not loop on misc_list
 unconditionally
Message-Id: <20121219151243.9f8882c8.akpm@linux-foundation.org>
In-Reply-To: <20121217222638.GA3747@Delta>
References: <20121217222638.GA3747@Delta>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 23:26:38 +0100
"Dae S. Kim" <dae@velatum.com> wrote:

> If the minor number is assigned dynamically, there is no need to
> search for misc->minor in misc_list, since misc->minor == 
> MISC_DYNAMIC_MINOR.
> 
> ...
>
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -190,12 +190,6 @@ int misc_register(struct miscdevice * misc)
>  	INIT_LIST_HEAD(&misc->list);
>  
>  	mutex_lock(&misc_mtx);
> -	list_for_each_entry(c, &misc_list, list) {
> -		if (c->minor == misc->minor) {
> -			mutex_unlock(&misc_mtx);
> -			return -EBUSY;
> -		}
> -	}
>  
>  	if (misc->minor == MISC_DYNAMIC_MINOR) {
>  		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
> @@ -205,6 +199,13 @@ int misc_register(struct miscdevice * misc)
>  		}
>  		misc->minor = DYNAMIC_MINORS - i - 1;
>  		set_bit(i, misc_minors);
> +	} else {
> +		list_for_each_entry(c, &misc_list, list) {
> +			if (c->minor == misc->minor) {
> +				mutex_unlock(&misc_mtx);
> +				return -EBUSY;
> +			}
> +		}
>  	}
>  

Looks OK.  It permits this:



From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix

reduce scope of local `c'

Cc: "Dae S. Kim" <dae@velatum.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dae S. Kim <dae@velatum.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix
+++ a/drivers/char/misc.c
@@ -183,7 +183,6 @@ static const struct file_operations misc
  
 int misc_register(struct miscdevice * misc)
 {
-	struct miscdevice *c;
 	dev_t dev;
 	int err = 0;
 
@@ -200,6 +199,8 @@ int misc_register(struct miscdevice * mi
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
 	} else {
+		struct miscdevice *c;
+
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == misc->minor) {
 				mutex_unlock(&misc_mtx);
_

