Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950Ab2COMOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:14:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:23281 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2COMOg (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 15 Mar 2012 08:14:36 -0400
Message-Id: <4F61EB380200007800078A79@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 15 Mar 2012 12:14:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <paulus@samba.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: adjust make rules
References: <4F588A0802000078000770FF@nat28.tlf.novell.com>
 <20120314191758.GD9528@infradead.org>
In-Reply-To: <20120314191758.GD9528@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.12 at 20:17, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
wrote:
> Em Thu, Mar 08, 2012 at 09:29:28AM +0000, Jan Beulich escreveu:
>> Add rules to generate pre-processed files (just like are available for
>> the normal kernel build), and adjust the rule to create assembly files
>> from C ones to produce its output in the output directory rather than
>> in the source tree.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> I'm trying to use it but hit this:
> 
> [acme@sandy linux]$ make -C tools/perf/ O=/home/git/build/perf 
> /home/git/build/perf/perf.s
> make: Entering directory `/home/git/linux/tools/perf'
>     CC /home/git/build/perf/perf.s
> perf.c: In function ‘handle_options’:
> perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
> perf.c:111: error: (Each undeclared identifier is reported only once
> perf.c:111: error: for each function it appears in.)
> perf.c: At top level:
> perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
> make: *** [/home/git/build/perf/perf.s] Error 1
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]
> 
> Do I have to go to tools/perf and do it from there, trying...

No. perf.c just is a bad example - perf.o has a special make rule,
and hence the pattern rule for perf.s fails because the symbols
defined for perf.o don't get also defined for perf.s. Those special
rules look pretty strange anyway - as long as using GNU make is a
requirement, they could be re-written to use the pattern rule, and
then would be much easier to extend to cover .i and .s generation
as well.

Using the rules added in this patch works fine for me for any of the
source files that don't have custom .o rules (which is what I needed
when I came up with this patch).

Jan

> [acme@sandy perf]$ make O=/home/git/build/perf /home/git/build/perf/perf.s
>     CC /home/git/build/perf/perf.s
> perf.c: In function ‘handle_options’:
> perf.c:111: error: ‘PERF_HTML_PATH’ undeclared (first use in this function)
> perf.c:111: error: (Each undeclared identifier is reported only once
> perf.c:111: error: for each function it appears in.)
> perf.c: At top level:
> perf.c:238: error: ‘PERF_VERSION’ undeclared here (not in a function)
> make: *** [/home/git/build/perf/perf.s] Error 1
> [acme@sandy perf]$ make O=/home/git/build/perf perf.s
> make: *** No rule to make target `perf.s'.  Stop.
> [acme@sandy perf]$
> 
> Same result, what am I doing wrong?
> 
> - Arnaldo
>  
>> ---
>>  tools/perf/Makefile |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> --- 3.3-rc6/tools/perf/Makefile
>> +++ 3.3-rc6-perf-make-rules/tools/perf/Makefile
>> @@ -706,10 +706,14 @@ $(OUTPUT)perf.o perf.spec \
>>  
>>  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
>>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
>> +$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
>> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
>>  $(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
>> -	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
>> +	$(QUIET_CC)$(CC) -o $@ -S $(ALL_CFLAGS) $<
>>  $(OUTPUT)%.o: %.S
>>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
>> +$(OUTPUT)%.s: %.S
>> +	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
>>  
>>  $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
>> 
>> 


