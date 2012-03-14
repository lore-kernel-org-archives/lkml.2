Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451Ab2CNTXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:23:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57045 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2CNTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:23:37 -0400
Date: Wed, 14 Mar 2012 16:17:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jan Beulich <JBeulich@suse.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: adjust make rules
Message-ID: <20120314191758.GD9528@infradead.org>
References: <4F588A0802000078000770FF@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F588A0802000078000770FF@nat28.tlf.novell.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 08, 2012 at 09:29:28AM +0000, Jan Beulich escreveu:
> Add rules to generate pre-processed files (just like are available for
> the normal kernel build), and adjust the rule to create assembly files
> from C ones to produce its output in the output directory rather than
> in the source tree.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

I'm trying to use it but hit this:

[acme@sandy linux]$ make -C tools/perf/ O=/home/git/build/perf /home/git/build/perf/perf.s
make: Entering directory `/home/git/linux/tools/perf'
    CC /home/git/build/perf/perf.s
perf.c: In function ‘handle_options’:
perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
perf.c:111: error: (Each undeclared identifier is reported only once
perf.c:111: error: for each function it appears in.)
perf.c: At top level:
perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
make: *** [/home/git/build/perf/perf.s] Error 1
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]

Do I have to go to tools/perf and do it from there, trying...

[acme@sandy perf]$ make O=/home/git/build/perf /home/git/build/perf/perf.s
    CC /home/git/build/perf/perf.s
perf.c: In function ‘handle_options’:
perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
perf.c:111: error: (Each undeclared identifier is reported only once
perf.c:111: error: for each function it appears in.)
perf.c: At top level:
perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
make: *** [/home/git/build/perf/perf.s] Error 1
[acme@sandy perf]$ make O=/home/git/build/perf perf.s
make: *** No rule to make target `perf.s'.  Stop.
[acme@sandy perf]$

Same result, what am I doing wrong?

- Arnaldo
 
> ---
>  tools/perf/Makefile |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- 3.3-rc6/tools/perf/Makefile
> +++ 3.3-rc6-perf-make-rules/tools/perf/Makefile
> @@ -706,10 +706,14 @@ $(OUTPUT)perf.o perf.spec \
>  
>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> +$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
>  $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
> +	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
>  $(OUTPUT)%.o: %.S
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> +$(OUTPUT)%.s: %.S
> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
>  
>  $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> 
> 
