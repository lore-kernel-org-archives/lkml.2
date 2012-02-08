Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2BHRxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:53:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49847 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2BHRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:53:08 -0500
Message-ID: <4F32B680.3090502@gmail.com>
Date: Wed, 08 Feb 2012 10:53:04 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data
 on a VM
References: <4F32A907.6030505@gmail.com> <20120208174434.GI22598@amd.com>
In-Reply-To: <20120208174434.GI22598@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/08/2012 10:44 AM, Joerg Roedel wrote:
> On Wed, Feb 08, 2012 at 09:55:35AM -0700, David Ahern wrote:
>> perf record -e cycles -p 21483 -- sleep 1
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.012 MB perf.data (~503 samples) ]
>> Segmentation fault
> 
> The problem is similar to the one Jason is seeing. I am working on a fix
> right now.
> Bottom line is that the perf-tool may receive samples tagged as
> GUEST_KERNEL even when guest-sampling is disabled (probably a
> race-condition). The perf-tool can not find a valid machine pointer for
> such a sample and passes NULL down to the other functions. And some
> functions don't seem to handle this.
> 
> David, can you try to change the default for perf_guest back to false
> amd re-test? Not with 'sleep 1' probably, on my setup it takes a busy
> guest and a few seconds to trigger.

The segfault is in the event processing once the collection is done
(perf-record), so the time length should not matter.

Either way, this fixes the segafult:

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..fb25d13 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = true;
+bool perf_guest = false;

 void event_attr_init(struct perf_event_attr *attr)
 {

which makes sense. It forces perf_session__find_machine_for_cpumode() to
return the host machine always.

David

> 
> 
> 	Joerg
> 
