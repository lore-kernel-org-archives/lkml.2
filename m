Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0H1TLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:11:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44179 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab0H1TLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:11:49 -0400
Message-ID: <4C795F6F.40202@canonical.com>
Date: Sat, 28 Aug 2010 12:11:43 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Comments to apparmor Makefile (and security/Makefile)
References: <20100828070305.GA8842@merkur.ravnborg.org>
In-Reply-To: <20100828070305.GA8842@merkur.ravnborg.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 12:03 AM, Sam Ravnborg wrote:
> Hi John.
> 
> I took a closer at security/apparmor/Makefile.
> 
> And I got a few comments...
> 
> 1) You have in the bottom explicit rules for three files:
>    capability_names.h, rlim_names.h and af_names.h
>    But the altter file is not referenced in any
>    apparmor file.
>    And there is no cmd_make-af variable defined.
>    Looks like a leftover that shall be dropped.
> 
yes, the network mediation was split out for later submission and
af_names.h should have been removed.

> 2) clean-files fails to include rlim_names.h
> 
fixed.

> 3) The cmd_make-caps line is much too long.
>    Please use "\" to break lines in smaller logical parts.
>    Same goes with the other cdm_ line.
> 
ok

> 4) make-rlim delete the symbol AF_MAX - but that does not
>   exist in the input file.
> 
yep

> 5) Two of the sed expressions looks almost equal - should they have been equal?
> 
no, they actually produce slightly different output.

> 6) A small comment describing the purpose of each sed expression would be helpfull
>    Something like:
> # Transform lines from:
> # #define FOO 123
> # =>
> # #define RLIM_FOO 123
> 
yeah that would be good to have

> 7) af_names.h needs to be dropped in .gitignore
> 
yep, A patch for this was just floated by Yong Zhang

> 8) From security/Makefile:
> 
>     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/built-in.o
> This is _not_ how we do it.
> 
> We say just:
> 
>     obj-$(CONFIG_SECURITY_APPARMOR)         += apparmor/
> 
> [security/Makefile has this issue in several places]
> 
okay, I set it up this way to conform to other entries in the file
If we are going to fix apparmor's entry we should fix them all

> There was a few tings that made me unsafe just providing a patch,
> so for now you got a list of comments.
> 
> 	Sam

np, thanks for the comments, patch attached

john

---

>From 9476b18428e3bd85b2ac8907759771eb1a86e6c5 Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Sat, 28 Aug 2010 12:01:03 -0700
Subject: [PATCH] AppArmor: Cleanup make file to remove cruft and make it easier to read

Cleanups based on comments from Sam Ravnborg,

* remove references to the currently unused af_names.h
* add rlim_names.h to clean-files:
* rework cmd_make-XXX to make them more readable by adding comments,
  reworking the expressions to put logical components on individual lines, and
  keep lines < 80 characters.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/Makefile |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index f204869..7adfd82 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -6,19 +6,47 @@ apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
               path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
               resource.o sid.o file.o
 
-clean-files: capability_names.h af_names.h
+clean-files: capability_names.h rlim_names.h
 
+
+# Build a lower case string table of capability names
+# Transforms lines from
+#    #define CAP_DAC_OVERRIDE     1
+# to
+#    [1] = "dac_override",
 quiet_cmd_make-caps = GEN     $@
-cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
+cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ;\
+	sed $< >>$@ -r -n -e '/CAP_FS_MASK/d' \
+	-e 's/^\#define[ \t]+CAP_([A-Z0-9_]+)[ \t]+([0-9]+)/[\2] = "\L\1",/p';\
+	echo "};" >> $@
+
 
+# Build a lower case string table of rlimit names.
+# Transforms lines from
+#    #define RLIMIT_STACK		3	/* max stack size */
+# to
+#    [RLIMIT_STACK] = "stack",
+#
+# and build a second integer table (with the second sed cmd), that maps
+# RLIMIT defines to the order defined in asm-generic/resource.h  The is
+# required by policy load to map policy ordering of RLIMITs to internal
+# ordering for architectures that redefine an RLIMIT.
+# Transforms lines from
+#    #define RLIMIT_STACK		3	/* max stack size */
+# to
+# RLIMIT_STACK, 
 quiet_cmd_make-rlim = GEN     $@
-cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ; sed -n --e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+RLIMIT_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@ ; echo "static const int rlim_map[] = {" >> $@ ; sed -n -e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+\\(RLIMIT_[A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/\\1,/p" $< >> $@ ; echo "};" >> $@
+cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ;\
+	sed $< >> $@ -r -n \
+	    -e 's/^\# ?define[ \t]+(RLIMIT_([A-Z0-9_]+)).*/[\1] = "\L\2",/p';\
+	echo "};" >> $@ ;\
+	echo "static const int rlim_map[] = {" >> $@ ;\
+	sed -r -n "s/^\# ?define[ \t]+(RLIMIT_[A-Z0-9_]+).*/\1,/p" $< >> $@ ;\
+	echo "};" >> $@
 
 $(obj)/capability.o : $(obj)/capability_names.h
 $(obj)/resource.o : $(obj)/rlim_names.h
 $(obj)/capability_names.h : $(srctree)/include/linux/capability.h
 	$(call cmd,make-caps)
-$(obj)/af_names.h : $(srctree)/include/linux/socket.h
-	$(call cmd,make-af)
 $(obj)/rlim_names.h : $(srctree)/include/asm-generic/resource.h
 	$(call cmd,make-rlim)
-- 
1.7.0.4

