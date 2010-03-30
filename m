Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0CaAWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:22:38 -0400
Received: from kroah.org ([198.145.64.141]:49114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab0C3XMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:44 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:45 2010
Message-Id: <20100330225844.465920596@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:58:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Gruenbacher <agruen@suse.de>, Eric Paris <eparis@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [58/89] dnotify: ignore FS_EVENT_ON_CHILD
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Gruenbacher <agruen@suse.de>

commit 945526846a84c00adac1efd1c6befdaa77039623 upstream.

Mask off FS_EVENT_ON_CHILD in dnotify_handle_event().  Otherwise, when there
is more than one watch on a directory and dnotify_should_send_event()
succeeds, events with FS_EVENT_ON_CHILD set will trigger all watches and cause
spurious events.

This case was overlooked in commit e42e2773.

	#define _GNU_SOURCE

	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>
	#include <string.h>

	static void create_event(int s, siginfo_t* si, void* p)
	{
		printf("create\n");
	}

	static void delete_event(int s, siginfo_t* si, void* p)
	{
		printf("delete\n");
	}

	int main (void) {
		struct sigaction action;
		char *tmpdir, *file;
		int fd1, fd2;

		sigemptyset (&action.sa_mask);
		action.sa_flags = SA_SIGINFO;

		action.sa_sigaction = create_event;
		sigaction (SIGRTMIN + 0, &action, NULL);

		action.sa_sigaction = delete_event;
		sigaction (SIGRTMIN + 1, &action, NULL);

	#	define TMPDIR "/tmp/test.XXXXXX"
		tmpdir = malloc(strlen(TMPDIR) + 1);
		strcpy(tmpdir, TMPDIR);
		mkdtemp(tmpdir);

	#	define TMPFILE "/file"
		file = malloc(strlen(tmpdir) + strlen(TMPFILE) + 1);
		sprintf(file, "%s/%s", tmpdir, TMPFILE);

		fd1 = open (tmpdir, O_RDONLY);
		fcntl(fd1, F_SETSIG, SIGRTMIN);
		fcntl(fd1, F_NOTIFY, DN_MULTISHOT | DN_CREATE);

		fd2 = open (tmpdir, O_RDONLY);
		fcntl(fd2, F_SETSIG, SIGRTMIN + 1);
		fcntl(fd2, F_NOTIFY, DN_MULTISHOT | DN_DELETE);

		if (fork()) {
			/* This triggers a create event */
			creat(file, 0600);
			/* This triggers a create and delete event (!) */
			unlink(file);
		} else {
			sleep(1);
			rmdir(tmpdir);
		}

		return 0;
	}

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/dnotify/dnotify.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -91,6 +91,7 @@ static int dnotify_handle_event(struct f
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
 	struct fown_struct *fown;
+	__u32 test_mask = event->mask & ~FS_EVENT_ON_CHILD;
 
 	to_tell = event->to_tell;
 
@@ -106,7 +107,7 @@ static int dnotify_handle_event(struct f
 	spin_lock(&entry->lock);
 	prev = &dnentry->dn;
 	while ((dn = *prev) != NULL) {
-		if ((dn->dn_mask & event->mask) == 0) {
+		if ((dn->dn_mask & test_mask) == 0) {
 			prev = &dn->dn_next;
 			continue;
 		}


