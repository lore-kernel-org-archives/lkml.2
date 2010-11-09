Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0KIP3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:29:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44724 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0KIP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CYTc63Eipa1IlHM1Re9DDSAtV1ACf+9BV2DkVdl6ES+1HsQUctocN5NQw9vmMZ8p9N
         5R+v6b5RV/vJmVJhc2TIkINzYEqMgLZfoZfNxUG+VCFhHslr7R5VkitPDWdzFecpRR0l
         +cOQX+MN/pYG2DBaS4nes9QW8g3Bg+RzvYfS4=
Subject: [PATCH] fixdep: use hash table instead of a single array
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 16:29:27 +0100
Message-ID: <1289316567.2774.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed fixdep uses ~2% of cpu time in kernel build, in function
use_config()

fixdep spends a lot of cpu cycles in linear searches in its internal
string array. With about 400 stored strings per dep file, this begins to
be noticeable.

Convert fixdep to use a hash table.

kbuild results on my x86_64 allmodconfig

Before patch :

real	10m30.414s
user	61m51.456s
sys	8m28.200s

real	10m12.334s
user	61m50.236s
sys	8m30.448s

real	10m42.947s
user	61m50.028s
sys	8m32.380s

After:

real	10m8.180s
user	61m22.506s
sys	8m32.384s

real	10m35.039s
user	61m21.654s
sys	8m32.212s

real	10m14.487s
user	61m23.498s
sys	8m32.312s

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 scripts/basic/fixdep.c |  109 +++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 48 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index ea26b23..ed05846 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -138,38 +138,36 @@ static void print_cmdline(void)
 	printf("cmd_%s := %s\n\n", target, cmdline);
 }
 
-char * str_config  = NULL;
-int    size_config = 0;
-int    len_config  = 0;
+struct item {
+	struct item	*next;
+	unsigned int	len;
+	unsigned int	hash;
+	char		name[0];
+};
 
-/*
- * Grow the configuration string to a desired length.
- * Usually the first growth is plenty.
- */
-static void grow_config(int len)
-{
-	while (len_config + len > size_config) {
-		if (size_config == 0)
-			size_config = 2048;
-		str_config = realloc(str_config, size_config *= 2);
-		if (str_config == NULL)
-			{ perror("fixdep:malloc"); exit(1); }
-	}
-}
+#define HASHSZ 256
+static struct item *hashtab[HASHSZ];
 
+static unsigned int strhash(const char *str, unsigned int sz)
+{
+	/* fnv32 hash */
+	unsigned int i, hash = 2166136261U;
 
+	for (i = 0; i < sz; i++)
+		hash = (hash ^ str[i]) * 0x01000193;
+	return hash;
+}
 
 /*
  * Lookup a value in the configuration string.
  */
-static int is_defined_config(const char * name, int len)
+static int is_defined_config(const char *name, int len, unsigned int hash)
 {
-	const char * pconfig;
-	const char * plast = str_config + len_config - len;
-	for ( pconfig = str_config + 1; pconfig < plast; pconfig++ ) {
-		if (pconfig[ -1] == '\n'
-		&&  pconfig[len] == '\n'
-		&&  !memcmp(pconfig, name, len))
+	struct item *aux;
+
+	for (aux = hashtab[hash % HASHSZ]; aux; aux = aux->next) {
+		if (aux->hash == hash && aux->len == len &&
+		    memcmp(aux->name, name, len) == 0)
 			return 1;
 	}
 	return 0;
@@ -178,13 +176,19 @@ static int is_defined_config(const char * name, int len)
 /*
  * Add a new value to the configuration string.
  */
-static void define_config(const char * name, int len)
+static void define_config(const char *name, int len, unsigned int hash)
 {
-	grow_config(len + 1);
+	struct item *aux = malloc(sizeof(*aux) + len);
 
-	memcpy(str_config+len_config, name, len);
-	len_config += len;
-	str_config[len_config++] = '\n';
+	if (!aux) {
+		perror("fixdep:malloc");
+		exit(1);
+	}
+	memcpy(aux->name, name, len);
+	aux->len = len;
+	aux->hash = hash;
+	aux->next = hashtab[hash % HASHSZ];
+	hashtab[hash % HASHSZ] = aux;
 }
 
 /*
@@ -192,40 +196,49 @@ static void define_config(const char * name, int len)
  */
 static void clear_config(void)
 {
-	len_config = 0;
-	define_config("", 0);
+	struct item *aux, *next;
+	unsigned int i;
+
+	for (i = 0; i < HASHSZ; i++) {
+		for (aux = hashtab[i]; aux; aux = next) {
+			next = aux->next;
+			free(aux);
+		}
+		hashtab[i] = NULL;
+	}
 }
 
 /*
  * Record the use of a CONFIG_* word.
  */
-static void use_config(char *m, int slen)
+static void use_config(const char *m, int slen)
 {
-	char s[PATH_MAX];
-	char *p;
+	unsigned int hash = strhash(m, slen);
+	int c, i;
 
-	if (is_defined_config(m, slen))
+	if (is_defined_config(m, slen, hash))
 	    return;
 
-	define_config(m, slen);
-
-	memcpy(s, m, slen); s[slen] = 0;
+	define_config(m, slen, hash);
 
-	for (p = s; p < s + slen; p++) {
-		if (*p == '_')
-			*p = '/';
+	printf("    $(wildcard include/config/");
+	for (i = 0; i < slen; i++) {
+		c = m[i];
+		if (c == '_')
+			c = '/';
 		else
-			*p = tolower((int)*p);
+			c = tolower(c);
+		putchar(c);
 	}
-	printf("    $(wildcard include/config/%s.h) \\\n", s);
+	printf(".h) \\\n");
 }
 
-static void parse_config_file(char *map, size_t len)
+static void parse_config_file(const char *map, size_t len)
 {
-	int *end = (int *) (map + len);
+	const int *end = (const int *) (map + len);
 	/* start at +1, so that p can never be < map */
-	int *m   = (int *) map + 1;
-	char *p, *q;
+	const int *m   = (const int *) map + 1;
+	const char *p, *q;
 
 	for (; m < end; m++) {
 		if (*m == INT_CONF) { p = (char *) m  ; goto conf; }
@@ -265,7 +278,7 @@ static int strrcmp(char *s, char *sub)
 	return memcmp(s + slen - sublen, sub, sublen);
 }
 
-static void do_config_file(char *filename)
+static void do_config_file(const char *filename)
 {
 	struct stat st;
 	int fd;



