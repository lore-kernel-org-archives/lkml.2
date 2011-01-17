Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1AQU2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 15:28:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60407 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1AQU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 15:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=bk3iJdvNextI30ZMWCwXSG+q7U82uLVPHLQDVL7yW/+5o8py9QsujSW93O5Xo5e8Kh
         zkwijFbxsUdR11uNIsQgzHXT9unG2mqZlkc5aQAwvdiy4kLGt2nPZQJa5dIopVJI2mYQ
         ehimwVy45CzlFOykApUdtc/V5A00nCghKM/Xk=
Date: Mon, 17 Jan 2011 18:28:01 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Han Pingtian <phan@redhat.com>
Subject: Re: [PATCH 1/2] perf-tools: Fix tracepoint event type recording
Message-ID: <20110117202801.GG2085@ghostprotocols.net>
References: <m34o97wg94.fsf@gmail.com>
 <20110117195034.GF2085@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117195034.GF2085@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 17, 2011 at 05:50:34PM -0200, Arnaldo Carvalho de Melo escreveu:
> > +	if (perf_header__push_event(id, *strp, len) < 0)
> > +		return EVT_FAILED;
> 
> Since you're changing the point where perf_header__push_event() is
> called, consider doing it _after_ parse_events() finishes, by traversing
> the evsel_list, that way, as a bonus, later, in perf/core we can kill
> some more global variables:
> 
> static int event_count;
> static struct perf_trace_event_type *events;
> 
> These variables should be in 'struct perf_header', but anyway, this is
> for later, I'm digressing, please just try to do it after
> parse_events(), traversing the evsel_list and getting the tracepoint
> name in string form using event_name(evsel) (that also uses an static
> variagle, argh, another fix to do).
> 
> Doing it that way and excluding the strnlen cleanup, the patch should be
> much smaller.
> 
> We also untie event parsing from header handling, that are only together
> in record, not in, say, top.

So here is the minimal patch, tested with:

[root@felicio l]# perf record -a -e sched:* sleep 2
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 2.180 MB perf.data (~95232 samples) ]
[root@felicio l]# hexdump -s 0x6e8 -C perf.data -n 512
000006e8  39 00 00 00 00 00 00 00  73 63 68 65 64 3a 73 63  |9.......sched:sc|
000006f8  68 65 64 5f 6b 74 68 72  65 61 64 5f 73 74 6f 70  |hed_kthread_stop|
00000708  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000728  00 00 00 00 00 00 00 00  38 00 00 00 00 00 00 00  |........8.......|
00000738  73 63 68 65 64 3a 73 63  68 65 64 5f 6b 74 68 72  |sched:sched_kthr|
00000748  65 61 64 5f 73 74 6f 70  5f 72 65 74 00 00 00 00  |ead_stop_ret....|
00000758  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000778  37 00 00 00 00 00 00 00  73 63 68 65 64 3a 73 63  |7.......sched:sc|
00000788  68 65 64 5f 77 61 6b 65  75 70 00 00 00 00 00 00  |hed_wakeup......|
00000798  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000007b8  00 00 00 00 00 00 00 00  36 00 00 00 00 00 00 00  |........6.......|
000007c8  73 63 68 65 64 3a 73 63  68 65 64 5f 77 61 6b 65  |sched:sched_wake|
000007d8  75 70 5f 6e 65 77 00 00  00 00 00 00 00 00 00 00  |up_new..........|
000007e8  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000808  35 00 00 00 00 00 00 00  73 63 68 65 64 3a 73 63  |5.......sched:sc|
00000818  68 65 64 5f 73 77 69 74  63 68 00 00 00 00 00 00  |hed_switch......|
00000828  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000848  00 00 00 00 00 00 00 00  34 00 00 00 00 00 00 00  |........4.......|
00000858  73 63 68 65 64 3a 73 63  68 65 64 5f 6d 69 67 72  |sched:sched_migr|
00000868  61 74 65 5f 74 61 73 6b  00 00 00 00 00 00 00 00  |ate_task........|
00000878  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000898  33 00 00 00 00 00 00 00  73 63 68 65 64 3a 73 63  |3.......sched:sc|
000008a8  68 65 64 5f 70 72 6f 63  65 73 73 5f 66 72 65 65  |hed_process_free|
000008b8  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000008d8  00 00 00 00 00 00 00 00  32 00 00 00 00 00 00 00  |........2.......|
000008e8
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_kthread_stop/id 
57
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_kthread_stop_ret/id 
56
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_wakeup/id 
55
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/id 
54
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_wakeup_switch/id 
cat: /sys/kernel/debug/tracing/events/sched/sched_wakeup_switch/id: No such file or directory
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_switch/id 
53
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_migrate_task/id 
52
[root@felicio l]# cat /sys/kernel/debug/tracing/events/sched/sched_process_free/id 
51
[root@felicio l]# 

See the 0x39, 0x38, 0x37, 0x36, just before the tracepoint names? :-)

It trows all this perf_header stuff out of the parsing routines and moves it to
record, where it belongs. No need to re-open the /sys/ file again to get something
we already have in perf_evsel->attr.config and that was parsed, opening the /sys
file in parse_single_tracepoint_event.

Please let me know if you see any hole in it.

- Arnaldo

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index df6064a..fcd29e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -936,6 +936,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	list_for_each_entry(pos, &evsel_list, node) {
 		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
+		if (perf_header__push_event(pos->attr.config, event_name(pos)))
+			goto out_free_fd;
 	}
 	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
 			      MAX_COUNTERS * threads->nr));
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1f4cfe5..bc2732e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,32 +490,6 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
@@ -559,9 +533,6 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else {
-		if (store_event_type(evt_name) < 0)
-			return EVT_FAILED;
-
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
 	}
