Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031995Ab2COR2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:28:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030242Ab2COR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:28:38 -0400
Date: Thu, 15 Mar 2012 14:28:30 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jan Beulich <JBeulich@suse.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: adjust make rules
Message-ID: <20120315172830.GF9528@infradead.org>
References: <4F588A0802000078000770FF@nat28.tlf.novell.com>
 <20120314191758.GD9528@infradead.org>
 <4F61EB380200007800078A79@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F61EB380200007800078A79@nat28.tlf.novell.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 15, 2012 at 12:14:32PM +0000, Jan Beulich escreveu:
> >>> On 14.03.12 at 20:17, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> wrote:
> > Em Thu, Mar 08, 2012 at 09:29:28AM +0000, Jan Beulich escreveu:
> >> Add rules to generate pre-processed files (just like are available for
> >> the normal kernel build), and adjust the rule to create assembly files
> >> from C ones to produce its output in the output directory rather than
> >> in the source tree.
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > 
> > I'm trying to use it but hit this:
> > 
> > [acme@sandy linux]$ make -C tools/perf/ O=/home/git/build/perf 
> > /home/git/build/perf/perf.s
> > make: Entering directory `/home/git/linux/tools/perf'
> >     CC /home/git/build/perf/perf.s
> > perf.c: In function ‘handle_options’:
> > perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
> > perf.c:111: error: (Each undeclared identifier is reported only once
> > perf.c:111: error: for each function it appears in.)
> > perf.c: At top level:
> > perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
> > make: *** [/home/git/build/perf/perf.s] Error 1
> > make: Leaving directory `/home/git/linux/tools/perf'
> > [acme@sandy linux]
> > 
> > Do I have to go to tools/perf and do it from there, trying...
> 
> No. perf.c just is a bad example - perf.o has a special make rule,
> and hence the pattern rule for perf.s fails because the symbols
> defined for perf.o don't get also defined for perf.s. Those special
> rules look pretty strange anyway - as long as using GNU make is a
> requirement, they could be re-written to use the pattern rule, and
> then would be much easier to extend to cover .i and .s generation
> as well.

Feel free to provide patches if you have the time to improve this
situation.

IIRC these things came from the git sources, having them closer to the
kernel Makefile practices would be good.
 
> Using the rules added in this patch works fine for me for any of the
> source files that don't have custom .o rules (which is what I needed
> when I came up with this patch).

Ok, I just tried it with another target and it worked. Applying.
 
> Jan
> 
> > [acme@sandy perf]$ make O=/home/git/build/perf /home/git/build/perf/perf.s
> >     CC /home/git/build/perf/perf.s
> > perf.c: In function ‘handle_options’:
> > perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
> > perf.c:111: error: (Each undeclared identifier is reported only once
> > perf.c:111: error: for each function it appears in.)
> > perf.c: At top level:
> > perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
> > make: *** [/home/git/build/perf/perf.s] Error 1
> > [acme@sandy perf]$ make O=/home/git/build/perf perf.s
> > make: *** No rule to make target `perf.s'.  Stop.
> > [acme@sandy perf]$
> > 
> > Same result, what am I doing wrong?
> > 
> > - Arnaldo
> >  
> >> ---
> >>  tools/perf/Makefile |    6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >> 
> >> --- 3.3-rc6/tools/perf/Makefile
> >> +++ 3.3-rc6-perf-make-rules/tools/perf/Makefile
> >> @@ -706,10 +706,14 @@ $(OUTPUT)perf.o perf.spec \
> >>  
> >>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
> >>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> >> +$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
> >> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
> >>  $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
> >> -	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
> >> +	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
> >>  $(OUTPUT)%.o: %.S
> >>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> >> +$(OUTPUT)%.s: %.S
> >> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
> >>  
> >>  $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
> >>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> >> 
> >> 
> 
