Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0DIKXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:23:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0DIKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:23:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=jbj+soBtKIPAw0MNocBnQU9kSMnHpB+lfa4rJ1jCSyZW9K0KKwlbPWdrQ2HsPbZDn
	vmwDpN9yWAkSqSli5az1g==
MIME-Version: 1.0
Date: Fri, 9 Apr 2010 12:22:59 +0200
Message-ID: <q2lbd4cb8901004090322g1efb36cesc39a6848ab403e9f@mail.gmail.com>
Subject: [BUG] perf_events: PERF_FORMAT_GROUP fails
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been running some tests where I count and I am
using PERF_FORMAT_GROUP. I want to extract all counts
in one read().

It turns out that this does not work as expected. I would expect
that if I create an event group, I can ALWAYS read it with a single
read(). Turns out, it depends on the state of the events.

If the events are still attached to a task then the read() returns
the expected data  which is:

/*
 *      { u64           nr;
 *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
 *        { u64         time_running; } && PERF_FORMAT_RUNNING
 *        { u64         value;
 *          { u64       id;           } && PERF_FORMAT_ID
 *        }             cntr[nr];
 */

But if you read once the monitored task has died, i.e., events are detached,
then all you get is the data for the leader of the group yet the value
of nr still
shows all the members of the group.

Here is an example with 2 events + ENABLED+RUNNING:
  - task active, events attached: read()=40 (5* 8,
5=nr+enabled+running+2*value), nr=2
  - task died, event detached: read()=32 (4*8 =
nr+enabled+running+value) yet nr=2

Seems to me the events need to be linked in sibling_list regardless of the state
they are in. And there is mismatch in how nr_siblings and sibling_list
are managed.
