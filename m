Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0J1AQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:16:21 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3545 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab0J1AQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:16:19 -0400
Message-ID: <4CC8C0D2.7060304@caviumnetworks.com>
Date: Wed, 27 Oct 2010 17:16:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf can't deal with many tracepoints
References: <E1PBFIJ-0004eC-Tj@tytso-glaptop>
In-Reply-To: <E1PBFIJ-0004eC-Tj@tytso-glaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 00:16:46.0947 (UTC) FILETIME=[688AEB30:01CB7635]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 04:20 PM, Theodore Ts'o wrote:
> Perf will drop dead if it comes across tracepoints that have anything
> but primitive structure accessors in the TP_printk() section of the
> tracepoint definition.  For example, the ext4 and jbd2 tracepoints uses
> jbd2_dev_to_name() to translate a dev_t to a string.  The block I/O
> tracepoints uses MAJOR() and MINOR() to translate a dev_t to a
> major/minor number pair.  Both do this in TP_printk.  This results in a
> fatal error:
>
> # perf record -R -c 1 -e ext4:ext4_da_writepages sh -c "cp -r /boot /test; sync"
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.110 MB perf.data (~4786 samples) ]
> # perf trace -i perf.data
>    Fatal: no argument match
>                cp-9792   [007] 1181919.509759: ext4_da_writepages: dev jbd2_dev_to_name ino
>
> There are people roaming around trying to convince me that perf is the
> One True Way to do everything, including tracepoints.  But there are a
> whole bunch of tracepoints that perf can't handle.  It seems to me we
> have three possible solutions:
>
> 1) Accept there are some tracepoints perf just can't handle, and just
> say that ftrace is the only way people can use those tracepoints
>
> 2) Enforce a rule which says that nothing other than primitive structure
> accessors are allowed, in which case we need a patch such like the one
> attached.  (We will need to audit all tracepoints; it's more than just
> ext4, as I've mentioned --- and yes, the patch below is ugly.  But it
> may be what I have to do to accomodate perf --- or maybe I should just
> tell people that perf is not supported, and if you want to use ext4 or
> block I/O tracepoints, you should use ftrace?)
>
> 3) Figure out some way of making perf smarter; I don't know how to do
> that in the general case, since it can't handle arbitrary C statements.
> But maybe it could be taught how to handle dev_t's in some intelligent
> fashion, perhaps.  And then combine this with either (1) or (2) above.
>
> What say ye?
>

Tracing is supposed to be low overhead.  Forcing people to decode things 
like this at the trace point, may take more code and cause the trace 
data to be larger, making it slower than necessary.

If there isn't a good reason to keep perf stupid, then making it smarter 
could be attractive.

That said, there is some tracepoint data that even Steve's offline 
ftrace analysis tools cannot handle on some architectures.  PFN comes to 
mind on Sparse Mem MIPS systems.  So the argument that only primitive 
structure accessors be allowed has some merits as well.

David Daney
