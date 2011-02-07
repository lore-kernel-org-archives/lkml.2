Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1BGK7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:59:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61806 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1BGK7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=PnM74jElp18nuJHrcSj6QdLZjO+E/0Md396JDYchN9piQIL8NwLPvqAruba2S2GPmH
         m0+O/dLMOuv6+NswrdSDLwqcuJ9BvIUCGTuTx/OEw6and6nHBlxxTNRdZ2ozaHz9OQzr
         kt5K1HuYUZ/iaGXTe6VybpwfYA2OHlecV7cv8=
From: Yuya Tanaka <yuya.tanaka.i@gmail.com>
To: procps-feedback@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, albert@users.sourceforge.net,
        csmall@users.sourceforge.net
Subject: [PATCH] ps/libproc: 10x improvement on performance with euid/egid select options
Date: Mon,  7 Feb 2011 19:59:48 +0900
Message-Id: <1297076388-6195-1-git-send-email-yuya.tanaka.i@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Significant improvement on performance of ps command  when euid/egid
options are specified with huge number of alive processes.

Applies the same way used by pgrep. (why 'ps' (the main program) have
not known this better method for now?) "ps -uroot" took 90% of total
time for overhead without patch. Total was 0.48 secs, and became 0.04
secs with patch, when 10000 processes including 107 root processes
were alive. (Measured with Ubuntu 10.04, kernel 2.6.32 Core2 Duo E7400,
2G mem)

Signed-off-by: Yuya Tanaka <yuya.tanaka.i@gmail.com>
---
 proc/readproc.c |   65 ++++++++++++++++++++++++++++++++---------
 proc/readproc.h |    5 +++
 ps/common.h     |    7 ++++
 ps/display.c    |    5 ++-
 ps/global.c     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ps/parser.c     |    7 ++++
 6 files changed, 156 insertions(+), 19 deletions(-)

