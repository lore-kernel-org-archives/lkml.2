Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1BPU5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:57:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31556 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1BPU5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:57:45 -0500
Message-ID: <4D5C3A0F.3080107@kernel.org>
Date: Wed, 16 Feb 2011 12:56:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, numa: exit early on numa_reset_distance()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B020B.4D5C3A39.01DC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do not call __pa(numa_distance), if it is not allocated before.

it will get BUG_ON if VIRTUAL_DEBUG is on.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -371,6 +371,12 @@ static void __init numa_reset_distance(v
 {
 	size_t size;
 
+	if (!numa_distance_cnt) {
+		numa_distance = NULL;
+
+		return;
+	}
+
 	size = numa_distance_cnt * sizeof(numa_distance[0]);
 	memblock_x86_free_range(__pa(numa_distance),
 				__pa(numa_distance) + size);
