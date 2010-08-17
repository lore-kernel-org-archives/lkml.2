Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0HQQKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:10:20 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1637 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab0HQQKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:10:17 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7HG9nQg026964
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100817154237.GG13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
	 <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop>
	 <1281970478.17267.12.camel@thorin>
	 <20100816152914.GC13095@ghostprotocols.net>
	 <1281973427.17267.16.camel@thorin>
	 <20100816155022.GD13095@ghostprotocols.net>
	 <1282046280.5822.4.camel@thorin>
	 <20100817154237.GG13095@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 18:09:49 +0200
Message-ID: <1282061389.5822.22.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-HP_X86_64_4CPU-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2010-08-17 at 12:42 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Aug 17, 2010 at 01:58:00PM +0200, Bernd Petrovitsch escreveu:
[...]
> > The following patch below at the end works for me. Alas, it is against
> > vanilla main line.
> 
> Adding $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h there, to have it look:
>
> +# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
> +# we depend the various files onto their directories.
> +$(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h: $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)))

Hmm, that adds that $(OUTPUT)PERF-VERSION-FILE and
$(OUTPUT)common-cmds.h (also) depends on the subdirectories of the other
objects (and thus it works always because at least one of them is a
subdirectory of $(OUTPUT)).
To be 110% anal, it should look like e.g.
+$(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h: $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)) $(OUTPUT))

or actually all targets.

> +# In the second step, we make a rule to actually create these directories
> +$(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS))):
> +       mkdir -p $@ 2>/dev/null
> +

BTW there is no automatic variable or other make-construct to refer in
the dependencies on the own target. Therefore the copy-paste-the-
variables solution.

Perhaps an additional variable reduces clutter (and eases maintenance)?

+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+       mkdir -p $@ 2>/dev/null
+

That should guarantee that all directories from the targets are created.

> As it was failing when I did:
> 
> rm -rf ~/build/perf
> make -C tools/perf O=~/build/perf
> 
> With that it retains the existing functionality,

Ah, I `mkdir`ed the output directory explicitly before the `make` (and
after the `rm -rf`).


BTW which is the preferred tree to base patches on (for the "perf"
subsystem)?

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

