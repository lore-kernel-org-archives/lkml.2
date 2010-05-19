Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab0ESEVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 00:21:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32818 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0ESEVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 00:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cGCmwEvL+Mi52LZmMfOJXJx5ONkdATYZqw5qtGMJr1b3QV9PmjAZKWCpYoT8j2pBwa
         UbOXoe8ZrXZ2WlUuSt/Ys0HCvmYx49B6vsqmHJc7fZj1VS0b0bdRbfVyKI26pyf7gyLo
         yS675DYHqZ3XxSw8JhtdJYLJrjV7Zwc+p2zt0=
Subject: Re: [BUG] perf: record does not seem to store buildids anymore
From: Tom Zanussi <tzanussi@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Masami Hiramatsu <mhiramat@redhat.com>, acme@ghostprotocols.net
In-Reply-To: <AANLkTimmScKO8YnPJWfTqFXBXQYwbbdej-gaYnHCgeTc@mail.gmail.com>
References: <AANLkTimmScKO8YnPJWfTqFXBXQYwbbdej-gaYnHCgeTc@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 May 2010 23:21:09 -0500
Message-Id: <1274242869.16737.25.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-05-18 at 11:36 +0200, Stephane Eranian wrote:
> Hi,
> 
> I am trying to understand how perf record deals with buildids.
> I am interested in offline and not live processing. According
> to http://lkml.org/lkml/2010/5/1/5, the inject patch does not
> change perf record. It should still save the buildids at the
> end of the perf.data file. I suspect it does not anymore.
> 
> If I do:
> 
> $ perf record -o - noploop 2 | perf inject -b | perf report -v -i -
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.063 MB - (~2756 samples) ]
> build id event received for
> /lib/modules/2.6.34-tip-default+/build/vmlinux:
> 0ad6b5dd1295e0177be9d12acafa72daac664ee7
> Looking at the vmlinux_path (5 entries long)
> Using /lib/modules/2.6.34-tip-default+/build/vmlinux for symbols
> build id event received for /usr/local/bin/noploop:
> e8a36c0c1e36e18522233ff2a4b1fff0f9689b1c
> 
> There is indeed a buildid generated for my noploop test program.
> 
> But I do the simpler:
> 
> $ perf record -o perf.out noploop 2
> noploop for 2 seconds
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.063 MB perf.out (~2739 samples) ]
> 
> $ perf buildid-list -i perf.out
> $
> 
> I get nothing.
> 
> If I try with perf report -D:
> 
> $ perf report -D -i perf.out
>    .....
>      TOTAL events:       2011
>       MMAP events:         21
>       LOST events:          0
>       COMM events:          1
>       EXIT events:          1
>   THROTTLE events:          0
> UNTHROTTLE events:          0
>       FORK events:          0
>       READ events:          0
>     SAMPLE events:       1988
>       ATTR events:          0
> EVENT_TYPE events:          0
> TRACING_DATA events:          0
>   BUILD_ID events:          0
> 
> It shows no buildid events found.
> 
> So either something is broken or I don't understand the logic here.

Neither the live-mode nor inject patches should have changed how offline
processing happens - that case still uses the original perf header write
path.

I think the introduction of the 'machines' abstraction may have broken
build ids - looking for instance at perf_header__adds_write(), the
HEADER_BUILD_ID feature is set when dsos__read_build_ids() returns true,
but the session->machines loop that reads the build_ids doesn't seem to
have the host machine in it, so doesn't find any buildids for the host,
and therefore doesn't set the feature or later write the buildid table.

I was able to get the buildids written by adding the host_machine to the
loop in dsos__read_build_ids() and dsos__write_buildid_table() and was
able to see them using 'perf buildid-list' by also adding host_machine
to perf_session__fprintf_dsos_buildid().

I'm guessing this isn't the right way to fix it, as the code that deals
with the buildids seems to assume that the host_machine is also in the
session->machines list, so I'll have to look into it some more myself
before sending a patch, unless someone beats me to it ;-)

Tom

