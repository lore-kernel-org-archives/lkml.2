Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0FQOTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:19:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab0FQOTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:19:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, carns@mcs.anl.gov
Subject: [patch] cfq: Don't allow queue merges for queues that have no process references
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 17 Jun 2010 10:19:11 -0400
Message-ID: <x49ocf9agio.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A user reported a kernel bug when running a particular program that did
the following:

created 32 threads
- each thread took a mutex, grabbed a global offset, added a buffer size
  to that offset, released the lock
- read from the given offset in the file
- created a new thread to do the same
- exited

The result is that cfq's close cooperator logic would trigger, as the
threads were issuing I/O within the mean seek distance of one another.
This workload managed to routinely trigger a use after free bug when
walking the list of merge candidates for a particular cfqq
(cfqq->new_cfqq).  The logic used for merging queues looks like this:

static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
{
	int process_refs, new_process_refs;
	struct cfq_queue *__cfqq;

	/* Avoid a circular list and skip interim queue merges */
	while ((__cfqq = new_cfqq->new_cfqq)) {
		if (__cfqq == cfqq)
			return;
		new_cfqq = __cfqq;
	}

	process_refs = cfqq_process_refs(cfqq);
	/*
	 * If the process for the cfqq has gone away, there is no
	 * sense in merging the queues.
	 */
	if (process_refs == 0)
		return;

	/*
	 * Merge in the direction of the lesser amount of work.
	 */
	new_process_refs = cfqq_process_refs(new_cfqq);
	if (new_process_refs >= process_refs) {
		cfqq->new_cfqq = new_cfqq;
		atomic_add(process_refs, &new_cfqq->ref);
	} else {
		new_cfqq->new_cfqq = cfqq;
		atomic_add(new_process_refs, &cfqq->ref);
	}
}

When a merge candidate is found, we add the process references for the
queue with less references to the queue with more.  The actual merging
of queues happens when a new request is issued for a given cfqq.  In the
case of the test program, it only does a single pread call to read in
1MB, so the actual merge never happens.

Normally, this is fine, as when the queue exits, we simply drop the
references we took on the other cfqqs in the merge chain:

	/*
	 * If this queue was scheduled to merge with another queue, be
	 * sure to drop the reference taken on that queue (and others in
	 * the merge chain).  See cfq_setup_merge and cfq_merge_cfqqs.
	 */
	__cfqq = cfqq->new_cfqq;
	while (__cfqq) {
		if (__cfqq == cfqq) {
			WARN(1, "cfqq->new_cfqq loop detected\n");
			break;
		}
		next = __cfqq->new_cfqq;
		cfq_put_queue(__cfqq);
		__cfqq = next;
	}

However, there is a hole in this logic.  Consider the following (and
keep in mind that each I/O keeps a reference to the cfqq):

q1->new_cfqq = q2   // q2 now has 2 process references
q3->new_cfqq = q2   // q2 now has 3 process references

// the process associated with q2 exits
// q2 now has 2 process references

// queue 1 exits, drops its reference on q2
// q2 now has 1 process reference

// q3 exits, so has 0 process references, and hence drops its references
// to q2, which leaves q2 also with 0 process references

q4 comes along and wants to merge with q3

q3->new_cfqq still points at q2!  We follow that link and end up at an
already freed cfqq.

So, the fix is to not follow a merge chain if the top-most queue does
not have a process reference, otherwise any queue in the chain could be
already freed.  I also changed the logic to disallow merging with a
queue that does not have any process references.  Previously, we did
this check for one of the merge candidates, but not the other.  That
doesn't really make sense.

Without the attached patch, my system would BUG within a couple of
seconds of running the reproducer program.  With the patch applied, my
system ran the program for over an hour without issues.

This addresses the following bugzilla:
    https://bugzilla.kernel.org/show_bug.cgi?id=16217

Thanks a ton to Phil Carns for providing the bug report and an excellent
reproducer.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Phil Carns <carns@mcs.anl.gov>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ff4f48..153f627 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1986,6 +1986,15 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	int process_refs, new_process_refs;
 	struct cfq_queue *__cfqq;
 
+	/*
+	 * If there are no process references on the new_cfqq, then it is
+	 * unsafe to follow the ->new_cfqq chain as other cfqq's in the
+	 * chain may have dropped their last reference (not just their
+	 * last process reference).
+	 */
+	if (!cfqq_process_refs(new_cfqq))
+		return;
+
 	/* Avoid a circular list and skip interim queue merges */
 	while ((__cfqq = new_cfqq->new_cfqq)) {
 		if (__cfqq == cfqq)
@@ -1994,17 +2003,17 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 
 	process_refs = cfqq_process_refs(cfqq);
+	new_process_refs = cfqq_process_refs(new_cfqq);
 	/*
 	 * If the process for the cfqq has gone away, there is no
 	 * sense in merging the queues.
 	 */
-	if (process_refs == 0)
+	if (process_refs == 0 || new_process_refs == 0)
 		return;
 
 	/*
 	 * Merge in the direction of the lesser amount of work.
 	 */
-	new_process_refs = cfqq_process_refs(new_cfqq);
 	if (new_process_refs >= process_refs) {
 		cfqq->new_cfqq = new_cfqq;
 		atomic_add(process_refs, &new_cfqq->ref);
