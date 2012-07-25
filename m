Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2GYURq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 16:17:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab2GYURo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 16:17:44 -0400
Message-ID: <50105454.5080400@suse.de>
Date: Thu, 26 Jul 2012 01:47:24 +0530
From: Ankit Jain <jankit@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
References: <500E89D1.9010303@suse.de> <20120724223702.GB6723@lenny.home.zabbo.net>
In-Reply-To: <20120724223702.GB6723@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 04:07 AM, Zach Brown wrote:
> On Tue, Jul 24, 2012 at 05:11:05PM +0530, Ankit Jain wrote:
[snip]
>> With this patch, io_submit prepares all the kiocbs and then
>> adds (kicks) them to ctx->run_list (kicked) in one go and then
>> schedules the workqueue. The actual operations are not executed
>> on io_submit's process context, so it can return very quickly.
> 
> Strong nack; this isn't safe without having done the work to ensure that
> all the task_struct references under the f_op->aio_*() paths won't be
> horribly confused to find a kernel thread instead of the process that
> called io_submit().
> 
> The one-off handling of the submitters's cred is an indication that
> there might be other cases to worry about :).

Makes sense, I will try to look into this.

>> 3. Also, I tried not using aio_queue_work from io_submit call, and instead
>> depending on an already scheduled one or the iocbs being run when
>> io_getevents gets called. This seemed to give improved perfomance. But
>> does this constitute as change of api semantics?
> 
> You can't rely on io_getevents() being called for forward progress.  Its
> perfectly reasonable for a task to wait for io completion by polling an
> eventfd that aio_complete() notifies, for instance.

Ah okay, didn't realize that.

Thanks,
-- 
Ankit Jain
SUSE Labs


