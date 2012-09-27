Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2I0Exs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:53:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56788 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2I0Exr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:53:47 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-08-5063dbd813a4
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: <acme@redhat.com>, <mingo@elte.hu>, <a.p.zijlstra@chello.nl>,
        <andi@firstfloor.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v3 3/9] perf script: Add more filter to find_scripts()
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
	<1348500251-9937-4-git-send-email-feng.tang@intel.com>
	<87lifyyiug.fsf@sejong.aot.lge.com> <20120926165641.74f2e5b3@feng-i7>
Date: Thu, 27 Sep 2012 13:45:30 +0900
In-Reply-To: <20120926165641.74f2e5b3@feng-i7> (Feng Tang's message of "Wed,
	26 Sep 2012 16:56:41 +0800")
Message-ID: <87vcf0ul91.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2012 16:56:41 +0800, Feng Tang wrote:
> On Tue, 25 Sep 2012 10:47:03 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>> It can't recognize extra spaces, multiple events connected by commas,
>> event groups and probably more..  So I think it'd better if we can use
>> parse_events() here - but w/o an evlist.  Jiri, what do you think?
>
> Yes, this func was really a pain to me :) And fortunately, current
> intree "xxx-record" scripts are all in simple format: "-e eventname ",
> and this lightweight func basically works fine.
>
> I agree that we'd better have a separate parse_events() similar func 
> to cherry-pick the events names in parse-events.c, to not make
> hists.c too heavy. 
>
> And frankly speaking, I'm not familiar at all with these flex/bison
> handling, so can we do things in steps: fixes those space issue, add
> a "fixme" in comments and push the basically working version first?

It'd not that hard.  How about using below (untested) patch?

Thanks,
Namhyung


diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index bf5d033ee1b4..5dc71f598028 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -817,6 +817,21 @@ int parse_events_terms(struct list_head *terms, const char *str)
 	return ret;
 }
 
+int __parse_events(struct list_head *evsel_list, const char *str)
+{
+	int ret;
+	struct parse_events_data__events data = {
+		.list = LIST_HEAD_INIT(data.list),
+	};
+
+	ret = parse_events__scanner(str, &data, PE_START_EVENTS);
+	if (!ret) {
+		list_splice(evsel_list, &data.list);
+		return 0;
+	}
+	return -1;
+}
+
 int parse_events(struct perf_evlist *evlist, const char *str,
 		 int unset __maybe_unused)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c356e443448d..c13e9bd0f041 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -32,6 +32,7 @@ extern int parse_events_option(const struct option *opt, const char *str,
 extern int parse_events(struct perf_evlist *evlist, const char *str,
 			int unset);
 extern int parse_events_terms(struct list_head *terms, const char *str);
+extern int __parse_events(struct list_head *evsel_list, const char *str);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
 #define EVENTS_HELP_MAX (128*1024)
