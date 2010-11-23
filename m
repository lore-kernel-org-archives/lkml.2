Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab0KWFgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:36:09 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43370 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0KWFgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:36:07 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: perf: Timestamp COMM and MMAP events for correct attribution
Date: Tue, 23 Nov 2010 16:35:38 +1100
Message-Id: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a bug introduced with the per-task-per-cpu event
support in perf where PERF_RECORD_COMM and PERF_RECORD_MMAP events would arrive
and be recorded via one CPUs buffer much later than samples corresponding to
them arriving on another CPUs buffer, and would cause perf to mis-attribute
those events.

This has been observed on multiple systems, but is more common the more CPUs
present - on 64 CPU systems it is extremely common (one system tested occurred
~50% of the time, while another was >99%), while on my quad Intel i7 it is much
rarer (but I have observed it several times). Examining the data file with perf
report -D shows the COMM and MMAP events a long way through the file (80% or
more), well after many previous events.

This series introduces an ABI change to perf to add the timestamps to the MMAP
and COMM events so that they can be correlated with the samples corresponding
to them. The timestamps are requested from the kernel by setting the all_timed
bit in the attributes when opening the events and is placed just after the
event header of the events in question.

While not necessary to fix this bug (or any other AFAIK), I have also included
changes to the PERF_RECORD_READ and PERF_RECORD_LOST events to add the
timestamp in the same manner. This could be useful to support and if we did
eventually want to add it it would be easier to change all the events in
question at once. Those changes are in separate patches from the COMM and MMAP
changes so they can easily be dropped when merging this upstream if they are
unwanted.

