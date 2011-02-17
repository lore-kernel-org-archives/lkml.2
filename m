Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1BQPCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:02:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1BQPCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:02:03 -0500
Date: Thu, 17 Feb 2011 16:02:00 +0100
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20110217150200.GA32177@sepie.suse.cz>
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
 <20110217144743.2db26b27.sfr@canb.auug.org.au>
 <4D5D201A.8090304@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5D201A.8090304@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 02:18:18PM +0100, Michal Marek wrote:
> On 17.2.2011 04:47, Stephen Rothwell wrote:
> > Hi all,
> > 
> > On Mon, 31 Jan 2011 15:42:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>
> >> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> >> failed like this:
> >>
> >> x86_64-linux-gcc: arch/x86/lib/memmove_64.c: No such file or directory
> >>
> >> Caused by commit 9599ec0471deae24044241e2173090d2cbc0e899 ("x86-64, mem:
> >> Convert memmove() to assembly file and fix return value bug") interacting
> >> with our build system.
> >>
> >> After removing arch/x86/lib/.memmove_64.o.cmd (left over from the build
> >> before merging the tip tree) from my object tree, it built correctly.
> > 
> > I am still getting this (of course).
> > 
> > Michal, is there anything that the kbuild system can do for us here?
> > Basically we have changed from using a .c file to generate a .o to using
> > a .S but the build system does not regenerate the .cmd file.
> 
> _Maybe_ we could work around it by letting fixdep remove the actual
> source file from the list of dependencies in the .cmd file. The
> dependency on the .c / .S / whatever file is given by the Makefiles, the
> .cmd file is only needed for additional dependencies on headers. Let's
> see what else breaks then ;).

It seems to work for me. Can you try the patch below? It needs to be
applied before merging 9599ec0 to have any effect.

Michal

From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH] fixdep: Do not record dependency on the source file itself

The dependency is already expressed by the Makefiles, storing it in the
.cmd file breaks build if a .c file is replaced by .S or vice versa,
because the .cmd file contains

foo/bar.o: foo/bar.c ...

foo/bar.c ... :

so the foo/bar.c -> foo/bar.o rule triggers even if there is no
foo/bar.c anymore.

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index c9a16ab..9264725 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -315,6 +315,7 @@ static void parse_dep_file(void *map, size_t len)
 	char *end = m + len;
 	char *p;
 	char s[PATH_MAX];
+	int first;
 
 	p = strchr(m, ':');
 	if (!p) {
@@ -327,6 +328,7 @@ static void parse_dep_file(void *map, size_t len)
 
 	clear_config();
 
+	first = 1;
 	while (m < end) {
 		while (m < end && (*m == ' ' || *m == '\\' || *m == '\n'))
 			m++;
@@ -340,9 +342,16 @@ static void parse_dep_file(void *map, size_t len)
 		if (strrcmp(s, "include/generated/autoconf.h") &&
 		    strrcmp(s, "arch/um/include/uml-config.h") &&
 		    strrcmp(s, ".ver")) {
-			printf("  %s \\\n", s);
+			/* Do not output the first dependency (the
+			 * source file), so that kbuild is not confused
+			 * if a .c file is rewritten into .S or vice
+			 * versa.
+			 */
+			if (!first)
+				printf("  %s \\\n", s);
 			do_config_file(s);
 		}
+		first = 0;
 		m = p + 1;
 	}
 	printf("\n%s: $(deps_%s)\n\n", target, target);
