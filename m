Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3AGTuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:50:22 -0500
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55061 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3AGTuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:50:20 -0500
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
	<1357333518-28899-2-git-send-email-gthelen@google.com>
	<20130107174427.GM3926@htj.dyndns.org>
Date: Mon, 07 Jan 2013 11:50:17 -0800
In-Reply-To: <20130107174427.GM3926@htj.dyndns.org> (Tejun Heo's message of
	"Mon, 7 Jan 2013 09:44:27 -0800")
Message-ID: <xr93a9sklqme.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07 2013, Tejun Heo wrote:

> On Fri, Jan 04, 2013 at 01:05:18PM -0800, Greg Thelen wrote:
>> If the <absolute-path-to-control-file> command line parameter cannot
>> be opened, then cgroup_event_listener prints an error message and
>> tries to return an error.  However, due to an uninitialized variable
>> the return value was undefined.
>> 
>> With this patch such failures always return non-zero error.
>> 
>> Compiler warning found this:
>>   $ gcc -Wall -O2 cgroup_event_listener.c
>>   cgroup_event_listener.c: In function ‘main’:
>>   cgroup_event_listener.c:109:2: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  tools/cgroup/cgroup_event_listener.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
>> index 3e082f9..a70f00c 100644
>> --- a/tools/cgroup/cgroup_event_listener.c
>> +++ b/tools/cgroup/cgroup_event_listener.c
>> @@ -35,7 +35,7 @@ int main(int argc, char **argv)
>>  	if (cfd == -1) {
>>  		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
>>  				strerror(errno));
>> -		goto out;
>> +		return 1;
>
> Hmm... so, event_control open failure path is broken the same way.
> Can you please fix it together?  Please just remove the cleanup path.

Done.  Patch below.

---8<---
cgroups: fix cgroup_event_listener error handling

The error handling in cgroup_event_listener.c did not correctly deal
with either an error opening either <control_file> or
cgroup.event_control.  Due to an uninitialized variable the program
exit code was undefined if either of these opens failed.

This patch simplifies and corrects cgroup_event_listener.c error
handling by:
1. using err*() rather than printf(),exit()
2. depending on process exit to close open files

With this patch failures always return non-zero error.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 tools/cgroup/cgroup_event_listener.c |   72 ++++++++++-----------------------
 1 files changed, 22 insertions(+), 50 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
index 3e082f9..4eb5507 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -5,6 +5,7 @@
  */
 
 #include <assert.h>
+#include <err.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
@@ -15,7 +16,7 @@
 
 #include <sys/eventfd.h>
 
-#define USAGE_STR "Usage: cgroup_event_listener <path-to-control-file> <args>\n"
+#define USAGE_STR "Usage: cgroup_event_listener <path-to-control-file> <args>"
 
 int main(int argc, char **argv)
 {
@@ -26,49 +27,33 @@ int main(int argc, char **argv)
 	char line[LINE_MAX];
 	int ret;
 
-	if (argc != 3) {
-		fputs(USAGE_STR, stderr);
-		return 1;
-	}
+	if (argc != 3)
+		errx(1, "%s", USAGE_STR);
 
 	cfd = open(argv[1], O_RDONLY);
-	if (cfd == -1) {
-		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
-				strerror(errno));
-		goto out;
-	}
+	if (cfd == -1)
+		err(1, "Cannot open %s", argv[1]);
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
 			dirname(argv[1]));
-	if (ret >= PATH_MAX) {
-		fputs("Path to cgroup.event_control is too long\n", stderr);
-		goto out;
-	}
+	if (ret >= PATH_MAX)
+		errx(1, "Path to cgroup.event_control is too long");
 
 	event_control = open(event_control_path, O_WRONLY);
-	if (event_control == -1) {
-		fprintf(stderr, "Cannot open %s: %s\n", event_control_path,
-				strerror(errno));
-		goto out;
-	}
+	if (event_control == -1)
+		err(1, "Cannot open %s", event_control_path);
 
 	efd = eventfd(0, 0);
-	if (efd == -1) {
-		perror("eventfd() failed");
-		goto out;
-	}
+	if (efd == -1)
+		err(1, "eventfd() failed");
 
 	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
-	if (ret >= LINE_MAX) {
-		fputs("Arguments string is too long\n", stderr);
-		goto out;
-	}
+	if (ret >= LINE_MAX)
+		errx(1, "Arguments string is too long");
 
 	ret = write(event_control, line, strlen(line) + 1);
-	if (ret == -1) {
-		perror("Cannot write to cgroup.event_control");
-		goto out;
-	}
+	if (ret == -1)
+		err(1, "Cannot write to cgroup.event_control");
 
 	while (1) {
 		uint64_t result;
@@ -77,34 +62,21 @@ int main(int argc, char **argv)
 		if (ret == -1) {
 			if (errno == EINTR)
 				continue;
-			perror("Cannot read from eventfd");
-			break;
+			err(1, "Cannot read from eventfd");
 		}
 		assert(ret == sizeof(result));
 
 		ret = access(event_control_path, W_OK);
 		if ((ret == -1) && (errno == ENOENT)) {
-				puts("The cgroup seems to have removed.");
-				ret = 0;
-				break;
-		}
-
-		if (ret == -1) {
-			perror("cgroup.event_control "
-					"is not accessible any more");
+			puts("The cgroup seems to have removed.");
 			break;
 		}
 
+		if (ret == -1)
+			err(1, "cgroup.event_control is not accessible any more");
+
 		printf("%s %s: crossed\n", argv[1], argv[2]);
 	}
 
-out:
-	if (efd >= 0)
-		close(efd);
-	if (event_control >= 0)
-		close(event_control);
-	if (cfd >= 0)
-		close(cfd);
-
-	return (ret != 0);
+	return 0;
 }
-- 
1.7.7.3

