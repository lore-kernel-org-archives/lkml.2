Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1EWOSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:18:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42068 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1EWOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=pMMylvAng1JqwIQgzCaBRtUCq+Z0kAZupdtMYQuM35cdTjmxo94VzXPL79pbD3F/0v
         j0hpyrf9JrrOaUsqDkfSyatcT+5eAeS6fRhAA9L874G8P96nixNHG6hzi6iyCnl5aDUy
         RxTQUvSCpkZ7D1crYuQL94KmgSZfYR4ZKeXPY=
Date: Mon, 23 May 2011 07:18:46 -0700
From: mark gross <markgross@thegnar.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mark gross <markgross@thegnar.org>
Subject: Re: linux-next: build warning after merge of the suspend tree
Message-ID: <20110523141846.GA8122@gvim.org>
Reply-To: markgross@thegnar.org
References: <20110523150636.ccd83777.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523150636.ccd83777.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 03:06:36PM +1000, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the suspend tree, today's linux-next build (i386 defconfig
> among others) produced this warning:
> 
> kernel/pm_qos_params.c: In function 'pm_qos_power_write':
> kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from incompatible pointer type
> include/linux/kernel.h:210: note: expected 'long int *' but argument is of type 's32 *'
> 
> Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
> interface to work with ascii input per").

Gah!  I'm sorry about that.

attached is a fix.


--mark

signed-off-by:markgross <markgross@thegnar.org>



>From a8f0587b9ae598be5ca4c3cdda4e0ced6ca9baaf Mon Sep 17 00:00:00 2001
From: mgross <mgross@cr48>
Date: Mon, 23 May 2011 07:14:09 -0700
Subject: [PATCH] clean up a compile time warning in the use of strict_strtol but that was
 passing an s32 * when it should be passing a long *

---
 kernel/pm_qos_params.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index d61ecf3..dd37c56 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -405,6 +405,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 		size_t count, loff_t *f_pos)
 {
 	s32 value;
+	long safe_int;
 	int x;
 	char ascii_value[11];
 	struct pm_qos_request_list *pm_qos_req;
@@ -417,10 +418,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 		ascii_value[count] = 0;
 		if (copy_from_user(ascii_value, buf, count))
 			return -EFAULT;
-		if ((x=strict_strtol(ascii_value, 16, &value)) != 0){
-			pr_debug("%s, 0x%x, 0x%x\n",ascii_value, value, x);
+		if ((x=strict_strtol(ascii_value, 16, &safe_int)) != 0){
+			pr_debug("%s, 0x%lx, 0x%x\n",ascii_value, safe_int, x);
 			return -EINVAL;
 		}
+		value = (s32) safe_int;
 	} else
 		return -EINVAL;
 
-- 
1.7.4.1

