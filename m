Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0DUQWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:22:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63469 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0DUQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hQUQ7pzIeH2Zj7uC58MUiX8UupqL916ABICdAi6O0uy4Kfpc27NKub+Eh4FTA9MLZT
         ljUO7Qw3EyKzBYF1xXRitHyOFVdeMwtaW+ikU19hzSiAMvaRbpu9O+Ln3oD9xgAkOsBw
         8ipmQqZi+tw8XNnA33T2x4eEkaKEs4txIFZDM=
Date: Thu, 22 Apr 2010 00:27:05 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: GuanJun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.34-rc1] proc: fix badness in fs/proc/generic.c
Message-ID: <20100421162704.GB13861@hack>
References: <z2xccf7f6161004210409n817c86eckdb72d9cdb31e3be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z2xccf7f6161004210409n817c86eckdb72d9cdb31e3be@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:09:42PM +0800, GuanJun He wrote:
>fix badness in fs/proc/generic.c,  Bug 15589 -  2.6.34-rc1: Badness at
>fs/proc/generic.c:316
>
>Signed-off-by: Guanjun He <heguanbo@gmail.com>

NACK.

The callers of __xlate_proc_name() all hold proc_subdir_lock.

>
>---
>diff -Nupr linux-2.6.34-rc1.orig/fs/proc/generic.c
>linux-2.6.34-rc1/fs/proc/generic.c
>--- linux-2.6.34-rc1.orig/fs/proc/generic.c     2010-03-09
>02:45:44.000000000 +0800
>+++ linux-2.6.34-rc1/fs/proc/generic.c  2010-04-21 19:02:49.000000000 +0800
>@@ -297,11 +297,13 @@ static int __xlate_proc_name(const char
>        const char              *cp = name, *next;
>        struct proc_dir_entry   *de;
>        int                     len;
>+       int                     rtn = 0;
>
>        de = *ret;
>        if (!de)
>                de = &proc_root;
>
>+       spin_lock(&proc_subdir_lock);
>        while (1) {
>                next = strchr(cp, '/');
>                if (!next)
>@@ -313,14 +315,17 @@ static int __xlate_proc_name(const char
>                                break;
>                }
>                if (!de) {
>-                       WARN(1, "name '%s'\n", name);
>-                       return -ENOENT;
>+                       WARN(1, "name \"%s\"\n", name);
>+                       rtn = -ENOENT;
>+                       goto out;
>                }
>                cp += len + 1;
>        }
>        *residual = cp;
>        *ret = de;
>-       return 0;
>+out:
>+       spin_unlock(&proc_subdir_lock);
>+       return rtn;
> }
>
> static int xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
