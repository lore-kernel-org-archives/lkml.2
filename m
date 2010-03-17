Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0CQH7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:59:09 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51848 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0CQH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:59:08 -0400
Message-ID: <4BA08BC4.1070605@dcl.info.waseda.ac.jp>
Date: Wed, 17 Mar 2010 16:59:00 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Make printing table easily
References: <1268034910-12544-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100311125126.GI31354@elte.hu> <20100311140615.GD28421@ghostprotocols.net> <4BA089C0.8090406@dcl.info.waseda.ac.jp>
In-Reply-To: <4BA089C0.8090406@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/10 16:50, Hitoshi Mitake wrote:
 > On 03/11/10 23:06, Arnaldo Carvalho de Melo wrote:
 >  > Em Thu, Mar 11, 2010 at 01:51:26PM +0100, Ingo Molnar escreveu:
 >  >>
 >  >> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp> wrote:
 >  >>
 >  >>> Hi,
 >  >>>
 >  >>> Making table of matrix by printf is painful work,
 >  >>> but it can be found in perf here and there.
 >  >>> So I'd like to propose semi-automation of making table.
 >  >>> New files util/table.c provides stuffs for easy table printing.
 >  >>
 >  >> Looks quite reasonable in theory. I suspect it would be useful to
 > see a few
 >  >> table printing places converted to this facility, to see the
 > simplification
 >  >> factor in practice.
 >  >
 >  > I'm going thru the printing routines now to get them usable by 
TUI/GUIs,
 >  > starting with a libnewt based browser integrating initially report and
 >  > annotate, after I get the first patch in shape for merging I'll 
revisit
 >  > this table class of yours :-)
 >
 > Thanks Arnaldo!
 >
 > But I noticed fatal weak point of table.c.
 >
 > User of table.c can reduce the cost of specifying
 > format specifier for printf, but like this case:
 >
 > table_add_fixed(t, "%p", SIZE_OF_ADDR);
 > if (some_cond1)
 > table_add_fixed(t, "%10d", sizeof(int));
 > if (some_cond2)
 > table_add_string(t, "%30s", 30);
 >
 > table_printf() may produces a lot of if-branch like this:
 >
 > if (some_cond1 && some_cond2)
 > table_printf(t, table_test, 2501, "one");
 > else if (!some_cond1 && some_cond2)
 > table_printf(t, table_test, "one");
 > else if (some_cond1 && !some_cond2)
 > table_printf(t, table_test, 2501);
 >
 > It is not so good, as Ingo told, at least table of this style
 > is not useful in real world...
 >
 > But, how about this style?
 >
 > First, user declare column with name like this:
 > table_add_column(t, "num1", "%10d", sizeof(int));
 >
 > Then, user can add values with name,
 > table_add_field(t, "num1", 2501);
 >
 > Finally, flush stored column
 > table_flush_line(t);
 >

Another suggestion:
If table_add_column() returns "column ID",
table_add_field() can specify tha column with it
and duplication of string can be reduced.
