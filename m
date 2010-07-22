Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0GVRFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:05:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:55396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0GVRFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:05:53 -0400
Date: Thu, 22 Jul 2010 14:05:42 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org
Subject: [PATCH v2] Re: perf annotate segfaults when source code has goto
 label that looks like hex number
Message-ID: <20100722170541.GF17631@ghostprotocols.net>
References: <20100722072044.GD27177@redhat.com>
 <20100722143345.GC17631@ghostprotocols.net>
 <20100722163851.GA10307@redhat.com>
 <20100722164711.GD17631@ghostprotocols.net>
 <20100722165222.GE17631@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722165222.GE17631@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 22, 2010 at 01:52:22PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jul 22, 2010 at 01:47:11PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Jul 22, 2010 at 07:38:51PM +0300, Gleb Natapov escreveu:
> > > On Thu, Jul 22, 2010 at 11:33:45AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > Can you try the attached patch?
> > > > 
> > > I can, only later. But if I underhand your patch correctly perf will
> > > still crash if there is a comment after the label on the same line.
> > 
> > Possibly, will try that now.
> 
> It could be a comment of play code, like:
> 
> [root@emilia ~]# cat test.c 
> int main(int argc, char **argv)
> {
>       int i;
> 
>       while(1) {
>               i++;
>               if (i == 10000000)
>                       goto add;
>       }
> add:	return 0;
> }
> [root@emilia ~]#
> 
> back to the drawing board :-\

What about this one?

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 699cf81..96e9044 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -976,13 +976,15 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':' || tmp == tmp2)
+		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
 			line_ip = -1;
 	}
 
 	if (line_ip != -1) {
 		u64 start = map__rip_2objdump(self->ms.map, sym->start);
 		offset = line_ip - start;
+		if (offset < 0 || (u64)line_ip > sym->end)
+			offset = -1;
 	}
 
 	objdump_line = objdump_line__new(offset, line);
