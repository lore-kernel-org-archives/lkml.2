Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986Ab0HFTsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:48:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0HFTsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:48:22 -0400
Subject: Re: [PATCH] SELINUX: Fix build error.
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, selinux@tycho.nsa.gov
In-Reply-To: <20100806193756.GA24645@linux-mips.org>
References: <20100806193756.GA24645@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 15:47:33 -0400
Message-ID: <1281124053.2609.9.camel@dhcp231-200.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 20:37 +0100, Ralf Baechle wrote:
> [...]
>   CC      security/selinux/hooks.o
> /home/ralf/src/linux/linux-mips/security/selinux/hooks.c: In function ‘selinux_inode_permission’:
> /home/ralf/src/linux/linux-mips/security/selinux/hooks.c:2644:38: error: ‘FILE__AUDIT_ACCESS’ undeclared (first use in this function)
> /home/ralf/src/linux/linux-mips/security/selinux/hooks.c:2644:38: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [security/selinux/hooks.o] Error 1
> make[3]: *** [security/selinux] Error 2
> make[2]: *** [security] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> This is cause by a stale security/selinux/av_permissions.h in the $(src)
> directory which will override a more recent version in $(obj) that is it
> appears to strike only when building with a separate object directory.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Eric Paris <eparis@redhat.com>

Ralf is at least the second person I've seen who had this problem since
the security tree merge.  The problem was not introduced in this merge,
it's just this merge was the first time I added new things to that file,
so it's the first time anyone would have noticed.  Introduced in
8753f6bec352392 but not really a problem until b782e0a68d17894d9a.

It's easily worked around deleting all of of the automagically generated
av_permissions.h files and letting them be regenerated but hardly anyone
would realize they need to delete files by hand (make clean, git clean,
etc won't delete it)

I think James is traveling for a bit so I'm putting it out there for a
faster track to inclusion.

-Eric

>  security/selinux/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/Makefile b/security/selinux/Makefile
> index f013982..58d80f3 100644
> --- a/security/selinux/Makefile
> +++ b/security/selinux/Makefile
> @@ -25,6 +25,6 @@ $(obj)/avc.o: $(obj)/flask.h
>  quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
>        cmd_flask = scripts/selinux/genheaders/genheaders $(obj)/flask.h $(obj)/av_permissions.h
>  
> -targets += flask.h
> +targets += flask.h av_permissions.h
>  $(obj)/flask.h: $(src)/include/classmap.h FORCE
>  	$(call if_changed,flask)


