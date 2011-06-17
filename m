Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1FQSpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:45:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab1FQSpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :message-id:references:to:x-mailer;
        b=fR0aiRhKGEWUU5oHYnKdR+cTGjtUTzfS6rqJdTixNMitivpeaAEZI6uHN5kVaJj3IT
         uGDBZBQoqBWUfJOJSuD6ihV2fTPk/rm6Sk/NE0kjdeMLuMIqW95f7xb7j9zMV4Lcmgex
         wNAfaxMwKTklACUlplICMxx0db8+wSM65cRug=
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/mixed; boundary=Apple-Mail-26--683334308
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <20110611.160842.2135350880385482648.davem@davemloft.net>
Date: Fri, 17 Jun 2011 20:45:47 +0200
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <C6872B72-24ED-425D-BA9E-9983779B393A@googlemail.com>
References: <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org> <1307711453-17412-1-git-send-email-minipli@googlemail.com> <20110611.160842.2135350880385482648.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-26--683334308
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On 12.06.2011, 01:08 David Miller wrote:

> From: Mathias Krause <minipli@googlemail.com>
> Date: Fri, 10 Jun 2011 15:10:53 +0200
> 
>> The address limit is already set in flush_old_exec() so this
>> assignment of USER_DS is redundant.
>> 
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ...
>> @@ -368,9 +368,6 @@ void flush_thread(void)
>> 
>> 	/* Clear FPU register state. */
>> 	t->fpsaved[0] = 0;
>> -	
>> -	if (get_thread_current_ds() != ASI_AIUS)
>> -		set_fs(USER_DS);
>> }
> 
> Yeah but now you're doing it unconditionally, the guard is here
> because the %asi register write which set_fs() does is extremely
> expensive on sparc64 and %99.99999 of the time we can avoid it.


David, can you please use the attached test program to give us some
numbers on how expensive the write to the %asi register is, relative to
the complexity of the whole exec() path. Please test it w/ and w/o the
attached patch. If the difference is significant it might be worth the
pain to push the set_fs() down to the arch specific code, e.g. into
flush_thread() as on SPARC, and remove it from flush_old_exec().

For the test something like:
$ for i in 1 2 3; do echo "run #$i:"; time exec_test 5000 /bin/true; done
or better:
$ perf stat -r3 exec_test 5000 /bin/true
should give some reasonable numbers.

I've no SPARC machine, so can't test myself.


Thanks,
Mathias

--Apple-Mail-26--683334308
Content-Disposition: attachment;
	filename=exec_test.c
Content-Type: application/octet-stream;
	name="exec_test.c"
Content-Transfer-Encoding: 7bit

#include <sys/mman.h>
#include <sys/wait.h>

#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>


int main(int argc, char **argv, char **envp) {
	unsigned long loops;
	struct {
		unsigned long parent;
		unsigned long child;
	} *err;

	if (argc < 3) {
		printf("usage: %s LOOPS CMD [ARGS]\n", argv[0]);
		exit(1);
	}

	loops = strtoul(argv[1], NULL, 0);

	err = mmap(NULL, sizeof(*err), PROT_READ | PROT_WRITE,
	           MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if (err == MAP_FAILED) {
		printf("failed to create shared mapping (%s)\n", strerror(errno));
		exit(1);
	}

	err->parent = err->child = 0;
	while (loops--) {
		switch (fork()) {
			case 0:
				execve(argv[2], &argv[2], envp);
				err->child++;
				exit(1);
				break;

			case -1:
				err->parent++;
				break;

			default:
				wait(NULL);
		}
	}

	if (err->parent || err->child) {
		printf("fork() errors: %lu\n", err->parent);
		printf("exec() errors: %lu\n", err->child);
	}

	return 0;
}

--Apple-Mail-26--683334308
Content-Disposition: attachment;
	filename=no_unconditional_set_fs.diff
Content-Type: application/octet-stream;
	name="no_unconditional_set_fs.diff"
Content-Transfer-Encoding: 7bit

diff --git a/fs/exec.c b/fs/exec.c
index 97e0d52..31df75f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1093,7 +1093,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;		/* We're using it now */
 
-	set_fs(USER_DS);
 	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;

--Apple-Mail-26--683334308--
