Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1CPT4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:56:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51584 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPT4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:56:14 -0400
Date: Wed, 16 Mar 2011 12:55:49 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, serge@hallyn.com,
        eparis@redhat.com, jmorris@namei.org, eugeneteo@kernel.org,
        drosenberg@vsecurity.com
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Message-ID: <20110316195549.GZ5466@outflux.net>
References: <1300303907-22627-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300303907-22627-1-git-send-email-richard@nod.at>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> When containers like LXC are used a unprivileged and jailed
> root user can still write to critical files in /proc/.
> E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> 
> This new restricted attribute makes it possible to protect such
> files. When restricted is set to true root needs CAP_SYS_ADMIN
> to into the file.

I was thinking about this too. I'd prefer more fine-grained control
in this area, since some sysctl entries aren't strictly controlled by
CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).

How about this instead?

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 8eb2522..5c5cfab 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -149,6 +149,10 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 	if (sysctl_perm(head->root, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
+	if (write && !cap_isclear(table->write_caps) &&
+            !cap_issubset(table->write_caps, current_cred()->cap_permitted))
+		goto out;
+
 	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
 	error = -EINVAL;
 	if (!table->proc_handler)
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..4e05493 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1018,6 +1018,7 @@ struct ctl_table
 	void *data;
 	int maxlen;
 	mode_t mode;
+	kernel_cap_t write_caps;	/* Capabilities required to write */
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */


-- 
Kees Cook
Ubuntu Security Team
