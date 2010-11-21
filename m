Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0KUUQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 15:16:11 -0500
Received: from element.ksp.sk ([158.195.16.154]:57859 "EHLO ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0KUUQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 15:16:10 -0500
Message-ID: <4CE97E06.6000207@dcs.fmph.uniba.sk>
Date: Sun, 21 Nov 2010 21:16:06 +0100
From: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: CFQ and dm-crypt
References: <4CC439ED.8090400@dcs.fmph.uniba.sk>	<x49y69b6qg6.fsf@segfault.boston.devel.redhat.com>	<4CD185C2.8000006@dcs.fmph.uniba.sk> <x497hgdqkvb.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497hgdqkvb.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On 11/03/10 04:23, Jeff Moyer wrote:
>>>>> CFQ io scheduler relies on using task_struct current to determine which
>>>>> process makes the io request. On the other hand, some dm modules (such
>>>>> as dm-crypt) use separate threads for doing io. As CFQ sees only these
>>>>> threads, it provides a very poor performance in such a case.
>>>>>
>>>>> IMHO the correct solution for this would be to store, for every io
>>>>> request, the process that initiated it (and preserve this information
>>>>> while the request is processed by device mapper). Would that be feasible?
>>> Sure.  Try the attached patch (still an rfc) and let us know how it
>>> goes.  In my environment, it speed up multiple concurrent buffered
>>> readers.  I wasn't able to do a full analysis via blktrace as 2.6.37-rc1
>>> seems to have broken blktrace support on my system.
>>
>> Thanks for the patch. Unfortunately, I got a kernel panic quite soon
>> after booting the patched kernel. I was not able to reproduce the
>> panic in a virtual machine, so I had to manually note the backtrace,
>> thus I apologize that it's incomplete:
> 
> Hi, Richard,
> 
> I have another patch for you to try.  This one holds up pretty well in
> my testing using a dm-crypt target.  Without the patch, I see no
> priority separation:

Hello,

I am sorry for a late reply (it took me some time to try the patch on
my main machine). Thank you for your work; unfortunately, I'm still
getting a panic at early boot stages: The BUG_ON assert in
cfq-iosched.c:cic_free_func failed, with a call trace as follows:

<IRQ>
cfq_free_io_context
put_io_context
cfq_put_request
elv_put_request
blk_finish_request
...

I applied your patch at Linus's git tree (commit
b86db4744230c94e480de56f1b7f31117edbf193), it applied cleanly.

I tried a little to find the source of the problem, but without
success so far. However, I think that calling put_io_context in
bio_endio only may introduce memory leaks under certain situations
(although this is probably not related to the panic I get):

In blk-core.c:blk_rq_prep_clone, __bio_clone allocates the io_context,
but if subsequent allocations fail, bio_free in free_and_out does not
free it.

Similarly, in dm-crypt.c:crypt_alloc_buffer, bio_put does not
free the io_context.

Or have I misunderstood something?

Greets
        Richard
