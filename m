Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1DSTLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:11:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1DSTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VhSIA1P8I4Kg1VS6nDoyO7uF6yZxuE3cCNwxzI0XHrGh/2qW4bk9Tnppp2ylRRCCEm
         DrI7vjuCoDzphYf5iiVA==
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 19:10:49 +0000
Message-ID: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
Subject: [BUG] perf_event: sampling buffer format cannot handle multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the sampling buffer format and I think there is an
issue in case
one samples on more than one event at a time and each event as a different
sample_type value (i.e., what it wants to record in each sample).

The sample_type is exported per-event by the API. In order to decode a sample
(PERF_RECORD_SAMPLE) one has to know which event caused it. To identify
the event, one has to include PERF_SAMPLE_ID in the sample_type. Each such
id uniquely identifies an event. Assuming the tool keeps a mapping of event to
ID, we can then reconstruct. This is what perf does.

The problem is that to extract the event ID, one has to already parse the sample
itself. That means, you need sample_type to extract the event ID.

Thus, we have a catch 22 situation.

Looking at the perf tool, it sort of works today simply because the
same sample_type
is applied to all events.

To solve this, we could either:
   - add the event ID to the header for PERF_RECORD_SAMPLE
   - enforce event ID is systematically saved at the beginning on
PERF_RECORD_SAMPLE

None of those options is transparent, I am afraid, unless we introduce
new record types.
