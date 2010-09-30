Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0I3UZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:25:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:53948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0I3UZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:25:08 -0400
Date: Thu, 30 Sep 2010 22:25:07 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-ID: <20100930202507.GC25629@sepie.suse.cz>
References: <20100930105025.c46e2fe0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930105025.c46e2fe0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 10:50:25AM +1000, Stephen Rothwell wrote:
> Hi Michal,
> 
> After merging the kbuild tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> scripts/kconfig/kxgettext.c: In function 'menu_build_message_list':
> scripts/kconfig/kxgettext.c:175: warning: passing argument 3 of 'message__add' discards qualifiers from pointer target type
> scripts/kconfig/kxgettext.c:148: note: expected 'char *' but argument is of type 'const char * const'
> scripts/kconfig/kxgettext.c:180: warning: passing argument 3 of 'message__add' discards qualifiers from pointer target type
> scripts/kconfig/kxgettext.c:148: note: expected 'char *' but argument is of type 'const char * const'

Thanks, fixed with


From: Michal Marek <mmarek@suse.cz>
Subject: kconfig: Propagate const

Commit 2e7a091 made struct file->name a const char*, but forgot to
constify all users of it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/kxgettext.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/kxgettext.c b/scripts/kconfig/kxgettext.c
index dcc3fcc..e9d8e79 100644
--- a/scripts/kconfig/kxgettext.c
+++ b/scripts/kconfig/kxgettext.c
@@ -63,11 +63,11 @@ next:
 
 struct file_line {
 	struct file_line *next;
-	char*		 file;
-	int		 lineno;
+	const char *file;
+	int lineno;
 };
 
-static struct file_line *file_line__new(char *file, int lineno)
+static struct file_line *file_line__new(const char *file, int lineno)
 {
 	struct file_line *self = malloc(sizeof(*self));
 
@@ -90,7 +90,8 @@ struct message {
 
 static struct message *message__list;
 
-static struct message *message__new(const char *msg, char *option, char *file, int lineno)
+static struct message *message__new(const char *msg, char *option,
+				    const char *file, int lineno)
 {
 	struct message *self = malloc(sizeof(*self));
 
@@ -130,7 +131,8 @@ static struct message *mesage__find(const char *msg)
 	return m;
 }
 
-static int message__add_file_line(struct message *self, char *file, int lineno)
+static int message__add_file_line(struct message *self, const char *file,
+				  int lineno)
 {
 	int rc = -1;
 	struct file_line *fl = file_line__new(file, lineno);
@@ -145,7 +147,8 @@ out:
 	return rc;
 }
 
-static int message__add(const char *msg, char *option, char *file, int lineno)
+static int message__add(const char *msg, char *option, const char *file,
+			int lineno)
 {
 	int rc = 0;
 	char bf[16384];
-- 
1.7.1

