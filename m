Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab1CINB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:01:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1CINB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:01:57 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=VOOo5lHdzEUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=II75eZPyu2gntX1qs_YA:9 a=DiVmo7QpcQbqwoUCticA:7 a=8M9h6ND-lXtDtCzOsE9wqWkDVssA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1291421609-14665-5-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-5-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 08:01:55 -0500
Message-ID: <1299675715.15854.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Ftrace event structures have a 12-byte struct trace_entry at the beginning.
> If the structure is aligned, this means that if the first field is 64-bits,
> there will be 4 bytes of padding. Ironically, due to the 4-byte ringbuffer
> header, this will make 64-bit writes unaligned, if the ring buffer position
> is currently 64-bit aligned:
> 4(rb)+12(ftrace)+4(pad) = 20;  20%8 = 4

Actually the better answer is: It's time to nuke the lock_depth field.
That was added temporarily in helping to remove the BKL, and now that
it's pretty much gone, I say we need to nuke it. That will remove 4
bytes from the 12 byte ftrace header giving us a 8 byte header. Much
nicer :)

I'll do that today. Thanks!

-- Steve

> 
> Adding __attribute__((packed)) to the event structures removes the extra
> space from the trace events, and actually improves alignment of trace
> events with a first field that is 64-bits.
> 
> About 65 tracepoints have a 4-byte pad at offset 12:
>  # find events -name format | xargs -n1 awk '
>    $1=="name:" {name=$2}
>    $1=="format:"{FS="\t"}
>    $3=="offset:12;" && $4=="size:4;"{okay=1}
>    $3=="offset:16;" && !okay {print name}' | wc -l
> 65
> 
> With all 'syscalls' and 'timer' events enabled, this results in a 5%
> improvement in a simple 512MB read benchmark with warm caches.


