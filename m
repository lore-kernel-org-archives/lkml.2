Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab0EEECO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 00:02:14 -0400
Received: from mail-iw0-f203.google.com ([209.85.223.203]:37483 "EHLO
	mail-iw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0EEECM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 00:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S1Cn7M1sobeQXfpYB7ndLzjNBT2wXJILRMmzb/+nJpsafMQDigq68A3tJTmdKtvcxZ
         UgXvpdH1jj6v3Ebjr/0vwZ8ivu6KB6Uv5gPWtcOqr9frvVv07QKCiC5ZewwKlL5ViE1p
         pj8Lv01WxAazDRNkst3Sneswrr9aewIQFFnQE=
Subject: [PATCH] perf/trace: use read() instead of lseek() in
 trace_event_read.c:skip()
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 04 May 2010 23:02:10 -0500
Message-Id: <1273032130.6383.28.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a small fix for a problem affecting live-mode, introduced in the
past day or so:

root@tropicana:~# perf trace rwtop
perf trace started with Perl
script /root/libexec/perf-core/scripts/perl/rwtop.pl

  Fatal: did not read header event

commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
function to skip over e.g. header_page, but this doesn't work for live
mode.  This patch re-implements skip() to use read() instead of
lseek() to fix that.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-read.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index cb54cd0..f55cc3a 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -53,12 +53,6 @@ static unsigned long	page_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-/* If it fails, the next read will report it */
-static void skip(int size)
-{
-	lseek(input_fd, size, SEEK_CUR);
-}
-
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -98,6 +92,19 @@ static int read_or_die(void *data, int size)
 	return r;
 }
 
+/* If it fails, the next read will report it */
+static void skip(int size)
+{
+	char buf[BUFSIZ];
+	int r;
+
+	while (size) {
+		r = size > BUFSIZ ? BUFSIZ : size;
+		read_or_die(buf, r);
+		size -= r;
+	};
+}
+
 static unsigned int read4(void)
 {
 	unsigned int data;
-- 
1.6.4.GIT



