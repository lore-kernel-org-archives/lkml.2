Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0ELIEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:04:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0ELIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qRRBf5UDnxibeC2JvpkBFHT3Gq/sYRQe5cDKBYw2qRLchBECvQwJoTgQgxGqbW2F/T
         fygpWGzu4myor6ea8C1jCYzbu3YViYPEpZeP+1XgOr85IjBWtyvKUz5Rv0ojLuk4IGdS
         Psd7pBpaNZ5TEz8Ja36jL8VyP3jkmtwVJRV/g=
Date: Wed, 12 May 2010 16:08:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
Message-ID: <20100512080837.GD5718@cr0.nay.redhat.com>
References: <4BE967B9.5050107@udo.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE967B9.5050107@udo.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 04:20:41PM +0200, Andrej Gelenberg wrote:
>Wrap store_scaling_governor with mutex lock cpufreq_governor_mutex.
>Fix kernel panic if switch scaling governor very fast.
>Bug in bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=15948
>
>Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
>---
> drivers/cpufreq/cpufreq.c |   16 +++++++++++-----
> 1 files changed, 11 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>index 75d293e..6ba42f9 100644
>--- a/drivers/cpufreq/cpufreq.c
>+++ b/drivers/cpufreq/cpufreq.c
>@@ -403,8 +403,6 @@ static int cpufreq_parse_governor(char
>*str_governor, unsigned int *policy,
> 	} else if (cpufreq_driver->target) {
> 		struct cpufreq_governor *t;
>
>-		mutex_lock(&cpufreq_governor_mutex);
>-
> 		t = __find_governor(str_governor);
>
> 		if (t == NULL) {
>@@ -429,8 +427,6 @@ static int cpufreq_parse_governor(char
>*str_governor, unsigned int *policy,
> 			*governor = t;
> 			err = 0;
> 		}
>-
>-		mutex_unlock(&cpufreq_governor_mutex);
> 	}
> out:
> 	return err;
>@@ -521,7 +517,7 @@ static ssize_t show_scaling_governor(struct
>cpufreq_policy *policy, char *buf)
> /**
>  * store_scaling_governor - store policy for the specified CPU
>  */
>-static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
>+static ssize_t _store_scaling_governor(struct cpufreq_policy *policy,
> 					const char *buf, size_t count)
> {
> 	unsigned int ret = -EINVAL;
>@@ -553,6 +549,16 @@ static ssize_t store_scaling_governor(struct
>cpufreq_policy *policy,
> 		return count;
> }
>
>+static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
>+                                        const char *buf, size_t count)
>+{
>+        ssize_t ret;
>+	mutex_lock(&cpufreq_governor_mutex);
>+        ret = _store_scaling_governor(policy, buf, count);
>+	mutex_unlock(&cpufreq_governor_mutex);
>+        return ret;
>+}
>+

Sorry, I don't get it, cpufreq_governor_mutex is used to protect
cpufreq_governor_list. What is the point of moving it up?
Can you explain what the race condition is?

Thanks!
 
