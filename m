Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab2JQT2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:28:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56438 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2JQT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:28:13 -0400
Date: Wed, 17 Oct 2012 20:28:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: yan yan <clouds.yan@gmail.com>
Cc: john.johansen@canonical.com, james.l.morris@oracle.com, eparis@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [BUG] Oops caused by audit code in 3.7.0-rc1
Message-ID: <20121017192809.GB2616@ZenIV.linux.org.uk>
References: <CAH+=+MEr=2jp6zDDr9WGrmng_O-AFKRuAruoeK-jtKnj7XqOCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+=+MEr=2jp6zDDr9WGrmng_O-AFKRuAruoeK-jtKnj7XqOCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:47:50PM +0800, yan yan wrote:

> [  896.957678] BUG: unable to handle kernel paging request at 72747461
> [  896.957824] IP: [<c12db352>] strlen+0x12/0x20
strlen() getting 4 bytes out of an ASCII string ("attr") as pointer.
Lovely...

> [  896.961222]  [<c10bdcbc>] audit_log_untrustedstring+0x1c/0x40
the same turd passed to audit_log_untrustedstring() as the second argument

> [  896.961346]  [<c1292e16>] audit_cb+0x36/0x40
apparmor... yuck.
Anyway, we have capability_names[sa->u.cap] yielding that shite.
IOW, sa->u.cap is out of range.

> [  896.961440]  [<c1285563>] common_lsm_audit+0x83/0x6e0
> [  896.961550]  [<c1292de0>] ? aa_audit+0x150/0x150
> [  896.961558]  [<c1292c8d>] aa_audit_msg+0x1d/0x20
> [  896.961558]  [<c1292ced>] aa_audit+0x5d/0x150
> [  896.961558]  [<c1292f53>] aa_capable+0x133/0x220

and this is where sa seems to have come from - audit_caps() inlined into
the end of aa_capable(), calling aa_audit() and passing it audit_cb as
callback and &sa as callback argument.  sa.u.cap is set to 'cap' argument
and unless something's corrupting memory in between, it seems that cap is
out of range.

> [  896.961558]  [<c1292de0>] ? aa_audit+0x150/0x150
> [  896.961558]  [<c10a1e3c>] ? lock_release_holdtime.part.22+0xbc/0xf0
> [  896.961558]  [<c1298b47>] apparmor_capable+0x67/0x80
> [  896.961558]  [<c126384c>] security_capable+0x1c/0x30
> [  896.961558]  [<c105567e>] ns_capable+0x2e/0x60
> [  896.961558]  [<c10556c4>] capable+0x14/0x20

sigh... more callchain from hell, going through the bowels of LSM...

> [  896.961558]  [<c1194d1a>] sys_epoll_ctl+0xba/0x800

anyway, cap should've originated here:
        if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
and grep for CAP_BLOCK_SUSPEND gives this
include/uapi/linux/capability.h:344:#define CAP_BLOCK_SUSPEND    36
OK, so where's the array it's
poking in?  Oh, fuck...
security/apparmor/Makefile:18:cmd_make-caps = echo "static const char *const capability_names[]
IOW, it's generated.  Great, a makefile to dig in - just the thing if you
need an emergency emetic in the morning...  I don't, but anyway:
cmd_make-caps = echo "static const char *const capability_names[] = {" > $@ ;\
        sed $< >>$@ -r -n -e '/CAP_FS_MASK/d' \
        -e 's/^\#define[ \t]+CAP_([A-Z0-9_]+)[ \t]+([0-9]+)/[\2] = "\L\1",/p';\
        echo "};" >> $@
is what's being done there.  Moderately brittle sed script.  What's being
fed to it?  And there we are:
$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
                            $(src)/Makefile
        $(call cmd,make-caps)
OK, that explains it nicely.  We don't have those defines in
include/linux/capability.h anymore - they moved to include/uapi/...;
It's still included from include/linux/capability.h, so gcc is fine, but this
script isn't.  Suggested fix: in the dependency line replace "include" with
"include/uapi".
