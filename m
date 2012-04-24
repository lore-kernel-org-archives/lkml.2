Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2DXDkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:40:36 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36629 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab2DXDkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:40:35 -0400
X-Sasl-enc: q4C2cydUxiqrYAsnnFxI8ZT3xJn17QaZvjvt/tUXk7udTZWkvEY98N+efA 1335238833
Message-ID: <1335238831.2260.17.camel@perseus.themaw.net>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 24 Apr 2012 11:40:31 +0800
In-Reply-To: <1335230757.2260.15.camel@perseus.themaw.net>
References: <4F94222C.6080608@msgid.tls.msk.ru>
	 <1335172741.2226.10.camel@perseus.themaw.net>
	 <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>
	 <4F959A5A.8070907@msgid.tls.msk.ru>
	 <1335230757.2260.15.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:25 +0800, Ian Kent wrote:
> On Mon, 2012-04-23 at 22:07 +0400, Michael Tokarev wrote:
> > On 23.04.2012 20:55, Michael Tokarev wrote:
> > > On 23.04.2012 20:29, Michael Tokarev wrote:
> > >> On 23.04.2012 13:19, Ian Kent wrote:
> > >>> On Sun, 2012-04-22 at 19:22 +0400, Michael Tokarev wrote:
> > >>>> This is JFYI for now, I only diagnozed the issue but had
> > >>>> no time to see what's going on.
> > >>>>
> > >>>> The short story is that with 3.0.24 and later kernels,
> > >>>> 32bit autofs stopped working on 64bit kernels, while
> > >>>> it worked before just fine.
> > >>>>
> > >>>> The userspace is of version 5.0.4.  Platform is x86.
> > >>>>
> > >>>> The sympthoms of the issue is that automount daemon,
> > >>>> on every access to a (not yet mounted) autofs mount
> > >>>> point, stalls forever, with the process trying to
> > >>>> access it stalling forever too -- this is why the
> > >>>> system didn't reboot, -- it stayed on an attempt to
> > >>>> access one of automount subdirs, somewhere in the
> > >>>> middle.
> > >>
> > >> This is what happens with 3.0.24+:
> > >>
> > >> [pid 15207] read(4, "\5\0\0\0\3\0\0\0\2\0\0\0\35\0\0\0@\17\246\3\0\0\0\0\350\3\0\0\350\3\0\0"..., 304) = 300
> > >> [pid 15207] read(4,  <unfinished ...> -- forever.
> > >>
> > >> It wants to read 304 bytes, but kernel only supplies 300
> > >> bytes.
> > >>
> > >> $ file /usr/sbin/automount
> > >> /usr/sbin/automount: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> > >> $ uname -a
> > >> Linux gandalf 3.0.0-amd64 #3.0.27 SMP Tue Apr 3 16:23:45 MSK 2012 x86_64 GNU/Linux
> > >>
> > >> This is a32744d4abae24572eff7269bc17895c41bd0085
> > >> "autofs: work around unhappy compat problem on x86-64",
> > >> included in 3.0.24:
> > >>
> > >> +static noinline size_t autofs_v5_packet_size(struct autofs_sb_info *sbi)
> > >> +{
> > >> +       size_t pktsz = sizeof(struct autofs_v5_packet);
> > >> +#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
> > >> +       if (sbi->compat_daemon > 0)
> > >> +               pktsz -= 4;
> > >> +#endif
> > >> +       return pktsz;
> > >> +}
> > >> +
> > >>
> > >> "End result: the "packed" size of the structure is 300 bytes: 4-byte, but
> > >> not 8-byte aligned.
> > >>
> > >> As a result, despite all the fields being in the same place on all
> > >> architectures, sizeof() will round up that size to 304 bytes on
> > >> architectures that have 8-byte alignment for u64."
> > >>
> > >> So I'm not sure how it worked before this change (from the
> > >> description of the patch it looks like it should not work).
> > >> But it definitely worked for me, and this patch broke it
> > >> for me.
> > > 
> > > It worked because the userspace apparently does the "rigtht"
> > > think already compensating for the kernel bitness mismatch.
> > > This is a bit funky too, but it should work:
> > > 
> > > static size_t get_kpkt_len(void)
> > > {
> > >         size_t pkt_len = sizeof(struct autofs_v5_packet);
> > >         struct utsname un;
> > > 
> > >         uname(&un);
> > > 
> > >         if (pkt_len % 8) {
> > >                 if (strcmp(un.machine, "alpha") == 0 ||
> > >                     strcmp(un.machine, "ia64") == 0 ||
> > >                     strcmp(un.machine, "x86_64") == 0 ||
> > >                     strcmp(un.machine, "ppc64") == 0)
> > >                         pkt_len += 4;
> > > 
> > >         }
> > > 
> > >         return pkt_len;
> > > }
> > > 
> > > So it looks like the kernel/user interface had an error,
> > > userspace adopted to the kernel by doing something, so
> > > it started working.  And next kernel adopted to the un-
> > > patched userspace, thus breaking patched userspace.
> > > 
> > > That's quite messy... :(  And I'm not sure what to do
> > > about this, -- the only solution - in my opinion anyway -
> > > is to revert this kernel patch and maybe switch to a
> > > new protocol version.
> > 
> > Okay, even if messy, there are quite easy pure userspace
> > solutions to all this.
> > 
> > But first of all, I want to question this change in the
> > first place, hence CC'ing to LKML too.
> 
> Back porting the 3.3 change to current stable kernels was not a good
> idea IMO and I probably should have NAKed the one that I actually saw,
> which was devoid of version btw.
> 
> The change came about because there was a complaint about me not wanting
> to fix this in the kernel, but wanting to continue using the user space
> workaround. But it was insisted that it be fixed in the kernel, and so
> it was done.
> 
> Consequently people will encounter this gotcha sooner or later and will
> need to apply a patch to resolve it. The back port to stable kernels
> just means it's sooner rather than later.
> 
> I have already told you that I will need to provide a (updated, since
> there is already a commit in git that covers 3.3) patch for autofs. I
> haven't done that yet because I've been a little ill.

