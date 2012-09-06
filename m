Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab2IFTCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:02:54 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53095 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759426Ab2IFTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:02:52 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIzz1202hzzz2dh668h839h944hd25hf0ah11b5h121eh1220h1155h)
X-WSS-ID: 0M9XZKI-02-37L-02
X-M-MSG: 
Date: Thu, 6 Sep 2012 21:02:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120906190238.GA29278@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1342826756-64663-9-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

just found your patch...

On 20.07.12 17:25:53, David Ahern wrote:
> PEBS cannot be used with guest mode. If user adds :p modifier set
> exclude_guest as well.

> @@ -653,6 +653,9 @@ int parse_events_modifier(struct list_head *list, char *str)
>  			eH = 0;
>  		} else if (*str == 'p') {
>  			precise++;
> +			/* use of precise requires exclude_guest */
> +			if (!exclude_GH)
> +				eG = 1;

We should only enable exclude_guest if no G/H modifiers are given on
the command line. If I correctly read the code this is indicated by
exclude_GH and correctly implemented.

To summarize how I think it should work:

 -e cycles:p ..... Enable exclude_guest bit. If the syscall fails,
                   fall back by disabling the guest bit and send
                   syscall again

 -e cycles:pGH ... Do not enable exclude_guest/_host. Do not fall back
                   on syscall errors.

Same for the case the p modifier is not set.

So we have the following:

 G           ... set exclude_host bit, clear exclude_guest
 H           ... set exclude_guest bit, clear exclude_host
 GH          ... clear both exclude_guest/_host
 <no G or H> ... default (set exclude_host bit, clear exclude_guest),
                 but fall back on syscall errors to clear both
                 exclude_guest/_host

The modifier parser should be correctly implemented and should work
with ibs. Will test this patch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

