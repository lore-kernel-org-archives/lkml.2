Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1BOGx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:53:56 -0500
Received: from smtp-relay1.palm.com ([63.80.53.70]:38974 "EHLO
	smtp-relay1.palm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1BOGxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:53:54 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 01:53:54 EST
X-IronPort-AV: E=Sophos;i="4.60,473,1291622400"; 
   d="scan'208";a="34220444"
From: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Feb 2011 22:43:47 -0800
Subject: Question about clearing of tsk->robust_list in clone
Thread-Topic: Question about clearing of tsk->robust_list in clone
Thread-Index: AQHLzNjxwFse+SuB2kymKMYIZTKndg==
Message-ID: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BF6C Bosz Boyh B2mQ CH9g D5f+ FLmL FQW8 FXJy F3qu HMPY
 HpMC H1uX H9RJ LTUq
 MN1r;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{AF34F1DF-1CF6-4A75-A42D-938228F72F8D};awBlAG4AbgBlAHQAaAAuAGEAbABiAGEAbgBvAHcAcwBrAGkAQABwAGEAbABtAC4AYwBvAG0A;Tue,
 15 Feb 2011 06:43:47
 GMT;UQB1AGUAcwB0AGkAbwBuACAAYQBiAG8AdQB0ACAAYwBsAGUAYQByAGkAbgBnACAAbwBmACAAdABzAGsALQA+AHIAbwBiAHUAcwB0AF8AbABpAHMAdAAgAGkAbgAgAGMAbABvAG4AZQA=
x-cr-puzzleid: {AF34F1DF-1CF6-4A75-A42D-938228F72F8D}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been tracking down a bug I ran into with a robust pthreads mutex
shared between a parent and a child that it forked. This finally came
down to a bad interaction between glibc and the kernel (and looks to
be present in the current Linux trees as well as glibc 2.13): 
copy_process() explicitly clears the robust_list pointer in the cloned
child. However, there is currently no logic in nptl to re-establish
the robust list pointer after a fork.

There was some conversation about this in the Fedora bugtracker:

  https://bugzilla.redhat.com/show_bug.cgi?id=628608

Those folks appear to have reached the same conclusion as I: this
could either be solved with some potentially complex glibc code, or by
simply not having the kernel NULL out robust_list in the child.

That code came in at:

    commit 8f17d3a5049d32392b79925c73a0cf99ce6d5af0
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Mon Mar 27 01:16:27 2006 -0800

        [PATCH] lightweight robust futexes updates
    
        - fix: initialize the robust list(s) to NULL in copy_process.
    
        - doc update
    
        - cleanup: rename _inuser to _inatomic
    
        - __user cleanups and other small cleanups
    
Can anyone say what problem was being fixed by initializing the robust
list(s) to NULL? I've stared at the implementation, and I cannot see any
harm (potentially a slight bit more work in exec, but no harm) in not
clearing them.

Test program appended, to demonstrate the issue somewhat concisely.

- Kenneth

-- child_robust_mutex_death.c --
#define _GNU_SOURCE // for ROBUST mutexes from pthread.h
#include <sys/mman.h>
#include <sys/wait.h>
#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>

int main()
{
  // Use an anonymous shared mapping to put the same mutex in child as in parent. Any other
  // sharing technique would work, this is simply easy and doesn't clutter.
  void * region = mmap(NULL, 4096, PROT_READ|PROT_WRITE,MAP_SHARED|MAP_ANONYMOUS, -1, 0);
  pthread_mutex_t * mutex = (pthread_mutex_t*)region;

  pthread_mutexattr_t attr;

  pthread_mutexattr_init(&attr);
  pthread_mutexattr_setrobust_np(&attr, PTHREAD_MUTEX_ROBUST_NP);
  pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
  pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
  pthread_mutex_init(mutex, &attr); 

  if (fork() == 0) {
    // child
    // To demonstrate issue, this lock must occur directly in a fork child which has not exec'd, and
    // not in a thread created via pthread_create after forking.
    pthread_mutex_lock(mutex);

    // We now exit from the child, which should trigger the robust mechanism to clean up the mutex.
    _exit(0);
    
  } else {
    // parent
    wait(NULL); // wait for child to die.
    
    // try to obtain the lock, indicating whether the child still has it. This test could be
    // done from any process with access to the mutex, it is merely convenient to do it from
    // the parent.
      
    int err = pthread_mutex_trylock(mutex);
    if (err == 0) {
      printf("Failed, mutex unlocked, but no EOWNERDEAD -- I don't know what happened.\n");
    } else if (err == EBUSY) {
      printf("Failed, mutex not unlocked -- fork child tsk->robust_list == NULL issue.\n");
    } else if (err == EOWNERDEAD) {
      printf("Success, robust mutex reported owner death as intended.\n");
    }
    _exit(0);
  }
}