AFAICT this patch is what's needed.
Can you check please.

autofs-5.0.4 - allow for kernel packet size change

From: Ian Kent <raven@themaw.net>

Kernel 3.3.0 has a patch to allow for the original missdesign of
the autofs v5 kernel packet. That change is being back ported to
earlier stable kernel releases which is causing autofs to hang in
mixed 32-bit user space/64-bit kernel

The problem is that while all the structure fields are alligned
correctly structure allignment on x86-64 causes the packet size
to be 4 bytes larger than on x86. So when running an x86 binary
on an x86-64 install the packet size did not match causing user
space pipe reads to hang.
---

 daemon/automount.c |    8 ++++++++
 include/mounts.h   |   17 +++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)


diff --git a/daemon/automount.c b/daemon/automount.c
index 863aac5..92236b1 100644
--- a/daemon/automount.c
+++ b/daemon/automount.c
@@ -38,6 +38,7 @@
 #include <dirent.h>
 #include <sys/vfs.h>
 #include <sys/utsname.h>
+#include "mounts.h"
 
 #include "automount.h"
 #ifdef LIBXML2_WORKAROUND
@@ -599,6 +600,13 @@ static size_t get_kpkt_len(void)
 {
 	size_t pkt_len = sizeof(struct autofs_v5_packet);
 	struct utsname un;
+	int kern_vers;
+
+	kern_vers = linux_version_code();
+	if (kern_vers > KERNEL_VERSION(3, 2, 9) ||
+	   (kern_vers > KERNEL_VERSION(3, 0, 23) &&
+            kern_vers < KERNEL_VERSION(3, 1, 0)))
+		return pkt_len;
 
 	uname(&un);
 
diff --git a/include/mounts.h b/include/mounts.h
index 4d932ca..3947d83 100644
--- a/include/mounts.h
+++ b/include/mounts.h
@@ -16,6 +16,9 @@
 #ifndef MOUNTS_H
 #define MOUNTS_H
 
+#include <linux/version.h>
+#include <sys/utsname.h>
+
 #ifndef AUTOFS_TYPE_ANY
 #define AUTOFS_TYPE_ANY		0x0000
 #endif
@@ -72,6 +75,20 @@ struct mnt_list {
 	struct list_head ordered;
 };
 
+static inline unsigned int linux_version_code(void)
+{
+        struct utsname my_utsname;
+        unsigned int p, q, r;
+
+        if (uname(&my_utsname))
+                return 0;
+
+        p = (unsigned int)atoi(strtok(my_utsname.release, "."));
+        q = (unsigned int)atoi(strtok(NULL, "."));
+        r = (unsigned int)atoi(strtok(NULL, "."));
+        return KERNEL_VERSION(p, q, r);
+}
+
 unsigned int query_kproto_ver(void);
 unsigned int get_kver_major(void);
 unsigned int get_kver_minor(void);


