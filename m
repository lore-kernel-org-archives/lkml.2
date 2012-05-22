Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab2EVPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:48:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42398 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2EVPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:48:15 -0400
Message-ID: <4FBBB539.5010805@gmail.com>
Date: Tue, 22 May 2012 09:48:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf, tool: Fix endianity trick for adds_features
 bitmask
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-7-git-send-email-jolsa@redhat.com> <4FBB1839.6000606@gmail.com> <20120522084153.GC2901@m.brq.redhat.com>
In-Reply-To: <20120522084153.GC2901@m.brq.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------000305040809080706090803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000305040809080706090803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/12 2:41 AM, Jiri Olsa wrote:

> hm, any special details for the record? because I'm sure I tested this way..
>
> I'll retest, thanks
> jirka


The attached fixes it.

--------------000305040809080706090803
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="perf-swap-features.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf-swap-features.patch"

commit 1353676ca6551a0165df030784ada20ebea73f73
Author: David Ahern <dsahern@gmail.com>
Date:   Tue May 22 09:40:17 2012 -0600

    perf, tool: Fix endianity swapping for adds_features bitmask
    
    Based on Jiri's latest attempt:
    https://lkml.org/lkml/2012/5/16/61
    
    Basically, adds_features should be byte swapped assuming unsigned
    longs are either 8-bytes (u64) or 4-bytes (u32).
    
    Fixes 32-bit ppc dumping 64-bit x86 feature data:
     ========
     captured on: Sun May 20 19:23:23 2012
     hostname : nxos-vdc-dev3
     os release : 3.4.0-rc7+
     perf version : 3.4.rc4.137.g978da3
     arch : x86_64
     nrcpus online : 16
     nrcpus avail : 16
     cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
     cpuid : GenuineIntel,6,26,5
     total memory : 24680324 kB
    ...
    
    Verified 64-bit x86 can still dump feature data for 32-bit ppc.
    
    Signed-off-by: David Ahern <dsahern@gmail.com>

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5385980..81db55b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1942,7 +1942,6 @@ int perf_file_header__read(struct perf_file_header *header,
 		else
 			return -1;
 	} else if (ph->needs_swap) {
-		unsigned int i;
 		/*
 		 * feature bitmap is declared as an array of unsigned longs --
 		 * not good since its size can differ between the host that
@@ -1958,14 +1957,17 @@ int perf_file_header__read(struct perf_file_header *header,
 		 * file), punt and fallback to the original behavior --
 		 * clearing all feature bits and setting buildid.
 		 */
-		for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i)
-			header->adds_features[i] = bswap_64(header->adds_features[i]);
+		mem_bswap_64(&header->adds_features,
+			    BITS_TO_U64(HEADER_FEAT_BITS));
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			for (i = 0; i < BITS_TO_LONGS(HEADER_FEAT_BITS); ++i) {
-				header->adds_features[i] = bswap_64(header->adds_features[i]);
-				header->adds_features[i] = bswap_32(header->adds_features[i]);
-			}
+			/* unswap as u64 */
+			mem_bswap_64(&header->adds_features,
+				    BITS_TO_U64(HEADER_FEAT_BITS));
+
+			/* unswap as u32 */
+			mem_bswap_32(&header->adds_features,
+				    BITS_TO_U32(HEADER_FEAT_BITS));
 		}
 
 		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index f1584833..587a230 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -8,6 +8,8 @@
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
+#define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4dcc8f3..43870c2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -441,6 +441,16 @@ void mem_bswap_64(void *src, int byte_size)
 	}
 }
 
+void mem_bswap_32(void *src, int byte_size)
+{
+	u32 *m = src;
+	while (byte_size > 0) {
+		*m = bswap_32(*m);
+		byte_size -= sizeof(u32);
+		++m;
+	}
+}
+
 static void perf_event__all64_swap(union perf_event *event)
 {
 	struct perf_event_header *hdr = &event->header;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..0c702e3 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -80,6 +80,7 @@ struct branch_info *machine__resolve_bstack(struct machine *self,
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);

--------------000305040809080706090803--
