Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2BVTNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:13:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50488 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BVTNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:13:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.132.229 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Wed, 22 Feb 2012 11:13:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/36] block: add io_context->active_ref
Message-ID: <20120222191347.GB17480@google.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <1329875223-5102-34-git-send-email-tj@kernel.org>
 <20120222184736.GE4128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222184736.GE4128@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Wed, Feb 22, 2012 at 01:47:36PM -0500, Vivek Goyal wrote:
> On Tue, Feb 21, 2012 at 05:47:00PM -0800, Tejun Heo wrote:
> > Currently ioc->nr_tasks is used to decide two things - whether an ioc
> > is done issuing IOs and whether it's shared by multiple tasks.  This
> > patch separate out the first into ioc->active_ref, which is acquired
> > and released using {get|put}_io_context_active() respectively.
> > 
> > This will be used to associate bio's with a given task.  This patch
> > doesn't introduce any visible behavior change.
> 
> Do we really need to spilit nr_tasks and active_ref stuff. IIUC, you
> are creatinv active_ref so that if somebody has taken active_ref in
> the system, then CFQ will idle and wait for more IO. But what if that
> bio gets throttled. Or gets delayed somewhere higher in the stack. Then
> we are unnecessarily idling in CFQ.

I think it's better to keep the distinction clear.  CFQ idling while
bios being throttled is unrelated to task exiting or not.  It can
easily happen while the task is live and well and if that's a
situation which needs to be addressed it better be solved for the
generic case rather than modifying something which is mostly
unrelated.  It *may* be helpful now but if you stack up unrelated
hacks like that, it quickly becomes a difficult-to-maintain mess where
modifying something completely unrelated breaks something else on the
other side.

It indeed is ugly to have ref, active_ref and nr_tasks tho.  If we can
remove CLONE_IO, nr_tasks will go away with it.  Maybe, I don't know.
Let's see.

Thanks.

-- 
tejun
