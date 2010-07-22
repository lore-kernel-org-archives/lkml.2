Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0GVOeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:34:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab0GVOeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:34:00 -0400
Date: Thu, 22 Jul 2010 11:33:45 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org
Subject: [PATCH] Re: perf annotate segfaults when source code has goto label
 that looks like hex number
Message-ID: <20100722143345.GC17631@ghostprotocols.net>
References: <20100722072044.GD27177@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20100722072044.GD27177@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Thu, Jul 22, 2010 at 10:20:44AM +0300, Gleb Natapov escreveu:
> strtoull() returns valid number when it gets line with label and following
> test passes too. I can't think of a way to unambiguously distinguish between
> label and valid rip. May be running objdump with --prefix-addresses will
> help, but it may make other thing unambiguous.

[root@emilia ~]# objdump --start-address=0x0000000000400474 --stop-address=0x0000000000400496 -dS ./a.out | grep -P ':\t'
  400474:	55                   	push   %rbp
  400475:	48 89 e5             	mov    %rsp,%rbp
  400478:	89 7d ec             	mov    %edi,-0x14(%rbp)
  40047b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  40047f:	eb 01                	jmp    400482 <main+0xe>
  400481:	90                   	nop
  400482:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  400486:	81 7d fc 80 96 98 00 	cmpl   $0x989680,-0x4(%rbp)
  40048d:	75 f2                	jne    400481 <main+0xd>
  40048f:	90                   	nop
  400490:	b8 00 00 00 00       	mov    $0x0,%eax
  400495:	c9                   	leaveq 
[root@emilia ~]# objdump --start-address=0x0000000000400474
--stop-address=0x0000000000400496 -dS ./a.out | grep ':$'
Disassembly of section .text:
0000000000400474 <main>:
add:
[root@emilia ~]#

Can you try the attached patch?

With it we get:


[root@emilia ~]# perf annotate

------------------------------------------------
 Percent |	Source code & Disassembly of a.out
------------------------------------------------
         :
         :
         :
         :	Disassembly of section .text:
         :
         :	0000000000400474 <main>:
         :	int main(int argc, char **argv)
         :	{
    0.00 :	  400474:       55                      push   %rbp
    0.00 :	  400475:       48 89 e5                mov    %rsp,%rbp
    0.00 :	  400478:       89 7d ec                mov    %edi,-0x14(%rbp)
    0.00 :	  40047b:       48 89 75 e0             mov    %rsi,-0x20(%rbp)
    0.00 :	  40047f:       eb 01                   jmp    400482 <main+0xe>
         :
         :	      while(1) {
         :	              i++;
         :	              if (i == 10000000)
         :	                      goto add;
         :	      }
   21.05 :	  400481:       90                      nop
         :	int main(int argc, char **argv)
         :	{
         :	      int i;
         :
         :	      while(1) {
         :	              i++;
    0.00 :	  400482:       83 45 fc 01             addl   $0x1,-0x4(%rbp)
         :	              if (i == 10000000)
   15.79 :	  400486:       81 7d fc 80 96 98 00    cmpl   $0x989680,-0x4(%rbp)
   63.16 :	  40048d:       75 f2                   jne    400481 <main+0xd>
         :	                      goto add;
    0.00 :	  40048f:       90                      nop
         :	      }
         :	add:
         :	      return 0;
    0.00 :	  400490:       b8 00 00 00 00          mov    $0x0,%eax
         :	}
    0.00 :	  400495:       c9                      leaveq 

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="annotate_fix.patch"

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 699cf81..e3486d5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -976,7 +976,7 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':' || tmp == tmp2)
+		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
 			line_ip = -1;
 	}
 

--ReaqsoxgOBHFXBhH--
