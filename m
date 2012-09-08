Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2IHOAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:00:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60726 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2IHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:00:45 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET RESEND 0/5] perf tools: Cleanup hist printing code (v4)
References: <1346640790-17197-1-git-send-email-namhyung@kernel.org>
	<20120908004854.GD20401@ghostprotocols.net>
Date: Sat, 08 Sep 2012 23:00:36 +0900
In-Reply-To: <20120908004854.GD20401@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 7 Sep 2012 17:48:54 -0700")
Message-ID: <87ipboaa2j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Fri, 7 Sep 2012 17:48:54 -0700, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 03, 2012 at 11:53:05AM +0900, Namhyung Kim escreveu:
>> This is a cleanup and refactoring patchset for the hist printing code
>> by adding perf_hpp__format functions and perf_hpp.  I believe it makes
>> the code easy to maintain and to add new features like upcoming group
>> viewing and callchain accumulation.
>
> I applied this patch series to then get some patches from Jiri's 'perf
> diff' series, so that he can use what you did here, as you noticed the
> overlap when reviewing his series.
>
> But then 'perf diff' segfaults :-\
>
> I left your patch series + with that overhead column fixlet at my tree,
> branch tmp.perf/hpp.
>
> The segfaults happens here:
>
> Program received signal SIGSEGV, Segmentation fault.
> 0x0000000000498837 in hpp__entry_delta (hpp=0x7fffffffdeb0, he=0xcd6310) at ui/hist.c:200
> 200			old_percent = 100.0 * he->pair->period / old_total;
> Missing separate debuginfos, use: debuginfo-install atk-1.28.0-2.el6.x86_64 bzip2-libs-1.0.5-7.el6_0.x86_64 elfutils-libelf-0.152-1.el6.x86_64 elfutils-libs-0.152-1.el6.x86_64 expat-2.0.1-11.el6_2.x86_64 fontconfig-2.8.0-3.el6.x86_64 freetype-2.3.11-6.el6_2.9.x86_64 glib2-2.22.5-7.el6.x86_64 gtk2-2.18.9-10.el6.x86_64 libX11-1.3-2.el6.x86_64 libXau-1.0.5-1.el6.x86_64 libXcomposite-0.4.1-2.el6.x86_64 libXcursor-1.1.10-2.el6.x86_64 libXdamage-1.1.2-1.el6.x86_64 libXext-1.1-3.el6.x86_64 libXfixes-4.0.4-1.el6.x86_64 libXi-1.3-3.el6.x86_64 libXinerama-1.1-1.el6.x86_64 libXrandr-1.3.0-4.el6.x86_64 libXrender-0.9.5-1.el6.x86_64 libpng-1.2.49-1.el6_2.x86_64 libselinux-2.0.94-5.3.el6.x86_64 libxcb-1.5-1.el6.x86_64 nss-softokn-freebl-3.12.9-11.el6.x86_64 pango-1.28.1-3.el6_0.5.x86_64 perl-libs-5.10.1
>  -127.el6.x86_64 pixman-0.18.4-1.el6_0.1.x86_64 xz-libs-4.999.9-0.3.beta.20091007git.el6.x86_64 zlib-1.2.3-27.el6.x86_64
> (gdb) p he->pair
> $1 = (struct hist_entry *) 0x0
>
> Please try with:
>
>   perf record -a usleep 1
>   perf record -a usleep 1
>   perf diff
>
> it will use perf.data.old and perf.data and will segfault in that branch.

I see the problem.  I overlooked he->pair can be NULL when perf diff is
running.  So the fix will be adding a NULL check before the line.  In
case of NULL, it will default to 0, so no problem.

Thanks,
Namhyung


diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 16dc486d02be..3c2701fa6be1 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -196,7 +196,7 @@ static int hpp__entry_delta(struct perf_hpp *hpp, struct hist_entry *he)
 	char buf[32] = " ";
 
 	old_total = pair_hists->stats.total_period;
-	if (old_total > 0)
+	if (old_total > 0 && he->pair)
 		old_percent = 100.0 * he->pair->period / old_total;
 
 	new_total = hpp->total_period;

