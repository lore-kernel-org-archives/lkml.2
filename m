Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0EQOeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:34:23 -0400
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:20482 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0EQOeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:34:21 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 10:34:21 EDT
Message-ID: <4BF152B5.2060000@ixiacom.com>
Date: Mon, 17 May 2010 07:29:09 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Null clone CLONE_VM conundrum
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for some advice to focus my investigation.

I'm using 2.6.31 kernel on PowerPC with glibc version 2.7.

I've been looking into some anomalous behaviour with a program
that uses clone(2).

I've narrowed down the problem to interaction between
the program and the following null clone:

int nullClone(void*)
{
    return 0;
}

...

   pid_t childPid = clone(nullClone, stackPointer,
                          CLONE_VM | SIGCHLD,
                          0, 0, 0, 0);

   waitpid(childPid, &childStatus);


As you can see, the null clone is essentially a nop.


Commenting /* CLONE_VM | */, leaving only SIGCHLD (aka null fork(2))
makes the following problem to go away.


The problem I see is that subsequent to the clone(2):

   pthread_mutex_lock(parentMutex);
     ...
   pthread_mutex_unlock(parentMutex);

   /* Null clone here */

   pthread_mutex_lock(parentMutex);
     ...
   pthread_mutex_unlock(parentMutex);  <---- Gets stuck here.


The mutex in question is created with PTHREAD_PRIO_INHERIT.

There are a few more details regarding null threads which
I won't get into just yet. I need to try to distill the
problem into a smaller program.


I'm suspicious because I believe the null clone should not
have any effect on the caller -- but obviously does, and in
a way I don't understand.


Do you have suggestions as to where I should look next to explain
this anomalous behaviour ?

What effects might the null clone have on the mutex implementation
that I am not accounting for ?


Earl
