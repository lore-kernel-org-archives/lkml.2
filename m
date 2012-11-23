Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2KWSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 13:44:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab2KWSoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 13:44:18 -0500
Date: Sat, 24 Nov 2012 00:13:45 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Kees Cook <keescook@chromium.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211240004060.15883@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
 <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz> <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
 <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz> <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
 <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com> <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz> <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   Hello Kees, all,

Please have a look at a *NEW* patch at the end of this mail. It seems to fix 
both the issues, stack disclosure + undue recursions.

It uses modprobe "--first-time" option which returns an error code when trying 
to load a module which is already present or unload one which is not present.

Checking this return value at - request_module() - and breaking the loop in 
case of an error seems to be doing the trick.

+-- On Mon, 19 Nov 2012, Kees Cook wrote --+
| I think to avoid the explosion of request_module calls in the abusive case, 
| we could simply return ELOOP instead of ENOEXEC on max recursion.

 -> http://www.spinics.net/lists/mm-commits/msg92433.html

1. returning -ELOOP has a side effect of not reaching to request_module()
   ever, for:
==
#ifdef CONFIG_MODULES
1415                 if (retval != -ENOEXEC || bprm->mm == NULL) {
1416                         break;
1417                 } else {
                        ...
==

2. above patch does not seem to fix the 2^6(64) recursions issue, for:
==
+                       bprm->recursion_depth = depth + 1;
                        retval = fn(bprm);
                        bprm->recursion_depth = depth;
==

setting - recursion_dept = depth - again and the outer for(try=0;try<2...) 
loop seems to be causing the 2^6 recursions.


Please have a look at this *NEW* patch to fix both the issues, stack 
disclosure + undue recursions.

===
diff --git a/fs/exec.c b/fs/exec.c
index 0039055..dec467f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1423,7 +1423,14 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 				break; /* -ENOEXEC */
 			if (try)
 				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+            if (request_module("binfmt-%04x",
+                                *(unsigned short *)(&bprm->buf[2])))
+            {
+                printk(KERN_WARNING
+                        "request_module: failed to load: binfmt-%04x",
+                         *(unsigned short *)(&bprm->buf[2]));
+                break;
+            }
 		}
 #else
 		break;
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 1c317e3..7ec0e3e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -83,7 +83,7 @@ static int call_modprobe(char *module_name, int wait)
 		NULL
 	};
 
-	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	char **argv = kmalloc(sizeof(char *[6]), GFP_KERNEL);
 	if (!argv)
 		goto out;
 
@@ -93,9 +93,10 @@ static int call_modprobe(char *module_name, int wait)
 
 	argv[0] = modprobe_path;
 	argv[1] = "-q";
-	argv[2] = "--";
-	argv[3] = module_name;	/* check free_modprobe_argv() */
-	argv[4] = NULL;
+	argv[2] = "--first-time";
+	argv[3] = "--";
+	argv[4] = module_name;	/* check free_modprobe_argv() */
+	argv[5] = NULL;
 
 	return call_usermodehelper_fns(modprobe_path, argv, envp,
 		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
===



Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
