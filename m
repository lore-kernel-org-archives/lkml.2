Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2HTB5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 21:57:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46853 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2HTB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 21:57:19 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-45-5031997cfe6d
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf ui/gtk: Ensure not to call gtk_main_quit() twice
References: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
	<CAOJsxLEZjxa1ySfVJeD-GJ5_Gi=nJTn40rCSu+PHhXjwn633oQ@mail.gmail.com>
Date: Mon, 20 Aug 2012 10:50:21 +0900
In-Reply-To: <CAOJsxLEZjxa1ySfVJeD-GJ5_Gi=nJTn40rCSu+PHhXjwn633oQ@mail.gmail.com>
	(Pekka Enberg's message of "Sat, 18 Aug 2012 10:52:03 +0300")
Message-ID: <878vdajpr6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012 10:52:03 +0300, Pekka Enberg wrote:
> On Fri, Aug 17, 2012 at 7:56 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Currently the gtk_main_quit() is called twice when perf exits so the
>> following warning is emitted:
>>
>>   [penberg@tux perf]$ ./perf report --gtk
>>   ^Cperf: Interrupt
>>
>>   (perf:4048): Gtk-CRITICAL **: IA__gtk_main_quit: assertion `main_loops != NULL' failed
>>
>> Fix it by not to call it unnecessarily.
>>
>> Reported-by: Pekka Enberg <penberg@kernel.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/ui/gtk/setup.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
>> index ad40b3626fdb..ec1ee26b485a 100644
>> --- a/tools/perf/ui/gtk/setup.c
>> +++ b/tools/perf/ui/gtk/setup.c
>> @@ -13,6 +13,8 @@ int perf_gtk__init(void)
>>
>>  void perf_gtk__exit(bool wait_for_ok __used)
>>  {
>> +       if (!perf_gtk__is_active_context(pgctx))
>> +               return;
>>         perf_error__unregister(&perf_gtk_eops);
>>         gtk_main_quit();
>>  }
>
> Wouldn't it be nicer to rearrange the callers so that perf_gtk__exit()
> is not called twice?

You mean this?


diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index c7820e569660..d25e145e9a89 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -2,6 +2,7 @@
 
 #include "../cache.h"
 #include "../debug.h"
+#include "gtk/gtk.h"
 
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
@@ -37,7 +38,8 @@ void exit_browser(bool wait_for_ok)
 {
 	switch (use_browser) {
 	case 2:
-		perf_gtk__exit(wait_for_ok);
+		if (perf_gtk__is_active_context(pgctx))
+			perf_gtk__exit(wait_for_ok);
 		break;
 
 	case 1:

