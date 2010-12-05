Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0LEWN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:13:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33853 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0LEWNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:13:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kQs8528ZQnnN2OsRm3cU+mZtIg7Ttz4KiL6zJmMValjboR2GDNKoW+D86lJbYstuoC
         N1SX6HF0JQCeRHfNxGVwvBB0AWcCugwAzg0HZZUUdMjl0eBLWjGWtSegfy8J0mM+313l
         BKu+TcWPIHp1adNuWCeSdEbvHeDs3kFiGt2Ro=
Date: Mon, 6 Dec 2010 01:13:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] perf: Prevent potential null dereference
Message-ID: <20101205221321.GD7799@lenovo>
References: <20101202222605.GA6471@lenovo> <20101202224104.GA1639@nowhere> <20101202224609.GA31473@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202224609.GA31473@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 08:46:10PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 02, 2010 at 11:41:08PM +0100, Frederic Weisbecker escreveu:
> > On Fri, Dec 03, 2010 at 01:26:05AM +0300, Cyrill Gorcunov wrote:
> > > In case if there is no memory we might hit null
> > > dereference on accessing calloc'ed data.
> > > 
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > > CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > CC: Peter Zijlstra <peterz@infradead.org>
> > > CC: Ingo Molnar <mingo@elte.hu>
> > > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
...
> > 
> > Good.
> > 
> > As a nit, not that it matters that much because we are very close to the starting code
> > anyway, but it would be better to propagate the error to the callers.
> 
> I'm of the opinion that main() should be where exit() is allowed, and
> even there... return would be better. 8-)
> 
> - Arnaldo
> 

ok, sorry for delay, it seems the following would be liked
more than first version ;)

  Cyrill
---
[PATCH] perf: Prevent potential null dereference v2

In case if there is no memory we might hit null
dereference on accessing calloc'ed data.

v2: propagate error to a caller

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---

NB it's unclear for me why don't we yield any message on
too long command line, but anyway even then it should not
be messed with this particular patch.

Arnaldo, I'll check builtin-kmem.c next time i be able to,
though if there anyone would like to beat me on this -- feel
free ;)

 tools/perf/builtin-record.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.git/tools/perf/builtin-record.c
=====================================================================
--- linux-2.6.git.orig/tools/perf/builtin-record.c
+++ linux-2.6.git/tools/perf/builtin-record.c
@@ -507,7 +507,7 @@ static void mmap_read_all(void)
 		write_output(&finished_round_event, sizeof(finished_round_event));
 }
 
-static void comm__construct(int argc, const char **argv)
+static int comm__construct(int argc, const char **argv)
 {
 	char *comm, *tmp;
 	size_t size;
@@ -521,9 +521,13 @@ static void comm__construct(int argc, co
 	}
 
 	if ((long)size < 0)
-		return;
+		return 0;
 
 	comm = calloc(1, size);
+	if (!comm) {
+		pr_err("Not enough memory to construct internal command line.\n");
+		return -ENOMEM;
+	}
 
 	tmp = comm;
 	for (i = 0; i < argc; i++) {
@@ -533,6 +537,7 @@ static void comm__construct(int argc, co
 	}
 
 	session->command_line = comm;
+	return 0;
 }
 
 static int __cmd_record(int argc, const char **argv)
@@ -597,7 +602,10 @@ static int __cmd_record(int argc, const 
 	if (!no_buildid)
 		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
 
-	comm__construct(argc, argv);
+	err = comm__construct(argc, argv);
+	if (err < 0)
+		goto out_delete_session;
+
 
 	if (!file_new) {
 		err = perf_header__read(session, output);
