Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1IUJqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:46:19 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2881 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1IUJqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:46:18 -0400
Subject: Re: [PATCH] User namespace: don't allow sysctl in non-init user ns
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <xs4all.20110915194812.GA24348@sergelap>
References: <xs4all.20110915194812.GA24348@sergelap>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: XS4ALL Internet B.V.
Date: Wed, 21 Sep 2011 11:46:07 +0200
Message-ID: <1316598367.5939.12.camel@n2o.xs4all.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 14:48 -0500, Serge E. Hallyn wrote:
> sysctl.c has its own custom uid check, which is not user namespace
> aware.  As discovered by Richard, that allows root in a container
> privileged access to set all sysctls.
> 
> To fix that, just refuse access if current is not in init_user_ns.  We
> may at some point want to relax that check so that some sysctls are
> allowed - for instance dmesg_restrict when syslog is containerized.
> 
> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vasiliy Kulikov <segoon@openwall.com>
> Cc: richard@nod.at
> ---
>  kernel/sysctl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 11d65b5..f2b42e2 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1697,6 +1697,8 @@ void register_sysctl_root(struct ctl_table_root *root)
>  
>  static int test_perm(int mode, int op)
>  {
> +	if (current_user_ns() != &init_user_ns)
> +		return -EACCES;
>  	if (!current_euid())
>  		mode >>= 6;
>  	else if (in_egroup_p(0))

I haven't tested it, but it looks like this denies access to /proc/sys
completely, right ? Wouldn't it be better to make access read-only ? 
For example glibc reads from several /proc/sys/... files for sysconf()
and pathconf(). That would fail with this patch I think ?

Something like

--- a/kernel/sysctl.c.orig	2011-06-24 00:24:26.000000000 +0200
+++ b/kernel/sysctl.c	2011-09-21 11:40:42.961291629 +0200
@@ -1892,10 +1892,15 @@
 
 static int test_perm(int mode, int op)
 {
-	if (!current_euid())
-		mode >>= 6;
-	else if (in_egroup_p(0))
-		mode >>= 3;
+	if (current_user_ns() != &init_user_ns) {
+		if (op & MAY_WRITE)
+			return -EACCES;
+	} else {
+		if (!current_euid())
+			mode >>= 6;
+		else if (in_egroup_p(0))
+			mode >>= 3;
+	}
 	if ((op & ~mode & (MAY_READ|MAY_WRITE|MAY_EXEC)) == 0)
 		return 0;
 	return -EACCES;

Mike.


