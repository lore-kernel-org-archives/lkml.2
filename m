Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab0LTXMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:12:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15929 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0LTXMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:12:03 -0500
Date: Tue, 21 Dec 2010 00:03:17 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Takashi Iwai <tiwai@suse.de>
cc: Jaroslav Kysela <perex@perex.cz>, Krzysztof Helt <krzysztof.h1@wp.pl>,
        Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound, core, pcm_lib: remember to always call va_end() on
 stuff that we va_start()
Message-ID: <alpine.LNX.2.00.1012202357150.23785@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker spotted that we do not always remember to call 
va_end() on 'args' in failure paths in snd_pcm_hw_rule_add().
Here's a patch to fix that up (compile tested only) - it also removes 
some annoying trailing whitespace that caught my eye while I was in the 
area..

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pcm_lib.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index b75db8e..11446a1 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1070,8 +1070,10 @@ int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 		struct snd_pcm_hw_rule *new;
 		unsigned int new_rules = constrs->rules_all + 16;
 		new = kcalloc(new_rules, sizeof(*c), GFP_KERNEL);
-		if (!new)
+		if (!new) {
+			va_end(args);
 			return -ENOMEM;
+		}
 		if (constrs->rules) {
 			memcpy(new, constrs->rules,
 			       constrs->rules_num * sizeof(*c));
@@ -1087,8 +1089,10 @@ int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 	c->private = private;
 	k = 0;
 	while (1) {
-		if (snd_BUG_ON(k >= ARRAY_SIZE(c->deps)))
+		if (snd_BUG_ON(k >= ARRAY_SIZE(c->deps))) {
+			va_end(args);
 			return -EINVAL;
+		}
 		c->deps[k++] = dep;
 		if (dep < 0)
 			break;
@@ -1097,7 +1101,7 @@ int snd_pcm_hw_rule_add(struct snd_pcm_runtime *runtime, unsigned int cond,
 	constrs->rules_num++;
 	va_end(args);
 	return 0;
-}				    
+}
 
 EXPORT_SYMBOL(snd_pcm_hw_rule_add);
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

