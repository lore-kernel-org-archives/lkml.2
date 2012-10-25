Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2JYLqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab2JYLqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:46:40 -0400
Date: Thu, 25 Oct 2012 17:16:22 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Kees Cook <keescook@chromium.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025041620.GH2616@ZenIV.linux.org.uk> <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Kees,

+-- On Wed, 24 Oct 2012, Kees Cook wrote --+
| What should the code here _actually_ be doing? The _script and _misc 
| handlers expect to rewrite the bprm contents and recurse, but the module 
| loader want to try again. It's not clear to me what the binfmt module 
| handler is even there for; I don't see any binfmt-XXXX aliases in the tree. 
| If nothing uses it, should we just rip it out? That would solve it too.

I've been following this issue and updated versions of HDs patch. Below is a 
small patch to search_binary_handler() routine, which attempts to make the 
request_module call before calling load_script routine.

Besides fixing the stack disclosure issue it also helps to *simplify* the 
search_binary_handler routine by removing the -for (try=0;try<2;try++)- loop.

I'd really appreciate any comments/suggestions you may have.

===
diff --git a/fs/exec.c b/fs/exec.c
index 8b9011b..e368f41 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1369,65 +1369,55 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
-	retval = -ENOENT;
-	for (try=0; try<2; try++) {
-		read_lock(&binfmt_lock);
-		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
-			if (!fn)
-				continue;
-			if (!try_module_get(fmt->module))
-				continue;
-			read_unlock(&binfmt_lock);
-			retval = fn(bprm, regs);
-			/*
-			 * Restore the depth counter to its starting value
-			 * in this call, so we don't have to rely on every
-			 * load_binary function to restore it on return.
-			 */
-			bprm->recursion_depth = depth;
-			if (retval >= 0) {
-				if (depth == 0) {
-					trace_sched_process_exec(current, old_pid, bprm);
-					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
-				}
-				put_binfmt(fmt);
-				allow_write_access(bprm->file);
-				if (bprm->file)
-					fput(bprm->file);
-				bprm->file = NULL;
-				current->did_exec = 1;
-				proc_exec_connector(current);
-				return retval;
-			}
-			read_lock(&binfmt_lock);
-			put_binfmt(fmt);
-			if (retval != -ENOEXEC || bprm->mm == NULL)
-				break;
-			if (!bprm->file) {
-				read_unlock(&binfmt_lock);
-				return retval;
-			}
-		}
-		read_unlock(&binfmt_lock);
 #ifdef CONFIG_MODULES
-		if (retval != -ENOEXEC || bprm->mm == NULL) {
-			break;
-		} else {
-#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
-			if (printable(bprm->buf[0]) &&
-			    printable(bprm->buf[1]) &&
-			    printable(bprm->buf[2]) &&
-			    printable(bprm->buf[3]))
-				break; /* -ENOEXEC */
-			if (try)
-				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
-		}
-#else
-		break;
+#define printable(c) (0x20<=(c) && (c)<=0x7e)
+
+    if (printable(bprm->buf[0]) && printable(bprm->buf[1])
+        && printable(bprm->buf[2]) && printable(bprm->buf[3]))
+        request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #endif
-	}
+
+    retval = -ENOENT;
+    read_lock(&binfmt_lock);
+    list_for_each_entry(fmt, &formats, lh) {
+        int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
+        if (!fn)
+            continue;
+        if (!try_module_get(fmt->module))
+            continue;
+        read_unlock(&binfmt_lock);
+        retval = fn(bprm, regs);
+        /*
+         * Restore the depth counter to its starting value
+         * in this call, so we don't have to rely on every
+         * load_binary function to restore it on return.
+         */
+        bprm->recursion_depth = depth;
+        if (retval >= 0) {
+            if (depth == 0) {
+                trace_sched_process_exec(current, old_pid, bprm);
+                ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
+            }
+            put_binfmt(fmt);
+            allow_write_access(bprm->file);
+            if (bprm->file)
+                fput(bprm->file);
+            bprm->file = NULL;
+            current->did_exec = 1;
+            proc_exec_connector(current);
+            return retval;
+        }
+        read_lock(&binfmt_lock);
+        put_binfmt(fmt);
+        if (retval != -ENOEXEC || bprm->mm == NULL)
+            break;
+        if (!bprm->file) {
+            read_unlock(&binfmt_lock);
+            return retval;
+        }
+    }
+    read_unlock(&binfmt_lock);
+
 	return retval;
 }
 
===

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
