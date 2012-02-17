Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab2BQBAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58559 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756828Ab2BQBAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:11 -0500
X-Sasl-enc: U+n80A8S8BP817XiCx9IBT+uX+/Ha+ogyyMzvEK+ueJf 1329440410
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:34 2012
Message-Id: <20120217005534.460345654@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [03/28] perf evsel: Fix an issue where perf report fails to show the proper percentage
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

commit a4a03fc7ef89020baca4f19174e6a43767c6d78a upstream.

This patch fixes an issue where perf report shows nan% for certain
perf.data files. The below is from a report for a do_fork probe:

   -nan%           sshd  [kernel.kallsyms]  [k] do_fork
   -nan%    packagekitd  [kernel.kallsyms]  [k] do_fork
   -nan%    dbus-daemon  [kernel.kallsyms]  [k] do_fork
   -nan%           bash  [kernel.kallsyms]  [k] do_fork

A git bisect shows commit f3bda2c as the cause. However, looking back
through the git history, I saw commit 640c03c which seems to have
removed the required initialization for perf_sample->period. The problem
only started showing after commit f3bda2c. The below patch re-introduces
the initialization and it fixes the problem for me.

With the below patch, for the same perf.data:

  73.08%             bash  [kernel.kallsyms]  [k] do_fork
   8.97%      11-dhclient  [kernel.kallsyms]  [k] do_fork
   6.41%             sshd  [kernel.kallsyms]  [k] do_fork
   3.85%        20-chrony  [kernel.kallsyms]  [k] do_fork
   2.56%         sendmail  [kernel.kallsyms]  [k] do_fork

This patch applies over current linux-tip commit 9949284.

Problem introduced in:

$ git describe 640c03c
v2.6.37-rc3-83-g640c03c

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120203170113.5190.25558.stgit@localhost6.localdomain6
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/evsel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -390,6 +390,7 @@ int perf_event__parse_sample(const union
 
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
+	data->period = 1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)


