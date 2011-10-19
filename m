Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1JSVjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:39:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61606 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab1JSVjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:39:35 -0400
Message-ID: <4E9F4392.406@gmail.com>
Date: Wed, 19 Oct 2011 15:39:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com> <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com> <20111019192011.GG2229@ghostprotocols.net>
In-Reply-To: <20111019192011.GG2229@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/19/2011 01:20 PM, Arnaldo Carvalho de Melo wrote:
> Can you check if that is the problem? I.e. take notes->lock, check if
> ->src is NULL, if so call symbol__alloc_hist, etc?
> 

Reproduced it on a lab box. This fixes the segfault:

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bc8f477..6bd501a 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -253,6 +253,17 @@ static int symbol__parse_objdump_line(struct symbol
*sym, struct map *map,
        free(line);
        return -1;
    }
+
+   pthread_mutex_lock(&notes->lock);
+   if (notes->src == NULL &&
+       symbol__alloc_hist(sym, 1) < 0) {
+       pthread_mutex_unlock(&notes->lock);
+       ui__warning("Not enough memory for annotating '%s' symbol!\n",
+               sym->name);
+       return -1;
+   }
+   pthread_mutex_unlock(&notes->lock);
+
    objdump__add_line(&notes->src->source, objdump_line);

    return 0;

Should I plumb nr_events down versus assuming its 1?
