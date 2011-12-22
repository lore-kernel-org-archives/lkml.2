Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1LVIBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:01:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab1LVIBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:01:35 -0500
Date: Thu, 22 Dec 2011 09:01:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: [PATCHv5 1/7] ftrace: Change filter/notrace set functions to return
 exit code
Message-ID: <20111222080123.GA1646@m.brq.redhat.com>
References: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-2-git-send-email-jolsa@redhat.com>
 <1324512732.5916.111.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324512732.5916.111.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 07:12:12PM -0500, Steven Rostedt wrote:
> On Wed, 2011-12-21 at 19:56 +0100, Jiri Olsa wrote:
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index b79ab33..7eb702f 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -2912,8 +2912,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
> >  	mutex_lock(&ftrace_regex_lock);
> >  	if (reset)
> >  		ftrace_filter_reset(hash);
> > -	if (buf)
> > -		ftrace_match_records(hash, buf, len);
> > +	if (buf &&
> > +	    !ftrace_match_records(hash, buf, len)) {
> 
> I'm fine with this patch, but the above line break is ugly. Put that on
> one line, and it still is < 80 characters.
> 
> I could just take this patch and fix the above. No need to make a new
> patch set for this one fix.

fixed version attached, thanks
jirka

---
Currently the ftrace_set_filter and ftrace_set_notrace functions
do not return any return code. So there's no way for ftrace_ops
user to tell wether the filter was correctly applied.

The set_ftrace_filter interface returns error in case the filter
did not match:

  # echo krava > set_ftrace_filter
  bash: echo: write error: Invalid argument

Changing both ftrace_set_filter and ftrace_set_notrace functions
to return zero if the filter was applied correctly or -E* values
in case of error.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/ftrace.h |    4 ++--
 kernel/trace/ftrace.c  |   15 +++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 26eafce..523640f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -180,9 +180,9 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
 void ftrace_set_global_filter(unsigned char *buf, int len, int reset);
 void ftrace_set_global_notrace(unsigned char *buf, int len, int reset);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b79ab33..46e1031 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2912,8 +2912,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
-	if (buf)
-		ftrace_match_records(hash, buf, len);
+	if (buf && !ftrace_match_records(hash, buf, len)) {
+		ret = -EINVAL;
+		goto out_regex_unlock;
+	}
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
@@ -2923,6 +2925,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_unlock(&ftrace_lock);
 
+ out_regex_unlock:
 	mutex_unlock(&ftrace_regex_lock);
 
 	free_ftrace_hash(hash);
@@ -2939,10 +2942,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
  */
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 1);
+	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
 
@@ -2957,10 +2960,10 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
  */
-void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 0);
+	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
 /**
-- 
1.7.1