diff --git a/proc/readproc.c b/proc/readproc.c
index 4fad11d..8edf455 100644
--- a/proc/readproc.c
+++ b/proc/readproc.c
@@ -541,8 +541,19 @@ static proc_t* simple_readproc(PROCTAB *restrict const PT, proc_t *restrict cons
     if (unlikely(stat(path, &sb) == -1))	/* no such dirent (anymore) */
 	goto next_proc;
 
-    if ((flags & PROC_UID) && !XinLN(uid_t, sb.st_uid, PT->uids, PT->nuid))
-	goto next_proc;			/* not one of the requested uids */
+    if ((flags & PROC_UID) || (flags & PROC_GID)) {
+      // the number of gids may be less than it of uids, so check first
+      if ((flags & PROC_GID && XinLN(gid_t, sb.st_gid, PT->gids, PT->ngid)) ||
+          (flags & PROC_UID && XinLN(uid_t, sb.st_uid, PT->uids, PT->nuid))) {
+        // match
+        if (flags & PROC_NEGATE)
+          goto next_proc;
+      }
+      else {
+        if (!(flags & PROC_NEGATE))
+          goto next_proc;
+      }
+    }
 
     p->euid = sb.st_uid;			/* need a way to get real uid */
     p->egid = sb.st_gid;			/* need a way to get real gid */
@@ -867,9 +878,15 @@ PROCTAB* openproc(int flags, ...) {
     va_start(ap, flags);		/*  Init args list */
     if (flags & PROC_PID)
     	PT->pids = va_arg(ap, pid_t*);
-    else if (flags & PROC_UID) {
-    	PT->uids = va_arg(ap, uid_t*);
-	PT->nuid = va_arg(ap, int);
+    else if (flags & PROC_UID || flags & PROC_GID) {
+        if (flags & PROC_UID) {
+            PT->uids = va_arg(ap, uid_t*);
+            PT->nuid = va_arg(ap, int);
+        }
+        if (flags & PROC_GID) {
+            PT->gids = va_arg(ap, gid_t*);
+            PT->ngid = va_arg(ap, int);
+        }
     }
     va_end(ap);				/*  Clean up args list */
 
@@ -925,17 +942,35 @@ proc_t** readproctab(int flags, ...) {
     int n = 0;
     va_list ap;
 
+    /* FIXME: Dirty fix, va_arg() have implicit rule that only uid should come first, not gid.
+     */
     va_start(ap, flags);		/* pass through args to openproc */
-    if (flags & PROC_UID) {
-	/* temporary variables to ensure that va_arg() instances
-	 * are called in the right order
-	 */
-	uid_t* u;
-	int i;
-
-	u = va_arg(ap, uid_t*);
-	i = va_arg(ap, int);
-	PT = openproc(flags, u, i);
+    if (flags & PROC_UID || flags & PROC_GID) {
+        /* temporary variables to ensure that va_arg() instances
+         * are called in the right order
+         */
+        uid_t* uids;
+        uid_t* gids;
+        int nuid;
+        int ngid;
+
+        if (flags & PROC_UID && flags & PROC_GID) {
+            uids = va_arg(ap, uid_t*);
+            gids = va_arg(ap, gid_t*);
+            nuid = va_arg(ap, int);
+            ngid = va_arg(ap, int);
+            PT = openproc(flags, uids, nuid, gids, ngid);
+        }
+        else if (flags & PROC_UID) {
+            uids = va_arg(ap, uid_t*);
+            nuid = va_arg(ap, int);
+            PT = openproc(flags, uids, nuid);
+        }
+        else if (flags & PROC_GID) {
+            gids = va_arg(ap, gid_t*);
+            ngid = va_arg(ap, int);
+            PT = openproc(flags, gids, ngid);
+        }
     }
     else if (flags & PROC_PID)
 	PT = openproc(flags, va_arg(ap, void*)); /* assume ptr sizes same */
diff --git a/proc/readproc.h b/proc/readproc.h
index a953b29..02dfe7b 100644
--- a/proc/readproc.h
+++ b/proc/readproc.h
@@ -165,6 +165,8 @@ typedef struct PROCTAB {
     pid_t*	pids;	// pids of the procs
     uid_t*	uids;	// uids of procs
     int		nuid;	// cannot really sentinel-terminate unsigned short[]
+    gid_t*  gids;   // gids of procs
+    int     ngid;   // same as nuid
     int         i;  // generic
     unsigned	flags;
     unsigned    u;  // generic
@@ -241,7 +243,10 @@ extern proc_t * get_proc_stats(pid_t pid, proc_t *p);
 
 // Obsolete, consider only processes with one of the passed:
 #define PROC_PID             0x1000  // process id numbers ( 0   terminated)
+// These are used by simple_readproc for filtering, reduce number of /proc/ entries to processed
 #define PROC_UID             0x4000  // user id numbers    ( length needed )
+#define PROC_GID             0x8000  // group id numbers    ( length needed )
+#define PROC_NEGATE         0x10000  // negate these filtering
 
 // it helps to give app code a few spare bits
 #define PROC_SPARE_1     0x01000000
diff --git a/ps/common.h b/ps/common.h
index 0b47d90..ef2ee76 100644
--- a/ps/common.h
+++ b/ps/common.h
@@ -270,6 +270,8 @@ extern void init_output(void);
 extern int pr_nop(char *restrict const outbuf, const proc_t *restrict const pp);
 
 /* global.c */
+extern void calc_selection_cache(void);
+extern PROCTAB *openproc_wrapper(int flags);
 extern void reset_global(void);
 
 /* global.c */
@@ -302,6 +304,11 @@ extern int             running_only;
 extern int             screen_cols;
 extern int             screen_rows;
 extern unsigned long   seconds_since_boot;
+extern int             sel_egid_count; /* increased when a SEL_EGID selection_list is added */
+extern gid_t          *sel_egids; /* will be generated from selection_list */
+extern int             sel_euid_count; /* increased when a SEL_EUID selection_list is added */
+extern uid_t          *sel_euids; /* will be generated from selection_list */
+extern int             sel_openproc_unfilterable; /* will be generated from selection_list */
 extern selection_node *selection_list;
 extern unsigned        simple_select;
 extern sort_node      *sort_list;
diff --git a/ps/display.c b/ps/display.c
index 4574b9c..1b87d4f 100644
--- a/ps/display.c
+++ b/ps/display.c
@@ -328,7 +328,8 @@ static int want_this_proc_pcpu(proc_t *buf){
 static void simple_spew(void){
   proc_t buf;
   PROCTAB* ptp;
-  ptp = openproc(needs_for_format | needs_for_sort | needs_for_select | needs_for_threads);
+
+  ptp = openproc_wrapper(needs_for_format | needs_for_sort | needs_for_select | needs_for_threads);
   if(!ptp) {
     fprintf(stderr, "Error: can not access /proc.\n");
     exit(1);
@@ -520,7 +521,7 @@ static void fancy_spew(void){
   PROCTAB *restrict ptp;
   int n = 0;  /* number of processes & index into array */
 
-  ptp = openproc(needs_for_format | needs_for_sort | needs_for_select | needs_for_threads);
+  ptp = openproc_wrapper(needs_for_format | needs_for_sort | needs_for_select | needs_for_threads);
   if(!ptp) {
     fprintf(stderr, "Error: can not access /proc.\n");
     exit(1);
diff --git a/ps/global.c b/ps/global.c
index 0b3bc5b..15dac1d 100644
--- a/ps/global.c
+++ b/ps/global.c
@@ -70,6 +70,11 @@ int             prefer_bsd_defaults = -1;
 int             screen_cols = -1;
 int             screen_rows = -1;
 unsigned long   seconds_since_boot = -1;
+int             sel_egid_count = -1; /* increased when a SEL_EGID selection_list is added */
+gid_t          *sel_egids = (gid_t *)0xdeadbeef; /* will be generated from selection_list */
+int             sel_euid_count = -1; /* increased when a SEL_EUID selection_list is added */
+uid_t          *sel_euids = (uid_t *)0xdeadbeef; /* will be generated from selection_list */
+int             sel_openproc_unfilterable = -1; /* will be generated from selection_list */
 selection_node *selection_list = (selection_node *)0xdeadbeef;
 unsigned        simple_select = 0xffffffff;
 sort_node      *sort_list = (sort_node *)0xdeadbeef; /* ready-to-use sort list */
@@ -85,11 +90,11 @@ int             wchan_is_number = -1;
 
 static void reset_selection_list(void){
   selection_node *old;
-  selection_node *walk = selection_list;
+  selection_node *walk;
   if(selection_list == (selection_node *)0xdeadbeef){
     selection_list = NULL;
-    return;
   }
+  walk = selection_list;
   while(walk){
     old = walk;
     walk = old->next;
@@ -97,6 +102,15 @@ static void reset_selection_list(void){
     free(old);
   }
   selection_list = NULL;
+  if (sel_euids != (uid_t *)0xdeadbeef && sel_euids != NULL)
+    free(sel_euids);
+  sel_euids = NULL;
+  sel_euid_count = 0;
+  if (sel_egids != (gid_t *)0xdeadbeef && sel_egids != NULL)
+    free(sel_egids);
+  sel_egids = NULL;
+  sel_egid_count = 0;
+  sel_openproc_unfilterable = 0;
 }
 
 // The rules:
@@ -353,6 +367,74 @@ static const char *set_personality(void){
     return NULL;
 }
 
+/************ Call this to create selection_list cache to pass to openproc ***************/
+void calc_selection_cache(void){
+  selection_node *sn = selection_list;
+  int i;
+  uid_t *su;
+  gid_t *sg;
+
+  if(!sn) return;
+  if(sel_euid_count > 0){
+    if (sel_euids) free(sel_euids);
+    sel_euids = malloc(sel_euid_count * sizeof(uid_t));
+  }
+  su = sel_euids;
+  if(sel_egid_count > 0){
+    if (sel_egids) free(sel_egids);
+    sel_egids = malloc(sel_egid_count * sizeof(gid_t));
+  }
+  sg = sel_egids;
+#define copy_sel_unions_to_ptr(ptr, u_type) \
+        for (i = 0; i < sn->n; i++) \
+          *ptr++ = (sn->u+i)->u_type;
+  while(sn){
+    switch(sn->typecode){
+    default:
+      // should not filtered by only these options...
+      goto out;
+      break;
+    case SEL_EUID:
+      copy_sel_unions_to_ptr(su, uid)
+      break;
+    case SEL_EGID:
+      copy_sel_unions_to_ptr(sg, gid)
+      break;
+    }
+    sn = sn->next;
+  }
+#undef copy_sel_unions_to_array
+  return;
+out:
+  sel_openproc_unfilterable = 1;
+}
+
+/************ Automatically call openproc() with appropriate arguments made from global variables ***************/
+PROCTAB *openproc_wrapper(int flags){
+  PROCTAB *ptp;
+  if (negate_selection)
+    flags |= PROC_NEGATE;
+
+  // TODO: there may be more smart way than create complex if blocks, new interface to libproc preffered
+  if (!sel_openproc_unfilterable && !all_processes && !simple_select) {
+    if (sel_euid_count > 0 && sel_egid_count > 0) {
+      ptp = openproc(flags | PROC_UID | PROC_GID, sel_euids, sel_euid_count, sel_egids, sel_egid_count);
+    }
+    else if (sel_euid_count > 0) {
+      ptp = openproc(flags | PROC_UID, sel_euids, sel_euid_count);
+    }
+    else if (sel_egid_count > 0) {
+      ptp = openproc(flags | PROC_GID, sel_egids, sel_egid_count);
+    }
+    else {
+      ptp = openproc(flags);
+    }
+  }
+  else {
+    ptp = openproc(flags);
+  }
+  return ptp;
+}
 
 /************ Call this to reinitialize everything ***************/
 void reset_global(void){
diff --git a/ps/parser.c b/ps/parser.c
index 5ad9035..3681154 100644
--- a/ps/parser.c
+++ b/ps/parser.c
@@ -376,6 +376,7 @@ static const char *parse_sysv_option(void){
       err=parse_list(arg, parse_gid);
       if(!err){
         selection_list->typecode = SEL_EGID;
+        sel_egid_count += selection_list->n;
         return NULL; /* can't have any more options */
       }
       return "List of session leaders OR effective group IDs was invalid.";
@@ -449,6 +450,7 @@ static const char *parse_sysv_option(void){
       err=parse_list(arg, parse_uid);
       if(err) return err;
       selection_list->typecode = SEL_EUID;
+      sel_euid_count += selection_list->n;
       return NULL; /* can't have any more options */
     case 'w':
       trace("-w wide output.\n");
@@ -591,6 +593,7 @@ static const char *parse_bsd_option(void){
       err=parse_list(arg, parse_uid);
       if(err) return err;
       selection_list->typecode = SEL_EUID;
+      sel_euid_count += selection_list->n;
       return NULL; /* can't have any more options */
     case 'V': /* single */
       trace("V show version info\n");
@@ -915,6 +918,7 @@ static const char *parse_gnu_option(void){
     err=parse_list(arg, parse_gid);
     if(err) return err;
     selection_list->typecode = SEL_EGID;
+    sel_egid_count += selection_list->n;
     return NULL;
   case_help:
     trace("--help\n");
@@ -987,6 +991,7 @@ static const char *parse_gnu_option(void){
     err=parse_list(arg, parse_uid);
     if(err) return err;
     selection_list->typecode = SEL_EUID;
+    sel_euid_count += selection_list->n;
     return NULL;
   case_version:
     trace("--version\n");
@@ -1186,6 +1191,7 @@ int arg_parse(int argc, char *argv[]){
   err = select_bits_setup();
   if(err) goto try_bsd;
 
+  calc_selection_cache();
   choose_dimensions();
   return 0;
 
@@ -1233,6 +1239,7 @@ try_bsd:
   // the issues. The same goes for other stuff too, BTW. Please ask.
   // I'm happy to justify various implementation choices.
 
+  calc_selection_cache();
   choose_dimensions();
   return 0;
 
-- 
1.7.1

