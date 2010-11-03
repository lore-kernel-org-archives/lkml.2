Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0KCPyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:54:51 -0400
Received: from element.ksp.sk ([158.195.16.154]:39370 "EHLO ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab0KCPyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:54:49 -0400
Message-ID: <4CD185C2.8000006@dcs.fmph.uniba.sk>
Date: Wed, 03 Nov 2010 16:54:42 +0100
From: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk> <x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/10 04:23, Jeff Moyer wrote:
>> > CFQ io scheduler relies on using task_struct current to determine which
>> > process makes the io request. On the other hand, some dm modules (such
>> > as dm-crypt) use separate threads for doing io. As CFQ sees only these
>> > threads, it provides a very poor performance in such a case.
>> >
>> > IMHO the correct solution for this would be to store, for every io
>> > request, the process that initiated it (and preserve this information
>> > while the request is processed by device mapper). Would that be feasible?
> Sure.  Try the attached patch (still an rfc) and let us know how it
> goes.  In my environment, it speed up multiple concurrent buffered
> readers.  I wasn't able to do a full analysis via blktrace as 2.6.37-rc1
> seems to have broken blktrace support on my system.

Thanks for the patch. Unfortunately, I got a kernel panic quite soon
after booting the patched kernel. I was not able to reproduce the
panic in a virtual machine, so I had to manually note the backtrace,
thus I apologize that it's incomplete:

Fatal exception in interupt.
...
do_invalid_op
cic_free_func 0x9d/0xb0
bio_endio 0x42/0x70
task_rq_lock
try_to_wake_up
invalid_op
cic_free_func
cfq_free_io_context
put_io_context
cfq_put_request
...

When I combined the patch with my previous hack on dm-crypt, it worked
fine; so the problem apparently goes away if cfq sees the corret io
context.

Moreover, I noticed in the sources that cfq still uses current task on
many places. For example, the CPU scheduler settings are inherited if
there is no io priority set. Hence I was wondering if it does not make
more sense to store whole task_struct of the initiating process in
bio, instead of just io_context?

Greets
      Richard

