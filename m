Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0HFOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:09:28 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:49450 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0HFOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:09:25 -0400
Date: Fri, 6 Aug 2010 16:09:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: nir.tzachar@gmail.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nconfig: add search support
Message-ID: <20100806140923.GA26456@merkur.ravnborg.org>
References: <AANLkTimyDwWtLbc682rW-QORjU0+r+txZO-iKAini1H1@mail.gmail.com> <1280838492-9942-1-git-send-email-nir.tzachar@gmail.com> <20100805100408.5b724047.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805100408.5b724047.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> or I'd like to be able to find "crc" menu items in any sub-menu.
> Maybe I should just stick to config symbol searches.  I don't think it's all
> that likely that people will know how each menu line text begins.

Following patch extends symbols search to search _both_ for CONFIG_
symbols AND prompts.

I think this could be a usefull extension.
You are navigation much more around than me in the
Kconfig files / editors. What do you think?

As this is an extension in the core part it will take effect
for all the editors (which is good).
[gconf does not use sym_re_search() - I assume this feature is
missing in that editor]. 

I will cook up a proper patch only if I get positive feedback.

	Sam

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index e95718f..8cda9c0 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -842,6 +842,7 @@ struct symbol *sym_find(const char *name)
 
 struct symbol **sym_re_search(const char *pattern)
 {
+	struct property *prop;
 	struct symbol *sym, **sym_arr = NULL;
 	int i, cnt, size;
 	regex_t re;
@@ -854,9 +855,15 @@ struct symbol **sym_re_search(const char *pattern)
 		return NULL;
 
 	for_all_symbols(i, sym) {
+		bool found = false;
 		if (sym->flags & SYMBOL_CONST || !sym->name)
 			continue;
-		if (regexec(&re, sym->name, 0, NULL, 0))
+		if (!regexec(&re, sym->name, 0, NULL, 0))
+			found = true;
+		for_all_prompts(sym, prop)
+			if (!regexec(&re, prop->text, 0, NULL, 0))
+				found = true;
+		if (!found)
 			continue;
 		if (cnt + 1 >= size) {
 			void *tmp = sym_arr;
