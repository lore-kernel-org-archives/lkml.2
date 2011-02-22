Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1BVPVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:21:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1BVPVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:21:12 -0500
Subject: Re: [PATCH 1/6] perf-events: Add support for supplementary event
 registers v5
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1298221019.2318.62.camel@localhost>
References: <1298221019.2318.62.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 22 Feb 2011 16:20:53 +0100
Message-ID: <1298388053.2217.204.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 00:56 +0800, Lin Ming wrote:
> @@ -225,7 +225,10 @@ struct perf_event_attr {
>         };
>  
>         __u32                   bp_type;
> -       __u64                   bp_addr;
> +       union {
> +               __u64           bp_addr;
> +               __u64           event_extra; /* Extra for some events */
> +       };
>         __u64                   bp_len;
>  }; 

I did s/event_extra/config1/g and:

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -227,9 +230,12 @@ struct perf_event_attr {
 	__u32			bp_type;
 	union {
 		__u64		bp_addr;
-		__u64		config1; /* Extra for some events */
+		__u64		config1;	/* extension of config0 */
+	};
+	union {
+		__u64		bp_len;
+		__u64		config2;	/* extension of config1 */
 	};
-	__u64			bp_len;
 };
 
 /*

Giving us basically 192 bits of config{,1,2} space and the possibility
of eventually deprecating the bp_ stuff.
